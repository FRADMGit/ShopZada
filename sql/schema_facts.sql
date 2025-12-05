-- order_dim
    CREATE TABLE IF NOT EXISTS order_dim (
        order_pk VARCHAR(250) PRIMARY KEY,
        user_pk TEXT,
        merchant_pk TEXT,
        staff_pk TEXT,
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
        co.user_pk,
        co.merchant_pk,
        co.staff_pk,
        co.campaign_pk,
        co.order_transaction_date,
        co.order_arrival_days,
        co.order_delay_days
    FROM
        clean_order co
        
    -- User Key Validation
    INNER JOIN user_dim ud ON co.user_pk = ud.user_pk

    -- Merchant Key Validation
    INNER JOIN merchant_dim md ON co.merchant_pk = md.merchant_pk

    -- Staff Key Validation
    INNER JOIN staff_dim sd ON co.staff_pk = sd.staff_pk

    -- Campaign Key Validation
    LEFT JOIN campaign_dim cd ON co.campaign_pk = cd.campaign_pk

    WHERE
        -- Primary Key Uniqueness Check
        NOT EXISTS (
            SELECT 1
            FROM order_dim od
            WHERE od.order_pk = co.order_id
        )
        
        -- Ensure mandatory keys are present in their dimension table
        AND ud.user_pk IS NOT NULL
        AND md.merchant_pk IS NOT NULL
        AND sd.staff_pk IS NOT NULL
        AND (co.campaign_pk IS NULL OR cd.campaign_pk IS NOT NULL);
-- line_fact
    CREATE TABLE IF NOT EXISTS line_fact (
        line_pk INTEGER PRIMARY KEY,
        order_pk VARCHAR(250) NOT NULL,
        product_pk TEXT,
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
        lid.order_id,
        lid.product_pk,
        lid.line_price,
        lid.line_quantity
    FROM
        clean_line lid
        
    -- Validate Product Key
    INNER JOIN product_dim pd ON lid.product_pk = pd.product_pk
    -- Validate Order Key
    INNER JOIN order_dim od ON lid.order_id = od.order_pk
        
    -- Uniqueness Check
    WHERE NOT EXISTS (
        SELECT 1
        FROM line_fact lf
        WHERE lf.line_pk = lid.line_id
    );
