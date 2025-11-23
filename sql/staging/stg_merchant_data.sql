SELECT DISTINCT
    merchant_id,
    creation_date AS merchant_creation_datetime,
    name AS merchant_name,
    street AS merchant_street,
    state AS merchant_state,
    city AS merchant_city,
    country AS merchant_country,
    REGEXP_REPLACE(contact_number, '[^0-9]', '', 'g') AS merchant_contact_number
FROM
    {{ ref('clean_merchant_data') }}
WHERE merchant_id IS NOT NULL
