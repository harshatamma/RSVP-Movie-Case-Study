/*
IMDB Case Study by Harsha Vardhan Tamma
*/

USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name,
       table_rows
FROM   information_schema.tables
WHERE  table_schema = 'imdb';

-- Q1 - Output:
/*
TABLE_NAME, TABLE_ROWS
'director_mapping','3867'
'genre','14662'
'movie','8344'
'names','23934'
'ratings','8230'
'role_mapping','15158'
*/






-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           end) AS ID_nulls,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           end) AS title_nulls,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           end) AS year_nulls,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           end) AS date_published_nulls,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           end) AS duration_nulls,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           end) AS country_nulls,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           end) AS worlwide_gross_income_nulls,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           end) AS languages_nulls,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           end) AS production_company_nulls
FROM   movie; 

/*
Q2 - Output: 
ID_nulls, title_nulls, year_nulls, date_published_nulls, duration_nulls, country_nulls, worlwide_gross_income_nulls, languages_nulls, production_company_nulls
'0','0','0','0','0','20','3724','194','528'
*
-- Null values in columns : country - 20, worldwide_gross_income : 3724, language : 194, production_company : 528

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

-- Total number of movies released each year
SELECT year as Year,
       Count(id) AS number_of_movies_per_year
FROM   movie
GROUP  BY year
ORDER  BY year; 

/* Output :
Year, number_of_movies_per_year
'2017','3052'
'2018','2944'
'2019','2001'
*/

-- Total number of movies released per month
SELECT Month(date_published) AS Month,
       Count(id)             AS number_of_movies_per_month
FROM   movie
GROUP  BY Month
ORDER  BY Month;

/* Output: 
Month, number_of_movies_per_month
'1','804'
'2','640'
'3','824'
'4','680'
'5','625'
'6','580'
'7','493'
'8','678'
'9','809'
'10','801'
'11','625'
'12','438'
*/



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- Pattern matching using LIKE operator for country column
SELECT year      AS Year,
       Count(id) AS number_of_movies_produced
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019; 

-- Q4. Solution : 1059 movies were produced in USA or India
/* Output
Year, number_of_movies_produced
'2019','1059'
*/









/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre AS 'Genre List'
FROM   genre; 

/* Output:
Genre List
'Drama'
'Fantasy'
'Thriller'
'Comedy'
'Horror'
'Family'
'Romance'
'Adventure'
'Action'
'Sci-Fi'
'Crime'
'Mystery'
'Others'
*/









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT     genre,
           Count(m.id) AS number_of_movies
FROM       movie       AS m
INNER JOIN genre       AS g
where      g.movie_id = m.id
GROUP BY   genre
ORDER BY   number_of_movies DESC
LIMIT      1 ;

/* Output
genre, number_of_movies
'Drama','4285'
*/

-- Drama genre had highest number of movies with a count of 4285.



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_count
     AS (SELECT movie_id,
                Count(DISTINCT genre) AS count_of_genre
         FROM   genre
         GROUP  BY movie_id)
SELECT Count(movie_id) AS 'Number of Movies with Single Genre'
FROM   genre_count
WHERE  count_of_genre = 1;


/* Output
Number of Movies with Single Genre
'3289'
*/

-- 3289 movies are of Single Genre



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
-- Finding the average duration of movies by grouping the genres that movies belong to 

-- Approach-1 : Use JOIN between movies and genre to get the data
SELECT genre                AS 'Genre',
       Round(Avg(duration),2) AS 'avg_duration'
FROM   movie AS m
       INNER JOIN genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY avg_duration DESC; 

/* Output
Genre, avg_duration
'Action','112.88'
'Romance','109.53'
'Crime','107.05'
'Drama','106.77'
'Fantasy','105.14'
'Comedy','102.62'
'Adventure','101.87'
'Mystery','101.80'
'Thriller','101.58'
'Family','100.97'
'Others','100.16'
'Sci-Fi','97.94'
'Horror','92.72'
*/





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

WITH genre_summary
     AS (SELECT genre,
                Count(movie_id)                    AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   movie AS mv
                LEFT JOIN genre AS gn
                       ON mv.id = gn.movie_id
         GROUP  BY genre)
