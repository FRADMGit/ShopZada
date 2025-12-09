DROP TABLE IF EXISTS user_job CASCADE;
CREATE TABLE user_job (
  "user_id" VARCHAR(250),
  user_name VARCHAR(250),
  user_job_title VARCHAR(250),
  user_job_level VARCHAR(250) 
);

DROP TABLE IF EXISTS user_data CASCADE;
CREATE TABLE user_data (
  "user_id" VARCHAR(250),
  user_creation_datetime VARCHAR(250),
  user_name VARCHAR(250),
  user_street VARCHAR(250),
  user_state VARCHAR(250),
  user_city VARCHAR(250),
  user_country VARCHAR(250),
  user_birthdate VARCHAR(250),
  user_gender VARCHAR(250),
  user_device_address VARCHAR(250),
  user_type VARCHAR(250)
);

DROP TABLE IF EXISTS order_data CASCADE;
CREATE TABLE order_data (
  order_id VARCHAR(250),
  "user_id" VARCHAR(250),
  order_arrival_days VARCHAR(250),
  order_transaction_date VARCHAR(250)
);

DROP TABLE IF EXISTS staff_data CASCADE;
CREATE TABLE staff_data (
  staff_id VARCHAR(250),
  staff_name VARCHAR(250),
  staff_job_level VARCHAR(250),
  staff_street VARCHAR(250),
  staff_state VARCHAR(250),
  staff_city VARCHAR(250),
  staff_country VARCHAR(250),
  staff_contact_number VARCHAR(250),
  staff_creation_datetime VARCHAR(250)
);

DROP TABLE IF EXISTS order_delays CASCADE;
CREATE TABLE order_delays (
  order_id VARCHAR(250),
  order_delay_days VARCHAR(250)
);

DROP TABLE IF EXISTS product_list CASCADE;
CREATE TABLE product_list (
  product_id VARCHAR(250),
  product_name VARCHAR(250),
  product_type VARCHAR(250),
  product_price NUMERIC
);

DROP TABLE IF EXISTS campaign_data CASCADE;
CREATE TABLE campaign_data (
  campaign_id VARCHAR(250),
  campaign_name VARCHAR(250),
  campaign_description VARCHAR(250),
  campaign_discount VARCHAR(250)
);

DROP TABLE IF EXISTS merchant_data CASCADE;
CREATE TABLE merchant_data (
  merchant_id VARCHAR(250),
  merchant_creation_datetime VARCHAR(250),
  merchant_name VARCHAR(250),
  merchant_street VARCHAR(250),
  merchant_state VARCHAR(250),
  merchant_city VARCHAR(250),
  merchant_country VARCHAR(250),
  merchant_contact_number VARCHAR(250)
);

DROP TABLE IF EXISTS user_credit_card CASCADE;
CREATE TABLE user_credit_card (
  "user_id" VARCHAR(250),
  user_name VARCHAR(250),
  user_credit_card_number VARCHAR(250),
  user_issuing_bank VARCHAR(250)
);

DROP TABLE IF EXISTS line_item_data_prices CASCADE;
CREATE TABLE line_item_data_prices (
  line_id INT,
  order_id VARCHAR(250),
  line_price NUMERIC,
  line_quantity VARCHAR(250)
);

DROP TABLE IF EXISTS line_item_data_products CASCADE;
CREATE TABLE line_item_data_products (
  line_id INT,
  order_id VARCHAR(250),
  product_name VARCHAR(250),
  product_id VARCHAR(250)
);

DROP TABLE IF EXISTS order_with_merchant_data CASCADE;
CREATE TABLE order_with_merchant_data (
  order_id VARCHAR(250),
  merchant_id VARCHAR(250),
  staff_id VARCHAR(250)
);

DROP TABLE IF EXISTS transactional_campaign_data CASCADE;
CREATE TABLE transactional_campaign_data (
  transaction_date VARCHAR(250),
  campaign_id VARCHAR(250),
  order_id VARCHAR(250),
  "estimated arrival" VARCHAR(250),
  availed NUMERIC
);



