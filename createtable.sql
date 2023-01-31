CREATE TABLE USERS(
   user_id TEXT PRIMARY KEY NOT NULL,
   name TEXT NOT NULL,
   yelp_since timestamp NOT NULL
);

CREATE TABLE BUSINESS(
   business_id TEXT PRIMARY KEY NOT NULL,
   title TEXT NOT NULL
);

CREATE TABLE REVIEW(
   business_id TEXT NOT NULL REFERENCES BUSINESS(business_id),
   user_id TEXT NOT NULL REFERENCES USERS(user_id),
   RATING NUMERIC NOT NULL,
   date timestamp NOT NULL,
   PRIMARY KEY (business_id, user_id, date)
);

CREATE TABLE CATEGORY(
   category_id BIGINT PRIMARY KEY NOT NULL,
   name TEXT NOT NULL
);

CREATE TABLE HASCATEGORY(
   business_id TEXT NOT NULL REFERENCES BUSINESS(business_id),
   category_id BIGINT NOT NULL REFERENCES CATEGORY(category_id),
   PRIMARY KEY(business_id, category_id)
);