SELECT *
FROM   genre_summary
WHERE  genre = "thriller"; 

/* Output
genre, movie_count, genre_rank
'Thriller','1484','3'
*/

-- Thriller is rank 3 with 1484 movies.




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

SELECT 	ROUND(MIN(avg_rating))AS 'min_avg_rating',
		ROUND(MAX(avg_rating)) AS 'max_avg_rating',
		ROUND(MIN(total_votes)) AS 'min_total_votes',
		ROUND(MAX(total_votes)) AS 'max_total_votes',
		ROUND(MIN(median_rating)) AS 'min_median_rating',
		ROUND(MAX(median_rating)) AS 'max_median_rating'
FROM ratings;

/* Output:
min_avg_rating, max_avg_rating, min_total_votes, max_total_votes, min_median_rating, max_median_rating
'1','10','100','725138','1','10'
*/


    

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

-- Finding the rank of each movie based on it's average rating

-- Approach-1:
-- Displaying the top 10 movies using CTE with LIMIT clause

WITH movie_ratings AS
(
           SELECT     mv.title,
                      rt.avg_rating
           FROM       movie   AS mv
           INNER JOIN ratings AS rt
           ON         mv.id = rt.movie_id )
SELECT   title,
         avg_rating,
         Dense_rank() OVER(ORDER BY avg_rating DESC) AS 'movie_rank'
FROM     movie_ratings LIMIT 10;

/* Output:
title, avg_rating, movie_rank
'Kirket','10.0','1'
'Love in Kilnerry','10.0','1'
'Gini Helida Kathe','9.8','2'
'Runam','9.7','3'
'Fan','9.6','4'
'Android Kunjappan Version 5.25','9.6','4'
'Yeh Suhaagraat Impossible','9.5','5'
'Safe','9.5','5'
'The Brighton Miracle','9.5','5'
'Shibu','9.4','6'
*/

-- Approach-2: Displaying top 10 RANKED movies using CTE with a condition on Rank
WITH movie_ratings
     AS (SELECT mv.title,
                rt.avg_rating,
                Dense_rank()
                  OVER(
                    ORDER BY avg_rating DESC) AS 'movie_rank'
         FROM   movie AS mv
                INNER JOIN ratings AS rt
                        ON mv.id = rt.movie_id)
SELECT title,
       avg_rating,
       movie_rank
FROM   movie_ratings
WHERE  movie_rank <= 10; 

/* Output:
'Kirket','10.0','1'
'Love in Kilnerry','10.0','1'
'Gini Helida Kathe','9.8','2'
'Runam','9.7','3'
'Fan','9.6','4'
'Android Kunjappan Version 5.25','9.6','4'
'Yeh Suhaagraat Impossible','9.5','5'
'Safe','9.5','5'
'The Brighton Miracle','9.5','5'
'Shibu','9.4','6'
'Our Little Haven','9.4','6'
'Zana','9.4','6'
'Family of Thakurganj','9.4','6'
'Ananthu V/S Nusrath','9.4','6'
'Eghantham','9.3','7'
'Wheels','9.3','7'
'Turnover','9.2','8'
'Digbhayam','9.2','8'
'Tõde ja õigus','9.2','8'
'Ekvtime: Man of God','9.2','8'
'Leera the Soulmate','9.2','8'
'AA BB KK','9.2','8'
'Peranbu','9.2','8'
'Dokyala Shot','9.2','8'
'Ardaas Karaan','9.2','8'
'Kuasha jakhon','9.1','9'
'Oththa Seruppu Size 7','9.1','9'
'Adutha Chodyam','9.1','9'
'The Colour of Darkness','9.1','9'
'Aloko Udapadi','9.1','9'
'C/o Kancharapalem','9.1','9'
'Nagarkirtan','9.1','9'
'Jelita Sejuba: Mencintai Kesatria Negara','9.1','9'
'Shindisi','9.0','10'
'Officer Arjun Singh IPS','9.0','10'
'Oskars Amerika','9.0','10'
'Delaware Shore','9.0','10'
'Abstruse','9.0','10'
'National Theatre Live: Angels in America Part Two - Perestroika','9.0','10'
'Innocent','9.0','10'
*/

