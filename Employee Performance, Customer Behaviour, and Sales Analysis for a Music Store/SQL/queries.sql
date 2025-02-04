----------------------------------------------------------------------------
/*
This project answers 10 questions related to employee performance, customer behavior and sales of a music store.
Skills used: CTEs, Subqueres, Joins, String manipulation and formatting, Grouping, filtering, Window functions, Aggregate functions, Date and time manipulation and formatting
*/
----------------------------------------------------------------------------

--the most senior employee in every job title
SELECT CONCAT(first_name,' ', last_name) AS employee_name,
	title
FROM employees
WHERE hire_date IN (
	SELECT
	MIN(hire_date)
FROM employees
GROUP BY title
)

--Biggest Customers For Each Sales Support Agent
WITH total_spent_by_customer AS(
	SELECT customer_id,
		support_rep_id,
		SUM(total) AS total_customer_spending
	FROM invoices
		INNER JOIN customers
		USING(customer_id)
	GROUP BY customer_id, support_rep_id
	ORDER BY SUM(total) DESC
) 

SELECT 
	e.first_name ||' '||e.last_name AS employee_name,
	c.first_name||' '||c.last_name AS Top_customer_name,
	ROUND(total_customer_spending, 0) AS Top_customer_spending
FROM customers AS c
	INNER JOIN total_spent_by_customer AS tsbp
	USING(customer_id)
	INNER JOIN employees AS e
	ON c.support_rep_id = e.employee_id
WHERE total_customer_spending IN (
	SELECT MAX(total_customer_spending)
	FROM total_spent_by_customer
	GROUP BY support_rep_id
	)

--Top 10 Selling Artists
WITH total_track_sales AS (
	SELECT SUM(invoice_lines.unit_price * quantity) AS track_sales,
			SUM(quantity) AS sales_quantity,
		track_id,
		album_id
	FROM invoice_lines
		INNER JOIN tracks
		USING(track_id)
	GROUP BY track_id, album_id
	ORDER BY track_id
)

SELECT 
	albums.artist_id,
	artists.name AS artist_name,
	SUM(track_sales) AS artist_total_sales,
	SUM(sales_quantity) AS number_of_tracks_sold
FROM albums
	INNER JOIN	total_track_sales AS tts
	USING(album_id)
	INNER JOIN artists
	USING(artist_id)
GROUP BY albums.artist_id, artists.name
ORDER BY artist_total_sales DESC, artist_name
LIMIT 10

--The Most Popular Genre In every country
WITH genres_per_countries_ranked AS (
SELECT country,
	genres.name AS genre,
	COUNT(genres.name) AS tracks_bought,
	RANK() OVER(PARTITION BY country ORDER BY COUNT(genres.name) DESC)
FROM (
	SELECT customer_id,
	genre_id
	FROM invoices
		INNER JOIN invoice_lines
		USING(invoice_id)
		INNER JOIN tracks
		USING(track_id)
	GROUP BY 
		customer_id,
		track_id,
		genre_id
	)
	INNER JOIN customers
	USING(customer_id)
	INNER JOIN genres
	USING(genre_id)
GROUP BY genres.name, country
ORDER BY country, tracks_bought DESC
)

SELECT country,
	genre,
	tracks_bought
FROM genres_per_countries_ranked
WHERE rank = 1
ORDER BY country

--The Average and The Median quantity bought
SELECT 
	ROUND(AVG(quantity), 0) AS average_quantity,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY quantity) AS median_quantity
FROM (
	SELECT 
		SUM(quantity) AS quantity
	FROM invoice_lines
	GROUP BY invoice_id
)

--Total Sales Per Year
SELECT EXTRACT(YEAR FROM invoice_date) AS year,
	ROUND(SUM(total), 0) AS total_sales
FROM invoices
GROUP BY EXTRACT(YEAR FROM invoice_date)
ORDER BY year

--Total Sales Per Month In Each Year
SELECT 
		EXTRACT(YEAR FROM invoice_date) AS year,
		TO_CHAR(invoice_date, 'Month') AS month,
		ROUND(SUM(total), 0) AS total_sales
FROM invoices
GROUP BY 
		EXTRACT(YEAR FROM invoice_date),
		TO_CHAR(invoice_date, 'Month'),
		EXTRACT(month FROM invoice_date)
ORDER BY year, 
		EXTRACT(month FROM invoice_date)

--The Average Time Between Customer Invoices Per customer
SELECT
	customer_id
	,DATE_TRUNC('hour', AVG(invoice_date::TIMESTAMP-previous_invoice::TIMESTAMP)) AS average_time
FROM (SELECT 
		customer_id
		,invoice_date
		,LAG(invoice_date) OVER(PARTITION BY customer_id ORDER BY invoice_date) AS previous_invoice
	FROM invoices
	)
GROUP BY customer_id
ORDER BY average_time

--The Average Time Between Customer Invoices For All Customers
SELECT 
	DATE_TRUNC('hour', AVG(invoice_date::TIMESTAMP-previous_invoice::TIMESTAMP)) AS average_time
FROM (SELECT 
		customer_id
		,invoice_date
		,LAG(invoice_date) OVER(PARTITION BY customer_id ORDER BY invoice_date) AS previous_invoice
	FROM invoices
	)

--List of Tracks That Did Not Get Any Sales
SELECT
	track_id
	,name
FROM tracks
WHERE track_id NOT IN (
	SELECT 
		track_id
	FROM invoice_lines
)
