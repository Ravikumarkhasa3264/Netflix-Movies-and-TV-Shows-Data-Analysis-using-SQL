Create database Netflix
use Netflix
select* from netflix_titles
--### 1. Count the Number of Movies vs TV Shows
select type,COUNT(show_id)Total
from netflix_titles group by type

--**Objective:** Determine the distribution of content types on Netflix.

--### 2. Find the Most Common Rating for Movies and TV Shows
select* from netflix_titles
select type,rating from(select type,rating,COUNT(*) counting_rating, RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rnk 
from netflix_titles where rating is not null group by type,rating)as ranked where rnk=1

--**Objective:** Identify the most frequently occurring rating for each type of content.

--### 3. List All Movies Released in a Specific Year (e.g., 2020)
select* from netflix_titles
select title,rating,date_added,listed_in from netflix_titles where type='Movie' and release_year=2020

--**Objective:** Retrieve all movies released in a specific year.

--### 4. Find the Top 5 Countries with the Most Content on Netflix
select*from netflix_titles
select country,count(*) total_content from netflix_titles  where country is not null  group by country
order by total_content desc
offset 0 rows fetch next 5 rows only
/*### 5 Identify the Longest Movie
*/
select title, country,date_added,duration  from netflix_titles where type='movie' and TRY_CAST(left(duration,charindex(' ',duration)-1)as int)=
(select MAX(TRY_CAST(left(duration,charindex(' ',duration)-1)as int)) from netflix_titles
where type='movie')


--### 6. Find Content Added in the Last 5 Years
select *from netflix_titles
select title from netflix_titles where date_added>=DATEADD(YEAR,-5,cast(getdate() as date))

--### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

select Director,title,type from netflix_titles where director like '%Rajiv Chilaka%'

--### 8. List All TV Shows with More Than 5 Seasons
select *from netflix_titles

select show_id, type, title, duration
from netflix_titles
where type = 'TV Show'
  and try_cast(left(duration, charindex(' ', duration + ' ') - 1) as int) > 5;
  --### 9. Count the Number of Content Items in Each Genre



--### 10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

select release_year,count(show_id)no_of_contents,
(select AVG(yearly_count)AVG_ADD from (
select release_year,count(show_id)yearly_count from netflix_titles where country='India'
group by release_year) as sub)overall_avg
from netflix_titles where country='India'
group by release_year
order  by no_of_contents desc
offset 0 row fetch next 5 rows only

--### 11. List All Movies that are Documentaries
select title,director,listed_in from netflix_titles where listed_in like '%Documentaries%'

--### 12. Find All Content Without a Director
select show_id,title from netflix_titles where director is null

--### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
select show_id,title,type from netflix_titles where cast like '%Salman khan%'
and
release_year >= YEAR(GETDATE()) - 10
ORDER BY release_year DESC

--### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

select*from netflix_titles
select category,COUNT(*)Content
from( Select 
        case 
            when description like '%kill%' 
              OR description like '%violence%' then 'Bad'
            else 'Good'
        end  category
    from netflix_titles
    where description IS NOT NULL
)  categorized_content
group by category
 

