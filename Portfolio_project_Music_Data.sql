Q1:Senior most employee

select employee_id,last_name,first_name,title,levels from employee
order by levels desc
limit 1;

Q2:Which countries have the most invoices

select billing_country, count(*) as total_invoice from invoice
group by billing_country
order by total_invoice desc
limit 1;


Q3:what are top 3 values of total invoices

Select total from invoice
order by total desc
limit 3;

Q4:which city purchased the most

select billing_city, sum(total) as invoice_total from invoice
group by billing_city
order by invoice_total desc
limit 1;

Q5:who is the best customer

select c.customer_id,c.first_name,c.last_name,c.city,sum(i.total) as Amount_purchased
from customer c join invoice i on c.customer_id=i.customer_id
group by c.customer_id
order by Amount_purchased desc
limit 1;

 set2
Q6:Email, first_name,last_name and genre of all Rock musuc listners, sortby email startig with A.

select distinct(c.email),c.first_name,c.last_name from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
where track_id in 
				(select track_id from track t 
					join genre g
					on t.genre_id = g.genre_id
					where g.name like 'Rock'
)
					
order by c.email 

Q7:Artist name and total track count of top 10 rock bands

select Ar.artist_id,Ar.name, count(Ar.artist_id) as no_of_songs from track t
join Album A on A.album_id = t.album_id
join Artist Ar on Ar.artist_id=A.artist_id
join genre g on g.genre_id=t.genre_id
where g.name like 'Rock'
group by Ar.artist_id
order by no_of_songs desc
limit 10

Q8:All track names that have song length loger than avg song length, return the name and milisecond for each track, orderby songlength
longest to smallest

select name, milliseconds  from track 
where milliseconds> (
					select avg(milliseconds) as Average_song_length
					from track
					)
order by milliseconds desc

set3
Q9: find how much amount spent by each customernon artists? write a query to return customer name , artist anme and total spent.

With best_selling_artists as
(
  select ar.artist_id,ar.name,sum(il.unit_price*il.quantity) as Amount_spent from invoice_line il
  join track t on il.track_id=t.track_id
  join album a on a.album_id=t.album_id
  join artist ar on ar.artist_id=a.artist_id
  group by ar.artist_id
  order by Amount_spent desc
  
)

select c.customer_id,c.first_name,c.last_name,bsa.name,sum(il.unit_price*il.quantity) as Amount_spent from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album a on a.album_id=t.album_id
join best_selling_artists bsa on bsa.artist_id=a.artist_id
group by c.customer_id,bsa.name
order by Amount_spent desc

Q10:most popular music genre for each country based on purchase

select i.billing_country,g.name,count(il.quantity) as cpurchase from invoice i
join invoice_line il on i.invoice_id =il.invoice_id
join track t on t.track_id=il.track_id
join genre g on g.genre_id=t.genre_id
group by i.billing_country,g.name
order by cpurchase desc
