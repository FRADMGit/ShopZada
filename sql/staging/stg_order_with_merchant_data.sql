SELECT DISTINCT
    order_id,
    merchant_id,
    staff_id
FROM
    {{ ref('clean_order_with_merchant_data') }}
WHERE order_id IS NOT NULL 
  AND merchant_id IS NOT NULL 
  AND staff_id IS NOT NULL
