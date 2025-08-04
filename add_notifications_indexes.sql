-- Add indexes for Notifications table
-- MySQL doesn't support IF NOT EXISTS for CREATE INDEX
-- We'll use a procedure to check if indexes exist before creating them

USE school_db;

DELIMITER $$

CREATE PROCEDURE AddIndexesIfNotExist()
BEGIN
    DECLARE index_exists INT DEFAULT 0;
    
    -- Check and create idx_notification_type
    SELECT COUNT(*) INTO index_exists 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = 'school_db' 
    AND TABLE_NAME = 'Notifications' 
    AND INDEX_NAME = 'idx_notification_type';
    
    IF index_exists = 0 THEN
        CREATE INDEX idx_notification_type ON Notifications (notification_type);
    END IF;
    
    -- Check and create idx_target_class
    SELECT COUNT(*) INTO index_exists 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = 'school_db' 
    AND TABLE_NAME = 'Notifications' 
    AND INDEX_NAME = 'idx_target_class';
    
    IF index_exists = 0 THEN
        CREATE INDEX idx_target_class ON Notifications (target_class);
    END IF;
    
    -- Check and create idx_target_subject
    SELECT COUNT(*) INTO index_exists 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = 'school_db' 
    AND TABLE_NAME = 'Notifications' 
    AND INDEX_NAME = 'idx_target_subject';
    
    IF index_exists = 0 THEN
        CREATE INDEX idx_target_subject ON Notifications (target_subject_id);
    END IF;
    
    -- Check and create idx_active
    SELECT COUNT(*) INTO index_exists 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = 'school_db' 
    AND TABLE_NAME = 'Notifications' 
    AND INDEX_NAME = 'idx_active';
    
    IF index_exists = 0 THEN
        CREATE INDEX idx_active ON Notifications (is_active);
    END IF;
    
    -- Check and create idx_dates
    SELECT COUNT(*) INTO index_exists 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = 'school_db' 
    AND TABLE_NAME = 'Notifications' 
    AND INDEX_NAME = 'idx_dates';
    
    IF index_exists = 0 THEN
        CREATE INDEX idx_dates ON Notifications (start_date, end_date);
    END IF;
    
    -- Check and create idx_created_at
    SELECT COUNT(*) INTO index_exists 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = 'school_db' 
    AND TABLE_NAME = 'Notifications' 
    AND INDEX_NAME = 'idx_created_at';
    
    IF index_exists = 0 THEN
        CREATE INDEX idx_created_at ON Notifications (created_at);
    END IF;
    
END$$

DELIMITER ;

-- Execute the procedure
CALL AddIndexesIfNotExist();

-- Drop the procedure after use
DROP PROCEDURE AddIndexesIfNotExist;

-- Show all indexes on the Notifications table
SELECT 
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX,
    NON_UNIQUE
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = 'school_db' 
AND TABLE_NAME = 'Notifications'
ORDER BY INDEX_NAME, SEQ_IN_INDEX;

-- Show the final table structure
DESCRIBE Notifications;