/* While selecting based on Rank, we see a lot of entries when compared to limit. Many movies have same rating which were given equal rank
However, if we need to get fair idea on top 10 ranked movies, it's better to avoid limit*/



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

-- Finding the number of movies based on median rating and sorting based on movie count.
-- Approach-1: Getting data using Join between movie and ratings
SELECT r.median_rating,
       Count(m.id) AS 'movie_count'
FROM   ratings AS r
       LEFT JOIN movie AS m
              ON r.movie_id = m.id
GROUP  BY r.median_rating
ORDER  BY movie_count;

-- Approach-2: Getting data directly from ratings table
SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count; 

/* Output:
median_rating, movie_count
'1','94'
'2','119'
'3','283'
'10','346'
'9','429'
'4','479'
'5','985'
'8','1030'
'6','1975'
'7','2257'
*/





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

-- Using CTE to find the rank of production company based on movie count with average rating > 8 using DENSE_RANK function.
-- Querying the CTE to find the production company with rank=1
WITH production_movie_count
     AS (SELECT production_company,
                Count(id)                    AS movie_count,
                Dense_rank()
                  OVER(
                    ORDER BY Count(id) DESC) AS prod_company_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_movie_count
WHERE  prod_company_rank = 1; 

/* Output:
production_company, movie_count, prod_company_rank
'Dream Warrior Pictures','3','1'
'National Theatre Live','3','1'
*/




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

SELECT genre,
       Count(m.id) AS movie_count
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC;

/* Output:
genre, movie_count
'Drama','24'
'Comedy','9'
'Action','8'
'Thriller','8'
'Sci-Fi','7'
'Crime','6'
'Horror','6'
'Mystery','4'
'Romance','4'
'Fantasy','3'
'Adventure','3'
'Family','1'
*/
    
-- 24 Drama movies were released during March 2017 in the USA which had more than 1,000 votes
-- Top 3 genres are drama, comedy and action during March 2017 in the USA which had more than 1,000 votes







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

-- Approach-1 : Using LIKE Operator
SELECT  title,
       avg_rating,
       genre
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  avg_rating > 8
       AND title LIKE 'The%'
ORDER BY avg_rating DESC;

-- Approach-1 : Using REGEX Operator
SELECT m.title, r.avg_rating, g.genre
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE title REGEXP '^The'
			AND avg_rating > 8
ORDER  BY r.avg_rating DESC;

/* Output:
title, avg_rating, genre
'The Brighton Miracle','9.5','Drama'
'The Colour of Darkness','9.1','Drama'
'The Blue Elephant 2','8.8','Drama'
'The Blue Elephant 2','8.8','Horror'
'The Blue Elephant 2','8.8','Mystery'
'The Irishman','8.7','Crime'
'The Irishman','8.7','Drama'
'The Mystery of Godliness: The Sequel','8.5','Drama'
'The Gambinos','8.4','Crime'
'The Gambinos','8.4','Drama'
'Theeran Adhigaaram Ondru','8.3','Action'
'Theeran Adhigaaram Ondru','8.3','Crime'
'Theeran Adhigaaram Ondru','8.3','Thriller'
'The King and I','8.2','Drama'
'The King and I','8.2','Romance'
*/

/* 
The above code returns list of all movies starting with 'The' and having ratings > 8. 
However, we will see that same movie belongs to more than one genre.

If we try to group by title, MySQL rejects the query for which the select list, HAVING condition, or ORDER BY list refer to non-aggregated columns 
that are neither named in the GROUP BY clause nor are functionally dependent on them. 
This is dependent on a SQL setting called "sql_mode" which is set to "ONLY_FULL_GROUP_BY" by default.

To work around this, we have to set the sql_mode variable.
If we set the SQL setting - SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));, we can temporarily disable this error for that SQL session.
MYSQL will pick one of the two possible results RANDOMLY!!. However, this is not recommended as it modifies the select functionality. 
*/

SHOW session variables LIKE '%sql_mode%'; 
-- Output: 'sql_mode','ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'

-- Replace ONLY_FULL_GROUP_BY with ''
SET session sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SHOW session variables LIKE '%sql_mode%'; 
-- Output: 'sql_mode', 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'

-- Rewriting the code again grouping by title
SELECT title,
       avg_rating,
       genre
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  avg_rating > 8
       AND title LIKE 'The%'
GROUP  BY title
ORDER  BY avg_rating DESC; 

/* Output:
title, avg_rating, genre
'The Brighton Miracle','9.5','Drama'
'The Colour of Darkness','9.1','Drama'
'The Blue Elephant 2','8.8','Drama'
'The Irishman','8.7','Crime'
'The Mystery of Godliness: The Sequel','8.5','Drama'
'The Gambinos','8.4','Crime'
'Theeran Adhigaaram Ondru','8.3','Action'
'The King and I','8.2','Drama'
*/
-- Restoring the sql_mode value
set session sql_mode='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SHOW session variables LIKE '%sql_mode%'; 
-- Output: 'sql_mode','ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'

/* 
##################################################################################################################
Note: 
The above workaround will not be used in subsequent queries as we are not sure whether it is a recommended approach.
The last/above implementation is just to check whether the changes work or not. 
##################################################################################################################
*/





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- Using BETWEEN to find the movies released between 1 April 2018 and 1 April 2019
SELECT median_rating, Count(movie_id) AS movie_count
FROM   movie AS m
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

/* Output:
median_rating, movie_count
'8','361'
*/

-- 361 movies were released between 1 April 2018 and 1 April 2019 which were given a median rating of 8.






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Approach-1:
-- Comparing total votes with respect to country of origin, between Germany and Italy
SELECT country,
       Sum(total_votes) AS Total_votes
FROM   ratings r
       INNER JOIN movie m
               ON r.movie_id = m.id
WHERE  country IN ( 'Germany', 'Italy' )
GROUP  BY country;

/* Output:
country, Total_votes
'Germany','106710'
'Italy','77965'
*/

-- Approach-2:
-- Comparing total votes with respect to language the movies are available in, between German and Italian
WITH german_movies
     AS (SELECT languages,
                SUM(total_votes) AS Total_votes
         FROM   ratings r
                inner join movie m
                        ON r.movie_id = m.id
         WHERE  languages LIKE '%German%'
         GROUP  BY languages) SELECT 'German'         AS LANGUAGE,
       SUM(total_votes) AS Total_votes
FROM   german_movies
UNION
(
WITH italian_movies
     AS (SELECT languages,
                SUM(total_votes) AS Total_votes
         FROM   ratings r
                inner join movie m
                        ON r.movie_id = m.id
         WHERE  languages LIKE '%Italian%'
         GROUP  BY languages)
SELECT 'Italian'        AS LANGUAGE,
       SUM(total_votes) AS Total_votes
 FROM   italian_movies); 		

/* Output:
LANGUAGE, Total_votes
'German','4421525'
'Italian','2559540'
*/

-- In both of these cases, German movies get more votes than Italian movies.


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

SELECT Sum(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   names; 

/* Output:
name_nulls, height_nulls, date_of_birth_nulls, known_for_movies_nulls
'0','17335','13431','15226'
*/

-- Height, date of birth, known for movies have null values




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

-- using CTE with genre ranking
WITH top_genres AS
(
           SELECT     genre
           FROM       genre
           INNER JOIN ratings
           using     (movie_id)
           WHERE      avg_rating > 8
           GROUP BY   genre
           ORDER BY   Count(movie_id) DESC limit 3 ),
-- top 3 directors based on total number of movies in top 3 genres using CTE
top_directors AS
(
           SELECT     n.NAME                                       AS director_name,
                      Count(g.movie_id)                            AS movie_count,
                      Rank() OVER(ORDER BY Count(g.movie_id) DESC) AS director_rank
           FROM       genre g
           INNER JOIN director_mapping dm
           ON         g.movie_id = dm.movie_id
           INNER JOIN names n
           ON         dm.name_id = n.id
           INNER JOIN ratings r
           ON         g.movie_id = r.movie_id,
                      top_genres
           WHERE      avg_rating > 8
           AND        g.genre IN (top_genres.genre)
           GROUP BY   n.NAME )
SELECT director_name,
       movie_count
FROM   top_directors
WHERE  director_rank <=3;

/* Did not use LIMIT clause as it will only give top 'n' records as output irrespective of movie_count.
Here Soubin Shahir, Joe Russo and Anthony Russo have same movie_count and therefore it's important that we display
them all intead of just first 3.*/








/* James Mangold can be hired as the director for RSVP's next project. Do you remember his movies, 'Logan' and 'The Wolverine'. 
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

SELECT n.name            AS actor_name,
       Count(r.movie_id) AS movie_count
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN ratings r
               ON rm.movie_id = r.movie_id
WHERE  median_rating >= 8
GROUP  BY n.name
ORDER  BY movie_count DESC
LIMIT  2; 

/* Output:
actor_name, movie_count
'Mammootty','8'
'Mohanlal','5'
*/

/*Used limit clause here as the movie_count corresponding to 3rd actor is less than that of second actor.
It can be easily verified by setting LIMIT as 3.*/

-- Mammootty is the top actor based on total number of movies with median rating greater than 8. He is followed by Mohanlal.





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

WITH prod_info
     AS (SELECT production_company,
                Sum(total_votes)                    			AS vote_count,
                Dense_Rank() OVER(ORDER BY Sum(total_votes) DESC) 	AS prod_comp_rank
         FROM   ratings r
				INNER JOIN movie m
						ON r.movie_id = m.id
         GROUP  BY production_company)
SELECT *
FROM   prod_info
WHERE  prod_comp_rank <= 3;

/* Output:
production_company, vote_count, prod_comp_rank
'Marvel Studios','2656967','1'
'Twentieth Century Fox','2411163','2'
'Warner Bros.','2396057','3'

*/

-- Marvel studios tops the total vote count, followed by Twentieth century fox and Warner Bros.






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

/*Sorting and Ranking of indian actors with at least 5 movies on weighted average of movie ratings, 
with weights being 'total_votes', and 2nd level sorting with total number of votes.*/
WITH indian_actors
     AS (SELECT n.NAME,
                Sum(total_votes)                                           AS
					total_votes,
                Count(DISTINCT r.movie_id)                                          AS
					movie_count,
                Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) AS
					actor_avg_rating,
                Dense_Rank() OVER(ORDER BY Round(Sum(total_votes * avg_rating)/Sum(total_votes), 2) DESC, 
                Sum(total_votes) DESC)                                     AS 
					actor_rank
         FROM   names n
                INNER JOIN role_mapping rm
                        ON n.id = rm.name_id
                INNER JOIN movie m
                        ON rm.movie_id = m.id
                INNER JOIN ratings r
                        ON rm.movie_id = r.movie_id
         WHERE  country = 'India'
         GROUP  BY n.NAME
         HAVING movie_count >= 5)
SELECT *
FROM   indian_actors;

/* Output: 
NAME, total_votes, movie_count, actor_avg_rating, actor_rank
'Vijay Sethupathi','23114','5','8.42','1'
'Fahadh Faasil','13557','5','7.99','2'
'Yogi Babu','8500','11','7.83','3'
'Taapsee Pannu','18895','5','7.70','4'
'Joju George','3926','5','7.58','5'
'Ammy Virk','2504','6','7.55','6'
'Dileesh Pothan','6235','5','7.52','7'
'Kunchacko Boban','5628','6','7.48','8'
'Pankaj Tripathi','40728','5','7.44','9'
'Rajkummar Rao','42560','6','7.37','10'
'Dulquer Salmaan','17666','5','7.30','11'
'Amit Sadh','13355','5','7.21','12'
'Tovino Thomas','11596','8','7.15','13'
'Mammootty','12613','8','7.04','14'
'Nassar','4016','5','7.03','15'
'Raashi Khanna','9816','5','7.01','16'
'Karamjit Anmol','1970','6','6.91','17'
'Manju Warrier','11276','5','6.76','18'
'Nayanthara','8962','6','6.68','19'
'Hareesh Kanaran','3196','5','6.58','20'
'Naseeruddin Shah','12604','5','6.54','21'
'Anandraj','2750','6','6.54','22'
'Mohanlal','17244','6','6.51','23'
'Sonam Bajwa','2109','5','6.44','24'
'Siddique','5953','7','6.43','25'
'Aju Varghese','2237','5','6.43','26'
'Prakash Raj','8548','6','6.37','27'
'Jimmy Sheirgill','3826','6','6.29','28'
'Mahesh Achanta','2716','6','6.21','29'
'Biju Menon','1916','5','6.21','30'
'Suraj Venjaramoodu','4284','6','6.19','31'
'Abir Chatterjee','1413','5','5.80','32'
'Sunny Deol','4594','5','5.71','33'
'Radha Ravi','1483','5','5.70','34'
'Prabhu Deva','2044','5','5.68','35'
*/

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

/*Sorting and Ranking of indian actresses with at least 3 movies on weighted average of movie ratings, 
with weights being 'total_votes', and 2nd level sorting with total number of votes.*/

WITH ind_actress
     AS (SELECT n.NAME                                                     AS
                actress_name,
                Sum(total_votes)                                           AS
                   total_votes,
                Count(r.movie_id)                                          AS
                   movie_count,
                Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) AS
                   actor_avg_rating,
                Dense_Rank() OVER(ORDER BY Round(Sum(total_votes * avg_rating)/Sum(total_votes), 2) DESC,
                Sum(total_votes) DESC)                                     AS
                actress_rank
         FROM   names n
                INNER JOIN role_mapping rm
                        ON n.id = rm.name_id
                INNER JOIN movie m
                        ON rm.movie_id = m.id
                INNER JOIN ratings r
                        ON rm.movie_id = r.movie_id
         WHERE  country = 'India'
                AND category = 'actress'
                AND languages = 'Hindi'
         GROUP  BY n.NAME
         HAVING movie_count >= 3)
