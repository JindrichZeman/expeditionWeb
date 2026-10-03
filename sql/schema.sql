-- ============================================
-- EXPEDITION SYSTEM - DATABASE SCHEMA
-- Vědecká expedice do vzdálené galaxie
-- ============================================

-- 1. ROLE (Uživatelské role)
CREATE TABLE `ROLE` (
  `role_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) UNIQUE NOT NULL COMMENT 'SuperAdmin, Admirál, Komandér, Vědec, Návštěvník',
  `description` VARCHAR(255),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. SPECIALTY (Vědecké obory)
CREATE TABLE `SPECIALTY` (
  `specialty_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) UNIQUE NOT NULL COMMENT 'Xenobiologie, Planetologie, atd.',
  `description` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. RANK (Vědecké hodnosti)
CREATE TABLE `RANK` (
  `rank_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) UNIQUE NOT NULL COMMENT 'Kapitán, Vědecký asistent, atd.',
  `level` INT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. USERS (Uživatelé s autentizací)
CREATE TABLE `USERS` (
  `user_id` INT AUTO_INCREMENT PRIMARY KEY,
  `login` VARCHAR(50) UNIQUE NOT NULL COMMENT 'Přihlašovací jméno',
  `password_hash` VARCHAR(255) NOT NULL COMMENT 'Bcrypt hash',
  `email` VARCHAR(100) UNIQUE NOT NULL,
  `first_name` VARCHAR(100),
  `last_name` VARCHAR(100),
  `birth_date` DATE NULL,
  `role_id` INT NOT NULL DEFAULT 5 COMMENT 'FK: Role (default Návštěvník)',
  `rank_id` INT NULL COMMENT 'FK: Vědecká hodnost',
  `specialty_id` INT NULL COMMENT 'FK: Obor specialisty',
  `avatar_file` VARCHAR(255) NULL COMMENT 'Cesta k avataru',
  `is_blocked` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`role_id`) REFERENCES `ROLE` (`role_id`),
  FOREIGN KEY (`rank_id`) REFERENCES `RANK` (`rank_id`),
  FOREIGN KEY (`specialty_id`) REFERENCES `SPECIALTY` (`specialty_id`),
  INDEX idx_login (login),
  INDEX idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. PLANETARY_SYSTEM (Planetární systémy)
CREATE TABLE `PLANETARY_SYSTEM` (
  `system_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) UNIQUE NOT NULL COMMENT 'Název systému',
  `distance_light_years` DECIMAL(10, 2) NULL,
  `description` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. PLANET (Planety)
CREATE TABLE `PLANET` (
  `planet_id` INT AUTO_INCREMENT PRIMARY KEY,
  `designation` VARCHAR(50) NOT NULL COMMENT 'Oficální označení (např. Kepler-452b)',
  `name` VARCHAR(150) COMMENT 'Populární název',
  `system_id` INT NOT NULL COMMENT 'FK: Planetární systém',
  `planet_type` VARCHAR(50) COMMENT 'terrestrial, gas_giant, ice_giant, atd.',
  `diameter_km` INT NULL,
  `has_atmosphere` TINYINT(1) DEFAULT 0,
  `description` TEXT,
  `image_path` VARCHAR(255) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`system_id`) REFERENCES `PLANETARY_SYSTEM` (`system_id`) ON DELETE RESTRICT,
  INDEX idx_system_id (system_id),
  UNIQUE KEY unique_designation (designation)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. EXPEDITION (Expedice/Mise)
CREATE TABLE `EXPEDITION` (
  `expedition_id` INT AUTO_INCREMENT PRIMARY KEY,
  `mission_code` VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kód mise (MISSION-001)',
  `title` VARCHAR(200) NOT NULL COMMENT 'Název expedice',
  `description` TEXT COMMENT 'Podrobný popis a cíle',
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL COMMENT 'NULL = mise probíhá',
  `target_system_id` INT NOT NULL COMMENT 'FK: Cílový systém',
  `lead_scientist_id` INT NOT NULL COMMENT 'FK: Vedoucí expedice (User)',
  `pdf_file` VARCHAR(255) NULL COMMENT 'Upload: Plán mise',
  `status` ENUM('draft', 'pending_review', 'approved', 'active', 'completed', 'rejected') 
          NOT NULL DEFAULT 'draft',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`target_system_id`) REFERENCES `PLANETARY_SYSTEM` (`system_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`lead_scientist_id`) REFERENCES `USERS` (`user_id`) ON DELETE RESTRICT,
  INDEX idx_status (status),
  INDEX idx_mission_code (mission_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. EXPEDITION_MEMBER (Členové expedice - M:N)
CREATE TABLE `EXPEDITION_MEMBER` (
  `expedition_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `role_in_expedition` VARCHAR(100) COMMENT 'Pozice v expedici (Vedoucí, Asistent)',
  `joined_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`expedition_id`, `user_id`),
  FOREIGN KEY (`expedition_id`) REFERENCES `EXPEDITION` (`expedition_id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `USERS` (`user_id`) ON DELETE CASCADE,
  INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. DISCOVERY (Vědecké objevy)
CREATE TABLE `DISCOVERY` (
  `discovery_id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(200) NOT NULL COMMENT 'Název objevu',
  `description` TEXT COMMENT 'Detailní popis',
  `date_discovered` DATE NOT NULL,
  `planet_id` INT NOT NULL COMMENT 'FK: Na které planetě',
  `discoverer_id` INT NOT NULL COMMENT 'FK: Kdo objev nahlásil',
  `expedition_id` INT NULL COMMENT 'FK: Volitelně ke které expedici',
  `photo_file` VARCHAR(255) NULL COMMENT 'Upload: Fotka/Polaroid',
  `status` ENUM('draft', 'submitted', 'under_review', 'approved', 'rejected') 
          NOT NULL DEFAULT 'draft',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`planet_id`) REFERENCES `PLANET` (`planet_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`discoverer_id`) REFERENCES `USERS` (`user_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`expedition_id`) REFERENCES `EXPEDITION` (`expedition_id`) ON DELETE SET NULL,
  INDEX idx_status (status),
  INDEX idx_planet_id (planet_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10. DISCOVERY_EVALUATION (Recenzní hodnocení - 3 kritéria)
CREATE TABLE `DISCOVERY_EVALUATION` (
  `evaluation_id` INT AUTO_INCREMENT PRIMARY KEY,
  `discovery_id` INT NOT NULL COMMENT 'FK: Kterého objevu',
  `reviewer_id` INT NOT NULL COMMENT 'FK: Komandér/recenzent',
  `danger_index` INT NOT NULL COMMENT 'Nebezpečí 1-5',
  `scientific_value` INT NOT NULL COMMENT 'Vědecký přínos 1-5',
  `sustainability_index` INT NOT NULL COMMENT 'Udržitelnost 1-5',
  `comment` TEXT COMMENT 'Poznámky recenzenta',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`discovery_id`) REFERENCES `DISCOVERY` (`discovery_id`) ON DELETE CASCADE,
  FOREIGN KEY (`reviewer_id`) REFERENCES `USERS` (`user_id`) ON DELETE RESTRICT,
  UNIQUE KEY `unique_review` (`discovery_id`, `reviewer_id`),
  INDEX idx_reviewer_id (reviewer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- KONEC SCHÉMATU
-- ============================================
