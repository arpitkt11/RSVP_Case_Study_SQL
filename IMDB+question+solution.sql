USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) FROM DIRECTOR_MAPPING;
-- Number of rows = 3867
SELECT COUNT(*) FROM GENRE ;
-- Number of rows = 14662
SELECT COUNT(*) FROM  MOVIE;
-- Number of rows = 7997
SELECT COUNT(*) FROM  NAMES;
-- Number of rows = 25735
SELECT COUNT(*) FROM  RATINGS;
-- Number of rows = 7997
SELECT COUNT(*) FROM  ROLE_MAPPING;
-- Number of rows = 15615



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT * FROM movie WHERE 
	title IS NULL OR
	year IS NULL OR
	date_published IS NULL OR
	duration IS NULL OR
	country IS NULL OR
	worlwide_gross_income IS NULL OR
	languages IS NULL OR
	production_company IS NULL;
    -- Alternatively: 
SELECT COUNT(ID) FROM movie WHERE title IS NULL; 
SELECT COUNT(ID) FROM movie WHERE year IS NULL; 
SELECT COUNT(ID) FROM movie WHERE date_published IS NULL; 
SELECT COUNT(ID) FROM movie WHERE duration IS NULL; 
SELECT COUNT(ID) FROM movie WHERE worlwide_gross_income IS NULL; 
SELECT COUNT(ID) FROM movie WHERE languages IS NULL; 
SELECT COUNT(ID) FROM movie WHERE production_company IS NULL; 
/* 
Resultset has a 1000 rows. Looking at data in each column, we can conclude that the following columns
 have NULL values:
country, worlwide_gross_income, languages, production_company
*/

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
-- Number of movies released each year
SELECT year,
       Count(title) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year;

-- Number of movies released each month 
SELECT Month(date_published) AS MONTH_NUM,
       Count(*)              AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

-- Highest number of movies were released in 2017


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
-- Pattern matching using LIKE operator for country column
SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019; 

-- 1059 movies were produced in the USA or India in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
-- Finding unique genres using DISTINCT keyword
SELECT DISTINCT genre
FROM   genre; 

-- Movies belong to 13 genres in the dataset.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
-- Using LIMIT clause to display only the genre with highest number of movies produced
SELECT     genre,
           Count(m.id) AS number_of_movies
FROM       movie       AS m
INNER JOIN genre       AS g
where      g.movie_id = m.id
GROUP BY   genre
ORDER BY   number_of_movies DESC limit 1 ;

-- 4265 Drama movies were produced in total and are the highest among all genres. 

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_with_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_with_one_genre
FROM   movies_with_one_genre; 

-- 3289 movies belong to only one genre


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

SELECT g.genre, ROUND(AVG(m.duration),2) AS avg_duration 
	FROM movie m 
    INNER JOIN genre g 
    ON m.id = g.movie_id
    GROUP BY g.genre
    ORDER BY ROUND(AVG(m.duration),2) DESC;

-- Result: Action category movies have the highest avg duration of 113 minutes,
-- whereas Horror movies are the shortest at an average of 93 minutes.

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
SELECT genre, COUNT(movie_id) movie_count,
	RANK() OVER (ORDER BY COUNT(MOVIE_ID) DESC) AS genre_rank
    FROM genre 
    GROUP BY genre;

-- Result: Thriller is No.3 in Rank

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
SELECT MIN(avg_rating) AS min_avg_rating,
		MAX(avg_rating) AS max_avg_rating,
		MIN(total_votes) AS min_total_votes,
		MAX(total_votes) AS max_total_votes,
		MIN(median_rating) AS min_median_rating,
		MAX(median_rating) as max_median_rating
        FROM ratings; 


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
SELECT m.title, r.avg_rating,
		DENSE_RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
        FROM movie m
		INNER JOIN ratings r
        ON m.id = r.movie_id;


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

SELECT median_rating, COUNT(movie_id) as movie_count
		FROM ratings
        GROUP BY median_rating
        ORDER BY COUNT(movie_id) DESC;

