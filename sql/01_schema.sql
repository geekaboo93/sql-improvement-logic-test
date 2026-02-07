CREATE DATABASE IF NOT EXISTS jobs_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE jobs_db;

CREATE TABLE job_categories (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_by BIGINT UNSIGNED NULL,
  created DATETIME NULL,
  modified DATETIME NULL,
  deleted DATETIME NULL
) ENGINE=InnoDB;

CREATE TABLE job_types (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  job_category_id BIGINT UNSIGNED NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_by BIGINT UNSIGNED NULL,
  created DATETIME NULL,
  modified DATETIME NULL,
  deleted DATETIME NULL,
  CONSTRAINT fk_job_types_category
    FOREIGN KEY (job_category_id) REFERENCES job_categories(id)
) ENGINE=InnoDB;

CREATE TABLE jobs (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  media_id BIGINT UNSIGNED NULL,
  job_category_id BIGINT UNSIGNED NOT NULL,
  job_type_id BIGINT UNSIGNED NOT NULL,
  description TEXT NULL,
  detail TEXT NULL,
  business_skill TEXT NULL,
  knowledge TEXT NULL,
  location TEXT NULL,
  activity TEXT NULL,
  academic_degree_doctor TINYINT(1) NOT NULL DEFAULT 0,
  academic_degree_master TINYINT(1) NOT NULL DEFAULT 0,
  academic_degree_professional TINYINT(1) NOT NULL DEFAULT 0,
  academic_degree_bachelor TINYINT(1) NOT NULL DEFAULT 0,
  salary_statistic_group VARCHAR(255) NULL,
  salary_range_first_year INT NULL,
  salary_range_average INT NULL,
  salary_range_remarks TEXT NULL,
  restriction TEXT NULL,
  estimated_total_workers INT NULL,
  remarks TEXT NULL,
  url VARCHAR(512) NULL,
  seo_description TEXT NULL,
  seo_keywords TEXT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  publish_status TINYINT(1) NOT NULL DEFAULT 0,
  version INT NOT NULL DEFAULT 1,
  created_by BIGINT UNSIGNED NULL,
  created DATETIME NULL,
  modified DATETIME NULL,
  deleted DATETIME NULL,
  CONSTRAINT fk_jobs_category
    FOREIGN KEY (job_category_id) REFERENCES job_categories(id),
  CONSTRAINT fk_jobs_type
    FOREIGN KEY (job_type_id) REFERENCES job_types(id)
) ENGINE=InnoDB;

CREATE TABLE personalities (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  deleted DATETIME NULL
) ENGINE=InnoDB;

CREATE TABLE practical_skills (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  deleted DATETIME NULL
) ENGINE=InnoDB;

CREATE TABLE basic_abilities (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  deleted DATETIME NULL
) ENGINE=InnoDB;

CREATE TABLE affiliates (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  type TINYINT NOT NULL,
  name VARCHAR(255) NOT NULL,
  deleted DATETIME NULL
) ENGINE=InnoDB;

CREATE TABLE jobs_personalities (
  job_id BIGINT UNSIGNED NOT NULL,
  personality_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (job_id, personality_id),
  CONSTRAINT fk_jp_job FOREIGN KEY (job_id) REFERENCES jobs(id),
  CONSTRAINT fk_jp_personality FOREIGN KEY (personality_id) REFERENCES personalities(id)
) ENGINE=InnoDB;

CREATE TABLE jobs_practical_skills (
  job_id BIGINT UNSIGNED NOT NULL,
  practical_skill_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (job_id, practical_skill_id),
  CONSTRAINT fk_jps_job FOREIGN KEY (job_id) REFERENCES jobs(id),
  CONSTRAINT fk_jps_skill FOREIGN KEY (practical_skill_id) REFERENCES practical_skills(id)
) ENGINE=InnoDB;

CREATE TABLE jobs_basic_abilities (
  job_id BIGINT UNSIGNED NOT NULL,
  basic_ability_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (job_id, basic_ability_id),
  CONSTRAINT fk_jba_job FOREIGN KEY (job_id) REFERENCES jobs(id),
  CONSTRAINT fk_jba_ability FOREIGN KEY (basic_ability_id) REFERENCES basic_abilities(id)
) ENGINE=InnoDB;

CREATE TABLE jobs_tools (
  job_id BIGINT UNSIGNED NOT NULL,
  affiliate_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (job_id, affiliate_id),
  CONSTRAINT fk_jt_job FOREIGN KEY (job_id) REFERENCES jobs(id),
  CONSTRAINT fk_jt_affiliate FOREIGN KEY (affiliate_id) REFERENCES affiliates(id)
) ENGINE=InnoDB;

CREATE TABLE jobs_career_paths (
  job_id BIGINT UNSIGNED NOT NULL,
  affiliate_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (job_id, affiliate_id),
  CONSTRAINT fk_jcp_job FOREIGN KEY (job_id) REFERENCES jobs(id),
  CONSTRAINT fk_jcp_affiliate FOREIGN KEY (affiliate_id) REFERENCES affiliates(id)
) ENGINE=InnoDB;

CREATE TABLE jobs_rec_qualifications (
  job_id BIGINT UNSIGNED NOT NULL,
  affiliate_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (job_id, affiliate_id),
  CONSTRAINT fk_jrq_job FOREIGN KEY (job_id) REFERENCES jobs(id),
  CONSTRAINT fk_jrq_affiliate FOREIGN KEY (affiliate_id) REFERENCES affiliates(id)
) ENGINE=InnoDB;

CREATE TABLE jobs_req_qualifications (
  job_id BIGINT UNSIGNED NOT NULL,
  affiliate_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (job_id, affiliate_id),
  CONSTRAINT fk_jreq_job FOREIGN KEY (job_id) REFERENCES jobs(id),
  CONSTRAINT fk_jreq_affiliate FOREIGN KEY (affiliate_id) REFERENCES affiliates(id)
) ENGINE=InnoDB;

CREATE INDEX idx_jobs_publish_deleted ON jobs (publish_status, deleted);
CREATE INDEX idx_jobs_sort ON jobs (sort_order, id);
CREATE INDEX idx_affiliates_type ON affiliates (type, deleted);
