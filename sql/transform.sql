-- clean campaign data
  DROP TABLE IF EXISTS clean_campaign_data CASCADE;
  CREATE TABLE clean_campaign_data AS
  SELECT DISTINCT
      campaign_id,
      campaign_name,
      regexp_replace(campaign_description, '\s*-\s*.*$', '') AS campaign_description,
      regexp_replace(campaign_description, '^.*-\s*', '') AS campaign_description_person,
      (regexp_replace(discount, '[^0-9\.]', '', 'g')::FLOAT / 100) AS campaign_discount
  FROM campaign_data
  WHERE campaign_id IS NOT NULL
      AND discount IS NOT NULL;
-- clean line item data prices
  DROP TABLE IF EXISTS clean_line_item_data_prices CASCADE;
  CREATE TABLE clean_line_item_data_prices AS
  SELECT DISTINCT
      line_id,
      order_id,
      price AS line_price,
      REGEXP_REPLACE(quantity, '[^0-9\.]', '', 'g')::INT AS line_quantity
  FROM line_item_data_prices
  WHERE line_id IS NOT NULL
      AND order_id IS NOT NULL
  ORDER BY
      line_id ASC;
-- clean line item data products
  DROP TABLE IF EXISTS clean_line_item_data_products CASCADE;
  CREATE TABLE clean_line_item_data_products AS
  SELECT DISTINCT
      line_id,
      order_id,
      product_name,
      product_id
  FROM line_item_data_products
  WHERE line_id IS NOT NULL
      AND order_id IS NOT NULL
  ORDER BY line_id ASC;
-- clean merchant data
  DROP TABLE IF EXISTS clean_merchant_data CASCADE;

  CREATE TABLE clean_merchant_data AS
  SELECT
      merchant_id,
      creation_date AS merchant_creation_datetime,
      name AS merchant_name,
      street AS merchant_street,
      state AS merchant_state,
      city AS merchant_city,
      country AS merchant_country,
      REGEXP_REPLACE(contact_number, '[^0-9]', '', 'g') AS merchant_contact_number
  FROM (
      SELECT *,
            ROW_NUMBER() OVER (PARTITION BY merchant_id ORDER BY creation_date DESC) AS rn
      FROM merchant_data
      WHERE merchant_id IS NOT NULL
  ) sub
  WHERE rn = 1;

-- clean order data
  DROP TABLE IF EXISTS clean_order_data CASCADE;
  CREATE TABLE clean_order_data AS
  SELECT DISTINCT
      order_id,
      "user_id",
      REGEXP_REPLACE("estimated arrival", '[^0-9\.]', '', 'g')::INT AS order_arrival_days,
      transaction_date AS order_transaction_date
  FROM order_data
  WHERE order_id IS NOT NULL
      AND "user_id" IS NOT NULL;
-- clean order delays
  DROP TABLE IF EXISTS clean_order_delays CASCADE;
  CREATE TABLE clean_order_delays AS
  SELECT DISTINCT
    order_id,
    "delay in days" AS order_delay_days
  FROM order_delays
  WHERE "delay in days" IS NOT NULL
    AND order_id IS NOT NULL;
-- order with merchant data
  DROP TABLE IF EXISTS clean_order_with_merchant_data CASCADE;
  CREATE TABLE clean_order_with_merchant_data AS
  SELECT DISTINCT
      order_id,
      merchant_id,
      staff_id
  FROM order_with_merchant_data
  WHERE order_id IS NOT NULL 
    AND merchant_id IS NOT NULL 
    AND staff_id IS NOT NULL;
-- clean product list
  DROP TABLE IF EXISTS clean_product_list CASCADE;
  CREATE TABLE clean_product_list AS
  SELECT DISTINCT
      product_id,
      product_name,
      price AS product_price,
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
      (POSITION('appliances' IN product_type) > 0) AS appliances,
      (POSITION('others' IN product_type) > 0) AS others
  FROM product_list
  WHERE product_id IS NOT NULL
    AND product_name IS NOT NULL
    AND price IS NOT NULL;
-- clean staff data
  DROP TABLE IF EXISTS clean_staff_data CASCADE;

  CREATE TABLE clean_staff_data AS
  SELECT
      staff_id,
      name AS staff_name,
      job_level AS staff_job_level,
      street AS staff_street,
      state AS staff_state,
      city AS staff_city,
      country AS staff_country,
      REGEXP_REPLACE(contact_number, '[^0-9]', '', 'g') AS staff_contact_number,
      creation_date AS staff_creation_datetime
  FROM (
      SELECT *,
            ROW_NUMBER() OVER (PARTITION BY staff_id ORDER BY creation_date DESC) AS rn
      FROM staff_data
      WHERE staff_id IS NOT NULL
        AND name IS NOT NULL
  ) sub
  WHERE rn = 1;

-- clean transactional campaign data
  DROP TABLE IF EXISTS clean_transactional_campaign_data CASCADE;
  CREATE TABLE clean_transactional_campaign_data AS
  SELECT DISTINCT
      campaign_id,
      order_id,
      availed AS campaign_availed
  FROM transactional_campaign_data
  WHERE campaign_id IS NOT NULL
    AND order_id IS NOT NULL;
-- clean user credit card
  DROP TABLE IF EXISTS clean_user_credit_card CASCADE;
  CREATE TABLE clean_user_credit_card AS
  SELECT DISTINCT * FROM user_credit_card;
-- clean user data
  DROP TABLE IF EXISTS clean_user_data CASCADE;

  CREATE TABLE clean_user_data AS
  SELECT 
      "user_id",
      creation_date AS user_creation_datetime,
      name AS "user_name",
      street AS user_street,
      state AS user_state,
      city AS user_city,
      country AS user_country,
      birthdate AS user_birth_datetime,
      gender AS user_gender,
      device_address AS user_device_address,
      user_type
  FROM (
      SELECT *,
            ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY creation_date DESC) AS rn
      FROM user_data
      WHERE "user_id" IS NOT NULL
        AND name IS NOT NULL
  ) sub
  WHERE rn = 1;

-- clean user job
  DROP TABLE IF EXISTS clean_user_job CASCADE;
  CREATE TABLE clean_user_job AS
  SELECT DISTINCT
      "user_id",
      name AS "user_name",
      job_title AS user_job,
      job_level AS user_job_level
  FROM user_job
  WHERE "user_id" IS NOT NULL
    AND name IS NOT NULL