-- Result: Movie with a median rating of 7 are the highest in number (2257)


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
SELECT m.production_company, COUNT(m.id) AS movie_count, 
		DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
        FROM movie m 
        INNER JOIN ratings r 
        ON m.id = r.movie_id
        WHERE r.avg_rating > 8 AND
        m.production_company IS NOT NULL
        GROUP BY m.production_company;


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
SELECT g.genre, COUNT(g.movie_id) AS movie_count
		FROM genre g, ratings r, movie m 
        WHERE 
        g.movie_id = m.id AND
        r.movie_id = m.id AND
		m.year = 2017 AND
        MONTH(m.date_published) = 3 AND
        m.country LIKE '%USA%' AND
        r.total_votes > 1000
        GROUP BY g.genre
        ORDER BY COUNT(g.movie_id) DESC;

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
SELECT m.title, r.avg_rating, g.genre
	FROM genre g, ratings r, movie m 
        WHERE 
        g.movie_id = m.id AND
        r.movie_id = m.id AND
        m.title like 'The%' AND
		r.avg_rating > 8;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT COUNT(m.id) AS movie_count
	FROM movie m
    INNER JOIN ratings r
	ON m.id = r.movie_id
    WHERE 
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01' AND
    r.median_rating = 8;

-- Result: 361 movies between 01-Apr-2018 and 01-Apr-2019 were given a median rating of 8

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
-- Compute the total number of votes for German and Italian movies.
SELECT languages,
       Sum(total_votes) AS VOTES
FROM   movie AS M
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  languages LIKE '%Italian%'
UNION
SELECT languages,
       Sum(total_votes) AS VOTES
FROM   movie AS M
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  languages LIKE '%GERMAN%'
ORDER  BY votes DESC; 

-- Query to check if German votes > Italian votes using SELECT IF statement
-- Answer is YES if German votes > Italian votes
-- Answer is NO if German votes <= Italian votes

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
-- NULL counts for individual columns of names table
SELECT Count(*) AS name_nulls
FROM   names
WHERE  NAME IS NULL;

SELECT Count(*) AS height_nulls
FROM   names
WHERE  height IS NULL;

SELECT Count(*) AS date_of_birth_nulls
FROM   names
WHERE  date_of_birth IS NULL;

SELECT Count(*) AS known_for_movies_nulls
FROM   names
WHERE  known_for_movies IS NULL; 

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
WITH top_3_genres AS
(
	SELECT g.genre AS top_genre, 
			COUNT(g.movie_id) AS movie_count
		FROM genre g
		INNER JOIN ratings r
		on g.movie_id = r.movie_id
		WHERE r.avg_rating > 8
		GROUP BY g.genre
		ORDER BY COUNT(g.movie_id) desc
		LIMIT 3
) 
SELECT n.name AS director_name,
		COUNT(dm.movie_id) AS movie_count
        FROM director_mapping dm, names n, ratings r, genre g 
        WHERE
        dm.movie_id = r.movie_id AND
        dm.name_id = n.id AND
        r.movie_id = g.movie_ID AND
        g.genre IN (SELECT top_genre FROM top_3_genres) AND
        r.avg_rating > 8
        GROUP BY n.name
        ORDER BY COUNT(dm.movie_id) desc; 
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


