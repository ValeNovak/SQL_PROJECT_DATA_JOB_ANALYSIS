# Introduction

Dive into the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills and where high demand meets high salary in data analytics.

SQL queries? Check them out here: [project_sql folder](/4_project_sql/).

# Background
In December, I successfully completed an adult education program specializing in Database Administration, where I gained substantial knowledge of SQL and database management. To further solidify my understanding, I decided to follow Luke Barousse's tutorials, using his insights and analyses to deepen my practical SQL skills.

This project is a continuation of that learning journey, where I apply SQL queries to answer specific data-related questions. By working through these queries, I aim to reinforce my knowledge and improve my ability to extract meaningful insights from structured data.

### The questions I wanted to answer through my SQL queries were:

1. What are the to-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?


# Tools I Used

For this project, I chose **SQL** and **PostgreSQL** for efficient data querying and analysis, **Visual Studio Code** for a streamlined coding experience, and **Git & GitHub** for version control and collaboration—while I initially started learning databases using **MS SQL Server**.

# The Analysis

Here is how I approached each question:

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
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
LIMIT 10;
```
This analysis highlights the top 10 highest-paying remote Data Analyst positions. The roles are sorted by the average yearly salary, providing a snapshot of the best-paying opportunities.

Key Insights:
Highest Salary: The Data Analyst role at Mantys offers the highest salary of $650,000.
Top Companies: Companies like Meta, Pinterest, and AT&T offer high-paying positions, with salaries ranging from $184,000 to $336,500.
Remote Opportunities: All positions are remote, with full-time work schedules.

### 2. Top Paying Data Analyst Job Skills

To identify the top-paying remote Data Analyst roles, I used a Common Table Expression (CTE) to first select the highest-paying jobs based on average yearly salary. Then, I joined this data with the skills required for each role. This query not only highlights the best-paying positions but also lists the specific skills needed for each job.

```sql
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
    salary_year_avg DESC
```

The most in-demand skills for Data Analysts include SQL (8 mentions) and Python (7 mentions), emphasizing their essential role in data analysis. Tableau (6 mentions) stands out as a key tool for data visualization. R (4 mentions) continues to be valuable, particularly for statistical analysis. Tools related to cloud and big data, such as Snowflake (3 mentions) and Azure (2 mentions), are increasingly important. Despite the growing use of modern data tools, Excel (3 mentions) remains a fundamental skill for Data Analysts.

### 3. Top In-demand Data Analyst Skills

This query identifies the top 5 most in-demand skills for remote Data Analyst positions. It joins the job_postings_fact, skills_job_dim, and skills_dim tables to count how many times each skill is mentioned in job postings. The query filters for remote jobs (job_work_from_home = TRUE) and groups the results by skill, ordering them by demand (count of mentions) in descending order.

```sql
SELECT 
    skills,
    COUNT(sjd.job_id) as demand_count
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd on jpf.job_id =sjd.job_id
INNER JOIN skills_dim sd on sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

Here are the results for Data Analyst about the most in-demand skills.
We can clearly see that SQL is the most in-demand skill followed by excel and python.

![Top demanded skills](assets\Top_demanded_skills.png) 

*Results of SQL query above*

### 4. Top Paying Data Analyst skills

This query retrieves the top 25 highest-paying skills for remote Data Analyst roles. It calculates the average salary for each skill by joining job postings with the skills data. The results are ordered by average salary, highlighting the skills that are associated with the highest-paying remote Data Analyst positions.

```sql
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
```
Some skills pay much more than others. The highest-paying skill is **PySpark**, followed by **Bitbucket** and **Couchbase**. 
**Big Data** and **AI** skills lead to higher salaries. Tools like PySpark, which handle large amounts of data, and Watson, an AI tool, are in demand. 
DataRobot, another AI tool, also pays well. Not all skills are strictly about data analysis. Bitbucket, for example, is a tool for software development, showing that some companies prefer data analysts who understand coding and DevOps. 
In simple terms, learning Big Data tools like PySpark, AI tools like Watson and DataRobot, and database tools like Couchbase can help you get higher-paying jobs as a data analyst.

### 5. Optimal skill for Data Analyst

I used two different query approaches to demonstrate how the same insights can be derived in different ways. The first query uses **Common Table Expressions (CTEs)** to separately calculate skills demand and **average salary**,** then joins these results to identify the skills with **high demand** and **high salaries** for remote **Data Analyst** roles. The second query simplifies this by combining the logic into one query, calculating both demand and average salary in a more concise way. The goal was to identify skills in high demand that are associated with high average salaries for remote Data Analyst positions, providing insights into skills that offer job security due to demand and financial benefits due to high salaries, which can guide career development in data analysis.


```sql
WITH skills_demand AS(
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY 
    skills_dim.skill_id
), average_salary AS(
SELECT 
    skills_job_dim.skill_id,
    ROUND(AVG(salary_year_avg),0) as avg_salary
FROM job_postings_fact 
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills_job_dim.skill_id
)



SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary on skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;


-- rewriting the same query more concisely

SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.skill_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
High Demand & High Salary Skills: Python, Go, and R are top choices if you're looking for high demand and great salaries, especially in data-related fields.
Strong Job Market but Moderate Salary: Cloud computing skills like AWS, Azure, and Snowflake, along with business intelligence tools like Tableau, are in demand but offer moderate salaries in comparison to some high-demand languages.
Specialized Skills: Skills like Hadoop, Confluence, and SSIS/SSRS may be more niche but are valuable for specialized roles, especially in big data, cloud computing, and enterprise systems.
In terms of career development, if you're aiming for high-paying opportunities, Python, Go, and R should be your primary focus. For versatility, AWS, Azure, and Java remain crucial as well.


# What I Learned

Here is what I have learned:

- **Previous SQL Experience**:
I gained significant SQL knowledge while working with **MS SQL Server** during my **Database Administrator** program. This experience allowed me to learn and apply various SQL concepts, and now, I am focused on refining and perfecting these skills through this project and other advanced techniques.

- **PostgreSQL & Visual Studio Code**:
In this project, I expanded my SQL skills by working with PostgreSQL and Visual Studio Code, reinforcing basic concepts while delving into more advanced SQL topics.

- **Git & GitHub Familiarity**:
I also familiarized myself with Git and GitHub, tools essential for version control and collaboration in the development process.

- **Real-World Data Experience**:
This project provided hands-on experience with real-world data, allowing me to apply theoretical knowledge in a practical context.

- **Future Growth**:
I’m confident that this experience will not only enhance my technical skills but also provide opportunities to apply these skills in real-world scenarios. Moving forward, I look forward to continuing to build on this foundation and further advancing my expertise as a data analyst.

# Conclusions

This project not only enhanced my understanding of SQL but also provided valuable insights into the essential skills and requirements for a career as a **Data Analyst**. Through analyzing job postings, I was able to identify the most in-demand skills and the highest-paying roles in the industry. This experience also highlighted the **importance of mastering SQL**, **data visualization tools**, and other technologies like **Python**, R, and cloud platforms such as **Azure** or **Snowflake**. By learning what skills are valued by employers and understanding the job market trends, this project serves as a useful resource for anyone aspiring to enter the data analytics field. It provides a clear path on which skills to focus on to increase employability and secure high-paying roles, offering strategic insights for career development in data analysis.
