USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) from DIRECTOR_MAPPING;
-- Result=3867
select count(*) from GENRE;
-- Result=14662
select count(*) from MOVIE;
-- Result=7997
select count(*) from NAMES;
-- Result=25735
select count(*) from RATINGS;
-- Result=7997
select count(*) from ROLE_MAPPING;
-- Result=15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
select 
	sum(case when id is NULL then 1 else 0 end) as null_id,
    sum(case when title is NULL then 1 else 0 end) as null_title,
    sum(case when year is NULL then 1 else 0 end) as null_year,
    sum(case when date_published is NULL then 1 else 0 end) as null_date_pub,
    sum(case when duration is NULL then 1 else 0 end) as null_dur,
    sum(case when country is NULL then 1 else 0 end) as null_country,
    sum(case when worlwide_gross_income is NULL then 1 else 0 end) as null_WGI,
    sum(case when languages is NULL then 1 else 0 end) as null_lang,
    sum(case when production_company is NULL then 1 else 0 end) as null_PC
from movie;



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Code for number of movies released each year
select year as Year, count(title) as number_of_movies from movie
group by year;

-- The maximum number of movies wwre released in the year of 2017

-- Code for the number of movies released each month
select Month(date_published) as month_num, count(*) as number_of_movies from movie
group by month_num
order by month_num;



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select country, year, count(title) as number_of_movies from movie
where country in ('USA', 'India') and year=2019
group by country, year;

-- In the year of 2019, India produced 295 movies while USA produced 592 movies.


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select distinct genre from genre;

--  Total 13 genres are there in the data set.


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select genre, year, count(movie_id) as number_of_movies from genre as gen
inner join movie as m 
where gen.movie_id = m.id and year=2019
group by genre
order by number_of_movies desc
limit 1;

-- 'Drama' genre has the highest number of movies produced overall with a count of 1078.






/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
with movies_with_only_one_genre as
(
	select movie_id, count(genre) as number_of_movies from genre
    group by movie_id
    having number_of_movies=1)
select count(*) as movies_with_only_one_genre from movies_with_only_one_genre;

-- There are 3289 movies with only one genre.








/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select genre, round(avg(duration),2) as avg_duration from genre as gen
inner join movie as m
on gen.movie_id=m.id
group by genre
order by avg(duration) desc;

-- Action movies have the highest average duration while horror has the least average duration. 




/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
with genre_rank as(
select genre, count(movie_id) as movie_count,
rank() over(order by count(movie_id) desc) as genre_rank
from genre
group by genre)
select * from genre_rank where genre='thriller';

-- 'Thriller' genre movies have the rank of 3 with 1484 count of movies.







/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
select min(avg_rating) as min_avg_rating,
	   max(avg_rating) as max_avg_rating,
       min(total_votes) as min_total_votes,
       max(total_votes) as max_total_votes,
       min(median_rating) as min_median_rating,
       max(median_rating) as max_median_rating
	from ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH rank_rating AS
(
SELECT 
		movies.title,
        rating.avg_rating AS avg_rating,
        -- Ranking
        RANK() OVER(ORDER BY rating.avg_rating DESC) AS movie_rank
FROM 
	ratings AS rating
INNER JOIN
	movie AS movies
ON
	movies.id = rating.movie_id
)
SELECT *
FROM
	rank_rating
WHERE
	movie_rank <= 10;

-- The movie having highest avg_rating is Kirket and  Love in Kilnerry with an avg_rating of 10.00 .
    

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
	median_rating,
    COUNT(movie_id) AS movie_count
FROM 
	ratings 
GROUP BY 
	median_rating
ORDER BY 
	median_rating;

-- Majority of the movies have high median rating of 7, 6 and 8 where as the remaining movies have the low median rating as 1,2,3,4,5,9 and 10 and they are less than 1000 numbers in each categories.

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
	production_company,
    COUNT(id) AS movie_count,
    -- Ranking
    RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM
	movie AS movies
INNER JOIN 
	ratings AS rating
ON 
	rating.movie_id = movies.id
WHERE 
	avg_rating > 8 AND production_company IS NOT NULL
GROUP BY
	production_company
ORDER BY
	movie_count DESC;

-- The production house that has produced most number of hits in the film industry are Dream Warrior pictures and National Theatre live with the highest rank and with product_company_rank as 1 .
-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
	category.genre,
    COUNT(category.movie_id) AS movie_count
FROM
	genre AS category
INNER JOIN
	ratings AS rating
USING (movie_id)
INNER JOIN
	movie as movies
ON
	movies.id = rating.movie_id
WHERE
	movies.country = 'USA' 
	AND rating.total_votes > 1000 
	AND MONTH(date_published) = 3 
	AND year = 2017
GROUP BY 
	genre
ORDER BY 
	movie_count DESC;

