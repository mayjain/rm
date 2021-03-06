create sequence shop_ac_people_seq;
create table shop_ac_people (
  id bigint not null primary key default nextval('shop_ac_people_seq'),
  salutation varchar(10) not null,
  first_name varchar(32) not null,
  last_name varchar(32) not null,
  password varchar(256) not null,
  status varchar(16) not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  constraint shop_ac_people_cns_email unique(email) ); 

create sequence shop_ac_companies_seq;
create table shop_ac_companies (
  id bigint not null primary key default nextval('shop_ac_companies_seq'),
  name varchar(128) not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create sequence shop_ac_phones_seq;
create table shop_ac_phones (
  id bigint not null primary key default nextval('shop_ac_phones_seq'),
  linkable_id bigint not null,
  linkable_type varchar(10) not null default 'people',
  phone_country_code varchar(10) not null default '+91',
  phone_city_code varchar(10) not null default '',
  phone_number varchar(10) not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create sequence shop_ac_emails_seq;
create table shop_ac_emails (
  id bigint not null primary key default nextval('shop_ac_emails_seq'),
  linkable_id bigint not null,
  linkable_type varchar(10) not null default 'people',
  email varchar(128) not null, 
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create sequence shop_lkp_states_seq;
create table shop_lkp_states (
  id bigint not null primary key default nextval('shop_lkp_states_seq'),
  name varchar(256) not null,
  country_code varchar(2) not null default 'IN',
  country varchar(32) not null default 'India',
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create sequence shop_lkp_cities_seq;
craete table shop_lkp_cities (
  id bigint not null primary key default nextval('shop_lkp_cities_seq'),
  name varchar(256) not null,
  state_id bigint not null references shop_lkp_states,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create sequence shop_ac_addresses_seq;
create table shop_ac_addresses (
  id bigint not null primary key default nextval('shop_ac_addresses_seq'),
  linkable_id bigint not null,
  linkable_type varchar(10) not null default 'people',
  street_1 varchar(128) not null, 
  street_2 varchar(128) not null,
  landmark_1 varchar(128),
  landmark_2 varchar(128),
  other text,
  city_id not null references shop_lkp_city,
  use_as_default integer not null default 0,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create sequence shop_lkp_statuses_seq;
create table shop_lkp_statuses (
  id bigint not null primary key default nextval('shop_lkp_statuses_seq'),
  linkable_type varchar(128) not null,
  code varchar(16) not null,
  description text not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create table shop_product_categories_seq;
create table shop_product_categories (
  id bigint not null primary key default nextval('shop_product_categories'),
  name varchar(256) not null,
  code varchar(16) not null,
  description text,
  status varchar(16) not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );  

create sequence shop_products_seq;
create table shop_products (
  id bigint not null primary key default nextval('shop_products_seq'),
  name varchar(256) not null,
  sku varchar(16) not null,
  category_id not null references shop_product_categories,
  description text,
  status varchar(16),
  unit_price numeric(10,2) not null default 0.0,
  unit_price_currency varchar(3) not null default 'INR',
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create sequence shop_product_sizes_seq;
create table shop_product_sizes (
  id bigint not null primary key default nextval('shop_product_sizes_seq'),
  product_id bigint not null references shop_products,
  size_code varchar(128) not null,
  status varchar(16) not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create sequence shop_product_colors_seq;
create table shop_product_colors (
  id bigint not null primary key default nextval('shop_product_colors_seq'),
  product_id bigint not null references shop_products,
  color_code varchar(128) not null,
  image_url varchar(256),
  image_color_code varchar(256),
  status varchar(16) not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create sequence shop_orders_seq;
create table shop_orders (
  id bigint not null primary key default nextval('shop_orders_seq'),
  user_id bigint not null references shop_ac_people,
  order_amount numeric(10,2) not null default 0.0,
  order_currency varchar(3) not null default 'INR',
  status varchar(16) not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create table shop_orders_products(
  order_id not null references shop_orders,
  product_id not null references shop_products,
  unit_price numeric(10,2) not null default 0.0,
  unit_price_currency varchar(3) not null default 'INR',
  quantity integer not null default 1,
  size_id bigint not null references shop_product_sizes,
  color_id bigint not null references shop_product_colors,
  status varchar(16) not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create sequence shop_pay_txns_seq;
create table shop_pay_txns (
  id bigint not null primary key default nextval('shop_pay_txns_seq'),
  order_id bigint not null references shop_orders,
  user_id bigint not null references shop_ac_people,
  txn_type bigint not null,
  txn_amount numeric(10,2) not null default 0.0,
  txn_currency varchar(3) not null default 'INR',
  status varchar(16) not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );

create sequence shop_pay_creditac_seq;
create table shop_pay_credit_account (
  id bigint not null primary key default nextval('shop_pay_creditac_seq'),
  user_id bigint not null references shop_ac_people,
  balance numeric(10,2) not null default 0.00,
  balance_currency varchar(3) not null default 'INR',
  coupon_code varchar(16) references shop_pay_coupons_master(coupon_code),
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );  
  
create sequence shop_pay_creditac_seq;
create table shop_pay_credit_account_txns (
  id bigint not null default nextval('shop_pay_creditac_txns_seq'),
  user_id bigint not null references shop_ac_people,
  txn_id bigint not null references shop_pay_txns,
  amount numeric(10,2) not null default 0.00,
  currency varchar(3) not null default 'INR'
  coupon_code varchar(16)  references shop_pay_coupons_master(coupon_code),
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );    

create sequence shop_coupons_master_seq;
create table shop_coupons_master (
  id bigint not null default nextval('shop_coupons_master_seq'),
  coupon_code varchar(16) not null,
  value numeric(10,2) not null default 0.0,
  valid_from timestamp not null default now(),
  valid_upto timestamp,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );  

create sequence shop_pay_pgs_seq;
create table shop_pay_pgs (
  id bigint not null primary key default nextval('shop_pay_card_txns_seq'),
  name varchar(32),
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );  

create sequence shop_pay_card_types_seq;
create table shop_pay_card_types (
  id bigint not null primary key default nextval('shop_pay_card_types_seq'),
  card_type_name varchar(16) not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );  

create sequence shop_pay_banks_seq;
create table shop_pay_banks (
  id bigint not null primary key default nextval('shop_pay_banks'),
  bank_name varchar(128) not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );  

create sequence shop_pay_card_txns_seq;
create table shop_pay_card_txns (
  id bigint not null primary  key default nextval('shop_pay_card_txns_seq'),
  txn_id bigint not null references shop_pay_txns,
  gateway_id bigint not null references shop_pay_pgs,
  card_type_id bigint not null references shop_pay_card_types,
  card_issuing_bank_id bigint not null references shop_pay_banks,
  card_number varchar(18) not null,
  name_on_card varchar(128) not null,
  amount numeric(10,2) not null,
  currency varchar(3) not null default 'INR',
  status varchar(16) not null,
  gateway_response_1 varchar(256),
  gateway_response_2 varchar(256),
  gateway_response_3 varchar(256),
  gateway_response_4 varchar(256),
  gateway_response_5 varchar(256),
  gateway_response_6 varchar(256),
  gateway_response_7 varchar(256),
  gateway_response_8 varchar(256),
  gateway_response_9 varchar(256),
  gateway_response_10 varchar(256),
  gateway_response_11 varchar(256),
  gateway_response_12 varchar(256),
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );  

create sequence shop_pay_nb_txns_seq;
create table shop_pay_nb_txns (
  id bigint not null primary  key default nextval('shop_pay_nb_txns_seq'),
  txn_id bigint not null references shop_pay_txns,
  bank_id bigint not null references shop_pay_banks,
  amount numeric(10,2) not null,
  currency varchar(3) not null default 'INR',
  status varchar(16) not null,
  bank_pay_response_1 varchar(256),
  bank_pay_response_2 varchar(256),
  bank_pay_response_3 varchar(256),
  bank_pay_response_4 varchar(256),
  bank_verify_response_1 varchar(256),
  bank_verify_response_2 varchar(256),
  bank_verify_response_3 varchar(256),
  bank_verify_response_4 varchar(256),
  created_at timestamp not null default now(),
  updated_at timestamp not null default now() );  

