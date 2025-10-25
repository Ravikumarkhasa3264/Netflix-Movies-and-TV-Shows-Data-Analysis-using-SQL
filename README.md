# Netflix-Movies-and-TV-Shows-Data-Analysis-using-SQL
This project analyzes the Netflix dataset using SQL Server (SSMS) to gain insights into movies and TV shows. The dataset contains details such as titles, release years, countries, cast, directors, duration, genres, ratings, and descriptions. The goal is to practice SQL queries and extract meaningful information from real-world streaming content.
Dataset

Table Name: netflix_titles
Columns:

show_id – Unique identifier for each title

type – Content type (Movie / TV Show)

title – Name of the movie or TV show

director – Name of the director

cast – List of actors

country – Country of production

date_added – Date added to Netflix

release_year – Year of release

rating – Age rating (e.g., TV-MA, PG-13)

duration – Duration in minutes or seasons

listed_in – Genres / categories

description – Brief description of the title

SQL Queries and Analysis
1. Count the Number of Movies vs TV Shows
SELECT type, COUNT(show_id) AS Total
FROM netflix_titles
GROUP BY type;

2. Find the Most Common Rating for Movies and TV Shows
SELECT type, rating
FROM (
    SELECT type, rating, COUNT(*) AS counting_rating,
           RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rnk
    FROM netflix_titles
    WHERE rating IS NOT NULL
    GROUP BY type, rating
) AS ranked
WHERE rnk = 1;

3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT title, rating, date_added, listed_in
FROM netflix_titles
WHERE type = 'Movie' AND release_year = 2020;

4. Top 5 Countries with the Most Content
SELECT country, COUNT(*) AS total_content
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

5. Identify the Longest Movie
SELECT title, country, date_added, duration
FROM netflix_titles
WHERE type = 'Movie'
  AND TRY_CAST(LEFT(duration, CHARINDEX(' ', duration)-1) AS INT) = (
      SELECT MAX(TRY_CAST(LEFT(duration, CHARINDEX(' ', duration)-1) AS INT))
      FROM netflix_titles
      WHERE type='Movie'
  );

6. Find Content Added in the Last 5 Years
SELECT title
FROM netflix_titles
WHERE date_added >= DATEADD(YEAR, -5, CAST(GETDATE() AS DATE));

7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT director, title, type
FROM netflix_titles
WHERE director LIKE '%Rajiv Chilaka%';

8. List All TV Shows with More Than 5 Seasons
SELECT show_id, type, title, duration
FROM netflix_titles
WHERE type = 'TV Show'
  AND TRY_CAST(LEFT(duration, CHARINDEX(' ', duration + ' ')-1) AS INT) > 5;

9. Count the Number of Content Items in Each Genre
SELECT listed_in AS genre, COUNT(*) AS total_content
FROM netflix_titles
GROUP BY listed_in;

10. Average Number of Content Released per Year in India (Top 5 Years)
SELECT TOP 5 release_year, COUNT(show_id) AS no_of_contents
FROM netflix_titles
WHERE country = 'India'
GROUP BY release_year
ORDER BY no_of_contents DESC;

11. List All Movies that are Documentaries
SELECT title, director, listed_in
FROM netflix_titles
WHERE listed_in LIKE '%Documentaries%';

12. Find All Content Without a Director
SELECT show_id, title
FROM netflix_titles
WHERE director IS NULL;

13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT show_id, title, type
FROM netflix_titles
WHERE cast LIKE '%Salman Khan%'
  AND release_year >= YEAR(GETDATE()) - 10
ORDER BY release_year DESC;

14. Categorize Content Based on Keywords 'Kill' or 'Violence'
SELECT category, COUNT(*) AS Content
FROM (
    SELECT CASE 
               WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad'
               ELSE 'Good'
           END AS category
    FROM netflix_titles
    WHERE description IS NOT NULL
) AS categorized_content
GROUP BY category;



Author

Ravi Kumar

SQL Data Analysis Enthusiast
















