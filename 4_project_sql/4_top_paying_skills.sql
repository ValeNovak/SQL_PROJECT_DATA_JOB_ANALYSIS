/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and 
    helps identify the most financially rewarding skills to acquire or improve
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) as avg_salary
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd on jpf.job_id =sjd.job_id
INNER JOIN skills_dim sd on sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;

/*
Some skills pay much more than others. The highest-paying skill is PySpark, followed by Bitbucket and Couchbase. 
Big Data and AI skills lead to higher salaries. Tools like PySpark, which handle large amounts of data, and Watson, an AI tool, are in demand. 
DataRobot, another AI tool, also pays well. Not all skills are strictly about data analysis. Bitbucket, for example, is a tool for software development, showing that some companies prefer data analysts who understand coding and DevOps. 
In simple terms, learning Big Data tools like PySpark, AI tools like Watson and DataRobot, and database tools like Couchbase can help you get higher-paying jobs as a data analyst.
*/