SELECT *
FROM   ind_actress
WHERE  actress_rank <= 5;

/* Output:
actress_name, total_votes, movie_count, actor_avg_rating, actress_rank
'Taapsee Pannu','18061','3','7.74','1'
'Divya Dutta','8579','3','6.88','2'
'Kriti Kharbanda','2549','3','4.80','3'
'Sonakshi Sinha','4025','4','4.18','4'
*/





/* Taapsee Pannu tops with average rating 7.74. 


Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Classifying movies of Thriller genre
-- Using case statement to create classes of avg_rating as variable, 'Movie_type' and ordering by title
SELECT title AS movie_title,
       avg_rating,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movie'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movie'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movie'
         ELSE 'Flop movie'
       END   Movie_type
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  g.genre = 'Thriller'
ORDER BY movie_title; 

/* Output too large to display ... sigh....*/





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

SELECT     genre,
           Round(Avg(duration))                 AS avg_duration,
           round(sum(Avg(duration)) OVER win1, 1) AS running_total_duration,
           round(avg(avg(duration)) OVER win2, 2) AS moving_avg_duration
FROM       genre g
INNER JOIN movie m
ON         g.movie_id = m.id
GROUP BY   genre 
WINDOW	   win1 AS (ORDER BY genre rows UNBOUNDED PRECEDING),
           win2 AS (ORDER BY genre rows BETWEEN 2 PRECEDING AND 2 following);

