SELECT DISTINCT
    staff_id,
    name AS staff_name,
    job_level AS staff_job_level,
    street AS staff_street,
    state AS staff_state,
    city AS staff_city,
    country AS staff_country,
    REGEXP_REPLACE(contact_number, '[^0-9]', '', 'g') AS staff_contact_number,
    creation_date AS staff_creation_datetime
FROM
    {{ ref('clean_staff_data') }}
WHERE staff_id IS NOT NULL
  AND name IS NOT NULL
