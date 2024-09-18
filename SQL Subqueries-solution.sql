-- Contamos el número de copias de la película "Hunchback Impossible" en el inventario
SELECT COUNT(*) AS numero_de_copias
FROM sakila.inventory AS i
JOIN sakila.film AS f ON i.film_id = f.film_id
WHERE f.title = 'Hunchback Impossible';

-- Encontramos la duración promedio de todas las películas
-- y luego listamos las películas cuya duración es mayor que este promedio
SELECT title, length
FROM sakila.film
WHERE length > (
    SELECT AVG(length)
    FROM sakila.film
);

-- Primero, obtenemos el film_id de la película "Alone Trip"
-- Luego, usamos este film_id para encontrar todos los actores que aparecen en esa película
SELECT a.actor_id, a.first_name, a.last_name
FROM sakila.actor AS a
JOIN sakila.film_actor AS fa ON a.actor_id = fa.actor_id
JOIN sakila.film AS f ON fa.film_id = f.film_id
WHERE f.title = 'Alone Trip';

-- Buscamos todas las películas que están en la categoría de "Family"
SELECT f.title
FROM sakila.film AS f
JOIN sakila.film_category AS fc ON f.film_id = fc.film_id
JOIN sakila.category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- Primero obtenemos los customer_id de los clientes que están en Canadá
-- Luego usamos esos customer_id para obtener los detalles de los clientes
SELECT c.first_name, c.last_name, c.email
FROM sakila.customer AS c
WHERE c.address_id IN (
    SELECT a.address_id
    FROM sakila.address AS a
    JOIN sakila.city AS ci ON a.city_id = ci.city_id
    JOIN sakila.country AS co ON ci.country_id = co.country_id
    WHERE co.country = 'Canada'
);
-- Usamos joins para obtener el nombre y el correo electrónico de los clientes de Canadá
SELECT c.first_name, c.last_name, c.email
FROM sakila.customer AS c
JOIN sakila.address AS a ON c.address_id = a.address_id
JOIN sakila.city AS ci ON a.city_id = ci.city_id
JOIN sakila.country AS co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- Unimos las tablas customer, address, city y country para obtener el nombre y el correo electrónico de los clientes de Canadá
SELECT c.first_name, c.last_name, c.email
FROM sakila.customer AS c
JOIN sakila.address AS a ON c.address_id = a.address_id
JOIN sakila.city AS ci ON a.city_id = ci.city_id
JOIN sakila.country AS co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- Primero, encontramos el actor que ha actuado en la mayor cantidad de películas
WITH ActorProlific AS (
    SELECT fa.actor_id, COUNT(fa.film_id) AS num_films
    FROM sakila.film_actor AS fa
    GROUP BY fa.actor_id
    ORDER BY num_films DESC
    LIMIT 1
)
-- Usamos el actor_id del actor más prolífico para listar las películas en las que ha actuado
SELECT f.title
FROM sakila.film_actor AS fa
JOIN sakila.film AS f ON fa.film_id = f.film_id
JOIN ActorProlific AS ap ON fa.actor_id = ap.actor_id;


-- Primero, encontramos el cliente que ha realizado el mayor monto de pagos
WITH ClienteRentable AS (
    SELECT p.customer_id, SUM(p.amount) AS total_pago
    FROM sakila.payment AS p
    GROUP BY p.customer_id
    ORDER BY total_pago DESC
    LIMIT 1
)
-- Usamos el customer_id del cliente más rentable para listar las películas que ha alquilado
SELECT f.title
FROM sakila.rental AS r
JOIN sakila.inventory AS i ON r.inventory_id = i.inventory_id
JOIN sakila.film AS f ON i.film_id = f.film_id
JOIN ClienteRentable AS cr ON r.customer_id = cr.customer_id;

-- Primero, calculamos el gasto promedio de los clientes
-- Luego, listamos los clientes que gastaron más que este promedio
SELECT customer_id, total_amount_spent
FROM (
    SELECT customer_id, SUM(amount) AS total_amount_spent
    FROM sakila.payment
    GROUP BY customer_id
) AS total_spent
WHERE total_amount_spent > (
    SELECT AVG(total_amount_spent)
    FROM (
        SELECT SUM(amount) AS total_amount_spent
        FROM sakila.payment
        GROUP BY customer_id
    ) AS avg_spent
);

