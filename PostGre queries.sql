/*

1. Count the number of Movies vs TV Shows
2. Find the most common rating for movies and TV shows
3. List all movies released in a specific year (e.g., 2020)
4. Find the top 5 countries with the most content on Netflix
5. Identify the longest movie
6. Find content added in the last 5 years
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
8. List all TV shows with more than 5 seasons
9. Count the number of content items in each genre
10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
11. List all movies that are documentaries
12. Find all content without a director
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.



--1. Count the number of Movies vs TV Shows

select 
	type, 
	count(*) contentType
from netflix
group by type



--2. Find the most common rating for movies and TV shows

with cte_ratingCount as 
(
	select 
		type, 
		rating, 
		count(rating) RatingCount
	from netflix
	group by type, rating
),
RankedRating as
(
	select
		type,rating, RatingCount,
		dense_rank() over(Partition by type order by ratingCount desc) rankedRating
	from cte_ratingCount
)
select * from rankedRating
where rankedRating = 1



--3. List all movies released in a specific year (e.g., 2020)

select
	*
from netflix
where release_year = 2020



--4. Find the top 5 countries with the most content on Netflix

with cte_releaseFilmCountry as
(
	select 
		*,
		unnest(STRING_to_array(country, ',')) as releaseCountry
	from netflix
),
cte_countryCount as
(
	select 
		releaseCountry,
		count(releaseCountry) as countryCount
	from cte_releaseFilmCountry
	group by releaseCountry
)
select
	*
from cte_countryCount
order by countryCount desc
limit 5



--5. Identify the longest movie

SELECT 
	*
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::int DESC



--6. Find content added in the last 5 years

select 
	*
from netflix
where release_year >=2019



-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select
	*
from(
	select 
		*,
		unnest(string_to_array(director,',')) as directorList
	from netflix )t
where directorList = 'Rajiv Chilaka'



--8. List all TV shows with more than 5 seasons

select 
	*
from netflix
where type = 'TV Show' and split_part(duration, ' ', 1)::int > 5



--9. Count the number of content items in each genre

select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(*) genreCount
from netflix
group by 1							-- 1 and 2 represents the column number
order by 2 desc



--10.Find numbers of content each year releases in India on netflix.

select
	release_year,
	count(release_year) as yearlyContent
from netflix
where country = 'India'
group by release_year
order by yearlyContent desc


--11. List all movies that are documentaries

select 
	*
from netflix
where listed_in like '%Documentaries%'



--12. Find all content without a director

select * from netflix where director is null



--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select
	*
from netflix
where casts like '%Salman Khan%'
and release_year > 2013



--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select
	unnest(string_to_array(casts,',')) as cast,
	count(*)
from netflix
where country like '%India%'
group by 1
order by 2 desc
limit 10



--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

select
	category, type,
	count(category) as categoryCount
from(
	select 
		show_id, title,type,
		description,
		case
			when description ilike '%kill%' or description ilike '%violence%' then 'Bad'
			else 'Good'
		end as category
	from netflix
	)t
group by 1, 2
order by 3 desc

*/