SELECT n.name AS actor_name, 
	COUNT(rm.movie_id) AS movie_count
	FROM role_mapping rm, ratings r, names n
    WHERE 
    rm.movie_id = r.movie_id AND
    rm.name_id = n.id AND 
    rm.category = 'actor' AND
    r.median_rating >= 8
    GROUP BY n.name
    ORDER BY COUNT(rm.movie_id) DESC
    LIMIT 2;


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
SELECT m.production_company, 
		SUM(r.total_votes) AS vote_count, 
        RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
        FROM movie m
        INNER JOIN ratings r
        ON m.id = r.movie_id
        WHERE 
        m.production_company IS NOT NULL
        GROUP BY m.production_company
        LIMIT 3;


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
WITH india_actors_min_5_movies AS
(
	SELECT n.name, COUNT(rm.movie_id) AS movie_count
		FROM role_mapping rm, movie m, names n, ratings r
		WHERE
		rm.movie_id = m.id AND
		rm.name_id = n.id AND
		m.id = r.movie_id AND
		m.country LIKE '%India%' AND
		rm.category = 'actor' 
		GROUP BY n.name
		HAVING COUNT(rm.movie_id) >= 5
) 
SELECT n.name AS actor_name, 
	SUM(r.total_votes) AS total_votes,
	SUM(min5.movie_count) as movie_count,	
	(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes)) AS actor_avg_rating, 
    RANK() OVER (ORDER BY (SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes)) DESC, SUM(r.total_votes) DESC) AS actor_rank
	FROM names n, ratings r, role_mapping rm, india_actors_min_5_movies min5
	WHERE n.id = rm.name_id AND
	rm.movie_id = r.movie_id AND
    n.name = min5.name
	GROUP BY n.name;


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
WITH india_actress_min_3_movies AS
(
	SELECT n.name, COUNT(rm.movie_id) AS movie_count
		FROM role_mapping rm, movie m, names n, ratings r
		WHERE
		rm.movie_id = m.id AND
		rm.name_id = n.id AND
		m.id = r.movie_id AND
		m.country LIKE '%India%' AND
        m.languages LIKE '%Hindi%' AND
		rm.category = 'actress' 
		GROUP BY n.name
		HAVING COUNT(rm.movie_id) >= 3
) 
SELECT n.name AS actress_name, 
    SUM(r.total_votes) AS total_votes,
    SUM(min3.movie_count) as movie_count,
	(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes)) AS actress_avg_rating, 
    RANK() OVER (ORDER BY (SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes)) DESC, SUM(r.total_votes) DESC) AS actress_rank
	FROM names n, ratings r, role_mapping rm, india_actress_min_3_movies min3
	WHERE n.id = rm.name_id AND
	rm.movie_id = r.movie_id AND
    n.name = min3.name
	GROUP BY n.name
    LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT m.title, r.avg_rating, 
	CASE
		WHEN r.avg_rating > 8 THEN 'Superhit'
		WHEN (r.avg_rating <= 8 AND r.avg_rating > 7) THEN 'Hit'
		WHEN (r.avg_rating <= 7 AND r.avg_rating > 5) THEN 'One-time-watch'
		ELSE 'Flop'
		END AS success_category
	FROM genre g, movie m, ratings r
	WHERE 
	g.movie_id = m.id AND
	m.id = r.movie_id AND
	g.genre = 'Thriller'
    ORDER BY r.avg_rating DESC;


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

WITH genre_wise_avg_duration AS
(
	SELECT g.genre, ROUND(AVG(m.duration), 2) as avg_duration
		FROM movie m
		INNER JOIN genre g 
		on m.id = g.movie_id 
		GROUP BY g.genre
)
SELECT genre, avg_duration, 
		SUM(avg_duration) OVER w1 AS running_total_duration,
        AVG(avg_duration) OVER w1 AS moving_avg_duration
        FROM genre_wise_avg_duration
        WINDOW w1 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING);

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
/*
Considerations in writing this query:
1. The world wide gross income in movie table is in varchar format. This needs to be converted to a number to 
		be able to sort numerically 
2. There are 3 records that have the value in INR. This is converted to USD using a rate of 75 INR/USD.
3. First CTE (ranked_movies) is used to rank movies grouped by genre and year in the increasing order of rank by income
4. Second CTE (top_3_genre) is used to just get the top 3 Genres based on number of movies
5. The final query joins the two CTEs and ranks the movies by increasing order of rank by income.
*/

