-- Script για ενημέρωση του πίνακα Notifications
-- Ελέγχει αν οι στήλες υπάρχουν πριν τις προσθέσει

USE school_db;

-- Προσθήκη στήλης notification_type αν δεν υπάρχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND COLUMN_NAME = 'notification_type') = 0,
    'ALTER TABLE Notifications ADD COLUMN notification_type ENUM(''general'', ''class'', ''subject'') DEFAULT ''general'' COMMENT ''Τύπος ανακοίνωσης'' AFTER content',
    'SELECT ''Column notification_type already exists'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Προσθήκη στήλης target_class αν δεν υπάρχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND COLUMN_NAME = 'target_class') = 0,
    'ALTER TABLE Notifications ADD COLUMN target_class VARCHAR(50) NULL COMMENT ''Στόχος τάξη (αν είναι class type)'' AFTER notification_type',
    'SELECT ''Column target_class already exists'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Προσθήκη στήλης target_subject_id αν δεν υπάρχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND COLUMN_NAME = 'target_subject_id') = 0,
    'ALTER TABLE Notifications ADD COLUMN target_subject_id INT NULL COMMENT ''Στόχος τμήμα/μάθημα (αν είναι subject type)'' AFTER target_class',
    'SELECT ''Column target_subject_id already exists'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Προσθήκη στήλης start_date αν δεν υπάρχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND COLUMN_NAME = 'start_date') = 0,
    'ALTER TABLE Notifications ADD COLUMN start_date DATE NULL COMMENT ''Ημερομηνία έναρξης εμφάνισης'' AFTER target_subject_id',
    'SELECT ''Column start_date already exists'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Προσθήκη στήλης end_date αν δεν υπάρχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND COLUMN_NAME = 'end_date') = 0,
    'ALTER TABLE Notifications ADD COLUMN end_date DATE NULL COMMENT ''Ημερομηνία λήξης εμφάνισης'' AFTER start_date',
    'SELECT ''Column end_date already exists'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Προσθήκη στήλης priority αν δεν υπάρχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND COLUMN_NAME = 'priority') = 0,
    'ALTER TABLE Notifications ADD COLUMN priority ENUM(''low'', ''normal'', ''high'', ''urgent'') DEFAULT ''normal'' COMMENT ''Προτεραιότητα ανακοίνωσης'' AFTER end_date',
    'SELECT ''Column priority already exists'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Προσθήκη στήλης is_active αν δεν υπάρχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND COLUMN_NAME = 'is_active') = 0,
    'ALTER TABLE Notifications ADD COLUMN is_active BOOLEAN DEFAULT TRUE COMMENT ''Κατάσταση ανακοίνωσης'' AFTER priority',
    'SELECT ''Column is_active already exists'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Ενημέρωση στήλης created_at για να έχει default τιμή CURRENT_TIMESTAMP αν δεν έχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND COLUMN_NAME = 'created_at'
     AND COLUMN_DEFAULT IS NULL) > 0,
    'ALTER TABLE Notifications MODIFY COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT ''Ημερομηνία δημιουργίας''',
    'SELECT ''Column created_at already has default value'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Προσθήκη Foreign Key για target_subject_id αν δεν υπάρχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND CONSTRAINT_NAME = 'fk_notifications_subject') = 0,
    'ALTER TABLE Notifications ADD CONSTRAINT fk_notifications_subject FOREIGN KEY (target_subject_id) REFERENCES Subjects(id) ON DELETE SET NULL',
    'SELECT ''Foreign key fk_notifications_subject already exists'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Προσθήκη Index για is_active αν δεν υπάρχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND INDEX_NAME = 'idx_active') = 0,
    'CREATE INDEX idx_active ON Notifications (is_active)',
    'SELECT ''Index idx_active already exists'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Προσθήκη Index για notification_type αν δεν υπάρχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND INDEX_NAME = 'idx_notification_type') = 0,
    'CREATE INDEX idx_notification_type ON Notifications (notification_type)',
    'SELECT ''Index idx_notification_type already exists'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Προσθήκη Index για target_class αν δεν υπάρχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND INDEX_NAME = 'idx_target_class') = 0,
    'CREATE INDEX idx_target_class ON Notifications (target_class)',
    'SELECT ''Index idx_target_class already exists'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Προσθήκη Index για date range αν δεν υπάρχει
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = 'school_db' 
     AND TABLE_NAME = 'Notifications' 
     AND INDEX_NAME = 'idx_date_range') = 0,
    'CREATE INDEX idx_date_range ON Notifications (start_date, end_date)',
    'SELECT ''Index idx_date_range already exists'' as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Εμφάνιση της τελικής δομής του πίνακα
DESCRIBE Notifications;

SELECT 'Notifications table updated successfully!' as result;
