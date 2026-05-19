/*Q1 : who is the senior most employee based on job title ? */
SELECT  TOP 1 * FROM employee
ORDER 
BY levels DESC  


/*Q2: Which countries have the most Invoices? */
SELECT  COUNT(*) AS NO_Of_invoice,billing_country
FROM invoice
GROUP  BY billing_country
ORDER BY  NO_Of_invoice  DESC ;

/*Q3:What are top 3 values of total invoice? */
SELECT  TOP 3 ROUND(total,0) FROM invoice
ORDER BY total DESC ;


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
SELECT SUM(total) AS Invoice_total, billing_city 
FROM invoice
GROUP BY billing_city
ORDER BY Invoice_total DESC
;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
SELECT TOP 1  c.customer_id , c.first_name,c.last_name, SUM(i.total) AS Total 
FROM customer AS c
JOIN invoice AS i
ON c.customer_id = i.customer_id 
GROUP BY c.customer_id , c.first_name,c.last_name
ORDER BY Total DESC

MODERATE QUESTIONS 
/*Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
SELECT  DISTINCT email , first_name , last_name
  FROM customer 
  JOIN invoice 
  ON invoice.customer_id = customer.customer_id
  JOIN invoice_line 
  ON invoice_line.invoice_id = invoice.invoice_id
  WHERE track_id IN(
				SELECT track_id FROM track_2 
				JOIN genre 
				ON genre.genre_id = track_2.genre_id
				WHERE genre.name LIKE 'Rock'

				) ORDER BY email
				;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
SELECT TOP 10  at.artist_id , at.name, COUNT(at.artist_id) AS no_of_song
FROM track_2 AS t
JOIN album AS a 
ON a.album_id = t.album_id
JOIN artist AS at
ON at.artist_id = a.artist_id
JOIN genre AS g
ON g.genre_id = t.genre_id 
WHERE g.name = 'Rock'
GROUP BY at.artist_id , at.name
ORDER BY no_of_song DESC;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
SELECT DISTINCT name, milliseconds 
FROM track_2
WHERE milliseconds >
(
SELECT ROUND(AVG(milliseconds),0) AS AVG_song
FROM track_2)
ORDER BY milliseconds DESC ;

ADVANCE QUESTIONS 
/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */
WITH Best_selling_artist AS (
SELECT TOP 1
at.artist_id  AS artist_id ,
at.name AS artist_name ,
SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice_line AS il
JOIN track_2 AS t 
ON t.track_id = il.track_id
JOIN album AS a
ON a.album_id = t.album_id
JOIN artist AS at
ON at.artist_id = a.artist_id
GROUP BY at.artist_id , at.name
ORDER BY total_sales DESC 
) 

/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */
SELECT c.customer_id , c.first_name , c.last_name, bsa.artist_name ,
SUM(il.quantity * il.unit_price) AS Amount_spent
FROM invoice AS i 
JOIN customer AS c 
ON c.customer_id = i.customer_id
JOIN invoice_line AS il 
ON il.invoice_id = i.invoice_id 
JOIN track_2 AS t 
ON t.track_id = il.track_id 
JOIN album AS al 
ON al.album_id = t.album_id 
JOIN Best_selling_artist AS bsa 
ON bsa.artist_id = al.artist_id 
GROUP BY c.customer_id , c.first_name , c.last_name, bsa.artist_name 
ORDER BY Amount_spent DESC ;

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

WITH popular_genre AS (
SELECT COUNT(il.quantity) AS purchase , c.country , g.name , g.genre_id ,
ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS Row_no
FROM invoice_line AS il
JOIN invoice AS i 
ON i.invoice_id = il.invoice_id 
JOIN customer AS c 
ON c.customer_id = i.customer_id 
JOIN track_2 AS t 
ON t.track_id = il.track_id
JOIN genre AS g 
ON g.genre_id = t.genre_id 
GROUP BY c.country , g.name , g.genre_id 

) 
SELECT * FROM popular_genre WHERE Row_no <= 1