/* Output:
genre, avg_duration, running_total_duration, moving_avg_duration
'Action','113','112.9','105.79'
'Adventure','102','214.8','106.11'
'Comedy','103','317.4','106.24'
'Crime','107','424.4','103.86'
'Drama','107','531.2','104.51'
'Family','101','632.2','102.53'
'Fantasy','105','737.3','101.48'
'Horror','93','830.0','100.16'
'Mystery','102','931.8','101.87'
'Others','100','1032.0','100.43'
'Romance','110','1141.5','102.20'
'Sci-Fi','98','1239.5','102.30'
'Thriller','102','1341.0','103.02'
*/

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

-- On the first glance, we can see that worlwide_gross_income has different currencies. So let's find out the data type
SELECT column_name,
       data_type
FROM   information_schema.columns
WHERE  table_schema = 'imdb'
AND    table_name = 'movie'
AND    column_name = 'worlwide_gross_income';

-- worlwide_gross_income has varchar datatype. Let's convert to decimal at later stages.
-- Top 3 Genres based on most number of movies
WITH top_three_genre AS
(
           SELECT     genre,
                      Count(movie_id) AS number_of_movies
           FROM       genre g
           INNER JOIN movie m
           ON         g.movie_id = m.id
           GROUP BY   genre
           ORDER BY   Count(movie_id) DESC limit 3 ),
