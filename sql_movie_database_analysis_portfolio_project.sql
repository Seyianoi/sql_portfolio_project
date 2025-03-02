/* To determine the top 5 highest grossing movies along with their directors*/

SELECT m.movie_name, 
       d.first_name|| '' ||d.last_name AS director_name,
	   (mr.domestic_takings+mr.international_takings) AS total_revenue
FROM movie_revenues mr
JOIN movies m ON mr.movie_id = m.movie_id
JOIN movies_directors md ON m.movie_id = md.movie_id
JOIN directors d ON md.director_id = d.director_id
ORDER BY total_revenue DESC
LIMIT 5;

/* To determine the average domestic revenue of movies by language and age certification*/

SELECT m.movie_lang,
       m.age_certificate,
	   AVG(mr.domestic_takings) AS average_domestic_revenue
FROM movie_revenues mr
JOIN movies m ON mr.movie_id = m.movie_id
GROUP BY m.movie_lang, m.age_certificate
ORDER BY average_domestic_revenue DESC;

/*To determine most frequently cast actor in movies directed by the same director*/

SELECT d.first_name||''||d.last_name AS director_name,
       a.first_name||''||a.last_name AS actor_name,
	   COUNT(ma.movie_id) AS movie_count
FROM directors d
JOIN movies_directors md ON d.director_id=md.director_id
JOIN movie_actors ma ON md.movie_id=ma.movie_id
JOIN actors a ON a.actor_id=ma.actor_id
GROUP BY d.director_id, a.actor_id, director_name, actor_name
ORDER BY movie_count DESC
LIMIT 1;

/*To determine international revenue comaprison between male and female actors*/

WITH leadactors AS (
     SELECT ma.movie_id, 
	        a.actor_id, 
			a.gender
	 FROM movie_actors ma
	 INNER JOIN actors a ON ma.actor_id=a.actor_id
	 WHERE ma.actor_id=(
           SELECT MIN(ma2.actor_id)
		   FROM movie_actors ma2 
		   WHERE ma2.movie_id=ma.movie_id
	 ))
SELECT la.gender,
       SUM(mr.international_takings) AS total_international_revenue
FROM leadactors la
INNER JOIN movie_revenues mr ON la.movie_id=mr.movie_id
GROUP BY la.gender;

/* To determine directors with movies that earned more internationally than domestically */ 

SELECT d.first_name||''||d.last_name AS director_name,
       COUNT(m.movie_id) AS movies_with_higher_international_revenue
FROM directors d
INNER JOIN movies m ON d.director_id=m.director_id
LEFT JOIN movie_revenues mr ON m.movie_id=mr.movie_id
WHERE mr.international_takings>mr.domestic_takings
GROUP BY d.director_id, director_name
HAVING COUNT (m.movie_id)>0
ORDER BY movies_with_higher_international_revenue DESC;






