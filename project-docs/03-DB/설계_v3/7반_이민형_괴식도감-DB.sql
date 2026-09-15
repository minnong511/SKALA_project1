-- PostgreSQL DDL v0.3.1, 현재 v2 기준 신규 스키마 생성용
-- 기존 DB에 실행하는 마이그레이션이 아님. 범위 및 허용 값은 API 검증.
BEGIN;

CREATE TABLE users (
  user_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  email varchar(255) NOT NULL,
  password_hash varchar(255),
  display_name varchar(50) NOT NULL,
  role varchar(20) DEFAULT 'USER' NOT NULL,
  created_at timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
  CONSTRAINT pk_users PRIMARY KEY (user_id),
  CONSTRAINT uq_users_1 UNIQUE (email)
);

CREATE TABLE external_accounts (
  external_account_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id bigint NOT NULL,
  provider varchar(20) DEFAULT 'GOOGLE' NOT NULL,
  provider_user_id varchar(255) NOT NULL,
  linked_at timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
  CONSTRAINT pk_external_accounts PRIMARY KEY (external_account_id),
  CONSTRAINT uq_external_accounts_1 UNIQUE (provider, provider_user_id),
  CONSTRAINT uq_external_accounts_2 UNIQUE (user_id, provider),
  CONSTRAINT fk_external_accounts_user_id FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
);

CREATE TABLE user_preferences (
  user_id bigint NOT NULL,
  preferred_categories jsonb NOT NULL,
  preferred_tastes jsonb NOT NULL,
  sweetness_preference varchar(50) NOT NULL,
  excluded_ingredients jsonb DEFAULT '[]'::jsonb NOT NULL,
  challenge_level varchar(20) NOT NULL,
  updated_at timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
  CONSTRAINT pk_user_preferences PRIMARY KEY (user_id),
  CONSTRAINT fk_user_preferences_user_id FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
);

CREATE TABLE brands (
  brand_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  name varchar(100) NOT NULL,
  CONSTRAINT pk_brands PRIMARY KEY (brand_id),
  CONSTRAINT uq_brands_1 UNIQUE (name)
);

CREATE TABLE drink_menus (
  menu_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  brand_id bigint NOT NULL,
  created_by bigint NOT NULL,
  name varchar(100) NOT NULL,
  base_drink varchar(100) NOT NULL,
  category varchar(30) NOT NULL,
  size varchar(50),
  temperature varchar(30),
  weirdness_level varchar(20) NOT NULL,
  recipe_description text,
  representative_image_url text,
  created_at timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
  CONSTRAINT pk_drink_menus PRIMARY KEY (menu_id),
  CONSTRAINT fk_drink_menus_brand_id FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE RESTRICT,
  CONSTRAINT fk_drink_menus_created_by FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE RESTRICT
);
CREATE INDEX idx_menus_brand ON drink_menus (brand_id);
CREATE INDEX idx_menus_category_created ON drink_menus (category, created_at DESC, menu_id DESC);
CREATE INDEX idx_menus_creator ON drink_menus (created_by);

CREATE TABLE menu_options (
  option_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  menu_id bigint NOT NULL,
  action varchar(20) NOT NULL,
  ingredient_name varchar(100) NOT NULL,
  quantity numeric(10,2),
  unit varchar(30),
  CONSTRAINT pk_menu_options PRIMARY KEY (option_id),
  CONSTRAINT fk_menu_options_menu_id FOREIGN KEY (menu_id) REFERENCES drink_menus(menu_id) ON DELETE RESTRICT
);
CREATE INDEX idx_options_menu ON menu_options (menu_id);

CREATE TABLE reviews (
  review_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id bigint NOT NULL,
  menu_id bigint NOT NULL,
  rating smallint NOT NULL,
  content text,
  created_at timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
  CONSTRAINT pk_reviews PRIMARY KEY (review_id),
  CONSTRAINT fk_reviews_user_id FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
  CONSTRAINT fk_reviews_menu_id FOREIGN KEY (menu_id) REFERENCES drink_menus(menu_id) ON DELETE RESTRICT
);
CREATE INDEX idx_reviews_menu_user ON reviews (menu_id, user_id);
CREATE INDEX idx_reviews_user_created ON reviews (user_id, created_at DESC, review_id DESC);

CREATE TABLE review_images (
  image_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  review_id bigint NOT NULL,
  image_url text NOT NULL,
  display_order smallint NOT NULL,
  CONSTRAINT pk_review_images PRIMARY KEY (image_id),
  CONSTRAINT uq_review_images_1 UNIQUE (review_id, display_order),
  CONSTRAINT fk_review_images_review_id FOREIGN KEY (review_id) REFERENCES reviews(review_id) ON DELETE RESTRICT
);

CREATE TABLE bookmarks (
  user_id bigint NOT NULL,
  menu_id bigint NOT NULL,
  saved_at timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
  CONSTRAINT pk_bookmarks PRIMARY KEY (user_id, menu_id),
  CONSTRAINT fk_bookmarks_user_id FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
  CONSTRAINT fk_bookmarks_menu_id FOREIGN KEY (menu_id) REFERENCES drink_menus(menu_id) ON DELETE RESTRICT
);
CREATE INDEX idx_bookmarks_user_saved ON bookmarks (user_id, saved_at DESC, menu_id DESC);
CREATE INDEX idx_bookmarks_menu ON bookmarks (menu_id);

COMMIT;
