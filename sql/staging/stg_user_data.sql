SELECT DISTINCT
    user_id,
    creation_date AS user_creation_datetime,
    name AS user_name,
    street AS user_street,
    state AS user_state,
    city AS user_city,
    country AS user_country,
    birthdate  AS user_birth_datetime,
    gender AS user_gender,
    device_address AS user_device_address,
    user_type
FROM
    {{ ref('clean_user_data') }}
WHERE user_id IS NOT NULL
  AND name IS NOT NULL
