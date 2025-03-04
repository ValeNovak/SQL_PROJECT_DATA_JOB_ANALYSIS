/* 
Find the count of the number of remote job postings per skill
    - Display the top 5 skill by their demand in remote jobs
    - Include skill ID, name and count of postings requirinf the skill
*/


WITH remote_job_skills AS(
    SELECT
        skill_id,
        COUNT(*) as skill_count
    FROM 
        skills_job_dim as skills_to_job
    INNER JOIN job_postings_fact as job_postings on skills_to_job.job_id = job_postings.job_id
    WHERE
        job_postings.job_work_from_home = True
        AND job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    skills.skill_id,
    skills as skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills on skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;
