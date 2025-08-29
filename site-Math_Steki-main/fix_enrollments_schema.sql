-- Fix the Classes table to match Subjects data
-- This will create Classes entries for each Subject so enrollments work properly

USE school_db;

-- First, let's see what's in Classes table
SELECT 'Current Classes data:' as info;
SELECT * FROM Classes;

-- Insert Classes entries to match each Subject
-- This creates a Class for each Subject with the same ID
INSERT IGNORE INTO Classes (class_id, class_name, course_id, teacher_id) 
SELECT 
    s.id as class_id,
    CONCAT(s.code, ' - ', s.name) as class_name,
    1 as course_id,  -- Default course_id
    s.teacherId as teacher_id
FROM Subjects s
WHERE s.id NOT IN (SELECT class_id FROM Classes WHERE class_id IS NOT NULL);

-- Show the updated Classes table
SELECT 'Updated Classes data:' as info;
SELECT * FROM Classes ORDER BY class_id;

-- Show the Subjects for reference
SELECT 'Subjects data for reference:' as info;
SELECT id, name, code, class as student_class, teacherId FROM Subjects ORDER BY id;

-- Verify that we can now create enrollments
SELECT 'Verification - Available class_ids in Classes:' as info;
SELECT DISTINCT class_id FROM Classes WHERE class_id IS NOT NULL ORDER BY class_id;

SELECT 'Verification - Subject IDs:' as info;
SELECT DISTINCT id FROM Subjects ORDER BY id;
