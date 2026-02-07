USE jobs_db_indexed;

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
  AND (
    JobCategories.name LIKE '%キャビンアテンダント%'
    OR JobTypes.name LIKE '%キャビンアテンダント%'
    OR Jobs.name LIKE '%キャビンアテンダント%'
    OR Jobs.description LIKE '%キャビンアテンダント%'
    OR Jobs.detail LIKE '%キャビンアテンダント%'
    OR Jobs.business_skill LIKE '%キャビンアテンダント%'
    OR Jobs.knowledge LIKE '%キャビンアテンダント%'
    OR Jobs.location LIKE '%キャビンアテンダント%'
    OR Jobs.activity LIKE '%キャビンアテンダント%'
    OR Jobs.salary_statistic_group LIKE '%キャビンアテンダント%'
    OR Jobs.salary_range_remarks LIKE '%キャビンアテンダント%'
    OR Jobs.restriction LIKE '%キャビンアテンダント%'
    OR Jobs.remarks LIKE '%キャビンアテンダント%'
    OR EXISTS (
      SELECT 1
      FROM jobs_personalities JP
      INNER JOIN personalities P
        ON P.id = JP.personality_id
        AND P.deleted IS NULL
      WHERE JP.job_id = Jobs.id
        AND P.name LIKE '%キャビンアテンダント%'
    )
    OR EXISTS (
      SELECT 1
      FROM jobs_practical_skills JPS
      INNER JOIN practical_skills PS
        ON PS.id = JPS.practical_skill_id
        AND PS.deleted IS NULL
      WHERE JPS.job_id = Jobs.id
        AND PS.name LIKE '%キャビンアテンダント%'
    )
    OR EXISTS (
      SELECT 1
      FROM jobs_basic_abilities JBA
      INNER JOIN basic_abilities BA
        ON BA.id = JBA.basic_ability_id
        AND BA.deleted IS NULL
      WHERE JBA.job_id = Jobs.id
        AND BA.name LIKE '%キャビンアテンダント%'
    )
    OR EXISTS (
      SELECT 1
      FROM jobs_tools JT
      INNER JOIN affiliates T
        ON T.id = JT.affiliate_id
        AND T.type = 1
        AND T.deleted IS NULL
      WHERE JT.job_id = Jobs.id
        AND T.name LIKE '%キャビンアテンダント%'
    )
    OR EXISTS (
      SELECT 1
      FROM jobs_career_paths JCP
      INNER JOIN affiliates CP
        ON CP.id = JCP.affiliate_id
        AND CP.type = 3
        AND CP.deleted IS NULL
      WHERE JCP.job_id = Jobs.id
        AND CP.name LIKE '%キャビンアテンダント%'
    )
    OR EXISTS (
      SELECT 1
      FROM jobs_rec_qualifications JRQ
      INNER JOIN affiliates RQ
        ON RQ.id = JRQ.affiliate_id
        AND RQ.type = 2
        AND RQ.deleted IS NULL
      WHERE JRQ.job_id = Jobs.id
        AND RQ.name LIKE '%キャビンアテンダント%'
    )
    OR EXISTS (
      SELECT 1
      FROM jobs_req_qualifications JREQ
      INNER JOIN affiliates REQ
        ON REQ.id = JREQ.affiliate_id
        AND REQ.type = 2
        AND REQ.deleted IS NULL
      WHERE JREQ.job_id = Jobs.id
        AND REQ.name LIKE '%キャビンアテンダント%'
    )
  )
ORDER BY Jobs.sort_order DESC, Jobs.id DESC
LIMIT 50 OFFSET 0;
