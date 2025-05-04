
## 22 Business Problem and Solutions

SELECT *
FROM imdb_movies;

/*1. A company wants to classify its movie portfolio based on revenue performance to better understand historical trends and guide future investments. Management has defined the following revenue-based segmentation:
Blockbuster: Revenue ≥ 300 million
Superhit: Revenue between 200 and 299.99 million
Hit: Revenue between 100 and 199.99 million
Normal: Revenue < 100 million The marketing team is specifically interested in evaluating the performance of their releases from the year 2014. 
They want to know how many movies released in 2014 fall under the 'Superhit' category to assess that year’s return on mid-tier investments.*/

SELECT Count(*) AS ` ‘Superhit’ in the year 2014`
FROM   (SELECT *,
               CASE
                 WHEN revenue_millions >= 300 THEN 'Blockbuster'
                 WHEN revenue_millions BETWEEN 200 AND 299.99THEN 'Superhit'
                 WHEN revenue_millions BETWEEN 100 AND 199.99 THEN 'Hit'
                 ELSE 'Normal'
               end AS 'Ratings'
        FROM   imdb_movies
        WHERE  year = 2014
        HAVING `ratings` = 'Superhit') a; 


-- 2.Calculate the total revenue from 'Blockbuster' movies (revenue ≥ 300M) released in 2015 to assess top-tier film performance for that year.

SELECT Round(Sum(revenue_millions), 2) AS
       `total revenue of the Blockbuster movies in the year 2015`
FROM   (SELECT *,
               CASE
                 WHEN revenue_millions >= 300 THEN 'Blockbuster'
                 WHEN revenue_millions BETWEEN 200 AND 299.99THEN 'Superhit'
                 WHEN revenue_millions BETWEEN 100 AND 199.99 THEN 'Hit'
                 ELSE 'Normal'
               end AS 'Ratings'
        FROM   imdb_movies
        WHERE  year = 2015
        HAVING `ratings` = 'Blockbuster') a; 
        
/*3. A company wants to enhance its movie recommendation system by segmenting its catalog based on viewer ratings. To achieve this, movies are categorized as:
Must Watch: Rating ≥ 8
Can Watch: Rating between 6 and 7.9
Avoid: Rating < 6 
The content strategy team is specifically interested in knowing how many movies in the entire dataset qualify as ‘Must Watch’, 
so they can prioritize promoting high-rated content to users and allocate marketing efforts accordingly.*/

SELECT count(*)
FROM   (SELECT *,
               IF(rating >= 8, 'Must Watch',
               IF(rating BETWEEN 6 AND 7.9, 'Can Watch',
               'Avoid')
               ) AS Ratings
        FROM   imdb_movies) a 
WHERE Ratings = 'Must Watch';
	
/*4. Evaluate the financial performance of lower-rated movies (ratings < 7) 
to better understand their impact. Specifically, they aim to analyze total revenue by year and genre,
 and determine the total revenue of 'Drama' movies with ratings below 7 in 2016 to assess that genre’s underperforming content.*/

SELECT Genre, year,Sum(revenue_millions)
FROM imdb_movies
WHERE Rating < 7
AND YEAR = 2016
AND Genre = 'Drama'
GROUP BY 1,2
ORDER BY 2 asc;

/*5. To assess the performance of different genres, the company wants to identify how much revenue the 'Comedy' genre contributed to the total movie revenue in the year 2016.
 This will help guide future investment decisions in genre-based content.*/

SELECT C.genre,
       Sum(rp) AS `revenue contribution`
FROM   (SELECT a.genre,
               Round(( revenue_millions * 100 / rm ), 2) AS RP
        FROM   imdb_movies a
               INNER JOIN (SELECT genre,
                                  Sum(revenue_millions) AS RM
                           FROM   imdb_movies
                           GROUP  BY 1) b
                       ON a.genre = b.genre
        WHERE  year = '2016'
               AND a.genre = 'Comedy') c
GROUP  BY 1; 

-- 6. calculate revenue contribution of ‘The Avengers’ within the 'Action' genre in 2012, to evaluate the significance of blockbuster titles in overall genre revenue.


SELECT a.genre,
       a.title,
       Round(( revenue_millions * 100 / rm ), 2) AS `revenue contribution`
