-- ============================================
-- EXPEDITION SYSTEM - MINIMALIST SCHEMA
-- KIV/WEB - Vědecká expedice do galaxie
-- ============================================

-- 1. ROLE (Číselník)
CREATE TABLE `ROLE` (
  `role_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) UNIQUE NOT NULL COMMENT 'Návštěvník, Vědec, Komandér, Admirál, SuperAdmin',
  `description` VARCHAR(255),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. USERS (Hlavní tabulka 1)
CREATE TABLE `USERS` (
  `user_id` INT AUTO_INCREMENT PRIMARY KEY,
  `login` VARCHAR(50) UNIQUE NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL COMMENT 'Bcrypt',
  `email` VARCHAR(100) UNIQUE NOT NULL,
  `first_name` VARCHAR(100),
  `last_name` VARCHAR(100),
  `specialty` VARCHAR(100) COMMENT 'Obor (Xenobiologie, atd.) - textový sloupec',
  `rank` VARCHAR(50) COMMENT 'Hodnost (Kapitán, atd.) - textový sloupec',
  `avatar_file` VARCHAR(255) NULL,
  `role_id` INT NOT NULL DEFAULT 5 COMMENT 'FK: Role',
  `is_blocked` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`role_id`) REFERENCES `ROLE` (`role_id`),
  INDEX idx_login (login),
  INDEX idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. EXPEDITIONS (Hlavní tabulka 2)
CREATE TABLE `EXPEDITIONS` (
  `expedition_id` INT AUTO_INCREMENT PRIMARY KEY,
  `mission_code` VARCHAR(20) UNIQUE NOT NULL COMMENT 'MISSION-001',
  `title` VARCHAR(200) NOT NULL,
  `description` TEXT,
  `target_system` VARCHAR(150) COMMENT 'Název systému (Kepler-452, atd.) - textový sloupec',
  `target_planet` VARCHAR(150) COMMENT 'Název planety - textový sloupec',
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  `lead_scientist_id` INT NOT NULL COMMENT 'FK: Vedoucí expedice',
  `pdf_file` VARCHAR(255) NULL COMMENT 'Plán mise',
  `status` ENUM('draft', 'pending_review', 'approved', 'active', 'completed', 'rejected') 
          NOT NULL DEFAULT 'draft',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`lead_scientist_id`) REFERENCES `USERS` (`user_id`) ON DELETE RESTRICT,
  INDEX idx_status (status),
  INDEX idx_mission_code (mission_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. DISCOVERIES (Hlavní tabulka 3)
CREATE TABLE `DISCOVERIES` (
  `discovery_id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(200) NOT NULL,
  `description` TEXT,
  `date_discovered` DATE NOT NULL,
  `planet_name` VARCHAR(150) COMMENT 'Název planety - textový sloupec',
  `discovery_type` VARCHAR(100) COMMENT 'Typ objevu (minerály, mikrobálie, atd.)',
  `discoverer_id` INT NOT NULL COMMENT 'FK: Kdo objev nahlásil',
  `expedition_id` INT NULL COMMENT 'FK: Ke které expedici patří',
  `photo_file` VARCHAR(255) NULL COMMENT 'Fotka/Polaroid',
  `status` ENUM('draft', 'submitted', 'under_review', 'approved', 'rejected') 
          NOT NULL DEFAULT 'draft',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`discoverer_id`) REFERENCES `USERS` (`user_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`expedition_id`) REFERENCES `EXPEDITIONS` (`expedition_id`) ON DELETE SET NULL,
  INDEX idx_status (status),
  INDEX idx_expedition_id (expedition_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. DISCOVERY_EVALUATIONS (Rozkladová tabulka M:N)
CREATE TABLE `DISCOVERY_EVALUATIONS` (
  `evaluation_id` INT AUTO_INCREMENT PRIMARY KEY,
  `discovery_id` INT NOT NULL COMMENT 'FK: Objev',
  `reviewer_id` INT NOT NULL COMMENT 'FK: Komandér (recenzent)',
  `danger_index` INT NOT NULL COMMENT 'Nebezpečí 1-5',
  `scientific_value` INT NOT NULL COMMENT 'Vědecký přínos 1-5',
  `sustainability_index` INT NOT NULL COMMENT 'Udržitelnost 1-5',
  `comment` TEXT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`discovery_id`) REFERENCES `DISCOVERIES` (`discovery_id`) ON DELETE CASCADE,
  FOREIGN KEY (`reviewer_id`) REFERENCES `USERS` (`user_id`) ON DELETE RESTRICT,
  UNIQUE KEY `unique_review` (`discovery_id`, `reviewer_id`),
  INDEX idx_reviewer_id (reviewer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- HOTOVO: 5 TABULEK, ČISTÉ A JEDNODUCHÉ
-- ============================================
