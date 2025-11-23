SELECT DISTINCT
    "Unnamed: 0" AS line_id,
    order_id,
    price AS line_price,
    REGEXP_REPLACE(quantity, '[^0-9\.]', '', 'g') AS line_quantity
FROM
    {{ ref('clean_line_item_data_prices') }}
ORDER BY
    "Unnamed: 0" ASC
