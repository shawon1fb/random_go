create view actor_info(actor_id, first_name, last_name, film_info) as
SELECT a.actor_id,
       a.first_name,
       a.last_name,
       group_concat(DISTINCT (c.name::text || ': '::text) || ((SELECT group_concat(f.title::text) AS group_concat
                                                               FROM film f
                                                                        JOIN film_category fc_1 ON f.film_id = fc_1.film_id
                                                                        JOIN film_actor fa_1 ON f.film_id = fa_1.film_id
                                                               WHERE fc_1.category_id = c.category_id
                                                                 AND fa_1.actor_id = a.actor_id
                                                               GROUP BY fa_1.actor_id))) AS film_info
FROM actor a
         LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
         LEFT JOIN film_category fc ON fa.film_id = fc.film_id
         LEFT JOIN category c ON fc.category_id = c.category_id
GROUP BY a.actor_id, a.first_name, a.last_name;

create view customer_list(id, name, address, "zip code", phone, city, country, notes, sid) as
SELECT cu.customer_id                                           AS id,
       (cu.first_name::text || ' '::text) || cu.last_name::text AS name,
       a.address,
       a.postal_code                                            AS "zip code",
       a.phone,
       city.city,
       country.country,
       CASE
           WHEN cu.activebool THEN 'active'::text
           ELSE ''::text
           END                                                  AS notes,
       cu.store_id                                              AS sid
FROM customer cu
         JOIN address a ON cu.address_id = a.address_id
         JOIN city ON a.city_id = city.city_id
         JOIN country ON city.country_id = country.country_id;

create view film_list(fid, title, description, category, price, length, rating, actors) as
SELECT film.film_id                                                                 AS fid,
       film.title,
       film.description,
       category.name                                                                AS category,
       film.rental_rate                                                             AS price,
       film.length,
       film.rating,
       group_concat((actor.first_name::text || ' '::text) || actor.last_name::text) AS actors
FROM category
         LEFT JOIN film_category ON category.category_id = film_category.category_id
         LEFT JOIN film ON film_category.film_id = film.film_id
         JOIN film_actor ON film.film_id = film_actor.film_id
         JOIN actor ON film_actor.actor_id = actor.actor_id
GROUP BY film.film_id, film.title, film.description, category.name, film.rental_rate, film.length, film.rating;

create view nicer_but_slower_film_list(fid, title, description, category, price, length, rating, actors) as
SELECT film.film_id                                               AS fid,
       film.title,
       film.description,
       category.name                                              AS category,
       film.rental_rate                                           AS price,
       film.length,
       film.rating,
       group_concat(((upper("substring"(actor.first_name::text, 1, 1)) ||
                      lower("substring"(actor.first_name::text, 2))) ||
                     upper("substring"(actor.last_name::text, 1, 1))) ||
                    lower("substring"(actor.last_name::text, 2))) AS actors
FROM category
         LEFT JOIN film_category ON category.category_id = film_category.category_id
         LEFT JOIN film ON film_category.film_id = film.film_id
         JOIN film_actor ON film.film_id = film_actor.film_id
         JOIN actor ON film_actor.actor_id = actor.actor_id
GROUP BY film.film_id, film.title, film.description, category.name, film.rental_rate, film.length, film.rating;

create view sales_by_film_category(category, total_sales) as
SELECT c.name        AS category,
       sum(p.amount) AS total_sales
FROM payment p
         JOIN rental r ON p.rental_id = r.rental_id
         JOIN inventory i ON r.inventory_id = i.inventory_id
         JOIN film f ON i.film_id = f.film_id
         JOIN film_category fc ON f.film_id = fc.film_id
         JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY (sum(p.amount)) DESC;

create view sales_by_store(store, manager, total_sales) as
SELECT (c.city::text || ','::text) || cy.country::text        AS store,
       (m.first_name::text || ' '::text) || m.last_name::text AS manager,
       sum(p.amount)                                          AS total_sales
FROM payment p
         JOIN rental r ON p.rental_id = r.rental_id
         JOIN inventory i ON r.inventory_id = i.inventory_id
         JOIN store s ON i.store_id = s.store_id
         JOIN address a ON s.address_id = a.address_id
         JOIN city c ON a.city_id = c.city_id
         JOIN country cy ON c.country_id = cy.country_id
         JOIN staff m ON s.manager_staff_id = m.staff_id
GROUP BY cy.country, c.city, s.store_id, m.first_name, m.last_name
ORDER BY cy.country, c.city;

create view staff_list(id, name, address, "zip code", phone, city, country, sid) as
SELECT s.staff_id                                             AS id,
       (s.first_name::text || ' '::text) || s.last_name::text AS name,
       a.address,
       a.postal_code                                          AS "zip code",
       a.phone,
       city.city,
       country.country,
       s.store_id                                             AS sid
FROM staff s
         JOIN address a ON s.address_id = a.address_id
         JOIN city ON a.city_id = city.city_id
         JOIN country ON city.country_id = country.country_id;

