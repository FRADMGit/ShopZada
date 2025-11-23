WITH affiliations AS (
SELECT
    a.order_id,
    b.user_id,
    merchant_id,
    staff_id,
    CASE campaign_availed
        WHEN 1 THEN campaign_id
        ELSE NULL
    END AS campaign_id,
    b.order_transaction_date,
    b.order_arrival_days
FROM {{ ref('stg_order_with_merchant_data') }} a
JOIN {{ ref('stg_order_data') }} b ON a.order_id = b.order_id
JOIN {{ ref('stg_user_data') }} c ON b.user_id = c.user_id
JOIN {{ ref('stg_transactional_campaign_data') }} d ON b.order_id = d.order_id
),
correct_user AS (
SELECT DISTINCT
    order_id,
    user_id,
    user_name
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY o.order_id ORDER BY u.user_creation_datetime DESC) AS rn
    FROM {{ ref('stg_order_data') }} o
    JOIN {{ ref('stg_user_data') }} u
        ON o.user_id = u.user_id
        AND u.user_creation_datetime <= o.order_transaction_date
)
WHERE rn = 1
),
correct_merchant AS (
SELECT DISTINCT
    order_id,
    merchant_id,
    merchant_name
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY a.order_id ORDER BY m.merchant_creation_datetime DESC) AS rn
    FROM affiliations a
    JOIN {{ ref('stg_merchant_data') }} m
        ON a.merchant_id = m.merchant_id
        AND m.merchant_creation_datetime <= a.order_transaction_date
)
WHERE rn = 1
),
correct_staff AS (
SELECT DISTINCT
    order_id,
    staff_id,
    staff_name
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY a.order_id ORDER BY s.staff_creation_datetime DESC) AS rn
    FROM affiliations a
    JOIN {{ ref('stg_staff_data') }} s
        ON a.staff_id = s.staff_id
        AND s.staff_creation_datetime <= a.order_transaction_date
)
WHERE rn = 1
)
SELECT DISTINCT
    a.order_id,
    u.user_id,
    u.user_name,
    m.merchant_id,
    m.merchant_name,
    s.staff_id,
    s.staff_name,
    a.campaign_id,
    a.order_transaction_date,
    a.order_arrival_days,
    d.order_delay_days
FROM affiliations a
JOIN correct_user u ON a.order_id = u.order_id
JOIN correct_merchant m ON a.order_id = m.order_id
JOIN correct_staff s ON a.order_id = s.order_id
JOIN {{ ref('stg_order_delays') }} d ON a.order_id = d.order_id
