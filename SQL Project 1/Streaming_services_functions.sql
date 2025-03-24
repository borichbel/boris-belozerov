/*
 1.What are top 3 countries whose films won the largest quantity of the awards in 2024? 
2. Who are the performers of the soundtracks of films from the collection "Romantic Comedies?
3. What role did the “Terry Mourbey” play in a film?
4.What fantasy films are on the site that last less than 120 minutes?
5.Which science fiction films were released in 2017?
6.Who played in the film “The Dark Knight”?
7.What film/films has/have the max rating on the website for films that have received the “Best Streaming Comedy Series” nomination?
8.What soundtracks are used in Canadian films released after 2010?
9.Which films on the website from the collection “Musical Masterpieces" have a rating above 4?
 */


 /* 1.What are top 3 countries whose films won the largest quantity of the awards in the period of 2000-2024?  */
select	ssm.country,
		COUNT(ssa.award_id) awards
from public.streaming_service_movies ssm 
right join public.streaming_service_awards ssa on ssm.film_id = ssa.film_id
where ssa."year" between 2000 and 2024
group by ssm.country
order by awards desc
limit 3;


/*2. Who are the performers of the soundtracks of films from the collection "Romantic Comedies? */
select sss.performer
from public.streaming_service_collection ssc 
join public.streaming_service_film_collection ssfc on ssc.collection_id = ssfc.collection_id
join public.streaming_service_soundtrack sss on ssfc.film_id = sss.film_id
where ssc.name_coll = 'Romantic Comedies';


/* 3. What role did the “Terry Mourbey” play in a film? */
select ssaf.role_type
from public.streaming_service_actor_film ssaf 
join public.streaming_service_actor ssa on ssaf.actor_id = ssa.actor_id
where ssa.full_name = 'Terry Mourbey';


/* 4.What fantasy films are on the site that last less than 120 minutes? */
select title
from public.streaming_service_movies 
where duration_min < 120;


/* 5.Which science fiction films were released in 2017? */
select title
from public.streaming_service_movies 
where genre = 'Science Fiction'
	and year = 2017;

/*6.Who played in the film “The Dark Knight”?*/


select ssa.full_name
from public.streaming_service_actor ssa 
join public.streaming_service_actor_film ssaf on ssa.actor_id = ssaf.actor_id
where ssaf.film_id in (select ssm.film_id
						from public.streaming_service_movies ssm 
						where ssm.title = 'The Dark Knight');


/* 7. What film/films has/have the max rating on the website for films that have received the “Best Streaming Comedy Series” nomination?*/

select title, rating
from public.streaming_service_movies ssm
where rating = (
				select max(rating)
				from public.streaming_service_movies ssm 
				where film_id in (select film_id
								from public.streaming_service_awards ssa 
								where nomination = 'Best Streaming Comedy Series'))
	
			and film_id in 		(select film_id
								from public.streaming_service_awards ssa 
								where nomination = 'Best Streaming Comedy Series');



/* 8.What soundtracks are used in Canadian films released after 2010? */
select sss.song_name
from public.streaming_service_soundtrack sss 
full join public.streaming_service_movies ssm on sss.film_id = ssm.film_id
where ssm.country = 'Canada' 
and ssm."year" > 2010;


/* 9. Which films on the website from the collection “Musical Masterpieces" have a rating above 4? */

select title
from streaming_service_movies ssm 
where film_id in(
				select ssfc.film_id
				from streaming_service_film_collection ssfc 
				join streaming_service_collection ssc on ssfc.collection_id = ssc.collection_id
				where ssc.name_coll = 'Musical Masterpieces')
and rating > 4;