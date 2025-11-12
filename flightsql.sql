#Display all columns and records from the 'data' table in the 'flight' database
select * from flight.data;

--Show the structure of the 'data' table (column names, data types, etc.)
show columns from data;

--Get the list of all unique airlines available in the dataset
select distinct(airline) from data;

--Count how many unique flight numbers exist in the dataset
select count(distinct flight_num) from data;

--Count the total number of unique flight dates (number of days covered)
select count(distinct `flight date`) as total_days_data from data;

--Calculate the total revenue generated from all flights
select sum(price) as total_revenue from data;

--Find the maximum, minimum, and average flight price
selecr max(case when price then price end) as max_price,
       min(case when price then price end) as min_price,
       avg(case when price then price end) as avg_price from data;
    

--Count the number of bookings made per airline, sorted by highest bookings first
select airline,count(*) as bookings from data
group by airline order by bookings desc;

--Find the total number of distinct flights operated by each airline
select airline,count(distinct flight_num) as total_flights
    from data group by airline 
    order by total_flights desc;

--Calculate total revenue earned by each airline, sorted by highest revenue
select airline,sum(price) as revenue from data 
group by order by revenue desc;

--Find the minimum and maximum price of flights for each airline
select airline,min(price) as min_price,max(pirce) as max_price
from data 
group by airline;

--Count the total tickets sold per month (based on flight date)
select monthname(`flight date`) as month, count(*) as total_tickets_sold 
from data 
group by monthname(`flight date`);


--Calculate total revenue per month
select monthname(`flight date`) as month, sum(price) as revenue 
from data 
group by monthname(`flight date`);

--Calculate total revenue per flight date
select `flight date`, sum(price) as revenue 
from data 
group by  `flight date`;

--Top 10 highest revenue-generating dates
select `flight date`, sum(price) as revenue 
from data group by `flight date` 
order by revenue desc 
limit 10;

--Bottom 10 lowest revenue-generating dates
select `flight date`, sum(price) as revenue 
from data 
group by `flight date` order by revenue 
limit 10;

--Count total tickets sold per flight date
select `flight date`, count(*) as tickets_sold 
from data group by `flight date`;

--Top 10 dates with the highest number of tickets sold
select `flight date`, count(*) as tickets_sold 
from data 
group by `flight date` 
order by tickets_sold desc 
limit 10;

--Bottom 10 dates with the least number of tickets sold
select `flight date`, count(*) as tickets_sold 
from data group by `flight date` 
order by tickets_sold limit 10;

--Count number of flights per airline on each flight date
select `flight date`, airline, count(*) as flights_count 
from data 
group by `flight date`, airline;

--Count number of flights operated by each airline per month
select monthname(`flight date`) as month, airline, count(*) as flights_count 
from data 
group by monthname(`flight date`), airline;

--Find the highest-priced flight for each airline
select d.airline, d.flight_num, d.price 
from data d 
join (
   select airline, max(price) as max_p 
    from data 
     group by airline
) m 
on d.airline = m.airline and d.price = m.max_p;

--Count total number of distinct flights per airline (sorted)
select airline, count(distinct flight_num) as total_cnt 
from data group by airline 
order by total_cnt desc;

--Calculate total revenue from all flights (sanity check)
select sum(price) from data;

--Find top 10 most frequently occurring flight numbers
select flight_num, count(*) as cnt 
from data 
group by flight_num 
order by cnt desc limit 10;

--Count total flights between each 'from' and 'to' city pair
select `from`, `to`, count(*) as total_cnt 
from data 
group by  `from`, `to` 
order by total_cnt;

--Count total flights for each airline between specific routes
select airline, `from`, `to`,count(*) as total_cnt 
from data group by airline, `from`, `to` 
order by total_cnt desc;

--Calculate total revenue generated per route (from–to)
select `from`, `to`, sum(price) as revenue 
from data 
group by `from`, `to`  order by revenue desc;

--Calculate route-wise revenue for each airline
select  airline, `from`, `to`, sum(price) as revenue 
from data  group by  airline, `from`, `to` 
order by revenue desc;

--Count total number of non-stop flights per airline
select airline, count(*) as nonstop_count 
from data where stops = 'non-stop' 
group by airline 
order by nonstop_count desc;

--alculate average flight price based on the number of stops
select stops, round(avg(price), 2) as avg_price 
from data 
group by stops;

--Find the most expensive economy class flight
select airline, flight_num, class, price 
from data 
where price = (select max(price) from data where class='economy');

--Find the cheapest economy class flights
select airline, flight_num, class, price 
from data 
where price=(select min(price) from data where class='economy');

--Find the most expensive business class flight
select airline, flight_num, class, price 
from data 
where price=(select max(price) from data where class='business');

--Find the cheapest business class flight
select airline, flight_num, class, price 
from data 
where price=(select min(price) from data where class='business');

--Calculate the average price of flights per airline (sorted by price)
select airline, round(avg(price), 2) as avg_price 
from data 
group by airline order by avg_price;

--Display top 5 most expensive flights overall
select airline, flight_num, price as expensive_flights_price 
from data order by price desc 
limit 5;

-- Display 5 cheapest flights overall
select airline, flight_num, price as cheapest_flights_price 
from data 
order by price limit 5;

--Rank airlines by their average flight price (lowest to highest)
select airline, avg(price) as avg_price, rank() over (order by avg(price)) as rank_by_price 
from data 
group by airline;

--Find airlines whose average price is above the overall average
select airline, avg(price) as avg_price 
from data group by airline 
having avg(price) > (select avg(price) from data);

--Count number of departures from each city (most frequent departure points)
select `from` as dep_city, count(*) as cnt 
from data 
group by `from` 
order by cnt desc;

-- Calculate average flight price between each route (from–to pair)
select `from`, `to`, round(avg(price), 2) as avg_price 
from data 
group by `from`, `to`;

--Rank flights within each airline based on price (highest first)
select  airline, flight_num, price, 
rank() over (partition by airline order by price desc) as price_rank 
from data;

--Retrieve the 2nd most expensive flight for each airline
select * 
from (
    select airline, flight_num, price, 
           RANK() OVER (PARTITION by airline order by price desc) as rnk 
    from data
) d 
where rnk = 2;

--Display the entire dataset (sanity check)
select * from data;

--Find the earliest (first) flight for each date based on departure time
select `flight date`, flight_num, dep_time
from (
    select `flight date`, flight_num, dep_time,
          row_number() over (partition by `flight date` order by dep_time) as rn
    from data
) as t where rn = 1;

--Find the latest (last) flight for each date based on arrival time
select `flight date`, flight_num, arr_time
from (
   select `flight date`, flight_num, arr_time, 
           row_number() over (partition by light date` order by arr_time desc) as rn
    from data
) as t where rn = 1;
