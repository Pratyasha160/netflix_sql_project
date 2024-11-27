DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
SELECT * FROM netflix;

select count(*) as total_content from netflix;

select distinct type from netflix;

select type, count(*) as total_count from netflix group by type ;

-- 15 Business Problems & Solutions
SELECT 
	type,
	rating
	FROM
(SELECT
	type,
    rating,
	count(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC)as ranking
from netflix
group by 1,2) AS t1 
WHERE ranking=1;

SELECT *
FROM netflix
WHERE type='Movie' and release_year = 2020;

select 
	country,
	total_content
	from(
		select 
			UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
			count(show_id)as total_content
			from netflix
			group by country
		) as t2
		where country is not null
	order by total_content desc
	limit 5;



select title,  substring(duration, 1,position ('m' in duration)-1)::int duration
from Netflix
where type = 'Movie' and duration is not null
order by 2 desc
limit 1;

select*
from netflix
where
TO_DATE(date_added,'Month DD,YYYY')>=CURRENT_DATE-INTERVAL '5 years';

SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';

select * from netflix where director ilike '%Rajiv Chilaka%';

select * from netflix
where type='TV Show' and 
SPLIT_PART(duration,' ',1)::numeric> 5 ;

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content,
	FROM netflix
GROUP BY 1;

select
EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY') ) AS year,
COUNT(*) as yearly_content,
round(
	count(*)::numeric/(SELECT count(*) from netflix where country='India')::numeric*100
	 ,2)as avg_content_per_year
	
FROM netflix
where country='India'
GROUP BY 1;

SELECT * 
FROM netflix
WHERE listed_in ILIKE '%Documentaries%';

SELECT * FROM netflix
where 
director IS NULL;

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

  
SELECT 
UNNEST(STRING_TO_ARRAY(casts, ','))as actors,
count(*)as total_content
from netflix
WHERE country ILIKE '%India'
GROUP BY 1
ORDER BY 2 desc
LIMIT 10;

WITH new_table 
AS
 (SELECT title,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix)
	SELECT 
	category,
	count(*) as total_content
	from new_table 
	GROUP BY 1;

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
15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.


