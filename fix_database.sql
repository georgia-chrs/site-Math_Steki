-- Script για διόρθωση και δημιουργία των πινάκων μαθητών
-- Εκτελέστε αυτό το script στη MySQL βάση δεδομένων σας

USE school_db;

-- Διαγραφή υπαρχόντων πινάκων που μπορεί να έχουν λάθος δομή (προσοχή: θα χαθούν τα δεδομένα)
DROP TABLE IF EXISTS StudentCodes;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS NewStudents;
DROP TABLE IF EXISTS NewTeachers;
DROP TABLE IF EXISTS Admins;

-- Δημιουργία πίνακα Admins για διαχειριστές
CREATE TABLE Admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας διαχειριστών';

-- Δημιουργία πίνακα Καθηγητών με τη σωστή δομή
CREATE TABLE NewTeachers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL COMMENT 'Πλήρες όνομα καθηγητή',
    subject VARCHAR(100) NOT NULL COMMENT 'Ειδικότητα/Μάθημα',
    phone VARCHAR(20) COMMENT 'Τηλέφωνο επικοινωνίας',
    email VARCHAR(255) COMMENT 'Email επικοινωνίας',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_subject (subject),
    UNIQUE KEY unique_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας καθηγητών';

-- Δημιουργία πίνακα Μαθητών με τη σωστή δομή
CREATE TABLE NewStudents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL COMMENT 'Όνομα μαθητή',
    last_name VARCHAR(100) NOT NULL COMMENT 'Επώνυμο μαθητή',
    father_name VARCHAR(100) COMMENT 'Όνομα πατέρα',
    username VARCHAR(50) UNIQUE COMMENT 'Username για login',
    password_hash VARCHAR(255) COMMENT 'Κρυπτογραφημένος κωδικός',
    class VARCHAR(50) NOT NULL COMMENT 'Τάξη μαθητή',
    phone VARCHAR(20) NOT NULL COMMENT 'Τηλέφωνο μαθητή',
    email VARCHAR(255) COMMENT 'Email μαθητή',
    parentName VARCHAR(255) COMMENT 'Όνομα γονέα',
    parentPhone VARCHAR(20) COMMENT 'Τηλέφωνο γονέα',
    address TEXT COMMENT 'Διεύθυνση κατοικίας',
    birthDate DATE COMMENT 'Ημερομηνία γέννησης',
    enrollmentDate DATE NOT NULL COMMENT 'Ημερομηνία εγγραφής',
    status ENUM('active', 'inactive', 'graduated') DEFAULT 'active' COMMENT 'Κατάσταση μαθητή',
    notes TEXT COMMENT 'Σημειώσεις για τον μαθητή',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_class (class),
    INDEX idx_status (status),
    INDEX idx_enrollment_date (enrollmentDate),
    UNIQUE KEY unique_phone (phone),
    UNIQUE KEY unique_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας μαθητών';