--  During March 2017 , USA has released most dramatic movies ie 16 counts and they have also concentrated on comedy movies which was half of the dramatic movies released and Least concentrated movies was Family genre.



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	title,
    avg_rating,
    genre
FROM
	genre AS category
INNER JOIN
	ratings AS rating
ON 
	category.movie_id = rating.movie_id
INNER JOIN
	movie AS movies
ON
	category.movie_id = movies.id
WHERE 
	title like 'The%' AND avg_rating > 8
ORDER BY 
	avg_rating DESC;
    
-- The Brigton Miracle and The colour of darkness has the highest avg_rating which is more than 9 and 28 movies  having avg_rating > 8 . Total 30 numbers of movies are there with starting 'The' with avg_rating >8.




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT 
    COUNT(id) as movie_count,
    median_rating as median_rating
FROM
	movie AS movies
INNER JOIN
	ratings AS rating
ON 
	rating.movie_id = movies.id
WHERE  date_published BETWEEN '2018-04-01' AND '2019-04-01' AND median_rating = 8
GROUP BY 
	median_rating;

-- Between 1st April 2018 and 1st April 2019, there are about 361 movies that released with 8 median rating .

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT
	SUM(total_votes) AS total_votes,
	country	
FROM 
	movie AS movies
INNER JOIN
	ratings AS rating
ON 
	movies.id = rating.movie_id
WHERE
	country in ('Germany', 'Italy')
GROUP BY 
	country;
-- Comparing both German movies and Italian movies , German movies has received highest votes ie 1,06,710.




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:


-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM
	names;
    
-- Except Names , all the others columns like height, date_of_birth, known_for_movies have null values. The height column  has highest null values (17335) and Date of birth had the least null value of 13431. 





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
--  First, we will find the top genres by count of movies with avg_rating > 8

WITH top_genres AS
(
           SELECT genre,
				  Count(m.id) AS movie_count ,
				  Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM movie AS m
           INNER JOIN genre AS gen
           ON gen.movie_id = m.id
           INNER JOIN ratings AS rating
           ON rating.movie_id = m.id
           WHERE avg_rating > 8
           GROUP BY genre limit 3 )
SELECT     nam.NAME AS director_name ,
           Count(d.movie_id) AS movie_count
FROM       director_mapping AS d
INNER JOIN genre G
using (movie_id)
INNER JOIN names AS nam
ON nam.id = d.name_id
INNER JOIN top_genres
using (genre)
INNER JOIN ratings
using (movie_id)
WHERE avg_rating > 8
GROUP BY NAME
ORDER BY movie_count DESC limit 3 ;




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
DISTINCT
	name AS actor_name,
	COUNT(rating.movie_id) AS movie_count
FROM 
	ratings AS rating
INNER JOIN
	role_mapping AS rolemap
ON
	rolemap.movie_id = rating.movie_id
INNER JOIN
	names AS nam
ON
	nam.id = rolemap.name_id
WHERE
	median_rating >= 8 AND category = 'actor'
GROUP BY
	name			-- To find number of movies with greater than 8 rating by actor.
ORDER BY 
	movie_count DESC
LIMIT 2;
-- We can understand that, both the south actors Mammootty and Mohanlal has the highest number of movie count with 8 above rating.





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
    m.production_company,
    SUM(total_votes) AS vote_count,
    RANK() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM
    movie AS m
INNER JOIN
    ratings AS r ON r.movie_id = m.id
GROUP BY 
    m.production_company
ORDER BY 
    vote_count DESC
LIMIT 3;


--  Marvel Studious has the highest number of votes followed by Twentieth Century Fox and Warner Bros.

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
	n.name AS actor_name,
	SUM(r.total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actor_avg_rating,		-- To find the weigthed average
    -- Using Ranking
    RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) DESC) AS actor_rank
FROM
	movie AS m
INNER JOIN
	ratings AS r
ON 
	r.movie_id = m.id
INNER JOIN
	role_mapping AS rm
ON 
	rm.movie_id = m.id
INNER JOIN
	names AS n
ON
	n.id = rm.name_id
WHERE
	rm.category = 'actor' AND m.country = 'India'		-- To consider only Indian actors
GROUP BY 
	actor_name
HAVING
	COUNT(m.id)>=5;		-- To indentify actors who have done atleast 5 movies   
  
--  With avg_rating higher than 7.8., Vijay Sethupathi, Fahadh Faasil and Yogi Babu are top 3 actors.

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT 
	n.name AS actress_name,
	SUM(r.total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actress_avg_rating,		-- To find the weigthed average
    -- Using Ranking
    RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) DESC) AS actress_rank
FROM
	movie AS m
INNER JOIN
	ratings AS r
ON 
	r.movie_id = m.id
INNER JOIN
	role_mapping AS rm
ON 
	rm.movie_id = m.id
INNER JOIN
	names AS n
ON
	n.id = rm.name_id