-- worldwide gross income of movies of each year from top 3 genre
-- Converting worldwide_gross_income datatype from 'varchar' to decimal
-- Converting values in INR to USD dollars after the data-type is corrected using conversion equation, 1 INR 0.0133 USD (as of now)
highest_grossing AS
(
           SELECT     genre,
                      year,
                      title AS movie_name,
                      CASE
                                 WHEN worlwide_gross_income LIKE 'INR%' THEN Cast(Replace(Ifnull(worlwide_gross_income,0),'INR',' ') AS DECIMAL(15))*0.0133
                                 ELSE Cast(Replace(Ifnull(worlwide_gross_income,0), '$',' ') AS                                         DECIMAL(15))
                      END                                                                        AS worlwide_gross_income,
                      Cast(worlwide_gross_income AS CHAR(15))                                    AS worldwide_gross_income,
                      Dense_rank() OVER( partition BY year ORDER BY worlwide_gross_income DESC ) AS movie_rank
           FROM       movie m
           INNER JOIN genre g
           ON         m.id= g.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_three_genre)
           ORDER BY   worlwide_gross_income DESC )
SELECT   genre,
         year,
         movie_name,
         worldwide_gross_income,
         Dense_rank() OVER( partition BY year ORDER BY worlwide_gross_income DESC ) AS movie_rank
