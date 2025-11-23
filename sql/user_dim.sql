SELECT DISTINCT
    ud.user_id,
    ud.user_name AS user_name,
    MAX(ud.user_creation_datetime) AS user_creation_datetime,
    MAX(ud.user_street) AS user_street,
    MAX(ud.user_state) AS user_state,
    MAX(ud.user_city) AS user_city,
    MAX(ud.user_country) AS user_country,
    MAX(ud.user_birth_datetime) AS user_birth_datetime,
    MAX(ud.user_gender) AS user_gender,
    MAX(ud.user_device_address) AS user_device_address,
    MAX(ud.user_type) AS user_type,
    MAX(cc.name) AS credit_card_holder_name,
    MAX(cc.credit_card_number) AS credit_card_number,
    MAX(cc.issuing_bank) AS issuing_bank,
    MAX(job.user_job) AS user_job,
    MAX(job.user_job_level) AS user_job_level
FROM 
    {{ ref('stg_user_data') }} AS ud
JOIN 
    {{ ref('stg_user_credit_card') }} AS cc 
        ON ud.user_id = cc.user_id
JOIN 
    {{ ref('stg_user_job') }} AS job 
        ON ud.user_id = job.user_id
WHERE 
    ud.user_id IS NOT NULL
    AND ud.user_name IS NOT NULL
GROUP BY 
    ud.user_id, 
    ud.user_name
