SELECT DISTINCT
    product_id,
    product_name,
    price AS product_price,
    CAST(POSITION('toys' IN product_type) > 0 AS INTEGER) AS toys,
    CAST(POSITION('entertainment' IN product_type) > 0 AS INTEGER) AS entertainment,
    CAST(POSITION('breakfast' IN product_type) > 0 AS INTEGER) AS breakfast,
    CAST(POSITION('lunch' IN product_type) > 0 AS INTEGER) AS lunch,
    CAST(POSITION('dinner' IN product_type) > 0 AS INTEGER) AS dinner,
    CAST(POSITION('accessories' IN product_type) > 0 AS INTEGER) AS accessories,
    CAST(POSITION('kitchenware' IN product_type) > 0 AS INTEGER) AS kitchenware,
    CAST(POSITION('grocery' IN product_type) > 0 AS INTEGER) AS grocery,
    CAST(POSITION('apparel' IN product_type) > 0 AS INTEGER) AS apparel,
    CAST(POSITION('furniture' IN product_type) > 0 AS INTEGER) AS furniture,
    CAST(POSITION('health' IN product_type) > 0 AS INTEGER) AS health,
    CAST(POSITION('hygiene' IN product_type) > 0 AS INTEGER) AS hygiene,
    CAST(POSITION('stationary' IN product_type) > 0 AS INTEGER) AS stationary,
    CAST(POSITION('tools' IN product_type) > 0 AS INTEGER) AS tools,
    CAST(POSITION('jewelry' IN product_type) > 0 AS INTEGER) AS jewelry,
    CAST(POSITION('technology' IN product_type) > 0 AS INTEGER) AS technology,
    CAST(POSITION('electronics' IN product_type) > 0 AS INTEGER) AS electronics,
    CAST(POSITION('sports' IN product_type) > 0 AS INTEGER) AS sports,
    CAST(POSITION('cosmetic' IN product_type) > 0 AS INTEGER) AS cosmetic,
    CAST(POSITION('music' IN product_type) > 0 AS INTEGER) AS music,
    CAST(POSITION('cleaning' IN product_type) > 0 AS INTEGER) AS cleaning,
    CAST(POSITION('appliances' IN product_type) > 0 AS INTEGER) AS appliances,
    CAST(POSITION('others' IN product_type) > 0 AS INTEGER) AS others
FROM {{ ref('clean_product_list') }}
WHERE product_id IS NOT NULL
  AND product_name IS NOT NULL
  AND price IS NOT NULL
