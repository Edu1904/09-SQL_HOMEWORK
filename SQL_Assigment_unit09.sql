USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
from actor
group by actor_id;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT first_name
from actor
group by actor_id;
SELECT last_name
from actor
group by actor_id;

SELECT concat(first_name, ' ', Last_name) as Actor_Name
from actor
group by actor_id;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
from actor
Where  first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name 
from actor
Where last_name like '%Gen%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT actor_id, first_name, last_name 
from actor
Where last_name like '%Li%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
from country
Where country In 
('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
SELECT * From actor;
alter table actor
add column  description BLOB Null AFTER last_name;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
SELECT * From actor;
alter table actor
drop column  description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(*) as 'last_name_count'
from actor
group by last_name; 

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT last_name, count(*) as 'last_name_count'
from actor
group by last_name Having count(*) >= 2; 

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
set first_name = 'HARPO'
Where first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
set first_name = 'GROUCHO'
WHERE FIRST_NAME = 'HARPO' AND last_name = 'WILLIAMS' AND actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DESCRIBE sakila.address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address
SELECT first_name, last_name, address
FROM staff s
INNER JOIN address a  
ON s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT first_name, last_name, sum(amount)
FROM staff s
INNER JOIN payment p  
ON s.staff_id = p.staff_id
group by p.staff_id 
order by last_name ASC;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT title, COUNT(actor_id)
FROM film f
INNER JOIN film_actor fa 
ON f.film_id = fa.film_id
group by title; 

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, COUNT(inventory_id)
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
WHERE title ="Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name, last_name, sum(amount)
FROM customer c
INNER JOIN payment p
ON c.customer_id = p.customer_id
group by c.customer_id
order by last_name ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the 
-- letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose 
-- language is English.
USE sakila;
SELECT title FROM film
    WHERE language_id in
    (SELECT language_id 
    FROM language 
    WHERE name= "English")
AND (title LIKE'Q%') OR (title LIKE'K%');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
USE sakila;
SELECT last_name, first_name 
FROM actor 
WHERE actor_id in
  (SELECT actor_id  FROM film_actor fa
  WHERE film_id in
       (SELECT film_id FROM film
       WHERE title = "Alone Trip"));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.
-- Use joins to retrieve this information.
USE sakila;
SELECT last_name, first_name, email
FROM customer c
INNER JOIN country co
ON c.customer_id = co.country_id
WHERE country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films. 
USE sakila;
SELECT title, category
from film_list
WHERE category = 'family';

-- 7e. Display the most frequently rented movies in descending order.
USE sakila;
SELECT i.film_id, ft.title, count(r.inventory_id)
FROM inventory i
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN film_text ft
ON i.film_id = ft.film_id
GROUP BY r.inventory_id
ORDER BY COUNT(r.inventory_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
USE sakila;
SELECT s.store_id, sum(amount)
FROM store s
INNER JOIN staff
ON s.store_id = staff.store_id
INNER JOIN payment p
ON staff.staff_id = p.staff_id
GROUP BY s.store_id
ORDER BY SUM(amount);

-- 7g. Write a query to display for each store its store ID, city, and country.
USE sakila;
SELECT s.store_id, c.city, co.country
FROM store s
INNER JOIN customer cu
ON s.store_id = cu.store_id
INNER JOIN address a
ON s.address_id = a.address_id
INNER JOIN  city c
ON a.city_id = c.city_id
INNER JOIN country co
ON c.country_id = co.country_id
GROUP BY s.store_id;
-- ORDER BY ;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: 
-- category, film_category, inventory, payment, and rental.)
USE sakila;
SELECT name, SUM(p.amount)
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id
INNER JOIN inventory i
ON fc.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
USE sakila;

CREATE VIEW TOP_5_GENRES_GROSS_REVENUE AS


SELECT name, SUM(p.amount)
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id
INNER JOIN inventory i
ON fc.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM TOP_5_GENRES_GROSS_REVENUE;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW TOP_5_GENRES_GROSS_REVENUE;
