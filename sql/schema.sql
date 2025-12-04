-- CAMPAIGN DIM
  DROP TABLE IF EXISTS campaign_dim CASCADE;
  CREATE TABLE campaign_dim AS
  SELECT DISTINCT * FROM clean_campaign_data;
-- LINE FACT
  DROP TABLE IF EXISTS line_fact CASCADE;
  CREATE TABLE line_fact AS
  SELECT DISTINCT
      a.line_id,
      a.order_id,
      a.product_id,
      a.product_name,
      b.line_quantity,
      b.line_price
  FROM clean_line_item_data_products a
  JOIN clean_line_item_data_prices b
  ON a.line_id = b.line_id
  ORDER BY a.line_id ASC;
-- MERCHANT DIM
  DROP TABLE IF EXISTS merchant_dim CASCADE;
  CREATE TABLE merchant_dim AS
  SELECT * FROM clean_merchant_data;
-- ORDER DIM
  DROP TABLE IF EXISTS order_dim CASCADE;
  CREATE TABLE order_dim AS
  WITH affiliations AS (
      SELECT
          a.order_id,
          b."user_id",
          a.merchant_id,
          a.staff_id,
          CASE WHEN d.campaign_availed = 1 THEN d.campaign_id ELSE NULL END AS campaign_id,
          b.order_transaction_date,
          b.order_arrival_days
      FROM clean_order_with_merchant_data a
      JOIN clean_order_data b ON a.order_id = b.order_id
      LEFT JOIN clean_transactional_campaign_data d ON b.order_id = d.order_id
  )
  SELECT
      a.order_id,
      u."user_id",
      u."user_name",
      m.merchant_id,
      m.merchant_name,
      s.staff_id,
      s.staff_name,
      a.campaign_id,
      a.order_transaction_date,
      a.order_arrival_days,
      d.order_delay_days
  FROM affiliations a
  JOIN clean_user_data u ON a."user_id" = u."user_id"
  JOIN clean_merchant_data m ON a.merchant_id = m.merchant_id
  JOIN clean_staff_data s ON a.staff_id = s.staff_id
  JOIN clean_order_delays d ON a.order_id = d.order_id;
-- PRODUCT DIM
  DROP TABLE IF EXISTS product_dim CASCADE;
  CREATE TABLE product_dim AS
  SELECT DISTINCT * FROM clean_product_list;
-- STAFF DIM
  DROP TABLE IF EXISTS staff_dim CASCADE;
  CREATE TABLE staff_dim AS
  SELECT DISTINCT * FROM clean_staff_data;
-- USER DIM
  DROP TABLE IF EXISTS user_dim CASCADE;

  CREATE TABLE user_dim AS
  SELECT
      u."user_id",
      u."user_name",
      u.user_creation_datetime,
      u.user_street,
      u.user_state,
      u.user_city,
      u.user_country,
      u.user_birth_datetime,
      u.user_gender,
      u.user_device_address,
      u.user_type,
      cc.name AS credit_card_holder_name,
      cc.credit_card_number,
      cc.issuing_bank,
      job.user_job,
      job.user_job_level
  FROM clean_user_data u
  JOIN clean_user_credit_card cc ON u."user_id" = cc."user_id"
  JOIN clean_user_job job ON u."user_id" = job."user_id"
  WHERE u."user_id" IS NOT NULL
    AND u."user_name" IS NOT NULL;

