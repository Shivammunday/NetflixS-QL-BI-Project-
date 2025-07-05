select * from netflix;
--1. Count the number of Movies vs TV Shows
select type,count(*) from netflix group by 1;
--2. Find the most common rating for movies and TV shows
select type,rating from (select type ,rating,count(*),rank() over(PARTITION BY type order by count(*) DESC) AS RANKING from netflix group by 1,2 order by 1,3 DESC) 
where ranking=1;
--3.List all movies released in a specific year (e.g., 2020)
select * from netflix where release_year='2020'
--4. Find the top 5 countries with the most content on Netflix
CREATE Table top_10_countries AS select 
       DISTINCT TRIM(UNNEST(STRING_TO_ARRAY(country,','))),COUNT(*) 
  from netflix where type='Movie' GROUP BY 1 ORDER BY 2 DESC LIMIT 10;
--5.Identify the longest movie
SELECT  TYPE,TITLE,duration FROM NETFLIX 
where type='Movie' and duration is not null 
oRDER By CAST(split_part(duration, ' ', 1) AS INTEGER) DESC 
limit by 10 ;
--6. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT TRIM(UNNEST(STRING_TO_ARRAY(DIRECTOR,','))) AS DIRECTOR,TYPE,TITLE FROM NETFLIX
WHERE DIRECTOR='Rajiv Chilaka' ;
--7.List all TV shows with more than 5 seasons
SELECT title,duration FROM NETFLIX WHERE  CAST(split_part(duration,' ',1) as integer)>=5 and type='TV Show' order by CAST(split_part(duration,' ',1) as integer)  DESC;
--8.Count the number of content items in each genre
create table top_5_categories as SELECT DISTINCT TRIM(UNNEST(STRING_TO_ARRAY(listed_in,','))) , COUNT(show_id)
from netflix group by 1 limit 5;
--9.List all movies that are documentaries
select title from (SELECT DISTINCT TRIM(UNNEST(STRING_TO_ARRAY(listed_in,','))) as categories ,title
from netflix WHERE TYPE='Movie') where categories='Documentaries'  ;
--10 Find all content without a director
select * from netflix where director is null;
--11.  Find how many movies actor 'Salman Khan' appeared in last 10 years!


select * from netflix where casts ilike '%Salman Khan%' and (select EXTRACT(YEAR FROM CURRENT_DATE)-release_year)<10 ;
--12. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT TRIM(UNNEST(STRING_TO_ARRAY(casts,','))) AS casts,count(*) FROM NETFLIX
WHERE country ilike '%india'  group by 1 order by 2 desc limit 10 ;
--13. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.
WITH MY_CTE AS (select *,
case
     when  description ilike '% kill%' 
     or  description ilike '%violence%' THEN 'BAD FILM'
     ELSE 'GOOD FILM'
END CATEGORY
from netflix)
SELECT TITLE,CATEGORY FROM MY_CTE order by 1

;



