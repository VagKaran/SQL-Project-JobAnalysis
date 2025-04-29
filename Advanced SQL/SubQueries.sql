SELECT
    name AS company_name
FROM 
company_dim
WHERE
    company_id IN(-- SubQuery starts here 
        SELECT
            company_id
        FROM 
            job_postings_fact
        WHERE 
            job_no_degree_mention = 'TRUE'
    )




-- CTEs Example
WITH company_job_count AS (
    SELECT
    company_id,
    COUNT(*) AS total_jobs
FROM
    job_postings_fact
GROUP BY
    company_id
)

SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM company_dim
left join company_job_count
ON company_dim.company_id = company_job_count.company_id
ORDER BY
    company_job_count.total_jobs DESC



-- CTEs Example 2

WITH remote_job_skills AS (
    SELECT
        skills_to_job.skill_id,
        COUNT(*) AS skill_count
    FROM 
        skills_job_dim AS skills_to_job
    INNER JOIN 
        job_postings_fact AS job_postings  
        ON skills_to_job.job_id = job_postings.job_id
    WHERE
        job_postings.job_no_degree_mention = 'TRUE'
        AND job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skills_to_job.skill_id
)
SELECT
    skills.skill_id,
    skills.skills,
    remote_job_skills.skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills
ON remote_job_skills.skill_id = skills.skill_id
ORDER BY
    remote_job_skills.skill_count DESC
LIMIT 5;

-- Problem 1 
SELECT skills_dim.skills
FROM skills_dim
INNER JOIN (
    SELECT 
        skill_id,
        COUNT(job_id) AS skill_count
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY COUNT(job_id) DESC
    LIMIT 5
) AS top_skills ON skills_dim.skill_id = top_skills.skill_id
ORDER BY top_skills.skill_count DESC;


-- Problem 2
SELECT
    company_id,
    name,
    CASE 
        WHEN job_count < 10 THEN 'Small'
        WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS company_size
FROM 
(
    SELECT
        company_dim.company_id,
        company_dim.name,
        COUNT(job_postings_fact.job_id) AS job_count
    FROM 
        job_postings_fact
    INNER JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    GROUP BY 
        company_dim.company_id
        , company_dim.name
) AS company_job_counts



-- Problem 3
SELECT
    company_dim.name
FROM
    company_dim
INNER JOIN (
SELECT
    company_id,
    AVG(salary_year_avg) AS overall_avg_salary
FROM
    job_postings_fact
GROUP BY
    company_id
) AS avg_salaries
ON company_dim.company_id = avg_salaries.company_id
WHERE
    overall_avg_salary > (
        SELECT
            AVG(salary_year_avg)
        FROM
            job_postings_fact
    )


-- Repeat of Problem 3 for practice
SELECT
    company_dim.name
FROM
    company_dim
INNER JOIN (
SELECT
    company_id,
    AVG(salary_year_avg) AS overall_avg_salary
FROM
    job_postings_fact
GROUP BY company_id
) AS avg_salaries  
ON company_dim.company_id = avg_salaries.company_id
WHERE 
    overall_avg_salary > (
        SELECT
            AVG(salary_year_avg)
        FROM
            job_postings_fact
    )