FROM   imdb_movies a
       INNER JOIN (SELECT genre,
                          Sum(revenue_millions) AS rm
                   FROM   imdb_movies
                   GROUP  BY 1) b
               ON a.genre = b.genre
WHERE  a.genre = 'Action'
       AND year = 2012
       AND title = 'The Avengers' ;
       
       
-- 7. Which genre has the highest revenue collection for the last 3 years?
SELECT a.genre, a.year, Max(RM)
FROM   imdb_movies a
       INNER JOIN (SELECT genre,
                          year,
                          Sum(revenue_millions) AS RM
                   FROM   imdb_movies
                   GROUP  BY 1,
                             2) b
               ON a.genre = b.genre 
GROUP BY 1,2
ORDER BY 2 desc,3 desc;

 --  8. Find out the the director who has highest average rating of his/her movies.

SELECT director,
       Max(ar)
FROM   (SELECT director,
               Avg(rating) AS AR
        FROM   imdb_movies
        GROUP  BY 1) a
GROUP  BY 1
ORDER  BY 2 DESC; 

-- 9. How many movies have revenue greater than highest movie revenue of the ‘Adventure’ genre?

SELECT count(title)
FROM imdb_movies
WHERE Revenue_millions > ( SELECT max(revenue_millions) as RM
						   FROM imdb_movies 
                           WHERE Genre = 'Adventure');

-- 10. How many movies have ratings greater than highest movie rating of the year 2015?

SELECT count(Title)
FROM imdb_movies
WHERE rating > ( SELECT Max(rating)
				 FROM imdb_movies
                 WHERE year = 2015);
                 
-- 11. What is the minimum revenue corresponding to a movie such that its rating is higher than highest movie rating of the year 2015 and its revenue is greater than highest movie revenue of the ‘Comedy’ genre?

SELECT Min(revenue_millions)
FROM   imdb_movies
WHERE  rating > (SELECT Max(rating)
                 FROM   imdb_movies
                 WHERE  year = 2015)
       AND revenue_millions > (SELECT Max(revenue_millions)
                               FROM   imdb_movies
                               WHERE  genre = 'Comedy'); 
                               
							
-- 12. How many movies contribute more than 10% of revenue to the total revenue of all movies in a year ?
 
SELECT *
FROM   (SELECT title,
               ( revenue_millions * 100 / rm ) AS pr
        FROM   imdb_movies a
               INNER JOIN (SELECT year,
                                  Sum(revenue_millions) AS rm
                           FROM   imdb_movies
                           GROUP  BY 1) b
                       ON a.year = b.year) a
WHERE  pr > 10 ;


-- 13. How many movies contribute more than 5% of revenue to the total revenue of all movies in their respective genre?
 
 
SELECT Count(*)
FROM   (SELECT title,
               ( revenue_millions * 100 / rm ) AS pr
        FROM   imdb_movies a
               INNER JOIN (SELECT genre,
                                  Sum(revenue_millions) AS rm
                           FROM   imdb_movies
                           GROUP  BY 1) b
                       ON a.genre = b.genre) c
WHERE  pr > 5; 
					
 SELECT Count(*)
FROM   (SELECT title,
               ( revenue_millions * 100 / tot_revenue ) AS perc_revenue
        FROM   imdb_movies A
               INNER JOIN (SELECT genre,
                                  Sum(revenue_millions) AS tot_revenue
                           FROM   imdb_movies
                           GROUP  BY genre) b
                       ON A.genre = b.genre
        WHERE  ( revenue_millions * 100 / tot_revenue ) > 5) C;
        
        
        
        
-- 14. How can we effectively identify and highlight the top-performing movies each year based on user ratings to enhance our platform's content discovery and recommendation features?

SELECT *
FROM imdb_movies;

SELECT title,year,rating,Rank()
			Over( Partition by year order by rating desc ) as ranks
FROM imdb_movies;

-- 15. How do we fix our annual movie ranking to accurately show the next best films after ties, and what is the rank of "Kung Fu Panda"?


SELECT title,
       year,
       rating,
       ranks
FROM   (SELECT title,
               year,
               rating,
               Dense_rank()
                 OVER(
                   partition BY year
                   ORDER BY rating DESC ) AS ranks
        FROM   imdb_movies) a
