-- Write an SQL query using a subquery to find all companies that have posted job listings where a degree is not required. 

SELECT 
    company_id,
    name as company_name
FROM 
    company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = true
    ORDER BY
        company_id
)

/*
Find the companies that have the most job openings.
- Get total number of job postings per compani id (job_posting_fact)
- Return the total number of jobs with the company name (company_dim)
*/


WITH company_job_count AS (
    SELECT 
        company_id,
        COUNT(*) as total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT 
    cd.name as company_name,
    cjc.total_jobs
FROM company_dim cd
LEFT JOIN company_job_count cjc on cjc.company_id = cd.company_id
ORDER BY
    total_jobs desc;