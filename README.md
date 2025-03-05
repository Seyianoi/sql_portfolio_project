# Movie Database Analysis Report

## Introduction

This report presents an analysis of a movie database using SQL and PostgreSQL. The analysis aims to extract insights regarding movie revenues, actor-director collaborations, and revenue comparisons. The results were obtained through a series of SQL queries designed to answer key business questions. Git and GitHub were used for version control and project management.

## Background

The dataset comprises several tables: `movies`, `actors`, `directors`, `movie_revenues`, `movie_actors`, and `movies_directors`. These tables store information about movies, their earnings, the actors and directors involved, and their relationships. The queries focus on extracting relevant insights about movie performance and casting trends.

## Tools Used

- **SQL**: For querying and analyzing the movie database.
- **PostgreSQL**: As the relational database management system (RDBMS) for executing queries.
- **Git**: For tracking changes in SQL scripts.
- **GitHub**: For storing and sharing the project repository.

## Analysis

### 1. Top 5 Highest-Grossing Movies and Their Directors

**Query:**

```sql
SELECT m.movie_name,
       d.first_name || ' ' || d.last_name AS director_name,
       (mr.domestic_takings + mr.international_takings) AS total_revenue
FROM movie_revenues mr
JOIN movies m ON mr.movie_id = m.movie_id
JOIN directors d ON m.director_id = d.director_id
ORDER BY total_revenue DESC
LIMIT 5;
```

**Results:**

| Movie Name        | Director            | Total Revenue (in million $) |
|------------------|--------------------|------------------------------|
| Titanic         | James Cameron      | 2187.3                       |
| Django Unchained | Quentin Tarantino  | 300.8                         |
| Pulp Fiction    | Quentin Tarantino  | 214.1                         |

**What I Learned:**

- James Cameron's *Titanic* is the highest-grossing movie in the dataset by a significant margin.
- Quentin Tarantino has two highly successful movies in the top three.
- Both international and domestic earnings contribute significantly to overall revenue.

**Conclusion:** Identifying successful directors and their films can help in strategic decision-making for future productions.

### 2. Average Domestic Revenue by Language and Age Certification

**Query:**

```sql
SELECT m.movie_lang,
       m.age_certificate,
       AVG(mr.domestic_takings) AS average_domestic_revenue
FROM movie_revenues mr
JOIN movies m ON mr.movie_id = m.movie_id
GROUP BY m.movie_lang, m.age_certificate
ORDER BY average_domestic_revenue DESC;
```

**Results:**

| Movie Language | Age Certification | Average Domestic Revenue (in million $) |
|---------------|-------------------|----------------------------------|
| English       | 12                | 659.2                            |
| English       | 15                | 74.87                            |
| English       | 18                | 73.80                            |
| Chinese       | 15                | No data available                |
| Japanese      | 18                | No data available                |

**What I Learned:**

- Movies rated **12** in English tend to have the highest average domestic revenue.
- **English-language movies** dominate the dataset, while Chinese and Japanese films lack domestic revenue data.
- **Age certification influences revenue**, as lower-rated films tend to attract wider audiences.

**Conclusion:** Understanding these trends can inform decisions about movie distribution and target audience segmentation.

### 3. Most Frequently Cast Actor in Movies by the Same Director

**Query:**

```sql
SELECT d.first_name || ' ' || d.last_name AS director_name,
       a.first_name || ' ' || a.last_name AS actor_name,
       COUNT(ma.movie_id) AS movie_count
FROM directors d
JOIN movies_directors md ON d.director_id = md.director_id
JOIN movie_actors ma ON md.movie_id = ma.movie_id
JOIN actors a ON a.actor_id = ma.actor_id
GROUP BY d.director_id, a.actor_id, director_name, actor_name
ORDER BY movie_count DESC
LIMIT 1;
```

**Results:**

- **Director:** Quentin Tarantino  
- **Actor:** Samuel Jackson  
- **Movie Count:** 2  

**What I Learned:**

- Quentin Tarantino frequently collaborates with Samuel Jackson.
- Some directors have strong partnerships with specific actors, which can contribute to the style and success of their films.
- Understanding these collaborations can help in predicting future casting decisions.

**Conclusion:** Recognizing these collaborations can help in predicting future casting decisions and marketing strategies.

### 4. International Revenue Comparison Between Male and Female Lead Actors

**Query:**

```sql
WITH leadactors AS (
     SELECT ma.movie_id,
            a.actor_id,
            a.gender
     FROM movie_actors ma
     INNER JOIN actors a ON ma.actor_id = a.actor_id
     WHERE ma.actor_id = (
           SELECT MIN(ma2.actor_id)
           FROM movie_actors ma2
           WHERE ma2.movie_id = ma.movie_id
     ))
SELECT la.gender,
       SUM(mr.international_takings) AS total_international_revenue
FROM leadactors la
JOIN movie_revenues mr ON la.movie_id = mr.movie_id
GROUP BY la.gender;
```

**What I Learned:**

- The current dataset lacks sufficient international revenue data to make a meaningful comparison between male and female lead actors.
- This highlights the importance of ensuring complete revenue data when analyzing gender-based revenue disparities.
- A more comprehensive dataset is needed to draw conclusive insights into gender-based revenue differences.

**Conclusion:** Insights from this analysis can guide discussions on gender representation and pay equity in the film industry.

## Summary

This analysis used SQL and PostgreSQL to derive insights from a movie database, revealing patterns in movie revenues, casting preferences, and gender-based earnings. The findings can assist stakeholders in making data-driven decisions regarding movie production and marketing.

