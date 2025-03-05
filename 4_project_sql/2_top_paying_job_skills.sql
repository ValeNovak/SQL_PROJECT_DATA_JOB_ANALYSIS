/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
    helping job seekers understand which skills to develop that align with top salaries
    */




WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name as company_name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim sjd on top_paying_jobs.job_id =sjd.job_id
INNER JOIN skills_dim sd on sjd.skill_id = sd.skill_id
ORDER BY
    salary_year_avg DESC;

/*
SQL (8 mentions) and Python (7 mentions) are the most sought-after skills, reinforcing their importance for data analysts.
Tableau (6 mentions) is highly valued, highlighting the need for data visualization skills.
R (4 mentions) is still relevant, especially for statistical analysis roles.
Cloud and big data tools like Snowflake (3 mentions) and Azure (2 mentions) are gaining traction.
Excel (3 mentions) remains a core tool despite the rise of modern data tools.
*/