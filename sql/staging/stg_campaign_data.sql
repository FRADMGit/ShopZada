SELECT DISTINCT
    campaign_id,
    campaign_name,
    regexp_replace(campaign_description, '\s*-\s*.*$', '') AS campaign_description,
    regexp_replace(campaign_description, '^.*-\s*', '') AS campaign_description_person,
    (regexp_replace(discount, '[^0-9\.]', '', 'g')::FLOAT / 100) AS campaign_discount
FROM {{ ref('clean_campaign_data') }}
WHERE campaign_id IS NOT NULL
    discount IS NOT NULL
