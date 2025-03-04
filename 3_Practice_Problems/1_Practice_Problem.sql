-- Write a query to find the average salary both yearly and hourly for job postings that were posted after June 1, 2023. Group the results by job schedule type.

SELECT 
    AVG(salary_year_avg) as avg_year_salary,
    AVG(salary_hour_avg) as avg_hour_salary,
    job_schedule_type,
    job_posted_date
FROM 
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type,
    job_posted_date;



-- Write a query to find companies (include company name) that have posted jobs offering health insurance, where these postings were made in the second quarter of 2023. Use date extraction.

SELECT 
    cd.name,
    EXTRACT(QUARTER FROM job_posted_date) as second_quarter,
    jpf.job_health_insurance,
    jpf.job_posted_date
FROM
    job_postings_fact as jpf
JOIN 
    company_dim as cd 
ON
    cd.company_id = jpf.company_id
WHERE 
    (job_health_insurance = 'True') 
    AND EXTRACT(QUARTER FROM job_posted_date) = 2
    AND EXTRACT(YEAR FROM jpf.job_posted_date) = 2023 
ORDER BY 
    cd.name;
