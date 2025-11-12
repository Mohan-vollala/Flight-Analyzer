#Display all columns and records from the 'data' table in the 'flight' database
SELECT * FROM flight.data;

--Show the structure of the 'data' table (column names, data types, etc.)
SHOW COLUMNS FROM data;

--Get the list of all unique airlines available in the dataset
SELECT DISTINCT(airline) FROM data;

--Count how many unique flight numbers exist in the dataset
SELECT COUNT(DISTINCT flight_num) FROM data;

--Count the total number of unique flight dates (number of days covered)
SELECT COUNT(DISTINCT `flight date`) AS total_days_data FROM data;

--Calculate the total revenue generated from all flights
SELECT SUM(price) AS total_revenue FROM data;

--Find the maximum, minimum, and average flight price
SELECT 
    MAX(CASE WHEN price THEN price END) AS max_price,
    MIN(CASE WHEN price THEN price END) AS min_price,
    AVG(CASE WHEN price THEN price END) AS avg_price 
FROM data;

--Count the number of bookings made per airline, sorted by highest bookings first
SELECT airline, COUNT(*) AS bookings 
FROM data
GROUP BY airline 
ORDER BY bookings DESC;

--Find the total number of distinct flights operated by each airline
SELECT airline, COUNT(DISTINCT flight_num) AS total_flights 
FROM data
GROUP BY airline 
ORDER BY total_flights DESC;

--Calculate total revenue earned by each airline, sorted by highest revenue
SELECT airline, SUM(price) AS revenue 
FROM data
GROUP BY airline 
ORDER BY revenue DESC;

--Find the minimum and maximum price of flights for each airline
SELECT airline, MIN(price) AS min_price, MAX(price) AS max_price 
FROM data
GROUP BY airline;

--Count the total tickets sold per month (based on flight date)
SELECT MONTHNAME(`flight date`) AS month, COUNT(*) AS total_tickets_sold 
FROM data 
GROUP BY MONTHNAME(`flight date`);

--Calculate total revenue per month
SELECT MONTHNAME(`flight date`) AS month, SUM(price) AS revenue 
FROM data 
GROUP BY MONTHNAME(`flight date`);

--Calculate total revenue per flight date
SELECT `flight date`, SUM(price) AS revenue 
FROM data 
GROUP BY `flight date`;

--Top 10 highest revenue-generating dates
SELECT `flight date`, SUM(price) AS revenue 
FROM data 
GROUP BY `flight date` 
ORDER BY revenue DESC 
LIMIT 10;

--Bottom 10 lowest revenue-generating dates
SELECT `flight date`, SUM(price) AS revenue 
FROM data 
GROUP BY `flight date` 
ORDER BY revenue 
LIMIT 10;

--Count total tickets sold per flight date
SELECT `flight date`, COUNT(*) AS tickets_sold 
FROM data 
GROUP BY `flight date`;

--Top 10 dates with the highest number of tickets sold
SELECT `flight date`, COUNT(*) AS tickets_sold 
FROM data 
GROUP BY `flight date` 
ORDER BY tickets_sold DESC 
LIMIT 10;

--Bottom 10 dates with the least number of tickets sold
SELECT `flight date`, COUNT(*) AS tickets_sold 
FROM data 
GROUP BY `flight date` 
ORDER BY tickets_sold 
LIMIT 10;

--Count number of flights per airline on each flight date
SELECT `flight date`, airline, COUNT(*) AS flights_count 
FROM data 
GROUP BY `flight date`, airline;

--Count number of flights operated by each airline per month
SELECT MONTHNAME(`flight date`) AS month, airline, COUNT(*) AS flights_count 
FROM data 
GROUP BY MONTHNAME(`flight date`), airline;

--Find the highest-priced flight for each airline
SELECT d.airline, d.flight_num, d.price 
FROM data d 
JOIN (
    SELECT airline, MAX(price) AS max_p 
    FROM data 
    GROUP BY airline
) m 
ON d.airline = m.airline AND d.price = m.max_p;

--Count total number of distinct flights per airline (sorted)
SELECT airline, COUNT(DISTINCT flight_num) AS total_cnt 
FROM data 
GROUP BY airline 
ORDER BY total_cnt DESC;

--Calculate total revenue from all flights (sanity check)
SELECT SUM(price) FROM data;

--Find top 10 most frequently occurring flight numbers
SELECT flight_num, COUNT(*) AS cnt 
FROM data 
GROUP BY flight_num 
ORDER BY cnt DESC 
LIMIT 10;

