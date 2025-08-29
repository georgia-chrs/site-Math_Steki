-- Script για διόρθωση κωδικών πρόσβασης
-- Εκτελέστε αυτό το script για να διορθώσετε τους κωδικούς

USE school_db;

-- Ενημέρωση κωδικών με απλούς κωδικούς για δοκιμή
-- Όλοι οι κωδικοί θα είναι "123456"

-- Hash για κωδικό "123456" (bcrypt με 10 rounds)
SET @password_hash = '$2b$10$Jgugq7famjoLDGhsGxum9u/LYPhd6MpDoPkLUlpKsDHCYJ3SoiPcK';

-- Ενημέρωση Admins
UPDATE Admins SET password_hash = @password_hash WHERE username = 'admin';
UPDATE Admins SET password_hash = @password_hash WHERE username = 'mariaio';

-- Ενημέρωση Students  
UPDATE Students SET password_hash = @password_hash WHERE username = 'mariaio';
UPDATE Students SET password_hash = @password_hash WHERE username = 'giannisp';
UPDATE Students SET password_hash = @password_hash WHERE username = 'kostasd';

-- Επιβεβαίωση αλλαγών
SELECT 'Κωδικοί ενημερώθηκαν επιτυχώς!' AS Status;

-- Προβολή όλων των χρηστών για επιβεβαίωση
SELECT 'ADMINS' AS Type, username, 'Κωδικός: 123456' AS Password FROM Admins
UNION ALL
SELECT 'STUDENTS' AS Type, username, 'Κωδικός: 123456' AS Password FROM Students
ORDER BY Type, username;