FROM     highest_grossing
WHERE    movie_rank <= 5;

/* Output:
genre, year, movie_name, worldwide_gross_income, movie_rank
'Drama','2017','Thank You for Your Service','$ 9995692','1'
'Drama','2017','The Healer','$ 9979800','2'
'Comedy','2017','The Healer','$ 9979800','2'
'Thriller','2017','Gi-eok-ui bam','$ 9968972','3'
'Drama','2017','Shatamanam Bhavati','INR 530500000','4'
'Drama','2017','Winner','INR 250000000','5'
'Thriller','2018','The Villain','INR 1300000000','1'
'Comedy','2018','Gung-hab','$ 9899017','2'
'Drama','2018','Antony & Cleopatra','$ 998079','3'
'Comedy','2018','La fuitina sbagliata','$ 992070','4'
'Drama','2018','Zaba','$ 991','5'
'Thriller','2019','Joker','$ 995064593','1'
'Drama','2019','Joker','$ 995064593','1'
'Comedy','2019','Friend Zone','$ 9894885','2'
'Comedy','2019','Eaten by Lions','$ 99276','3'
'Thriller','2019','Prescience','$ 9956','4'
'Drama','2019','Nur eine Frau','$ 9884','5'

*/





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
WITH prod_comp_info
     AS (SELECT production_company,
                Count(movie_id)                    			AS movie_count,
                Rank() over(ORDER BY Count(movie_id) DESC) 	AS prod_comp_rank
         FROM   ratings r
				INNER JOIN movie m
						ON r.movie_id = m.id
         WHERE  production_company IS NOT NULL
                AND median_rating >= 8
                AND Position(',' IN languages) > 0
         GROUP  BY production_company)
SELECT *
FROM   prod_comp_info
WHERE  prod_comp_rank <= 2; 

/* Output:
production_company, movie_count, prod_comp_rank
'Star Cinema','7','1'
'Twentieth Century Fox','4','2'
*/

