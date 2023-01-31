/*
Group 18
Tomas Mesquita -    121 648 5166
Afsana Salahudeen - 121 645 5422
Justin Ngov -       121 657 6491
*/

CREATE TABLE query1 as SELECT h.category_id, (SELECT name FROM category WHERE category_id = h.category_id) AS name, COUNT(*) AS count FROM HASCATEGORY h GROUP BY(h.category_id);

CREATE TABLE query2 as SELECT h.category_id, (SELECT name FROM category WHERE category_id = h.category_id) AS name, avg(r.rating) AS rating FROM HASCATEGORY h, REVIEW r where r.business_id = h.business_id GROUP BY(h.category_id);

CREATE TABLE query3 as SELECT r.business_id, (SELECT title FROM business WHERE business_id = r.business_id) AS title, COUNT(*) AS countofratings FROM review r GROUP BY(r.business_id) HAVING count(*) > 4000;

CREATE TABLE query4 as SELECT b.business_id, b.title FROM business b, category c, hascategory h WHERE c.name = 'Chinese' and c.category_id = h.category_id and b.business_id = h.business_id;

CREATE TABLE query5 as SELECT b.business_id, b.title, avg(r.rating) as average FROM REVIEW r, business b where r.business_id = b.business_id GROUP BY(b.business_id);

CREATE TABLE query6 as SELECT avg(r.rating) as average from review r, business b, hascategory h, category c where c.name = 'Chinese' and c.category_id = h.category_id and b.business_id = h.business_id and b.business_id = r.business_id;

CREATE TABLE query7 as SELECT avg(r.rating) as average from review r, business b, hascategory h1, hascategory h2, category c1, category c2 where (c1.name = 'Chinese' and c2.name = 'Japanese') and c1.category_id = h1.category_id and c2.category_id = h2.category_id and b.business_id = h1.business_id and b.business_id = h2.business_id and b.business_id = r.business_id;

CREATE TABLE query8 as SELECT avg(r.rating) as average from review r, business b, hascategory h, category c where c.name = 'Chinese' and c.category_id = h.category_id and b.business_id = h.business_id and b.business_id = r.business_id and b.business_id NOT IN (SELECT b.business_id FROM category c, business b, hascategory h where c.name = 'Japanese' and c.category_id = h.category_id and b.business_id = h.business_id);

CREATE TABLE query9 as SELECT b.business_id, avg(r.rating) from business b, review r, users u where u.user_id = 'CxDOIDnH8gp9KXzpBHJYXw' and u.user_id = r.user_id and r.business_id = b.business_id GROUP BY (b.business_id) ORDER BY (b.business_id);

--pairwise table. cross join between all business's avg reviews and all of this user's reviews
CREATE TABLE pairwise as 
(Select * from 
    (SELECT b.business_id as business, 
        (avg(r.rating)) as OverallRating FROM REVIEW r, business b where r.business_id = b.business_id and b.business_id NOT IN 
            (SELECT b.business_id as user_business from review r, business b, users u where u.user_id = r.user_id and b.business_id = r.business_id and u.user_id = 'ogAjjUdQWzE_zlAGZWMd0g' GROUP BY (b.business_id)) GROUP BY(b.business_id) ) as a 
            CROSS JOIN (SELECT b.business_id as user_business, (avg(r.rating)) as PersonalRating from review r, business b, users u where u.user_id = r.user_id and b.business_id = r.business_id and u.user_id = 'ogAjjUdQWzE_zlAGZWMd0g' GROUP BY (b.business_id)) as hera);

--create similarscore table, which has similarity scores added to previous table
CREATE TABLE similarscore as (SELECT p.business, p.OverallRating, p.user_business, p.PersonalRating, (1 - abs(p.OverallRating - p.PersonalRating)/5) as simscore from pairwise p);

CREATE TABLE predictedratings as (SELECT business, (sum(simscore * PersonalRating) / sum(simscore) ) as predictedrating from similarscore GROUP BY(business));

CREATE TABLE query10 as (SELECT b.business_id, b.title from predictedratings p, business b where p.predictedrating > 4.33 and p.business = b.business_id );
