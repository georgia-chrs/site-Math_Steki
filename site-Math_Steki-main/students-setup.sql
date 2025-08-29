-- Δημιουργία πινάκων για Μαθητές, Καθηγητές, Τμήματα και Κωδικούς
-- Εκτελέστε αυτό το script στη MySQL βάση δεδομένων σας

USE school_db; -- Αλλάξτε το school_db με το όνομα της βάσης σας

-- Δημιουργία πίνακα για Καθηγητές
CREATE TABLE IF NOT EXISTS Teachers (
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

-- Δημιουργία πίνακα για Μαθητές
CREATE TABLE IF NOT EXISTS Students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL COMMENT 'Όνομα μαθητή',
    lastName VARCHAR(100) NOT NULL COMMENT 'Επώνυμο μαθητή',
    studentClass VARCHAR(50) NOT NULL COMMENT 'Τάξη μαθητή',
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
    
    INDEX idx_class (studentClass),
    INDEX idx_status (status),
    INDEX idx_enrollment_date (enrollmentDate),
    UNIQUE KEY unique_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας μαθητών';

-- Δημιουργία πίνακα για Τμήματα/Μαθήματα
CREATE TABLE IF NOT EXISTS Subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT 'Όνομα μαθήματος',
    code VARCHAR(20) NOT NULL UNIQUE COMMENT 'Κωδικός τμήματος',
    class VARCHAR(50) NOT NULL COMMENT 'Τάξη που αφορά',
    teacherId INT COMMENT 'ID καθηγητή που διδάσκει',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (teacherId) REFERENCES Teachers(id) ON DELETE SET NULL,
    INDEX idx_class (class),
    INDEX idx_teacher (teacherId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας τμημάτων/μαθημάτων';

-- Δημιουργία πίνακα για Εγγραφές μαθητών σε τμήματα
CREATE TABLE IF NOT EXISTS Enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    studentId INT NOT NULL COMMENT 'ID μαθητή',
    subjectId INT NOT NULL COMMENT 'ID τμήματος',
    enrollmentDate DATE NOT NULL COMMENT 'Ημερομηνία εγγραφής',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (studentId) REFERENCES Students(id) ON DELETE CASCADE,
    FOREIGN KEY (subjectId) REFERENCES Subjects(id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (studentId, subjectId),
    INDEX idx_student (studentId),
    INDEX idx_subject (subjectId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας εγγραφών μαθητών σε τμήματα';

-- Δημιουργία πίνακα για Κωδικούς Μαθητών
CREATE TABLE IF NOT EXISTS StudentCodes (
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
    
    FOREIGN KEY (studentId) REFERENCES Students(id) ON DELETE CASCADE,
    INDEX idx_student (studentId),
    INDEX idx_status (status),
    INDEX idx_expiry (expiryDate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας κωδικών πρόσβασης μαθητών';

-- Προσθήκη δειγματικών δεδομένων για Καθηγητές
INSERT IGNORE INTO Teachers (id, name, subject, phone, email) VALUES
(1, 'Δρ. Μαρία Αντωνίου', 'Μαθηματικά', '6901234567', 'maria.antoniou@mathsteki.gr'),
(2, 'Κώστας Γεωργίου', 'Φυσική', '6902345678', 'kostas.georgiou@mathsteki.gr'),
(3, 'Ελένη Παπαδάκη', 'Χημεία', '6903456789', 'eleni.papadaki@mathsteki.gr'),
(4, 'Γιάννης Νικολάου', 'Αρχαία', '6904567890', 'giannis.nikolaou@mathsteki.gr'),
(5, 'Άννα Κωνσταντίνου', 'Νέα Ελληνικά', '6905678901', 'anna.konstantinou@mathsteki.gr');

-- Προσθήκη δειγματικών δεδομένων για Μαθητές
INSERT IGNORE INTO Students (id, firstName, lastName, studentClass, phone, email, parentName, parentPhone, address, birthDate, enrollmentDate, status, notes) VALUES
(1, 'Γιάννης', 'Παπαδόπουλος', 'Β\' Λυκείου', '6901234567', 'giannis@example.com', 'Κώστας Παπαδόπουλος', '6907654321', 'Λεωφ. Κηφισίας 123, Αθήνα', '2007-03-15', '2023-09-01', 'active', 'Πολύ καλός μαθητής, ενδιαφέρεται για τα μαθηματικά'),
(2, 'Μαρία', 'Γεωργίου', 'Γ\' Λυκείου', '6902345678', 'maria@example.com', 'Ελένη Γεωργίου', '6908765432', 'Οδός Ερμού 45, Θεσσαλονίκη', '2006-07-22', '2022-09-01', 'active', 'Πολύ οργανωμένη, στοχεύει σε ιατρική σχολή'),
(3, 'Κώστας', 'Δημητρίου', 'Α\' Λυκείου', '6903456789', 'kostas@example.com', 'Νίκος Δημητρίου', '6909876543', 'Πλατεία Συντάγματος 10, Αθήνα', '2008-11-08', '2024-09-01', 'active', 'Ενδιαφέρεται για φυσικές επιστήμες');

-- Προσθήκη δειγματικών δεδομένων για Τμήματα
INSERT IGNORE INTO Subjects (id, name, code, class, teacherId) VALUES
(1, 'Μαθηματικά', 'Μγ4', 'Γ\' Λυκείου', 1),
(2, 'Χημεία', 'Χγ2', 'Γ\' Λυκείου', 3),
(3, 'Φυσική', 'Φβ1', 'Β\' Λυκείου', 2),
(4, 'Αρχαία', 'Αρα3', 'Α\' Λυκείου', 4),
(5, 'Νέα Ελληνικά', 'Νεγ1', 'Γ\' Γυμνασίου', 5);

-- Προσθήκη δειγματικών εγγραφών
INSERT IGNORE INTO Enrollments (id, studentId, subjectId, enrollmentDate) VALUES
(1, 1, 1, '2024-09-01'), -- Γιάννης στα Μαθηματικά
(2, 1, 2, '2024-09-01'), -- Γιάννης στη Χημεία
(3, 2, 1, '2024-09-01'), -- Μαρία στα Μαθηματικά
(4, 2, 3, '2024-09-15'), -- Μαρία στη Φυσική
(5, 3, 4, '2024-09-01'); -- Κώστας στα Αρχαία

-- Προσθήκη δειγματικών κωδικών μαθητών (κωδικοί είναι σε plain text για demo - σε παραγωγή θα πρέπει να είναι hashed)
INSERT IGNORE INTO StudentCodes (id, studentId, username, password, status, createdDate, expiryDate, maxSessions, currentSessions) VALUES
(1, 1, 'giannis.p', 'St2024!gp', 'active', '2024-09-01', '2025-06-30', 5, 2),
(2, 2, 'maria.g', 'St2024!mg', 'active', '2024-09-01', '2025-06-30', 5, 1),
(3, 3, 'kostas.d', 'St2024!kd', 'inactive', '2024-09-01', '2025-06-30', 5, 0);

-- Επιβεβαίωση δημιουργίας
SELECT 'Πίνακας Teachers δημιουργήθηκε επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός Καθηγητών' FROM Teachers;

SELECT 'Πίνακας Students δημιουργήθηκε επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός Μαθητών' FROM Students;

SELECT 'Πίνακας Subjects δημιουργήθηκε επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός Τμημάτων' FROM Subjects;

SELECT 'Πίνακας Enrollments δημιουργήθηκε επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός Εγγραφών' FROM Enrollments;

SELECT 'Πίνακας StudentCodes δημιουργήθηκε επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός Κωδικών Μαθητών' FROM StudentCodes;

-- Προβολή δομής των πινάκων
DESCRIBE Teachers;
DESCRIBE Students;
DESCRIBE Subjects;
DESCRIBE Enrollments;
DESCRIBE StudentCodes;
