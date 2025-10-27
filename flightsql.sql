SELECT * FROM flight.data;
show columns from data;

select distinct(airline) from data;
select count(distinct(flight_num)) from data;
select count(distinct `flight date`) as total_days_data from data;
select sum(price) as total_revenue from data;

select 
 max(case when price then price end) as max_price,
 min(case when price then price end) as min_price,
 avg(case when price then price end) as avg_price from data;
 
 select airline,count(*) as bookings from data
 group by airline order by bookings desc;
 
select airline,count(distinct flight_num) as total_flights from data
 group by airline order by total_flights desc;

select airline,sum(price)as revenue from data
group by airline order by revenue desc;

select airline,min(price) as min_price,max(price) as max_price from data
group by airline;

select monthname(`flight date`) as month,count(*) as total_tickets_sold from data group by monthname(`flight date`);
select monthname(`flight date`) as month,sum(price) as revneue from data group by monthname(`flight date`);

select `flight date`,sum(price) as revenue from data
group by `flight date`; 

select `flight date`,sum(price) as revenue from data
group by `flight date` order by revenue desc limit 10;
select `flight date`,sum(price) as revenue from data
group by `flight date` order by revenue limit 10;

select `flight date`,count(*) as tickets_sold from data
group by `flight date`;

select `flight date`,count(*) as tickets_sold from data
group by `flight date` order by tickets_sold desc limit 10;
select `flight date`,count(*) as tickets_sold from data
group by `flight date` order by tickets_sold limit 10;

select `flight date`,airline,count(*) from data
group by `flight date`,airline;

select `flight date`,airline,count(*) as flights_count from data
group by `flight date`,airline;

select monthname(`flight date`) as Month,airline,count(*) as flights_count from data
group by monthname(`flight date`),airline;

select d.airline,d.flight_num,d.price from data d join(select airline,max(price) as max_p from  data
group by airline) m on d.airline=m.airline and d.price=m.max_p;

select airline,count( distinct flight_num) as total_cnt from data
group by airline order by total_cnt desc;

select sum(price) from data;
select flight_num,count(*) as cnt from data
group by flight_num order by cnt desc limit 10;

select `from`,`to`,count(*) as total_cnt from data
group by `from`,`to` order by total_cnt;

select airline,`from`,`to`,count(*) as total_cnt from data
group by airline,`from`,`to` order by total_cnt desc;

select `from`,`to`,sum(price) as revenue from data
group by `from`,`to` order by revenue desc;

select airline,`from`,`to`,sum(price) as revenue from data
group by airline,`from`,`to` order by revenue desc;

select airline,count(*) as nonstop_count from data
where stops='non-stop'
group by airline order by nonstop_count desc;

select stops,round(avg(price),2) as avg_price from data group by stops; 

select airline,flight_num,class,price from data
where price=(select max(price) from data where class='economy');

select airline,flight_num,class,price from data
where price=(select min(price) from data where class='economy');

select airline,flight_num,class,price from data
where price=(select max(price) from data where class='business');

select airline,flight_num,class,price from data
where price=(select min(price) from data where class='business');

select airline,round(avg(price),2) as avg_price from data
group by airline order by avg_price;

select airline,flight_num,price as expensive_flights_price from data
order by price desc limit 5;
select airline,flight_num,price as cheapest_flights_price from data
order by price limit 5;

select airline,avg(price) as avg_price, rank() over(order by avg(price)) as rank_by_price from data group by airline;

select airline,avg(price) as avg_price from data group by airline having avg(price)>(select avg(price) from data);

select `from`as dep_city,count(*) as cnt from data group by `from` order by cnt desc;

select `from`,`to`,round(avg(price),2) as avg_price from data
group by `from`,`to`;

SELECT airline, flight_num, price,
rank() over (partition by airline order by price desc) as price_rank
FROM data;

select * from(Select airline,flight_num,price,rank() over(partition by airline order by price desc) as rnk
from data) d where rnk=2;

select * from data;

SELECT "flight date", flight_num, dep_time
FROM (
    SELECT "flight date", flight_num, dep_time,
           ROW_NUMBER() OVER (PARTITION BY "flight date" ORDER BY dep_time ASC) AS rn
    FROM data
) t
WHERE rn=1;

select "flight date", flight_num, arr_time
from(select  "flight date", flight_num, arr_time, row_number() OVER (partition by "flight date" order by arr_time desc) AS rn
from data) d where rn = 1;



