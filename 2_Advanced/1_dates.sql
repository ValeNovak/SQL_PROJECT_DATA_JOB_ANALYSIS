SELECT
    job_title_short as title,
    job_location as location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' as date_time,
    EXTRACT(MONTH FROM job_posted_date),
    EXTRACT(YEAR FROM job_posted_date)
FROM job_postings_fact
LIMIT 5;

SELECT
    count(job_id) as job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) as month 
FROM 
    job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY month
ORDER BY job_posted_count DESC;