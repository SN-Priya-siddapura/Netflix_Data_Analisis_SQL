--Netflix Project
DROP TABLE IF EXISTS Netflix;

Create Table netflix
(
	show_id	VARCHAR(10),
	type CHAR(15),
	title VARCHAR(150),
	director CHAR(220),
	casts VARCHAR(800),
	country	VARCHAR(130),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(20),
	duration VARCHAR(20),
	listed_in VARCHAR(250),
	description VARCHAR(260)
);
--view the table
 Select * from netflix;

--COUNT total number of rows
Select Count(*) as total_count from netflix;

--DISTINCT types
Select Distinct type from netflix;

--Count the number of movies and TV shows
Select type, Count(type) as content_count
from netflix
group by type;

--Find the most common rating for movies and TV shows
Select type,rating from
(
	Select type,rating, count(*),
	Rank() Over(Partition by type order by count(*)desc) as ranking
	from netflix
	group by type, rating) as T1
Where ranking = 1;

-- List all movied released in a specfic year(eg 2020)
Select * from netflix
Where type = 'Movie' and release_year = 2020

-- Find the top 5 countries with the most content on netflix
Select 
Ltrim(new_country) as trimed_new_country,
count(show_id) as total_content 
from
(
Select UNNEST(STRING_to_array(country, ',')) as new_country, show_id
from netflix
) as T1
group by new_country
order by total_content Desc, new_country limit 5;

---Identify the longest movie
Select * from netflix
where type = 'movie' and duration = (select max(duration) from netflix)

--Find content added in the last 5 years
Select * from netflix
where to_date(date_added, 'Month DD,YYYY') >= Current_date - Interval '5 years'

--Find all the movies/ TV shows by director 'rajiv chilaka'

Select * from netflix
where director ILIKE '%Rajiv Chilaka%'

--List all the TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

--count the number of content items in each genre
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;

--Find each year and the average numbers of content release in India on netflix
--return top 5 year with highest avg content releaxe
SELECT
    EXTRACT (YEAR FROM TO_DATE(date_added, 'Month DD, ٧٧٧٧')) as year,
    COUNT(*) as yearly_content,
    ROUND(
    COUNT (*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100
    ,2)as avg_content_per_year
 FROM netflix
 WHERE country = 'India'
 GROUP BY 1

--List all the movies that are documentaries
Select * from netflix
where
listed_in Ilike'%documentaries%'

--Find all the content without a director
Select * from Netflix
WHERE
director IS NULL

--Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

Select * from Netflix
where 
casts Ilike '%Salman Khan%'
and release_year> extract(year from current_date) - 10;

--Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

--Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'sensitive'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;



 





