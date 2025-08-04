-- Πίνακες για το Admin System - Βαθμοί, Πρόοδος, Ημερολόγιο
-- Εκτελέστε αυτό το script στη MySQL βάση δεδομένων σας

USE school_db;

-- Δημιουργία πίνακα για Βαθμούς
CREATE TABLE IF NOT EXISTS Grades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    studentId INT NOT NULL COMMENT 'ID μαθητή',
    subjectId INT NOT NULL COMMENT 'ID μαθήματος',
    gradeType ENUM('quiz', 'homework', 'oral', 'project', 'exam') NOT NULL COMMENT 'Τύπος αξιολόγησης',
    gradeValue DECIMAL(4,2) NOT NULL COMMENT 'Βαθμός (0.00-20.00)',
    gradeDate DATE NOT NULL COMMENT 'Ημερομηνία αξιολόγησης',
    comments TEXT COMMENT 'Σχόλια για τον βαθμό',
    teacherId INT COMMENT 'ID καθηγητή που έβαλε τον βαθμό',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (studentId) REFERENCES Students(id) ON DELETE CASCADE,
    FOREIGN KEY (subjectId) REFERENCES Subjects(id) ON DELETE CASCADE,
    FOREIGN KEY (teacherId) REFERENCES Teachers(id) ON DELETE SET NULL,
    
    INDEX idx_student (studentId),
    INDEX idx_subject (subjectId),
    INDEX idx_grade_date (gradeDate),
    INDEX idx_grade_type (gradeType),
    
    CONSTRAINT chk_grade_value CHECK (gradeValue >= 0 AND gradeValue <= 20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας βαθμών μαθητών';

-- Δημιουργία πίνακα για Πρόοδο Μαθητών
CREATE TABLE IF NOT EXISTS StudentProgress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    studentId INT NOT NULL COMMENT 'ID μαθητή',
    subjectId INT NOT NULL COMMENT 'ID μαθήματος',
    progressDate DATE NOT NULL COMMENT 'Ημερομηνία καταγραφής προόδου',
    progressNote TEXT NOT NULL COMMENT 'Σημείωση προόδου',
    progressRating ENUM('excellent', 'good', 'average', 'needs_improvement') COMMENT 'Αξιολόγηση προόδου',
    teacherId INT COMMENT 'ID καθηγητή που έκανε την καταγραφή',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (studentId) REFERENCES Students(id) ON DELETE CASCADE,
    FOREIGN KEY (subjectId) REFERENCES Subjects(id) ON DELETE CASCADE,
    FOREIGN KEY (teacherId) REFERENCES Teachers(id) ON DELETE SET NULL,
    
    INDEX idx_student (studentId),
    INDEX idx_subject (subjectId),
    INDEX idx_progress_date (progressDate),
    INDEX idx_progress_rating (progressRating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας προόδου μαθητών';

-- Δημιουργία πίνακα για Ημερολόγιο/Events
CREATE TABLE IF NOT EXISTS StudentCalendar (
    id INT AUTO_INCREMENT PRIMARY KEY,
    studentId INT NOT NULL COMMENT 'ID μαθητή',
    eventType ENUM('makeup_class', 'exam', 'meeting', 'absence', 'extra_class', 'other') NOT NULL COMMENT 'Τύπος γεγονότος',
    subjectId INT COMMENT 'ID μαθήματος (προαιρετικό)',
    eventTitle VARCHAR(255) NOT NULL COMMENT 'Τίτλος γεγονότος',
    eventDescription TEXT COMMENT 'Περιγραφή γεγονότος',
    eventDate DATE NOT NULL COMMENT 'Ημερομηνία γεγονότος',
    eventTime TIME COMMENT 'Ώρα γεγονότος',
    teacherId INT COMMENT 'ID καθηγητή που δημιούργησε το γεγονός',
    isVisible BOOLEAN DEFAULT TRUE COMMENT 'Αν είναι ορατό στον μαθητή',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (studentId) REFERENCES Students(id) ON DELETE CASCADE,
    FOREIGN KEY (subjectId) REFERENCES Subjects(id) ON DELETE SET NULL,
    FOREIGN KEY (teacherId) REFERENCES Teachers(id) ON DELETE SET NULL,
    
    INDEX idx_student (studentId),
    INDEX idx_event_date (eventDate),
    INDEX idx_event_type (eventType),
    INDEX idx_subject (subjectId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας ημερολογίου μαθητών';

-- Δημιουργία πίνακα για Admin Users (για authentication)
CREATE TABLE IF NOT EXISTS AdminUsers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT 'Username διαχειριστή',
    password VARCHAR(255) NOT NULL COMMENT 'Κωδικός πρόσβασης (hashed)',
    fullName VARCHAR(255) NOT NULL COMMENT 'Πλήρες όνομα διαχειριστή',
    email VARCHAR(255) COMMENT 'Email διαχειριστή',
    role ENUM('admin', 'teacher', 'super_admin') DEFAULT 'admin' COMMENT 'Ρόλος χρήστη',
    isActive BOOLEAN DEFAULT TRUE COMMENT 'Αν ο λογαριασμός είναι ενεργός',
    lastLogin TIMESTAMP NULL COMMENT 'Τελευταία σύνδεση',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_username (username),
    INDEX idx_role (role),
    INDEX idx_active (isActive)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας διαχειριστών συστήματος';

-- Προσθήκη δειγματικών δεδομένων για βαθμούς
INSERT IGNORE INTO Grades (studentId, subjectId, gradeType, gradeValue, gradeDate, comments, teacherId) VALUES
(1, 1, 'quiz', 18.5, '2024-01-15', 'Πολύ καλή επίδοση στο διαγώνισμα παραγώγων', 1),
(1, 1, 'homework', 19.0, '2024-01-20', 'Άριστη εργασία για τα ολοκληρώματα', 1),
(1, 2, 'quiz', 16.5, '2024-01-18', 'Καλή κατανόηση της οργανικής χημείας', 3),
(2, 1, 'quiz', 17.0, '2024-01-15', 'Καλή προετοιμασία, μικρά λάθη στις ασκήσεις', 1),
(2, 1, 'oral', 18.0, '2024-01-25', 'Εξαιρετική προφορική εξέταση', 1),
(3, 4, 'homework', 15.5, '2024-01-22', 'Καλή προσπάθεια στη μετάφραση', 4);

-- Προσθήκη δειγματικών δεδομένων για πρόοδο
INSERT IGNORE INTO StudentProgress (studentId, subjectId, progressDate, progressNote, progressRating, teacherId) VALUES
(1, 1, '2024-01-30', 'Ο Γιάννης δείχνει εξαιρετική πρόοδο στα μαθηματικά. Έχει κατανοήσει πλήρως τις παραγώγους και τα ολοκληρώματα. Συστήνεται να συνεχίσει με την ίδια προσπάθεια.', 'excellent', 1),
(1, 2, '2024-01-30', 'Στη χημεία παρουσιάζει καλή κατανόηση των βασικών αρχών. Χρειάζεται περισσότερη εξάσκηση στις ασκήσεις στοιχειομετρίας.', 'good', 3),
(2, 1, '2024-01-30', 'Η Μαρία είναι πολύ οργανωμένη και συστηματική. Έχει καλή βάση στα μαθηματικά αλλά χρειάζεται περισσότερη εξάσκηση στα πιο δύσκολα θέματα.', 'good', 1),
(3, 4, '2024-01-30', 'Ο Κώστας δείχνει ενδιαφέρον για τα αρχαία αλλά χρειάζεται περισσότερη εστίαση στη μελέτη. Συστήνεται καθημερινή επανάληψη του λεξιλογίου.', 'average', 4);

-- Προσθήκη δειγματικών δεδομένων για ημερολόγιο
INSERT IGNORE INTO StudentCalendar (studentId, eventType, subjectId, eventTitle, eventDescription, eventDate, eventTime, teacherId) VALUES
(1, 'makeup_class', 1, 'Αναπλήρωση Μαθηματικών', 'Αναπλήρωση για το μάθημα που χάθηκε λόγω αργίας. Θα καλύψουμε τα ολοκληρώματα.', '2024-02-05', '15:00:00', 1),
(1, 'exam', 2, 'Διαγώνισμα Χημείας', 'Διαγώνισμα στην οργανική χημεία - κεφάλαια 3-5', '2024-02-10', '10:00:00', 3),
(2, 'meeting', NULL, 'Συνάντηση με Γονείς', 'Ενημέρωση γονέων για την πρόοδο της Μαρίας', '2024-02-08', '17:00:00', 1),
(2, 'extra_class', 1, 'Επιπλέον Μάθημα Μαθηματικών', 'Επαναληπτικό μάθημα για τις πανελλαδικές εξετάσεις', '2024-02-12', '16:00:00', 1),
(3, 'absence', 4, 'Απουσία από Αρχαία', 'Δικαιολογημένη απουσία - ασθένεια', '2024-01-28', NULL, 4),
(1, 'other', NULL, 'Ενημέρωση για Υποτροφίες', 'Πληροφορίες για διαθέσιμες υποτροφίες για πανεπιστήμια', '2024-02-15', '14:00:00', NULL);

-- Προσθήκη δειγματικού admin user
INSERT IGNORE INTO AdminUsers (id, username, password, fullName, email, role, isActive) VALUES
(1, 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Διαχειριστής Συστήματος', 'admin@mathsteki.gr', 'super_admin', TRUE),
(2, 'teacher1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Μαρία Αντωνίου', 'maria.antoniou@mathsteki.gr', 'teacher', TRUE);

-- Επιβεβαίωση δημιουργίας
SELECT 'Πίνακας Grades δημιουργήθηκε επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός Βαθμών' FROM Grades;

SELECT 'Πίνακας StudentProgress δημιουργήθηκε επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός Καταγραφών Προόδου' FROM StudentProgress;

SELECT 'Πίνακας StudentCalendar δημιουργήθηκε επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός Γεγονότων Ημερολογίου' FROM StudentCalendar;

SELECT 'Πίνακας AdminUsers δημιουργήθηκε επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός Admin Users' FROM AdminUsers;

-- Προβολή δομής των πινάκων
DESCRIBE Grades;
DESCRIBE StudentProgress;
DESCRIBE StudentCalendar;
DESCRIBE AdminUsers;