-- Δημιουργία πίνακα Τμημάτων/Μαθημάτων
CREATE TABLE Subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT 'Όνομα μαθήματος',
    code VARCHAR(20) NOT NULL UNIQUE COMMENT 'Κωδικός τμήματος',
    class VARCHAR(50) NOT NULL COMMENT 'Τάξη που αφορά',
    teacherId INT COMMENT 'ID καθηγητή που διδάσκει',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (teacherId) REFERENCES NewTeachers(id) ON DELETE SET NULL,
    INDEX idx_class (class),
    INDEX idx_teacher (teacherId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας τμημάτων/μαθημάτων';

-- Δημιουργία πίνακα Εγγραφών μαθητών σε τμήματα
CREATE TABLE Enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    studentId INT NOT NULL COMMENT 'ID μαθητή',
    subjectId INT NOT NULL COMMENT 'ID τμήματος',
    enrollmentDate DATE NOT NULL COMMENT 'Ημερομηνία εγγραφής',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (studentId) REFERENCES NewStudents(id) ON DELETE CASCADE,
    FOREIGN KEY (subjectId) REFERENCES Subjects(id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (studentId, subjectId),
    INDEX idx_student (studentId),
    INDEX idx_subject (subjectId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας εγγραφών μαθητών σε τμήματα';

-- Δημιουργία πίνακα Κωδικών Μαθητών
CREATE TABLE StudentCodes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    studentId INT NOT NULL COMMENT 'ID μαθητή',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT 'Username για σύνδεση',
    password VARCHAR(255) NOT NULL COMMENT 'Κωδικός πρόσβασης (hashed)',
    status ENUM('active', 'inactive', 'expired') DEFAULT 'active' COMMENT 'Κατάσταση κωδικού',
    lastLogin TIMESTAMP NULL COMMENT 'Τελευταία σύνδεση',
    createdDate DATE NOT NULL COMMENT 'Ημερομηνία δημιουργίας',
    expiryDate DATE COMMENT 'Ημερομηνία λήξης',
    maxSessions INT DEFAULT 5 COMMENT 'Μέγιστος αριθμός συνεδριών',
    currentSessions INT DEFAULT 0 COMMENT 'Τρέχουσες ενεργές συνεδρίες',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (studentId) REFERENCES NewStudents(id) ON DELETE CASCADE,
    INDEX idx_student (studentId),
    INDEX idx_status (status),
    INDEX idx_expiry (expiryDate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας κωδικών πρόσβασης μαθητών';

-- Προσθήκη δεδομένων για Admins (χρησιμοποιήστε το hash.js για να δημιουργήσετε νέους κωδικούς)
INSERT INTO Admins (id, username, password_hash, full_name, email) VALUES
(1, 'admin', '$2b$10$Jgugq7famjoLDGhsGxum9u/LYPhd6MpDoPkLUlpKsDHCYJ3SoiPcK', 'Διαχειριστής Συστήματος', 'admin@mathsteki.gr'),
(2, 'mariaio', '$2b$10$Jgugq7famjoLDGhsGxum9u/LYPhd6MpDoPkLUlpKsDHCYJ3SoiPcK', 'Μαρία Ιωάννου', 'mariaio@mathsteki.gr');

-- Προσθήκη δειγματικών δεδομένων για Καθηγητές
INSERT INTO NewTeachers (id, name, subject, phone, email) VALUES
(1, 'Δρ. Μαρία Αντωνίου', 'Μαθηματικά', '6901234567', 'maria.antoniou@mathsteki.gr'),
(2, 'Κώστας Γεωργίου', 'Φυσική', '6902345678', 'kostas.georgiou@mathsteki.gr'),
(3, 'Ελένη Παπαδάκη', 'Χημεία', '6903456789', 'eleni.papadaki@mathsteki.gr'),
(4, 'Γιάννης Νικολάου', 'Αρχαία', '6904567890', 'giannis.nikolaou@mathsteki.gr'),
(5, 'Άννα Κωνσταντίνου', 'Νέα Ελληνικά', '6905678901', 'anna.konstantinou@mathsteki.gr');

-- Προσθήκη δειγματικών δεδομένων για Μαθητές
INSERT INTO NewStudents (id, first_name, last_name, father_name, username, password_hash, class, phone, email, parentName, parentPhone, address, birthDate, enrollmentDate, status, notes) VALUES
(1, 'Μαρία', 'Ιωάννου', 'Νίκος', 'mariaio', '$2b$10$Jgugq7famjoLDGhsGxum9u/LYPhd6MpDoPkLUlpKsDHCYJ3SoiPcK', 'Γ\' Λυκείου', '6901234567', 'maria@example.com', 'Νίκος Ιωάννου', '6907654321', 'Λεωφ. Κηφισίας 123, Αθήνα', '2006-03-15', '2023-09-01', 'active', 'Πολύ καλή μαθήτρια, ενδιαφέρεται για τα μαθηματικά'),
(2, 'Γιάννης', 'Παπαδόπουλος', 'Κώστας', 'giannisp', '$2b$10$Jgugq7famjoLDGhsGxum9u/LYPhd6MpDoPkLUlpKsDHCYJ3SoiPcK', 'Β\' Λυκείου', '6902345678', 'giannis@example.com', 'Κώστας Παπαδόπουλος', '6908765432', 'Οδός Ερμού 45, Θεσσαλονίκη', '2007-07-22', '2022-09-01', 'active', 'Πολύ οργανωμένος, στοχεύει σε πολυτεχνείο'),
(3, 'Κώστας', 'Δημητρίου', 'Νίκος', 'kostasd', '$2b$10$Jgugq7famjoLDGhsGxum9u/LYPhd6MpDoPkLUlpKsDHCYJ3SoiPcK', 'Α\' Λυκείου', '6903456789', 'kostas@example.com', 'Νίκος Δημητρίου', '6909876543', 'Πλατεία Συντάγματος 10, Αθήνα', '2008-11-08', '2024-09-01', 'active', 'Ενδιαφέρεται για φυσικές επιστήμες');

-- Προσθήκη δειγματικών δεδομένων για Τμήματα
INSERT INTO Subjects (id, name, code, class, teacherId) VALUES
(1, 'Μαθηματικά', 'Μγ4', 'Γ\' Λυκείου', 1),
(2, 'Χημεία', 'Χγ2', 'Γ\' Λυκείου', 3),
(3, 'Φυσική', 'Φβ1', 'Β\' Λυκείου', 2),
(4, 'Αρχαία', 'Αρα3', 'Α\' Λυκείου', 4),
(5, 'Νέα Ελληνικά', 'Νεγ1', 'Γ\' Γυμνασίου', 5);

-- Προσθήκη δειγματικών εγγραφών
INSERT INTO Enrollments (id, studentId, subjectId, enrollmentDate) VALUES
(1, 1, 1, '2024-09-01'), -- Γιάννης στα Μαθηματικά
(2, 1, 2, '2024-09-01'), -- Γιάννης στη Χημεία
(3, 2, 1, '2024-09-01'), -- Μαρία στα Μαθηματικά
(4, 2, 3, '2024-09-15'), -- Μαρία στη Φυσική
(5, 3, 4, '2024-09-01'); -- Κώστας στα Αρχαία

-- Προσθήκη δειγματικών κωδικών μαθητών
INSERT INTO StudentCodes (id, studentId, username, password, status, createdDate, expiryDate, maxSessions, currentSessions) VALUES
(1, 1, 'giannis.p', 'St2024!gp', 'active', '2024-09-01', '2025-06-30', 5, 2),
(2, 2, 'maria.g', 'St2024!mg', 'active', '2024-09-01', '2025-06-30', 5, 1),
(3, 3, 'kostas.d', 'St2024!kd', 'inactive', '2024-09-01', '2025-06-30', 5, 0);

-- Μετονομασία των πινάκων στα τελικά ονόματα
RENAME TABLE Teachers TO OldTeachers;
RENAME TABLE Students TO OldStudents;
RENAME TABLE NewTeachers TO Teachers;
RENAME TABLE NewStudents TO Students;

-- Επιβεβαίωση δημιουργίας
SELECT 'Πίνακες δημιουργήθηκαν επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός Καθηγητών' FROM Teachers;
SELECT COUNT(*) AS 'Αριθμός Μαθητών' FROM Students;
SELECT COUNT(*) AS 'Αριθμός Τμημάτων' FROM Subjects;
SELECT COUNT(*) AS 'Αριθμός Εγγραφών' FROM Enrollments;
SELECT COUNT(*) AS 'Αριθμός Κωδικών Μαθητών' FROM StudentCodes;

-- Προβολή δομής των πινάκων
DESCRIBE Teachers;
DESCRIBE Students;
DESCRIBE Subjects;
DESCRIBE Enrollments;
DESCRIBE StudentCodes;

