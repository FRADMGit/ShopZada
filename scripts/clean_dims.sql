-- clean_product
  DROP TABLE IF EXISTS clean_product CASCADE;
  CREATE TABLE clean_product AS
  WITH products AS (
    SELECT DISTINCT
      product_id,
      product_name,
      product_price,
      (POSITION('toys' IN product_type) > 0) AS toys,
      (POSITION('entertainment' IN product_type) > 0) AS entertainment,
      (POSITION('breakfast' IN product_type) > 0) AS breakfast,
      (POSITION('lunch' IN product_type) > 0) AS lunch,
      (POSITION('dinner' IN product_type) > 0) AS dinner,
      (POSITION('accessories' IN product_type) > 0) AS accessories,
      (POSITION('kitchenware' IN product_type) > 0) AS kitchenware,
      (POSITION('grocery' IN product_type) > 0) AS grocery,
      (POSITION('apparel' IN product_type) > 0) AS apparel,
      (POSITION('furniture' IN product_type) > 0) AS furniture,
      (POSITION('health' IN product_type) > 0) AS health,
      (POSITION('hygiene' IN product_type) > 0) AS hygiene,
      (POSITION('stationary' IN product_type) > 0) AS stationary,
      (POSITION('tools' IN product_type) > 0) AS tools,
      (POSITION('jewelry' IN product_type) > 0) AS jewelry,
      (POSITION('technology' IN product_type) > 0) AS technology,
      (POSITION('electronics' IN product_type) > 0) AS electronics,
      (POSITION('sports' IN product_type) > 0) AS sports,
      (POSITION('cosmetic' IN product_type) > 0) AS cosmetic,
      (POSITION('music' IN product_type) > 0) AS music,
      (POSITION('cleaning' IN product_type) > 0) AS cleaning,
      (POSITION('appliances' IN product_type) > 0) AS appliances
    FROM product_list
    WHERE product_id IS NOT NULL
	ORDER BY product_id
  )
  SELECT
    'PRODUCT' || LPAD(CAST((ROW_NUMBER() OVER()) AS TEXT), 5, '0') AS product_pk,
    *,
	NOT (
      toys OR entertainment OR breakfast OR lunch OR dinner OR accessories OR 
      kitchenware OR grocery OR apparel OR furniture OR health OR hygiene OR 
      stationary OR tools OR jewelry OR technology OR electronics OR sports OR 
      cosmetic OR music OR cleaning OR appliances
    ) AS others
  FROM products;

-- clean_campaign
  DROP TABLE IF EXISTS clean_campaign CASCADE;
  CREATE TABLE clean_campaign AS
  SELECT DISTINCT
    campaign_id,
    campaign_name,
    regexp_replace(campaign_description, '\s*-\s*.*$', '') AS campaign_description,
    regexp_replace(campaign_description, '^.*-\s*', '') AS campaign_description_person,
    (regexp_replace(campaign_discount, '[^0-9\.]', '', 'g')::FLOAT / 100) AS campaign_discount
  FROM campaign_data
  WHERE campaign_id IS NOT NULL
  ORDER BY campaign_id;

-- clean_merchant
  DROP TABLE IF EXISTS clean_merchant CASCADE;
  CREATE TABLE clean_merchant AS
  WITH merchants AS (
    SELECT
      merchant_id,
      merchant_name,
      merchant_street,
      merchant_state,
      merchant_city,
      merchant_country,
      REGEXP_REPLACE(merchant_contact_number, '[^0-9]', '', 'g') AS merchant_contact_number,
      TO_TIMESTAMP(merchant_creation_datetime, 'YYYY-MM-DD HH24:MI:SS') AS merchant_creation_datetime
    FROM merchant_data
    WHERE merchant_id IS NOT NULL
	AND merchant_creation_datetime ~ '^\d{8}$'
    ORDER BY merchant_creation_datetime
  )
  SELECT 'MERCHANT' || LPAD(CAST((ROW_NUMBER() OVER()) AS TEXT), 5, '0') AS merchant_pk, *
  FROM merchants;

-- clean_staff
  DROP TABLE IF EXISTS clean_staff CASCADE;
  CREATE TABLE clean_staff AS
  SELECT
	  'STAFF' || LPAD(CAST((ROW_NUMBER() OVER()) AS TEXT), 5, '0') AS staff_pk,
	  staff_id,
	  staff_name,
	  staff_job_level,
	  staff_street,
	  staff_state,
	  staff_city,
	  staff_country,
	  staff_contact_number,
	  TO_TIMESTAMP(staff_creation_datetime, 'YYYY-MM-DD HH24:MI:SS') AS staff_creation_datetime
  FROM (SELECT DISTINCT * FROM staff_data WHERE staff_id IS NOT NULL AND staff_creation_datetime ~ '^\d{8}$'
  ORDER BY staff_creation_datetime);

-- clean_user
  DROP TABLE IF EXISTS clean_user CASCADE;
  CREATE TABLE clean_user AS
  WITH users AS (
    SELECT DISTINCT
      a.user_id,
      a.user_name,
      user_creation_datetime,
      user_street,
      user_state,
      user_city,
      user_country,
      user_birthdate,
      user_gender,
      user_device_address,
      user_type,
      user_job_title,
      user_job_level,
      user_credit_card_number,
      user_issuing_bank
    FROM user_data a
	LEFT JOIN user_job b USING(user_id, user_name)
	LEFT JOIN user_credit_card c USING(user_id, user_name)
    ORDER BY user_creation_datetime
  )
  SELECT
	'USER' || LPAD(CAST((ROW_NUMBER() OVER()) AS TEXT), 5, '0') AS user_pk,
	user_id,
	user_name,
	TO_TIMESTAMP(user_creation_datetime, 'YYYY-MM-DD HH24:MI:SS') AS user_creation_datetime,
	user_street,
	user_state,
	user_city,
	user_country,
	TO_TIMESTAMP(user_birthdate, 'YYYY-MM-DD HH24:MI:SS') AS user_birthdate,
	user_gender,
	user_device_address,
	user_type,
	user_job_title,
	user_job_level,
	user_credit_card,
	user_issuing_bank
  FROM users
  where user_id IS NOT NULL AND user_creation_datetime ~ '^\d{8}$' AND user_birthdate ~ '^\d{8}$'