WHERE
	rm.category = 'actress' AND m.country = 'India' AND m.languages = 'Hindi'		-- To consider only Indian actors with Hindi languages 
GROUP BY 
	actress_name
HAVING
	COUNT(m.id)>=3		-- To indentify actress who have done atleast 3 Indian movies
LIMIT 5; 

-- With an average rating 7.74,Taapsee Pannu is the top actress.

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT 
	m.title,
    r.avg_rating,
		CASE
			WHEN avg_rating > 8 THEN 'Superhit Movies'
            WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit Movies'
            WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-Time-Watch Movies'
		ELSE
			'Flop Movies'
		END AS avg_rating_category
FROM
	movie AS m
INNER JOIN
	ratings AS r
ON
	r.movie_id = m.id
INNER JOIN 
	genre AS g
ON
	m.id = g.movie_id
WHERE 
	g.genre = 'Thriller';

-- The top movie in hit movie is  Der müde Tod with average rating 7.7.


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
	g.genre,
    ROUND(AVG(m.duration),2) AS avg_duration,
    ROUND(SUM(AVG(m.duration)) OVER(ORDER BY genre),2) AS running_total_duration,		-- To find total running duration
    ROUND(AVG(AVG(m.duration)) OVER(ORDER BY genre),2) AS moving_avg_duration		-- To find avg moving duration
FROM 
	movie AS m
INNER JOIN
	genre AS g
ON
	g.movie_id = m.id
GROUP BY 
	genre;
    
-- Genre-wise Action genre has the highest avg_duration followed by running_total_duration and moving_avg_duration.

-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_3_genre AS		-- First find Top 3 genres
(
SELECT 
	genre,
    COUNT(movie_id) AS movie_count
FROM
	genre
GROUP BY 
	genre
ORDER BY 
	movie_count DESC
LIMIT 3
),
-- Now we will write a queary for Top 5 movies
top_5_movies AS
(
SELECT 
	genre,
    year,
    title AS movie_name,
    worlwide_gross_income,
    RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM 
	movie AS m
INNER JOIN
	genre AS g
ON 
	g.movie_id = m.id
WHERE
	genre IN (SELECT genre FROM top_3_genre)		-- Select top 3 genres
)
SELECT * 
FROM
	top_5_movies
WHERE
	movie_rank <= 5		-- Top 5 movies from the list
ORDER BY 
	movie_rank;
    
-- Drama and Thriller belongs to the top 5 highest-grossing movies from each year.

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
    production_company,
    COUNT(id) AS movie_count,
    ROW_NUMBER() OVER (ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM
    movie AS m
INNER JOIN
    ratings AS r ON r.movie_id = m.id
WHERE
    median_rating >= 8 
    AND production_company IS NOT NULL 
    AND POSITION(',' IN languages) > 0
GROUP BY
    production_company
LIMIT 2;

--  Star Cinema and Twentieth Century Fox being the top 2 have produced highest number of rating among multilingual movies.
-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT 
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating,
    RANK() OVER (ORDER BY ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) DESC) AS actress_rank
FROM 
    names AS n
INNER JOIN
    role_mapping AS rm ON rm.name_id = n.id
INNER JOIN
    ratings AS r ON r.movie_id = rm.movie_id
INNER JOIN
    genre AS g ON g.movie_id = r.movie_id
WHERE 
    g.genre = 'Drama' AND rm.category = 'actress' AND r.avg_rating > 8
GROUP BY
    actress_name
ORDER BY
    movie_count DESC
LIMIT 3;


-- Top 3 actresses who  have  been rated above 8 in drama genre are Susan Brown, Amanda Lawrence and Denise Gough..


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH num_movies AS (
    SELECT 
        dm.name_id,
        n.name,
        dm.movie_id,
        m.duration,
        r.avg_rating,
        r.total_votes,
        m.date_published,
        LEAD(m.date_published, 1) OVER(PARTITION BY dm.name_id ORDER BY m.date_published, dm.movie_id) AS next_date_published
    FROM
        director_mapping AS dm
    INNER JOIN
        names AS n ON n.id = dm.name_id
    INNER JOIN
        movie AS m ON m.id = dm.movie_id
    INNER JOIN
        ratings AS r ON r.movie_id = m.id
),
top_directors AS (
    SELECT
        *,
        DATEDIFF(next_date_published, date_published) AS date_diff
    FROM 
        num_movies
)
SELECT
    name_id AS director_id,
    name AS director_name,
    COUNT(movie_id) AS number_of_movies,
    ROUND(AVG(date_diff)) AS avg_inter_movie_days,
    ROUND(SUM(avg_rating), 2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM
    top_directors
GROUP BY 
    director_id
ORDER BY 
    number_of_movies DESC
LIMIT 9;
--  Andrew Jones is the highest in the list compared to the other 8 directors.





