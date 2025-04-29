-- Problem 1: Find the top 10 companies with the most unique job titles in the job_postings_fact table.
WITH JobTitleCount AS (
        SELECT
        company_id,
        COUNT(DISTINCT job_title) AS job_title_count
        FROM 
            job_postings_fact   
        GROUP BY 
            company_id
)    
SELECT 
    c.name AS company_name,
    j.job_title_count
FROM 
   JobTitleCount AS j
JOIN company_dim AS c
ON 
    j.company_id = c.company_id
ORDER BY 
    j.job_title_count DESC
LIMIT 10;



-- Problem 2
WITH CountryAverageSalary AS (
SELECT
    job_country,
    AVG(salary_year_avg) AS avg_salary_country
FROM
    job_postings_fact
GROUP BY    
    job_country
)

SELECT 
    j.job_id,
    j.job_title,
    c.name AS company_name,
    j.salary_year_avg,
    EXTRACT(MONTH FROM j.job_posted_date) AS posting_month,
    CASE
        WHEN j.salary_year_avg > ca.avg_salary_country THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_comparison
FROM
    job_postings_fact AS j
JOIN company_dim AS c ON  j.company_id = c.company_id
JOIN CountryAverageSalary AS ca ON  j.job_country = ca.job_country
ORDER BY
    j.job_posted_date DESC




-- Problem 3
-- Counts the distinct skills required for each company's job posting
WITH required_skills AS (
    SELECT
        companies.company_id,
        COUNT(DISTINCT skills_to_job.skill_id) AS unique_skills_required
    FROM
        company_dim AS companies 
    LEFT JOIN job_postings_fact as job_postings ON companies.company_id = job_postings.company_id
    LEFT JOIN skills_job_dim as skills_to_job ON job_postings.job_id = skills_to_job.job_id
    GROUP BY
        companies.company_id
),
-- Gets the highest average yearly salary from the jobs that require at least one skills 
max_salary AS (
    SELECT
        job_postings.company_id,
        MAX(job_postings.salary_year_avg) AS highest_average_salary
    FROM
        job_postings_fact AS job_postings
    WHERE
        job_postings.job_id IN (SELECT job_id FROM skills_job_dim)
    GROUP BY
        job_postings.company_id
)
-- Joins 2 CTEs with table to get the query
SELECT
    companies.name,
    required_skills.unique_skills_required as unique_skills_required, --handle companies w/o any skills required
    max_salary.highest_average_salary
FROM
    company_dim AS companies
LEFT JOIN required_skills ON companies.company_id = required_skills.company_id
LEFT JOIN max_salary ON companies.company_id = max_salary.company_id
ORDER BY
    companies.name;