-- Star Cinema, Twentieth Century Fox are the top two production houses in terms of number of hit multilingual movies.



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
WITH top_actress
     AS (SELECT n.NAME                                                     	AS
                actress_name,
                Sum(total_votes)                                           	AS
                   total_votes,
                Count(r.movie_id)                                          	AS
                   movie_count,
                Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) 	AS
                   actor_avg_rating,
                Rank() OVER(ORDER BY Count(r.movie_id) DESC)             	AS
                   actress_rank
         FROM   names n
                INNER JOIN role_mapping rm
                        ON n.id = rm.name_id
                INNER JOIN genre g
                        ON rm.movie_id = g.movie_id
                INNER JOIN ratings r
                        ON rm.movie_id = r.movie_id
         WHERE  category = 'actress'
                AND genre = 'Drama'
                AND avg_rating > 8
         GROUP  BY n.NAME
         )
SELECT *
FROM   top_actress
WHERE  actress_rank <= 3;

/* Output:
actress_name, total_votes, movie_count, actor_avg_rating, actress_rank
'Parvathy Thiruvothu','4974','2','8.25','1'
'Susan Brown','656','2','8.94','1'
'Amanda Lawrence','656','2','8.94','1'
'Denise Gough','656','2','8.94','1'
*/

/* 
Here first four actresses in the output have same movie_count and therefore it's important that we display
them all instead of just first 3. So did not use LIMIT clause as it will only give top 'n' records as output irrespective of movie_count.
*/




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

-- Creating a new column in output to display date of last publication for every record, 'Previous_date_published' using LAG
-- Summary of directors with a new column, 'Previous_date_published'
WITH director_info
     AS (SELECT dm.name_id,
                n.name,
                dm.movie_id,
                r.avg_rating,
                r.total_votes,
                m.duration,
                date_published,
                Lag(date_published, 1) OVER(PARTITION BY dm.name_id
												ORDER BY date_published) AS previous_date_published
         FROM   names n
                INNER JOIN director_mapping dm
                        ON n.id = dm.name_id
                INNER JOIN movie m
                        ON dm.movie_id = m.id
                INNER JOIN ratings r
                        ON m.id = r.movie_id),

-- Renaming columns and ranking directors based on number_of_movies
     top_directors
     AS (SELECT name_id                                                       AS
                director_id,
                NAME                                                          AS
                   director_name,
                Count(movie_id)                                               AS
                   number_of_movies,
                Round(Avg(Datediff(date_published, previous_date_published))) AS
                avg_inter_movie_days,
                Round(sum(avg_rating*total_votes)/sum(total_votes), 2)        AS
                   avg_rating,
                Sum(total_votes)                                              AS
                   total_votes,
                Round(Min(avg_rating), 1)                                     AS
                   min_rating,
                Round(Max(avg_rating), 1)                                     AS
                   max_rating,
                Sum(duration)                                                 AS
                   total_duration,
                Rank() OVER(ORDER BY Count(movie_id) DESC)                    AS
                   director_rank
         FROM   director_info
         GROUP  BY director_id)
         
-- Get the top 9 directors details
SELECT director_id,
       director_name,
       number_of_movies,
       avg_inter_movie_days,
       avg_rating,
       total_votes,
       min_rating,
       max_rating,
       total_duration
FROM   top_directors
WHERE  director_rank <= 9;

/* Output
director_id, director_name, number_of_movies, avg_inter_movie_days, avg_rating, total_votes, min_rating, max_rating, total_duration
'nm1777967','A.L. Vijay','5','177','5.65','1754','3.7','6.9','613'
'nm2096009','Andrew Jones','5','191','3.04','1989','2.7','3.2','432'
'nm0001752','Steven Soderbergh','4','254','6.77','171684','6.2','7.0','401'
'nm0425364','Jesse V. Johnson','4','299','6.10','14778','4.2','6.5','383'
'nm0515005','Sam Liu','4','260','6.32','28557','5.8','6.7','312'
'nm0814469','Sion Sono','4','331','6.31','2972','5.4','6.4','502'
'nm0831321','Chris Stokes','4','198','4.32','3664','4.0','4.6','352'
'nm2691863','Justin Price','4','315','4.93','5343','3.0','5.8','346'
'nm6356309','Özgür Bakar','4','112','3.96','1092','3.1','4.9','374'
*/

-- Avoiding the use of LIMIT for safety.





