-- user view
    DROP VIEW IF EXISTS user_view;

    CREATE VIEW user_view AS
    WITH user_orders AS (
        SELECT
            o.user_pk,
            u.user_name,
            u.user_country,
            u.user_device_address,
            u.user_type,
            u.user_job_title,
            u.user_job_level,
            u.user_issuing_bank,
            o.order_pk,
            l.line_quantity,
            l.line_price,
            o.order_transaction_date
        FROM line_fact l
        JOIN order_dim o ON l.order_pk = o.order_pk
        JOIN user_dim u ON o.user_pk = u.user_pk
    ),
    aggregated AS (
        SELECT
            user_pk,
            user_name,
            user_country,
            user_device_address,
            user_type,
            user_job_title,
            user_job_level,
            user_issuing_bank,
            COUNT(DISTINCT order_pk) AS total_orders,
            SUM(line_quantity) AS total_items_bought,
            SUM(line_quantity * line_price) AS total_spend,
            MIN(order_transaction_date) AS first_order_date,
            MAX(order_transaction_date) AS last_order_date
        FROM user_orders
        GROUP BY
            user_pk,
            user_name,
            user_country,
            user_device_address,
            user_type,
            user_job_title,
            user_job_level,
            user_issuing_bank
    )
    SELECT *
    FROM aggregated
    ORDER BY total_spend DESC;

-- product view
    DROP VIEW IF EXISTS product_view;

    CREATE VIEW product_view AS
    WITH exploded AS (
        SELECT product_pk, product_name, 'toys' AS category FROM product_dim WHERE toys
        UNION ALL SELECT product_pk, product_name, 'entertainment' FROM product_dim WHERE entertainment
        UNION ALL SELECT product_pk, product_name, 'breakfast' FROM product_dim WHERE breakfast
        UNION ALL SELECT product_pk, product_name, 'lunch' FROM product_dim WHERE lunch
        UNION ALL SELECT product_pk, product_name, 'dinner' FROM product_dim WHERE dinner
        UNION ALL SELECT product_pk, product_name, 'accessories' FROM product_dim WHERE accessories
        UNION ALL SELECT product_pk, product_name, 'kitchenware' FROM product_dim WHERE kitchenware
        UNION ALL SELECT product_pk, product_name, 'grocery' FROM product_dim WHERE grocery
        UNION ALL SELECT product_pk, product_name, 'apparel' FROM product_dim WHERE apparel
        UNION ALL SELECT product_pk, product_name, 'furniture' FROM product_dim WHERE furniture
        UNION ALL SELECT product_pk, product_name, 'health' FROM product_dim WHERE health
        UNION ALL SELECT product_pk, product_name, 'hygiene' FROM product_dim WHERE hygiene
        UNION ALL SELECT product_pk, product_name, 'stationary' FROM product_dim WHERE stationary
        UNION ALL SELECT product_pk, product_name, 'tools' FROM product_dim WHERE tools
        UNION ALL SELECT product_pk, product_name, 'jewelry' FROM product_dim WHERE jewelry
        UNION ALL SELECT product_pk, product_name, 'technology' FROM product_dim WHERE technology
        UNION ALL SELECT product_pk, product_name, 'electronics' FROM product_dim WHERE electronics
        UNION ALL SELECT product_pk, product_name, 'sports' FROM product_dim WHERE sports
        UNION ALL SELECT product_pk, product_name, 'cosmetic' FROM product_dim WHERE cosmetic
        UNION ALL SELECT product_pk, product_name, 'music' FROM product_dim WHERE music
        UNION ALL SELECT product_pk, product_name, 'cleaning' FROM product_dim WHERE cleaning
        UNION ALL SELECT product_pk, product_name, 'appliances' FROM product_dim WHERE appliances
        UNION ALL SELECT product_pk, product_name, 'others' FROM product_dim WHERE others
    ),
    sales AS (
        SELECT
            e.product_pk,
            e.category,
            l.order_pk,
            SUM(l.line_quantity) AS total_quantity_sold,
            SUM(l.line_quantity * l.line_price) AS total_sales
        FROM exploded e
        LEFT JOIN line_fact l
            ON e.product_pk = l.product_pk
        GROUP BY e.category, e.product_pk, l.order_pk
    ),
    category_agg AS (
        SELECT
            category,
            COUNT(DISTINCT product_pk) AS products_under_category,
            SUM(total_sales) AS total_sales,
            SUM(total_quantity_sold) AS total_quantity_sold,
            COUNT(DISTINCT order_pk) AS total_orders
        FROM sales
        GROUP BY category
    ),
    grand_total AS (
        SELECT SUM(total_sales) AS overall_sales FROM category_agg
    )
    SELECT
        c.*,
        ROUND(c.total_sales / NULLIF(g.overall_sales,0), 4) AS ratio
    FROM category_agg c
    CROSS JOIN grand_total g
    ORDER BY total_sales DESC;

