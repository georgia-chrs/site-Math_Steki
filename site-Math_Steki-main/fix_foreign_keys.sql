-- Fix foreign key constraints for Enrollments table
-- The Enrollments table should reference Subjects, not Classes

USE school_db;

-- First, drop the existing foreign key constraint
ALTER TABLE Enrollments DROP FOREIGN KEY Enrollments_ibfk_2;

-- Add the correct foreign key constraint to reference Subjects table
ALTER TABLE Enrollments 
ADD CONSTRAINT Enrollments_ibfk_2 
FOREIGN KEY (class_id) REFERENCES Subjects(id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- Verify the change
SHOW CREATE TABLE Enrollments;

-- Also ensure the Teachers foreign key is correct
ALTER TABLE Subjects DROP FOREIGN KEY IF EXISTS Subjects_ibfk_1;
ALTER TABLE Subjects 
ADD CONSTRAINT Subjects_ibfk_1 
FOREIGN KEY (teacherId) REFERENCES Teachers(id) 
ON DELETE SET NULL ON UPDATE CASCADE;

-- Verify the Subjects table
SHOW CREATE TABLE Subjects;

SELECT 'Foreign key constraints fixed successfully!' as message;
