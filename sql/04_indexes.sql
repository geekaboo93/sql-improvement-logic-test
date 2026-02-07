USE jobs_db;

-- publish_status + deleted are always filtered; sort_order + id are used for ORDER BY
CREATE INDEX idx_jobs_publish_deleted_sort ON jobs (publish_status, deleted, sort_order, id);

-- Join paths from jobs to category/type
CREATE INDEX idx_jobs_category ON jobs (job_category_id);
CREATE INDEX idx_jobs_type ON jobs (job_type_id);

-- Filter out deleted categories/types quickly
CREATE INDEX idx_job_categories_deleted ON job_categories (deleted, id);
CREATE INDEX idx_job_types_deleted ON job_types (deleted, id);

-- Link tables: speed up EXISTS checks by job_id
CREATE INDEX idx_jobs_personalities_job ON jobs_personalities (job_id, personality_id);
CREATE INDEX idx_jobs_practical_skills_job ON jobs_practical_skills (job_id, practical_skill_id);
CREATE INDEX idx_jobs_basic_abilities_job ON jobs_basic_abilities (job_id, basic_ability_id);
CREATE INDEX idx_jobs_tools_job ON jobs_tools (job_id, affiliate_id);
CREATE INDEX idx_jobs_career_paths_job ON jobs_career_paths (job_id, affiliate_id);
CREATE INDEX idx_jobs_rec_qualifications_job ON jobs_rec_qualifications (job_id, affiliate_id);
CREATE INDEX idx_jobs_req_qualifications_job ON jobs_req_qualifications (job_id, affiliate_id);

-- Lookup tables: filter by deleted/type when resolving names in EXISTS
CREATE INDEX idx_personalities_deleted ON personalities (deleted, id);
CREATE INDEX idx_practical_skills_deleted ON practical_skills (deleted, id);
CREATE INDEX idx_basic_abilities_deleted ON basic_abilities (deleted, id);
CREATE INDEX idx_affiliates_type_deleted ON affiliates (type, deleted, id);
