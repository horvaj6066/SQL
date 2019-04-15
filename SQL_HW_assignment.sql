use sakila;
show tables;
select first_name, last_name from actor;
ALTER TABLE actor 
ADD COLUMN actor_name varchar (50) FIRST;
UPDATE actor 
SET actor_name = CONCAT(upper(first_name)," ",upper(last_name));
select actor_name from actor;
SELECT actor_name, actor_ID from actor 
WHERE first_name='Joe';
SELECT last_name from actor
where last_name like '%GEN%';
SELECT actor_name FROM actor
WHERE last_name like '%LI%'
ORDER BY last_name, first_name ASC; 
SELECT country_id, country 
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
ALTER TABLE actor 
ADD COLUMN description BLOB AFTER actor_name;
SELECT * FROM actor;
ALTER TABLE actor
DROP COLUMN description;
SELECT * FROM actor;
SELECT last_name, count(*) FROM actor 
GROUP BY last_name HAVING count(*) >=2;
SET sql_safe_updates=0;  

UPDATE actor SET actor_name = 'HARPO WILLIAMS', first_name = 'HARPO', last_name = 'WILLIAMS' 
WHERE actor_name = 'GROUCHO WILLIAMS';
SELECT actor_name FROM actor
WHERE last_name='Williams';
UPDATE actor SET actor_name = 'GROUCHO WILLIAMS', first_name = 'GROUCHO' 
WHERE first_name = 'HARPO';
SHOW CREATE TABLE address;
SELECT * FROM address;
SELECT * FROM staff;

SELECT staff.first_name, staff.last_name, address.address
FROM staff INNER JOIN address ON staff.address_id = address.address_id
order by staff.first_name;

SELECT staff.first_name, staff.last_name, sum(payment.amount) AS "August Expenses"  -- finally woohooo 
FROM staff INNER JOIN payment ON staff.staff_id = payment.staff_id 
WHERE (payment.payment_date BETWEEN '2005-08-01 00:00:00' AND '2005-09-1 00:00:00')
GROUP BY staff.first_name;

SELECT film.title, count(film_actor.actor_ID) 
FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.title;
SELECT count("Hunchback Impossible") from inventory;

SELECT customer.last_name, customer.first_name, payment.amount  
FROM customer JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY last_name
ORDER BY last_name;

SELECT title FROM film 
WHERE title LIKE 'K%' OR title LIKE 'Q%';

-- 7b
select actor_name from actor where actor_ID in
	(
	select actor_id from film_actor where film_id IN
		(
		select film_id from film where title = "Alone Trip"  -- inside
		)
	);

-- 7c   
SELECT customer.email, customer.first_name, customer.last_name 
FROM customer
JOIN address
ON customer.address_id= address.address_id 
JOIN city
ON address.city_id = city.city_id
JOIN country 
ON city.country_id = country.country_id
WHERE country='Canada';

-- 7d
SELECT title FROM film where rating = 'G';

-- 7e
SELECT count(title), title 
FROM film 
JOIN inventory 
ON film.film_id = inventory.film_id
JOIN rental 
ON rental.inventory_id = inventory.inventory_id
GROUP BY title
order by count(title) DESC;

-- 7f 
SELECT sum(amount), store_id
FROM payment
JOIN staff 
ON payment.staff_id = staff.staff_id
Group by store_id; 
 
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country  
FROM store
JOIN address 
ON store.address_id = address.address_id
JOIN city 
ON city.city_id = address.city_id
JOIN country
ON country.country_id = city.country_id;

use sakila;

-- * 7h. List the top five genres in gross revenue in descending order. 
SELECT  sum(payment.amount), category.name
FROM payment 
JOIN  rental
ON payment.rental_id=rental.rental_id 
JOIN  inventory
ON inventory.inventory_id = rental.inventory_id
JOIN  film_category 
ON film_category.film_id  = inventory.film_id
JOIN  category 
ON category.category_id = film_category.category_ID
GROUP BY category.name
ORDER BY sum(payment.amount) DESC LIMIT 5;

CREATE VIEW `top_5_genres` 
AS SELECT  sum(payment.amount), category.name
FROM payment 
JOIN  rental
ON payment.rental_id=rental.rental_id 
JOIN  inventory
ON inventory.inventory_id = rental.inventory_id
JOIN  film_category 
ON film_category.film_id  = inventory.film_id
JOIN  category 
ON category.category_id = film_category.category_ID
GROUP BY category.name
ORDER BY sum(payment.amount) DESC LIMIT 5;

SELECT * FROM top_5_genres;

DROP VIEW top_5_genres;


