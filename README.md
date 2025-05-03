# imdb-movies-SQL-Project



##  Business Problem and Solutions
#### 1. A film production company wants to classify its movie portfolio based on revenue performance to better understand historical trends and guide future investments. Management has defined the following revenue-based segmentation:
#### * Blockbuster: Revenue ≥ 300 million
#### * Superhit: Revenue between 200 and 299.99 million
#### * Hit: Revenue between 100 and 199.99 million
#### * Normal: Revenue < 100 million
#### The marketing team is specifically interested in evaluating the performance of their releases from the year 2014.
#### They want to know how many movies released in 2014 fall under the 'Superhit' category to assess that year’s return on mid-tier investments.

```Sql
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
```
**Objective:** To determine the number of 'Superhit' movies released in the year 2014 by classifying films based on their revenue using a CASE WHEN logic.
