-- clean_order
    DROP TABLE IF EXISTS clean_order CASCADE;
    CREATE TABLE clean_order AS
    WITH denormalized AS (
        SELECT
            od.order_id,
            od.user_id,
            CAST(od.order_transaction_date AS DATE) AS order_transaction_date,
            od.order_arrival_days,
            odl.order_delay_days,
            msm.merchant_id,
            msm.staff_id,
            tcd.campaign_id,
            tcd.availed,
            cu.user_pk,
            cu.user_creation_datetime,
            cm.merchant_pk,
            cm.merchant_creation_datetime,
            cs.staff_pk,
            cs.staff_creation_datetime
        FROM order_data od
		WHERE od.order_id IS NOT NULL AND order_transaction_date ~ '^\d{8}$'
        
        -- FIX 1: Change these to LEFT JOIN. 
        -- If an order has no delay record or merchant map, we keep the order and fill NULLs.
        LEFT JOIN order_delays odl USING(order_id)
        LEFT JOIN (SELECT DISTINCT order_id, merchant_id, staff_id FROM order_with_merchant_data) msm USING(order_id)
        LEFT JOIN (SELECT order_id, campaign_id, availed FROM transactional_campaign_data) tcd USING(order_id)

        -- FIX 2: User Join
        -- We join ON the ID *AND* the specific condition that it is the most recent valid record.
        LEFT JOIN clean_user cu 
            ON od.user_id = cu.user_id
            AND cu.user_creation_datetime = (
                SELECT MAX(cu2.user_creation_datetime)
                FROM clean_user cu2
                WHERE cu2.user_id = od.user_id
                AND cu2.user_creation_datetime <= od.order_transaction_date 
            )

        -- FIX 3: Merchant Join
        LEFT JOIN clean_merchant cm 
            ON msm.merchant_id = cm.merchant_id
            AND cm.merchant_creation_datetime = (
                SELECT MAX(cm2.merchant_creation_datetime)
                FROM clean_merchant cm2
                WHERE cm2.merchant_id = msm.merchant_id
                AND cm2.merchant_creation_datetime <= od.order_transaction_date
            )

        -- FIX 4: Staff Join
        LEFT JOIN clean_staff cs 
            ON msm.staff_id = cs.staff_id
            AND cs.staff_creation_datetime = (
                SELECT MAX(cs2.staff_creation_datetime)
                FROM clean_staff cs2
                WHERE cs2.staff_id = msm.staff_id
                AND cs2.staff_creation_datetime <= od.order_transaction_date
            )
    )
    SELECT
        order_id,
        user_pk,
        merchant_pk,
        staff_pk,
		CASE WHEN availed = 1 THEN campaign_id ELSE NULL END AS campaign_pk,
        order_transaction_date,
        REGEXP_REPLACE(order_arrival_days, '[^0-9\.]', '', 'g')::INT AS order_arrival_days,
        REGEXP_REPLACE(order_delay_days, '[^0-9\.]', '', 'g')::INT AS order_delay_days
    FROM denormalized;

-- clean_line
    DROP TABLE IF EXISTS clean_line CASCADE;
    CREATE TABLE clean_line AS
        SELECT
            line_id,
            order_id,
            product_pk,
            line_price,
            REGEXP_REPLACE(line_quantity, '[^0-9\.]', '', 'g')::INT AS line_quantity
        FROM line_item_data_prices
        FULL JOIN line_item_data_products USING(line_id, order_id)
        JOIN clean_product USING(product_id, product_name)

