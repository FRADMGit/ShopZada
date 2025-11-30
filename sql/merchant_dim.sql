SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY merchant_id, merchant_name
            ORDER BY merchant_creation_datetime DESC NULLS LAST
        ) AS rn
    FROM {{ ref("stg_merchant_data") }}
)
WHERE rn = 1
