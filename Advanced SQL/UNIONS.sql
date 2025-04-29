-- Practice Problem_8
SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,-- Because I need only the Date 
    salary_year_avg
FROM (
SELECT *
FROM january_jobs
UNION ALL -- Because I don't want to remove duplicates
SELECT *
FROM february_jobs
UNION ALL -- Because I don't want to remove duplicates
SELECT *
FROM march_jobs
) AS Quarter1_jobs
WHERE 
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC





-- Problem 1 - Easy

SELECT
    job_id,
    job_title_short,
    'With Salary Info' AS salary_info
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL AND salary_hour_avg IS NOT NULL

UNION ALL

SELECT
    job_id,
    job_title_short,
    'Without Salary Info' AS salary_info
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NULL AND salary_hour_avg IS NULL

ORDER BY 
    job_id,
    salary_info DESC;


-- Problem 2 - Medium

WITH Q1_Jobs AS (
SELECT job_id,job_title_short,job_location,job_via, salary_year_avg
FROM january_jobs

UNION ALL

SELECT job_id, job_title_short,job_location,job_via, salary_year_avg
FROM february_jobs

UNION ALL

SELECT job_id,  job_title_short,job_location, job_via,salary_year_avg
FROM march_jobs
)

SELECT
    Q1_Jobs.job_id,
    Q1_Jobs.job_title_short,
    Q1_Jobs.job_location,  
    Q1_Jobs .job_via,
    skills_dim.skills, 
    skills_dim.type AS skill_type
FROM Q1_Jobs
LEFT JOIN skills_job_dim ON Q1_Jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    Q1_Jobs.salary_year_avg > 70000 
ORDER BY
    Q1_Jobs.job_id


-- Problem 3 - Hard

WITH combined_job_postings AS(
    SELECT job_id,job_posted_date
    FROM january_jobs
    UNION ALL
    SELECT job_id,job_posted_date
    FROM february_jobs
    UNION ALL
    SELECT job_id,job_posted_date
    FROM march_jobs
),
monthly_skill_demand AS(
    SELECT
        skills_dim.skills,
        EXTRACT(YEAR FROM combined_job_postings.job_posted_date) AS year,  
        EXTRACT(MONTH FROM combined_job_postings.job_posted_date) AS month,
        COUNT(DISTINCT combined_job_postings.job_id) AS job_count     
    FROM 
        combined_job_postings
    INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    GROUP BY
        skills_dim.skills,
        EXTRACT(YEAR FROM combined_job_postings.job_posted_date),
        EXTRACT(MONTH FROM combined_job_postings.job_posted_date)
)

SELECT
    skills,
    year,
    month,
    job_count
FROM
    monthly_skill_demand
ORDER BY
    skills,
    year,
    month;