WHERE  title = 'Kung Fu Panda' ;






-- 16. Create a report where all the movies are ranked based on revenue in their respective genre. What is the rank of ‘Inception’ movie in its genre?


SELECT *
FROM   (SELECT title,
               genre,
               Rank()
                 OVER(
                   partition BY genre
                   ORDER BY revenue_millions DESC) AS ranks
        FROM   imdb_movies) a
WHERE  title = 'Inception' ;

-- 17. Calculate the revenue contribution of movies towards the total revenue of respective genres

SELECT title,
       genre,
       revenue_millions,
       total_genre_revenue,
       Round(( revenue_millions * 100 / total_genre_revenue ), 2) AS percentage
FROM   (SELECT title,
               genre,
               revenue_millions,
               Sum(revenue_millions)
                 OVER(
                   partition BY genre) AS Total_genre_revenue
        FROM   imdb_movies) a ;




-- 18. Compute the percentage rating in terms of top rated movies in their respective genre. What is the percentage rating of the movie ‘Blood Diamond’?

SELECT title,
       genre,
       rating,
       ( rating * 100 / max_genre_rating ) AS perc
FROM   (SELECT title,
               genre,
               rating,
               Max(rating)
                 OVER(
                   partition BY genre) AS max_genre_rating
        FROM   imdb_movies) a
WHERE  title = 'Blood diamond';


 -- 19. Calculate the cumulative revenue for the year. What is the cumulative revenue for “Iron Man 2” movie?’


SELECT id,
       title,
       year,
       revenue_millions,
       cumulative_revenue_year
FROM   (SELECT id,
               title,
               year,
               revenue_millions,
               Sum(revenue_millions)
                 OVER(
                   partition BY year
                   ORDER BY id) AS cumulative_revenue_year
        FROM   imdb_movies
        WHERE  revenue_millions IS NOT NULL) AS table1
WHERE  title = 'Iron Man 2' ;


/* 20. Management has defined the following revenue-based segmentation:
Blockbuster: Revenue ≥ 300 million
Superhit: Revenue between 200 and 299.99 million
Hit: Revenue between 100 and 199.99 million
Normal: Revenue < 100 million Find the first Blockbuster movie of each year. In the year 2014, Which movie was the first blockbuster?*/


SELECT year,
       title,
       film_response,
       First_value(title)
         OVER(
           partition BY year) AS "First_blockbuster_movie_year"
FROM   (SELECT year,
               title,
               CASE
                 WHEN revenue_millions >= 300 THEN "blockbuster"
                 WHEN revenue_millions BETWEEN 200 AND 299.99 THEN "super hit"
                 WHEN revenue_millions BETWEEN 100 AND 199.99 THEN "hit"
                 ELSE "normal"
               END AS "Film_response"
        FROM   imdb_movies) a
WHERE  film_response = 'Blockbuster'
       AND year = 2014; 

-- 21. Find the 5th Blockbuster movie of each year. Which year option does not have any 5th Blockbuster movie?

SELECT *
FROM (SELECT distinct year,
       title,
       film_response,
       nth_value(title,5)
         OVER(
           partition BY year) AS "Fifth_blockbuster_movie_year"
FROM   (SELECT year,
               title,
               CASE
                 WHEN revenue_millions >= 300 THEN "blockbuster"
                 WHEN revenue_millions BETWEEN 200 AND 299.99 THEN "super hit"
                 WHEN revenue_millions BETWEEN 100 AND 199.99 THEN "hit"
                 ELSE "normal"
               END AS "Film_response"
        FROM   imdb_movies) a
WHERE  film_response = 'Blockbuster') a
WHERE Fifth_blockbuster_movie_year is null;


/*22. Find out the Year on Year growth of the movie revenue.
Calculate the YoY Growth for each year.
Which year had negative growth?
Which year had highest growth?*/


SELECT year,
       annual_revenue,
       ( annual_revenue / Lag(annual_revenue, 1, NULL)
                            OVER() - 1 ) * 100 AS "YOY_GROWTH"
FROM   (SELECT year,
               Sum(revenue_millions) AS Annual_revenue
        FROM   imdb_movies
        GROUP  BY 1
        ORDER  BY 1) a; 
