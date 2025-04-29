CREATE TABLE January_Jobs AS 
(
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
);


CREATE TABLE February_Jobs AS 
(
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2
);

CREATE TABLE March_Jobs AS 
(
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3
);


SELECT *
FROM January_Jobs;



-- Problem 1: Find the average salary for each job schedule type (e.g., full-time, part-time) for jobs posted after June 1, 2023.
SELECT
    job_schedule_type AS schedule_type,
    AVG(salary_year_avg) AS avg_salary,
    AVG(salary_hour_avg) AS avg_hourly_salary
FROM job_postings_fact
WHERE job_posted_date::DATE >'2023-06-01'
GROUP BY job_schedule_type
ORDER BY job_schedule_type;



SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
GROUP BY month
ORDER BY month;


SELECT
    COUNT(job_postings_fact.job_id)  AS job_count,
    company_dim.name AS company_name
FROM job_postings_fact
JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE job_postings_fact.job_health_insurance = TRUE 
    AND EXTRACT(QUARTER FROM job_posted_date) = 2
GROUP BY company_dim.name
HAVING COUNT(job_postings_fact.job_id) > 0
ORDER BY job_count DESC
