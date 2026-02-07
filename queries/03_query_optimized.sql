USE jobs_db;

-- Optimized with UNION subquery approach
-- Strategy: Find all matching job IDs first, then join only those jobs
SELECT
  Jobs.id AS `Jobs__id`,
  Jobs.name AS `Jobs__name`,
  Jobs.media_id AS `Jobs__media_id`,
  Jobs.job_category_id AS `Jobs__job_category_id`,
  Jobs.job_type_id AS `Jobs__job_type_id`,
  Jobs.description AS `Jobs__description`,
  Jobs.detail AS `Jobs__detail`,
  Jobs.business_skill AS `Jobs__business_skill`,
  Jobs.knowledge AS `Jobs__knowledge`,
  Jobs.location AS `Jobs__location`,
  Jobs.activity AS `Jobs__activity`,
  Jobs.academic_degree_doctor AS `Jobs__academic_degree_doctor`,
  Jobs.academic_degree_master AS `Jobs__academic_degree_master`,
  Jobs.academic_degree_professional AS `Jobs__academic_degree_professional`,
  Jobs.academic_degree_bachelor AS `Jobs__academic_degree_bachelor`,
  Jobs.salary_statistic_group AS `Jobs__salary_statistic_group`,
  Jobs.salary_range_first_year AS `Jobs__salary_range_first_year`,
  Jobs.salary_range_average AS `Jobs__salary_range_average`,
  Jobs.salary_range_remarks AS `Jobs__salary_range_remarks`,
  Jobs.restriction AS `Jobs__restriction`,
  Jobs.estimated_total_workers AS `Jobs__estimated_total_workers`,
  Jobs.remarks AS `Jobs__remarks`,
  Jobs.url AS `Jobs__url`,
  Jobs.seo_description AS `Jobs__seo_description`,
  Jobs.seo_keywords AS `Jobs__seo_keywords`,
  Jobs.sort_order AS `Jobs__sort_order`,
  Jobs.publish_status AS `Jobs__publish_status`,
  Jobs.version AS `Jobs__version`,
  Jobs.created_by AS `Jobs__created_by`,
  Jobs.created AS `Jobs__created`,
  Jobs.modified AS `Jobs__modified`,
  Jobs.deleted AS `Jobs__deleted`,

  JobCategories.id AS `JobCategories__id`,
  JobCategories.name AS `JobCategories__name`,
  JobCategories.sort_order AS `JobCategories__sort_order`,
  JobCategories.created_by AS `JobCategories__created_by`,
  JobCategories.created AS `JobCategories__created`,
  JobCategories.modified AS `JobCategories__modified`,
  JobCategories.deleted AS `JobCategories__deleted`,

  JobTypes.id AS `JobTypes__id`,
  JobTypes.name AS `JobTypes__name`,
  JobTypes.job_category_id AS `JobTypes__job_category_id`,
  JobTypes.sort_order AS `JobTypes__sort_order`,
  JobTypes.created_by AS `JobTypes__created_by`,
  JobTypes.created AS `JobTypes__created`,
  JobTypes.modified AS `JobTypes__modified`,
  JobTypes.deleted AS `JobTypes__deleted`
FROM jobs Jobs
INNER JOIN job_categories JobCategories
  ON JobCategories.id = Jobs.job_category_id
  AND JobCategories.deleted IS NULL
INNER JOIN job_types JobTypes
  ON JobTypes.id = Jobs.job_type_id
  AND JobTypes.deleted IS NULL
WHERE
  Jobs.publish_status = 1
  AND Jobs.deleted IS NULL
  AND Jobs.id IN (
    -- Find all job IDs that match any of the search criteria
    SELECT DISTINCT job_id FROM (
      -- Search in job_categories
      SELECT j.id as job_id
      FROM jobs j
      INNER JOIN job_categories jc ON jc.id = j.job_category_id
      WHERE jc.name LIKE '%キャビンアテンダント%' AND jc.deleted IS NULL
      
      UNION
      
      -- Search in job_types
      SELECT j.id as job_id
      FROM jobs j
      INNER JOIN job_types jt ON jt.id = j.job_type_id
      WHERE jt.name LIKE '%キャビンアテンダント%' AND jt.deleted IS NULL
      
      UNION
      
      -- Search in jobs table columns
      SELECT id as job_id
      FROM jobs
      WHERE name LIKE '%キャビンアテンダント%'
         OR description LIKE '%キャビンアテンダント%'
         OR detail LIKE '%キャビンアテンダント%'
         OR business_skill LIKE '%キャビンアテンダント%'
         OR knowledge LIKE '%キャビンアテンダント%'
         OR location LIKE '%キャビンアテンダント%'
         OR activity LIKE '%キャビンアテンダント%'
         OR salary_statistic_group LIKE '%キャビンアテンダント%'
         OR salary_range_remarks LIKE '%キャビンアテンダント%'
         OR restriction LIKE '%キャビンアテンダント%'
         OR remarks LIKE '%キャビンアテンダント%'
      
      UNION
      
      -- Search in personalities
      SELECT jp.job_id
      FROM jobs_personalities jp
      INNER JOIN personalities p ON p.id = jp.personality_id
      WHERE p.name LIKE '%キャビンアテンダント%' AND p.deleted IS NULL
      
      UNION
      
      -- Search in practical_skills
      SELECT jps.job_id
      FROM jobs_practical_skills jps
      INNER JOIN practical_skills ps ON ps.id = jps.practical_skill_id
      WHERE ps.name LIKE '%キャビンアテンダント%' AND ps.deleted IS NULL
      
      UNION
      
      -- Search in basic_abilities
      SELECT jba.job_id
      FROM jobs_basic_abilities jba
      INNER JOIN basic_abilities ba ON ba.id = jba.basic_ability_id
      WHERE ba.name LIKE '%キャビンアテンダント%' AND ba.deleted IS NULL
      
      UNION
      
      -- Search in tools (affiliates type 1)
      SELECT jt.job_id
      FROM jobs_tools jt
      INNER JOIN affiliates t ON t.id = jt.affiliate_id
      WHERE t.type = 1 AND t.name LIKE '%キャビンアテンダント%' AND t.deleted IS NULL
      
      UNION
      
      -- Search in career_paths (affiliates type 3)
      SELECT jcp.job_id
      FROM jobs_career_paths jcp
      INNER JOIN affiliates cp ON cp.id = jcp.affiliate_id
      WHERE cp.type = 3 AND cp.name LIKE '%キャビンアテンダント%' AND cp.deleted IS NULL
      
      UNION
      
      -- Search in rec_qualifications (affiliates type 2)
      SELECT jrq.job_id
      FROM jobs_rec_qualifications jrq
      INNER JOIN affiliates rq ON rq.id = jrq.affiliate_id
      WHERE rq.type = 2 AND rq.name LIKE '%キャビンアテンダント%' AND rq.deleted IS NULL
      
      UNION
      
      -- Search in req_qualifications (affiliates type 2)
      SELECT jreq.job_id
      FROM jobs_req_qualifications jreq
      INNER JOIN affiliates req ON req.id = jreq.affiliate_id
      WHERE req.type = 2 AND req.name LIKE '%キャビンアテンダント%' AND req.deleted IS NULL
    ) AS MatchingJobs
  )
ORDER BY Jobs.sort_order DESC, Jobs.id DESC
LIMIT 50 OFFSET 0;