WITH ranked_movies AS
(
	SELECT g.genre, 
			m.year, 
			m.title AS movie_name, 
			CASE 
				WHEN worlwide_gross_income LIKE '$ %' THEN CAST(SUBSTRING(worlwide_gross_income, 3) AS UNSIGNED)
				WHEN worlwide_gross_income LIKE 'INR %' THEN (CAST(SUBSTRING(worlwide_gross_income, 5) AS UNSIGNED) * 75)
				ELSE 0 
			END AS worldwide_gross_income,
			RANK() OVER w1 AS movie_rank
			FROM movie m
			INNER JOIN genre g 
			ON m.id = g.movie_id 
			WHERE m.worlwide_gross_income IS NOT NULL
			WINDOW w1 AS (PARTITION BY g.genre, m.year
							ORDER BY CASE 
				WHEN worlwide_gross_income LIKE '$ %' THEN CAST(SUBSTRING(worlwide_gross_income, 3) AS UNSIGNED)
				WHEN worlwide_gross_income LIKE 'INR %' THEN (CAST(SUBSTRING(worlwide_gross_income, 5) AS UNSIGNED) * 75)
				ELSE 0 
			END DESC)
), 
top_3_genre AS
(
	SELECT genre 
		FROM genre 
		GROUP BY genre
		ORDER BY COUNT(movie_id) DESC
		LIMIT 3
) 
SELECT rm.genre, rm.year, rm.movie_name, rm.worldwide_gross_income, rm.movie_rank
		FROM ranked_movies rm 
        INNER JOIN top_3_genre t3g
        ON rm.genre = t3g.genre 
        WHERE
        rm.movie_rank <= 5
        ORDER BY rm.genre, rm.year, rm.movie_rank asc;
        
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

WITH top_prod_houses AS
(
	SELECT m.production_company, COUNT(m.id) movie_count, 
			RANK() OVER(ORDER BY COUNT(m.id) DESC) as prod_comp_rank
			FROM movie m
			INNER JOIN 
			ratings r
			ON m.id = r.movie_id AND
			r.median_rating >= 8 AND
			POSITION(',' IN m.languages) > 0 AND
			m.production_company IS NOT NULL
			GROUP BY m.production_company
) SELECT production_company, movie_count, prod_comp_rank 
		FROM top_prod_houses 
        WHERE prod_comp_rank <= 2;

-- Result: Star Cinema and Twentieth Century Fox

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
WITH top_actress AS
(
SELECT n.name AS actress_name,
		SUM(r.total_votes) AS total_votes,
        COUNT(rm.movie_id) AS movie_count,
        AVG(r.avg_rating) AS actress_avg_rating,
        DENSE_RANK() OVER (ORDER BY COUNT(rm.movie_id) DESC, AVG(r.avg_rating) DESC) AS actress_rank
		FROM names n, role_mapping rm, ratings r, genre g
        WHERE
        n.id = rm.name_id AND
        r.movie_id = rm.movie_id AND
        g.movie_id = rm.movie_id AND
        rm.category = 'actress' AND
        r.avg_rating > 8 AND
        g.genre = 'Drama'
        GROUP BY n.name
) 
SELECT actress_name, total_votes, movie_count, actress_avg_rating, actress_rank
		FROM top_actress
        WHERE actress_rank <= 3;


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

/*
Note on how the query is structured:
CTE dir_rating: To facilitate calcuation of min and max avg rating of each director
CTE dir_min_max_rating: Table that holds min and max values of avg rating for each director
CTE director_movie_dates: Using a Lead function, this table adds a column with the next movie date for each director
CTE director_date_diffs: Using the above CTE, calculate the difference between movies for each director
CTE avg_inter_movie_duration: Using the above, calculate the average inter movie duration for each director
Main Query: Combines info from movie, avg_inter_movie_duration, dir_min_max_rating to produce the required output.
*/
WITH dir_rating AS
(
	SELECT dr.name_id, r.avg_rating 
		FROM director_mapping dr, names n, ratings r
			WHERE 
			dr.name_id = n.id AND
            dr.movie_id = r.movie_id 
),
dir_min_max_rating AS
(
	SELECT name_id, MIN(avg_rating) AS min_rating, MAX(avg_rating) AS max_rating
		FROM dir_rating 
		GROUP BY name_id
),
director_movie_dates AS
(
	SELECT dr.name_id AS d_id, n.name AS d_name, m.date_published,
			LEAD(m.date_published,1) 
				OVER (PARTITION BY dr.name_id ORDER BY m.date_published) AS next_movie_date
			FROM director_mapping dr, names n, movie m 
			WHERE 
			dr.name_id = n.id AND
			dr.movie_id = m.id
			ORDER BY dr.name_id, n.name, m.date_published ASC
),
director_date_diffs AS
(
	SELECT d_id, d_name, 
		DATEDIFF(next_movie_date, date_published) AS inter_movie_dur
		FROM director_movie_dates 
),
avg_inter_movie_duration AS
(
	SELECT d_id, d_name, ROUND(AVG(inter_movie_dur)) AS avg_inter_movie_days
			FROM director_date_diffs 
			GROUP BY d_id, d_name
)
SELECT dr.name_id AS director_id, 
		aimd.d_name AS director_name,
        COUNT(m.id) AS number_of_movies, 
        aimd.avg_inter_movie_days,
        ROUND((SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes)),2) AS avg_rating, 
        SUM(r.total_votes) AS total_votes, 
        dmmr.min_rating,
        dmmr.max_rating,
        SUM(m.duration) AS total_duration
			FROM director_mapping dr, 
				 movie m, 
                 names n,
				 ratings r,
				 avg_inter_movie_duration aimd,
				 dir_min_max_rating dmmr
					WHERE 
						dr.movie_id = m.id AND
                        dr.name_id = n.id AND
						m.id = r.movie_id AND
						aimd.d_id = n.id AND
						dmmr.name_id = n.id
						GROUP BY dr.name_id, aimd.d_name, aimd.avg_inter_movie_days, dmmr.min_rating, dmmr.max_rating
						ORDER BY COUNT(m.id) DESC, ((SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes))) DESC
                        LIMIT 9;

