-- order dim
    CREATE TABLE IF NOT EXISTS order_dim (
        order_pk VARCHAR(250) PRIMARY KEY,
        user_pk VARCHAR(250),
        merchant_pk VARCHAR(250),
        staff_pk VARCHAR(250),
        campaign_pk VARCHAR(250),
        order_transaction_date DATE,
        order_arrival_days INTEGER,
        order_delay_days INTEGER
    );

    INSERT INTO order_dim (
        order_pk,
        user_pk,
        merchant_pk,
        staff_pk,
        campaign_pk,
        order_transaction_date,
        order_arrival_days,
        order_delay_days
    )
    SELECT
        co.order_id,
        COALESCE(ud.user_pk, 'UNKNOWN'),
        COALESCE(md.merchant_pk, 'UNKNOWN'),
        COALESCE(sd.staff_pk, 'UNKNOWN'),
        COALESCE(cd.campaign_pk, 'UNKNOWN'),
        co.order_transaction_date,
        co.order_arrival_days,
        co.order_delay_days
    FROM clean_order co
    LEFT JOIN user_dim ud       ON co.user_pk = ud.user_pk
    LEFT JOIN merchant_dim md   ON co.merchant_pk = md.merchant_pk
    LEFT JOIN staff_dim sd      ON co.staff_pk = sd.staff_pk
    LEFT JOIN campaign_dim cd   ON co.campaign_pk = cd.campaign_pk
    WHERE co.order_id IS NOT NULL
    ON CONFLICT (order_pk)
    DO UPDATE SET
        user_pk = EXCLUDED.user_pk,
        merchant_pk = EXCLUDED.merchant_pk,
        staff_pk = EXCLUDED.staff_pk,
        campaign_pk = EXCLUDED.campaign_pk,
        order_transaction_date = EXCLUDED.order_transaction_date,
        order_arrival_days = EXCLUDED.order_arrival_days,
        order_delay_days = EXCLUDED.order_delay_days;

    -- Unknown fallback
    INSERT INTO order_dim (order_pk) VALUES ('UNKNOWN')
    ON CONFLICT (order_pk) DO NOTHING;

-- line fact
    CREATE TABLE IF NOT EXISTS line_fact (
        line_pk INTEGER PRIMARY KEY,
        order_pk VARCHAR(250) NOT NULL,
        product_pk VARCHAR(250),
        line_price NUMERIC,
        line_quantity INTEGER
    );

    INSERT INTO line_fact (
        line_pk,
        order_pk,
        product_pk,
        line_price,
        line_quantity
    )
    SELECT
        lid.line_id,
        COALESCE(od.order_pk, 'UNKNOWN'),
        COALESCE(pd.product_pk, 'UNKNOWN'),
        lid.line_price,
        lid.line_quantity
    FROM clean_line lid
    LEFT JOIN order_dim od   ON lid.order_id = od.order_pk
    LEFT JOIN product_dim pd ON lid.product_pk = pd.product_pk
    WHERE lid.line_id IS NOT NULL
    ON CONFLICT (line_pk)
    DO UPDATE SET
        order_pk = EXCLUDED.order_pk,
        product_pk = EXCLUDED.product_pk,
        line_price = EXCLUDED.line_price,
        line_quantity = EXCLUDED.line_quantity;
