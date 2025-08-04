-- Fix Notifications table structure
-- Add missing columns for the enhanced announcement system

USE school_db;

-- First, let's check if columns exist and add them if they don't
-- MySQL doesn't support IF NOT EXISTS for ALTER TABLE ADD COLUMN directly
-- So we'll use a procedure to handle this

DELIMITER $$

CREATE PROCEDURE AddColumnIfNotExists()
BEGIN
    -- Check and add notification_type column
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'school_db' 
        AND TABLE_NAME = 'Notifications' 
        AND COLUMN_NAME = 'notification_type'
    ) THEN
        ALTER TABLE Notifications 
        ADD COLUMN notification_type ENUM('general', 'class', 'subject') DEFAULT 'general' 
        COMMENT 'Τύπος ανακοίνωσης' AFTER content;
    END IF;

    -- Check and add target_class column
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'school_db' 
        AND TABLE_NAME = 'Notifications' 
        AND COLUMN_NAME = 'target_class'
    ) THEN
        ALTER TABLE Notifications 
        ADD COLUMN target_class VARCHAR(50) NULL 
        COMMENT 'Στόχος τάξη (αν είναι class type)' AFTER notification_type;
    END IF;

    -- Check and add target_subject_id column
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'school_db' 
        AND TABLE_NAME = 'Notifications' 
        AND COLUMN_NAME = 'target_subject_id'
    ) THEN
        ALTER TABLE Notifications 
        ADD COLUMN target_subject_id INT NULL 
        COMMENT 'Στόχος τμήμα/μάθημα (αν είναι subject type)' AFTER target_class;
    END IF;

    -- Check and add start_date column
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'school_db' 
        AND TABLE_NAME = 'Notifications' 
        AND COLUMN_NAME = 'start_date'
    ) THEN
        ALTER TABLE Notifications 
        ADD COLUMN start_date DATE NULL 
        COMMENT 'Ημερομηνία έναρξης εμφάνισης' AFTER target_subject_id;
    END IF;

    -- Check and add end_date column
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'school_db' 
        AND TABLE_NAME = 'Notifications' 
        AND COLUMN_NAME = 'end_date'
    ) THEN
        ALTER TABLE Notifications 
        ADD COLUMN end_date DATE NULL 
        COMMENT 'Ημερομηνία λήξης εμφάνισης' AFTER start_date;
    END IF;

    -- Check and add priority column
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'school_db' 
        AND TABLE_NAME = 'Notifications' 
        AND COLUMN_NAME = 'priority'
    ) THEN
        ALTER TABLE Notifications 
        ADD COLUMN priority ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal' 
        COMMENT 'Προτεραιότητα ανακοίνωσης' AFTER end_date;
    END IF;

    -- Check and add is_active column
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'school_db' 
        AND TABLE_NAME = 'Notifications' 
        AND COLUMN_NAME = 'is_active'
    ) THEN
        ALTER TABLE Notifications 
        ADD COLUMN is_active BOOLEAN DEFAULT TRUE 
        COMMENT 'Ενεργή ανακοίνωση' AFTER priority;
    END IF;

    -- Check and add pdf_attachment column
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'school_db' 
        AND TABLE_NAME = 'Notifications' 
        AND COLUMN_NAME = 'pdf_attachment'
    ) THEN
        ALTER TABLE Notifications 
        ADD COLUMN pdf_attachment VARCHAR(255) NULL 
        COMMENT 'Διαδρομή αρχείου PDF' AFTER is_active;
    END IF;

    -- Check and add external_link column
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'school_db' 
        AND TABLE_NAME = 'Notifications' 
        AND COLUMN_NAME = 'external_link'
    ) THEN
        ALTER TABLE Notifications 
        ADD COLUMN external_link VARCHAR(500) NULL 
        COMMENT 'Εξωτερικός σύνδεσμος' AFTER pdf_attachment;
    END IF;

    -- Check and add updated_at column
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'school_db' 
        AND TABLE_NAME = 'Notifications' 
        AND COLUMN_NAME = 'updated_at'
    ) THEN
        ALTER TABLE Notifications 
        ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
        COMMENT 'Ημερομηνία τελευταίας ενημέρωσης' AFTER external_link;
    END IF;

END$$

DELIMITER ;

-- Execute the procedure
CALL AddColumnIfNotExists();

-- Drop the procedure after use
DROP PROCEDURE AddColumnIfNotExists;

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_notification_type ON Notifications (notification_type);
CREATE INDEX IF NOT EXISTS idx_target_class ON Notifications (target_class);
CREATE INDEX IF NOT EXISTS idx_target_subject ON Notifications (target_subject_id);
CREATE INDEX IF NOT EXISTS idx_active ON Notifications (is_active);
CREATE INDEX IF NOT EXISTS idx_dates ON Notifications (start_date, end_date);

-- Show the updated table structure
DESCRIBE Notifications;

-- Show sample of existing data to verify structure
SELECT * FROM Notifications LIMIT 3;