/* End of all SQL queries based on Questions */

/***************************************/
/* SQL queries for additional insights */

/* Query no. 20 modified to get top actress */
SELECT n.name AS actor_name, 
	COUNT(rm.movie_id) AS movie_count
	FROM role_mapping rm, ratings r, names n
    WHERE 
    rm.movie_id = r.movie_id AND
    rm.name_id = n.id AND 
    rm.category = 'actress' AND
    r.median_rating >= 8
    GROUP BY n.name
    ORDER BY COUNT(rm.movie_id) DESC
    LIMIT 2;

/* SQL Query #29 modified for min movie count 3 and order by weighted avg. rating */
WITH dir_rating AS
(
	SELECT dr.name_id, r.avg_rating 
		FROM director_mapping dr, names n, ratings r
			WHERE 
			dr.name_id = n.id AND
            dr.movie_id = r.movie_id 
),
dir_min_max_rating AS
(
	SELECT name_id, MIN(avg_rating) AS min_rating, MAX(avg_rating) AS max_rating
		FROM dir_rating 
		GROUP BY name_id
),
director_movie_dates AS
(
	SELECT dr.name_id AS d_id, n.name AS d_name, m.date_published,
			LEAD(m.date_published,1) 
				OVER (PARTITION BY dr.name_id ORDER BY m.date_published) AS next_movie_date
			FROM director_mapping dr, names n, movie m 
			WHERE 
			dr.name_id = n.id AND
			dr.movie_id = m.id
			ORDER BY dr.name_id, n.name, m.date_published ASC
),
director_date_diffs AS
(
	SELECT d_id, d_name, 
		DATEDIFF(next_movie_date, date_published) AS inter_movie_dur
		FROM director_movie_dates 
),
avg_inter_movie_duration AS
(
	SELECT d_id, d_name, ROUND(AVG(inter_movie_dur)) AS avg_inter_movie_days
			FROM director_date_diffs 
			GROUP BY d_id, d_name
)
SELECT dr.name_id AS director_id, 
		aimd.d_name AS director_name,
        COUNT(m.id) AS number_of_movies, 
        aimd.avg_inter_movie_days,
        ROUND((SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes)),2) AS avg_rating, 
        SUM(r.total_votes) AS total_votes, 
        dmmr.min_rating,
        dmmr.max_rating,
        SUM(m.duration) AS total_duration
			FROM director_mapping dr, 
				 movie m, 
                 names n,
				 ratings r,
				 avg_inter_movie_duration aimd,
				 dir_min_max_rating dmmr
					WHERE 
						dr.movie_id = m.id AND
                        dr.name_id = n.id AND
						m.id = r.movie_id AND
						aimd.d_id = n.id AND
						dmmr.name_id = n.id 
						GROUP BY dr.name_id, aimd.d_name, aimd.avg_inter_movie_days, dmmr.min_rating, dmmr.max_rating
                        HAVING COUNT(m.id) >= 3
						ORDER BY (SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes)) DESC;


