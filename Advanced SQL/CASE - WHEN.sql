SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Other'
    END AS location_category
FROM job_postings_fact
GROUP BY location_category;



-- Problem 1:CASE-WHEN
SELECT 
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= 100000 THEN 'High Salary'
        WHEN salary_year_avg >= 60000 THEN 'Standard Salary'
        WHEN salary_year_avg < 60000 THEN 'Low Salary'
    END AS salary_category
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC;



-- Problem 2: CASE-WHEN

SELECT
    CASE
        WHEN job_work_from_home = TRUE THEN 'Work From Home'
        ELSE 'On-Site'
    END AS work_type,
    COUNT(DISTINCT company_id) AS unique_companies
FROM job_postings_fact
GROUP BY work_type;   


--Problem 3: CASE-WHEN
SELECT
    job_id,
    salary_year_avg,
    CASE
         WHEN job_title ILIKE '%senior%' THEN 'Senior'
        WHEN job_title ILIKE '%manager%' OR job_title ILIKE '%lead%' THEN 'Lead/Manager'
        WHEN job_title ILIKE '%junior%' OR job_title ILIKE '%entry%' THEN 'Junior/Entry'
        ELSE 'Not Specified'
    END AS experience_level,
    CASE
        WHEN job_work_from_home = TRUE THEN 'Yes'
        ELSE 'No'
    END AS remote_option
FROM 
    job_postings_fact
WHERE   
    salary_year_avg IS NOT NULL
    
ORDER BY
    job_id;


SELECT DISTINCT job_title From job_postings_fact
