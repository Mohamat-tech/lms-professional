-- ============================================
-- LMS PROFESSIONAL - DATABASE SCHEMA
-- Développé par NDAOBA MOHAMAT 24G2687
-- ============================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `email` VARCHAR(255) UNIQUE NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `firstName` VARCHAR(100) NOT NULL,
  `lastName` VARCHAR(100) NOT NULL,
  `role` ENUM('student', 'professor', 'admin') NOT NULL DEFAULT 'student',
  `status` ENUM('active', 'inactive', 'suspended') NOT NULL DEFAULT 'active',
  `profilePicture` VARCHAR(255),
  `bio` TEXT,
  `phone` VARCHAR(20),
  `address` TEXT,
  `dateOfBirth` DATE,
  `academicEmail` VARCHAR(255),
  `matricule` VARCHAR(50) UNIQUE,
  `filiere` VARCHAR(100),
  `level` ENUM('L1', 'L2', 'L3', 'M1', 'M2') DEFAULT 'L1',
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `lastLogin` DATETIME,
  INDEX idx_email (email),
  INDEX idx_role (role),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- COURSES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `courses` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `description` LONGTEXT,
  `code` VARCHAR(50) UNIQUE NOT NULL,
  `professorId` INT NOT NULL,
  `filiere` VARCHAR(100),
  `level` ENUM('L1', 'L2', 'L3', 'M1', 'M2'),
  `capacity` INT DEFAULT 50,
  `status` ENUM('draft', 'published', 'archived') DEFAULT 'draft',
  `coverImage` VARCHAR(255),
  `syllabus` LONGTEXT,
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (professorId) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_professor (professorId),
  INDEX idx_status (status),
  INDEX idx_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- COURSE CONTENT TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `courseContent` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `courseId` INT NOT NULL,
  `type` ENUM('lecture', 'pdf', 'video', 'quiz', 'assignment') NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` LONGTEXT,
  `contentUrl` VARCHAR(255),
  `filePath` VARCHAR(255),
  `order` INT,
  `isVisible` BOOLEAN DEFAULT TRUE,
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (courseId) REFERENCES courses(id) ON DELETE CASCADE,
  INDEX idx_course (courseId),
  INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- COURSE ENROLLMENT TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `courseEnrollments` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `courseId` INT NOT NULL,
  `studentId` INT NOT NULL,
  `enrollmentDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `completionDate` DATETIME,
  `status` ENUM('enrolled', 'completed', 'dropped') DEFAULT 'enrolled',
  `progressPercentage` DECIMAL(5,2) DEFAULT 0,
  UNIQUE KEY unique_enrollment (courseId, studentId),
  FOREIGN KEY (courseId) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (studentId) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_student (studentId),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- ASSIGNMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `assignments` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `courseId` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` LONGTEXT,
  `dueDate` DATETIME NOT NULL,
  `maxScore` DECIMAL(5,2) DEFAULT 100,
  `allowLateSubmission` BOOLEAN DEFAULT FALSE,
  `status` ENUM('draft', 'published', 'closed') DEFAULT 'draft',
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (courseId) REFERENCES courses(id) ON DELETE CASCADE,
  INDEX idx_course (courseId),
  INDEX idx_dueDate (dueDate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- SUBMISSIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `submissions` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `assignmentId` INT NOT NULL,
  `studentId` INT NOT NULL,
  `filePath` VARCHAR(255),
  `fileOriginalName` VARCHAR(255),
  `submissionText` LONGTEXT,
  `submissionDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('draft', 'submitted', 'graded') DEFAULT 'submitted',
  `score` DECIMAL(5,2),
  `feedback` LONGTEXT,
  `aiCorrectionNotes` LONGTEXT,
  UNIQUE KEY unique_submission (assignmentId, studentId),
  FOREIGN KEY (assignmentId) REFERENCES assignments(id) ON DELETE CASCADE,
  FOREIGN KEY (studentId) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_student (studentId),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- GRADES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `grades` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `courseId` INT NOT NULL,
  `studentId` INT NOT NULL,
  `score` DECIMAL(5,2),
  `percentage` DECIMAL(5,2),
  `grade` ENUM('A', 'B', 'C', 'D', 'F') COMMENT 'Letter grade',
  `competencies` JSON COMMENT 'Competency percentages as JSON',
  `recordDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `recordedBy` INT,
  UNIQUE KEY unique_grade (courseId, studentId),
  FOREIGN KEY (courseId) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (studentId) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (recordedBy) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_student (studentId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- COMPETENCIES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `competencies` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `category` VARCHAR(100),
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- STUDENT COMPETENCY PROGRESS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `studentCompetencyProgress` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `studentId` INT NOT NULL,
  `competencyId` INT NOT NULL,
  `percentageAchieved` DECIMAL(5,2) DEFAULT 0,
  `lastUpdated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY unique_progress (studentId, competencyId),
  FOREIGN KEY (studentId) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (competencyId) REFERENCES competencies(id) ON DELETE CASCADE,
  INDEX idx_student (studentId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- GROUP STUDY SESSIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `groupStudySessions` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `courseId` INT,
  `creatorId` INT NOT NULL,
  `scheduledDate` DATETIME,
  `maxMembers` INT DEFAULT 5,
  `status` ENUM('scheduled', 'ongoing', 'completed', 'cancelled') DEFAULT 'scheduled',
  `meetingLink` VARCHAR(255),
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (courseId) REFERENCES courses(id) ON DELETE SET NULL,
  FOREIGN KEY (creatorId) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- GROUP STUDY MEMBERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `groupStudyMembers` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `sessionId` INT NOT NULL,
  `userId` INT NOT NULL,
  `joinDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('joined', 'left') DEFAULT 'joined',
  UNIQUE KEY unique_member (sessionId, userId),
  FOREIGN KEY (sessionId) REFERENCES groupStudySessions(id) ON DELETE CASCADE,
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_session (sessionId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- LIVE SESSIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `liveSessions` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `courseId` INT NOT NULL,
  `professorId` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `scheduledStart` DATETIME NOT NULL,
  `actualStart` DATETIME,
  `actualEnd` DATETIME,
  `status` ENUM('scheduled', 'live', 'completed', 'cancelled') DEFAULT 'scheduled',
  `recordingUrl` VARCHAR(255),
  `maxParticipants` INT,
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (courseId) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (professorId) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_course (courseId),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- LIVE SESSION PARTICIPANTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `liveSessionParticipants` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `sessionId` INT NOT NULL,
  `userId` INT NOT NULL,
  `joinTime` DATETIME,
  `leaveTime` DATETIME,
  `attendanceStatus` ENUM('attended', 'missed', 'excused') DEFAULT 'attended',
  UNIQUE KEY unique_participant (sessionId, userId),
  FOREIGN KEY (sessionId) REFERENCES liveSessions(id) ON DELETE CASCADE,
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_session (sessionId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- NOTIFICATIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `userId` INT NOT NULL,
  `type` VARCHAR(50),
  `title` VARCHAR(255),
  `message` LONGTEXT,
  `relatedId` INT,
  `isRead` BOOLEAN DEFAULT FALSE,
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (userId),
  INDEX idx_isRead (isRead)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- AUDIT LOG TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `auditLog` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `userId` INT,
  `action` VARCHAR(100),
  `resourceType` VARCHAR(50),
  `resourceId` INT,
  `details` JSON,
  `ipAddress` VARCHAR(45),
  `userAgent` VARCHAR(255),
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_user (userId),
  INDEX idx_action (action)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- INSERT INITIAL COMPETENCIES
-- ============================================

INSERT INTO `competencies` (name, description, category) VALUES
('Python Programming', 'Ability to write Python code', 'Programming'),
('Web Development', 'Frontend and Backend web development skills', 'Web'),
('Database Design', 'Database modeling and SQL expertise', 'Database'),
('Problem Solving', 'Logical problem-solving abilities', 'Soft Skills'),
('Communication', 'Effective communication skills', 'Soft Skills'),
('Project Management', 'Planning and executing projects', 'Management'),
('Cloud Services', 'AWS, Google Cloud, Azure knowledge', 'Cloud'),
('Data Analysis', 'Data analytics and visualization', 'Analytics');

COMMIT;
