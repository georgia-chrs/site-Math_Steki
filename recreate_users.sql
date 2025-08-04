-- Script για εισαγωγή χρηστών με σωστούς κωδικούς
-- Αυτό θα διαγράψει και θα ξαναδημιουργήσει τους χρήστες

USE school_db;

-- Διαγραφή και επαναδημιουργία χρηστών
DELETE FROM Students WHERE username IN ('mariaio', 'giannisp', 'kostasd');
DELETE FROM Admins WHERE username IN ('admin', 'mariaio');

-- Hash για κωδικό "123456"
SET @hash123456 = '$2b$10$Jgugq7famjoLDGhsGxum9u/LYPhd6MpDoPkLUlpKsDHCYJ3SoiPcK';

-- Εισαγωγή Admins με σωστούς κωδικούς
INSERT INTO Admins (username, password_hash, full_name, email) VALUES
('admin', @hash123456, 'Διαχειριστής Συστήματος', 'admin@mathsteki.gr'),
('mariaio', @hash123456, 'Μαρία Ιωάννου - Admin', 'mariaio.admin@mathsteki.gr');

-- Εισαγωγή Students με σωστούς κωδικούς  
INSERT INTO Students (first_name, last_name, father_name, username, password_hash, class, phone, email, enrollmentDate) VALUES
('Μαρία', 'Ιωάννου', 'Νίκος', 'mariaio', @hash123456, 'Γ Λυκείου', '6901234567', 'maria@example.com', '2023-09-01'),
('Γιάννης', 'Παπαδόπουλος', 'Κώστας', 'giannisp', @hash123456, 'Β Λυκείου', '6902345678', 'giannis@example.com', '2022-09-01'),
('Κώστας', 'Δημητρίου', 'Νίκος', 'kostasd', @hash123456, 'Α Λυκείου', '6903456789', 'kostas@example.com', '2024-09-01');

-- Επιβεβαίωση
SELECT 'Χρήστες δημιουργήθηκαν επιτυχώς!' AS Status;

-- Προβολή όλων των χρηστών
SELECT 'ADMIN' AS Type, username, full_name AS Name FROM Admins
UNION ALL
SELECT 'STUDENT' AS Type, username, CONCAT(first_name, ' ', last_name) AS Name FROM Students
ORDER BY Type, username;

-- Έλεγχος κωδικών (όλοι θα έχουν τον ίδιο hash)
SELECT 'Όλοι οι κωδικοί είναι: 123456' AS Info;