--Count total flights between each 'from' and 'to' city pair
SELECT `from`, `to`, COUNT(*) AS total_cnt 
FROM data 
GROUP BY `from`, `to` 
ORDER BY total_cnt;

--Count total flights for each airline between specific routes
SELECT airline, `from`, `to`, COUNT(*) AS total_cnt 
FROM data 
GROUP BY airline, `from`, `to` 
ORDER BY total_cnt DESC;

--Calculate total revenue generated per route (from–to)
SELECT `from`, `to`, SUM(price) AS revenue 
FROM data 
GROUP BY `from`, `to` 
ORDER BY revenue DESC;

--Calculate route-wise revenue for each airline
SELECT airline, `from`, `to`, SUM(price) AS revenue 
FROM data 
GROUP BY airline, `from`, `to` 
ORDER BY revenue DESC;

--Count total number of non-stop flights per airline
SELECT airline, COUNT(*) AS nonstop_count 
FROM data 
WHERE stops = 'non-stop' 
GROUP BY airline 
ORDER BY nonstop_count DESC;

--alculate average flight price based on the number of stops
SELECT stops, ROUND(AVG(price), 2) AS avg_price 
FROM data 
GROUP BY stops;

--Find the most expensive economy class flight
SELECT airline, flight_num, class, price 
FROM data 
WHERE price = (SELECT MAX(price) FROM data WHERE class = 'economy');

--Find the cheapest economy class flight
SELECT airline, flight_num, class, price 
FROM data 
WHERE price = (SELECT MIN(price) FROM data WHERE class = 'economy');

--Find the most expensive business class flight
SELECT airline, flight_num, class, price 
FROM data 
WHERE price = (SELECT MAX(price) FROM data WHERE class = 'business');

--Find the cheapest business class flight
SELECT airline, flight_num, class, price 
FROM data 
WHERE price = (SELECT MIN(price) FROM data WHERE class = 'business');

--Calculate the average price of flights per airline (sorted by price)
SELECT airline, ROUND(AVG(price), 2) AS avg_price 
FROM data 
GROUP BY airline 
ORDER BY avg_price;

--Display top 5 most expensive flights overall
SELECT airline, flight_num, price AS expensive_flights_price 
FROM data 
ORDER BY price DESC 
LIMIT 5;

-- Display 5 cheapest flights overall
SELECT airline, flight_num, price AS cheapest_flights_price 
FROM data 
ORDER BY price 
LIMIT 5;

--Rank airlines by their average flight price (lowest to highest)
SELECT airline, AVG(price) AS avg_price, RANK() OVER (ORDER BY AVG(price)) AS rank_by_price 
FROM data 
GROUP BY airline;

--Find airlines whose average price is above the overall average
SELECT airline, AVG(price) AS avg_price 
FROM data 
GROUP BY airline 
HAVING AVG(price) > (SELECT AVG(price) FROM data);

--Count number of departures from each city (most frequent departure points)
SELECT `from` AS dep_city, COUNT(*) AS cnt 
FROM data 
GROUP BY `from` 
ORDER BY cnt DESC;

-- Calculate average flight price between each route (from–to pair)
SELECT `from`, `to`, ROUND(AVG(price), 2) AS avg_price 
FROM data 
GROUP BY `from`, `to`;

--Rank flights within each airline based on price (highest first)
SELECT airline, flight_num, price, 
RANK() OVER (PARTITION BY airline ORDER BY price DESC) AS price_rank 
FROM data;

--Retrieve the 2nd most expensive flight for each airline
SELECT * 
FROM (
    SELECT airline, flight_num, price, 
           RANK() OVER (PARTITION BY airline ORDER BY price DESC) AS rnk 
    FROM data
) d 
WHERE rnk = 2;

--Display the entire dataset (sanity check)
SELECT * FROM data;

--Find the earliest (first) flight for each date based on departure time
SELECT `flight date`, flight_num, dep_time
FROM (
    SELECT `flight date`, flight_num, dep_time,
           ROW_NUMBER() OVER (PARTITION BY `flight date` ORDER BY dep_time ASC) AS rn
    FROM data
) t
WHERE rn = 1;

--Find the latest (last) flight for each date based on arrival time
SELECT `flight date`, flight_num, arr_time
FROM (
    SELECT `flight date`, flight_num, arr_time, 
           ROW_NUMBER() OVER (PARTITION BY `flight date` ORDER BY arr_time DESC) AS rn
    FROM data
) d 
WHERE rn = 1;