-- merchant view
    DROP VIEW IF EXISTS merchant_view;

    CREATE VIEW merchant_view AS
    WITH order_metrics AS (
        SELECT
            m.merchant_pk,
            m.merchant_name,
            m.merchant_country,
            COUNT(DISTINCT o.order_pk) AS total_orders,
            SUM(l.line_quantity * l.line_price) AS total_sales,
            AVG(o.order_arrival_days) AS average_arrival_days,
            COUNT(DISTINCT o.user_pk) AS total_customers
        FROM order_dim o
        JOIN merchant_dim m
            ON o.merchant_pk = m.merchant_pk
        JOIN line_fact l
            ON o.order_pk = l.order_pk
        GROUP BY m.merchant_pk, m.merchant_name, m.merchant_country
    )
    SELECT *
    FROM order_metrics
    ORDER BY total_orders DESC;

-- staff view
    DROP VIEW IF EXISTS staff_view;

    CREATE VIEW staff_view AS
    WITH staff_orders AS (
        SELECT
            s.staff_pk,
            s.staff_name,
            s.staff_job_level,
            o.order_pk,
            o.user_pk,
            l.line_quantity,
            l.line_price,
            o.order_delay_days
        FROM line_fact l
        JOIN order_dim o
            ON l.order_pk = o.order_pk
        JOIN staff_dim s
            ON o.staff_pk = s.staff_pk
    )
    SELECT
        staff_pk,
        staff_name,
        staff_job_level,
        COUNT(DISTINCT order_pk) AS total_orders,
        SUM(line_quantity) AS total_items_sold,
        SUM(line_quantity * line_price) AS total_sales,
        AVG(order_delay_days) AS average_order_delay_days,
        COUNT(DISTINCT user_pk) AS distinct_customers
    FROM staff_orders
    GROUP BY staff_pk, staff_name, staff_job_level
    ORDER BY total_orders DESC;

-- campaign view
    DROP VIEW IF EXISTS campaign_view;

    CREATE VIEW campaign_view AS
    WITH campaign_orders AS (
        SELECT
            COALESCE(c.campaign_pk, 'UNKNOWN') AS campaign_pk,
            COALESCE(c.campaign_name, 'NO CAMPAIGN') AS campaign_name,
            COALESCE(c.campaign_discount, 0) AS campaign_discount,
            o.order_pk,
            o.user_pk,
            l.line_quantity,
            l.line_price,
            o.order_transaction_date
        FROM order_dim o
        JOIN line_fact l ON o.order_pk = l.order_pk
        LEFT JOIN campaign_dim c ON o.campaign_pk = c.campaign_pk
    ),
    aggregated AS (
        SELECT
            campaign_pk,
            campaign_name,
            ROUND(campaign_discount::NUMERIC, 2) AS campaign_discount,
            COUNT(DISTINCT order_pk) AS total_orders,
            SUM(line_quantity) AS total_items_sold,
            ROUND(SUM(line_quantity * line_price), 2) AS total_sales,
            COUNT(DISTINCT user_pk) AS distinct_customers,
            MIN(order_transaction_date) AS first_order_date,
            MAX(order_transaction_date) AS last_order_date,
            ROUND(
                SUM(
                    line_quantity * line_price *
                    (campaign_discount / NULLIF(1 - campaign_discount, 0))
                )::NUMERIC,
                2
            ) AS discount_expense
        FROM campaign_orders
        GROUP BY
            campaign_pk,
            campaign_name,
            campaign_discount
    )
    SELECT *
    FROM aggregated
    ORDER BY total_sales DESC;
