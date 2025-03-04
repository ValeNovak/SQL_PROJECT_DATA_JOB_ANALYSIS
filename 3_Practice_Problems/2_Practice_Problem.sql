-- Identify the top 5 skills that are most frequently mentioned in job postings.

SELECT 
    skill_id,
    skills
FROM skills_dim
WHERE skill_id IN (
    SELECT 
        skill_id
    FROM 
        skills_job_dim
    GROUP BY 
        skill_id
    ORDER BY 
        COUNT(skill_id) DESC 
    LIMIT 5
);