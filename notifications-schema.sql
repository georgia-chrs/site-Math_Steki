-- Δημιουργία πίνακα για Ανακοινώσεις με φιλτράρισμα ανά τμήμα/τάξη
-- Εκτελέστε αυτό το script στη MySQL βάση δεδομένων σας

USE school_db;

-- Δημιουργία πίνακα για Ανακοινώσεις
CREATE TABLE IF NOT EXISTS Notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL COMMENT 'Τίτλος ανακοίνωσης',
    content TEXT NOT NULL COMMENT 'Περιεχόμενο ανακοίνωσης',
    notification_type ENUM('general', 'class', 'subject') DEFAULT 'general' COMMENT 'Τύπος ανακοίνωσης',
    target_class VARCHAR(50) NULL COMMENT 'Στόχος τάξη (αν είναι class type)',
    target_subject_id INT NULL COMMENT 'Στόχος τμήμα/μάθημα (αν είναι subject type)',
    start_date DATE NULL COMMENT 'Ημερομηνία έναρξης εμφάνισης',
    end_date DATE NULL COMMENT 'Ημερομηνία λήξης εμφάνισης',
    priority ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal' COMMENT 'Προτεραιότητα ανακοίνωσης',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Αν η ανακοίνωση είναι ενεργή',
    pdf_attachment VARCHAR(255) NULL COMMENT 'Όνομα αρχείου PDF (προαιρετικό)',
    external_link VARCHAR(500) NULL COMMENT 'Εξωτερικός σύνδεσμος (προαιρετικό)',
    created_by INT COMMENT 'ID διαχειριστή που δημιούργησε την ανακοίνωση',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (target_subject_id) REFERENCES Subjects(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES AdminUsers(id) ON DELETE SET NULL,
    
    INDEX idx_type (notification_type),
    INDEX idx_class (target_class),
    INDEX idx_subject (target_subject_id),
    INDEX idx_dates (start_date, end_date),
    INDEX idx_priority (priority),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας ανακοινώσεων με φιλτράρισμα ανά τμήμα/τάξη';

-- Προσθήκη κάποιων δειγματικών ανακοινώσεων
INSERT IGNORE INTO Notifications (title, content, notification_type, target_class, priority, created_by) VALUES
('Αλλαγή στο πρόγραμμα μαθημάτων', 'Παρακαλούμε να ενημερωθείτε ότι το μάθημα της Παρασκευής 15/3 θα γίνει στις 6:00 μ.μ. αντί για 5:00 μ.μ.', 'class', 'Γ΄ Λυκείου', 'high', 1),
('Νέα παλιά θέματα διαθέσιμα', 'Ανέβηκαν νέα παλιά θέματα Μαθηματικών από τις πανελλαδικές εξετάσεις 2024.', 'general', NULL, 'normal', 1),
('Εξετάσεις Χημείας', 'Οι εξετάσεις Χημείας θα πραγματοποιηθούν την επόμενη εβδομάδα. Παρακαλούμε μελετήστε τα κεφάλαια 5-8.', 'class', 'Β΄ Λυκείου', 'high', 1),
('Διακοπές Πάσχα', 'Το φροντιστήριο θα παραμείνει κλειστό από 29/4 έως 7/5 λόγω διακοπών Πάσχα.', 'general', NULL, 'normal', 1);

-- Προσθήκη ευρετηρίων για καλύτερη απόδοση
CREATE INDEX idx_notifications_composite ON Notifications (is_active, notification_type, start_date, end_date);

-- View για εύκολη ανάκτηση ανακοινώσεων με πληροφορίες τμημάτων
CREATE OR REPLACE VIEW NotificationsView AS
SELECT 
    n.notification_id,
    n.title,
    n.content,
    n.notification_type,
    n.target_class,
    n.target_subject_id,
    s.name as subject_name,
    s.code as subject_code,
    n.start_date,
    n.end_date,
    n.priority,
    n.is_active,
    n.pdf_attachment,
    n.external_link,
    n.created_by,
    au.fullName as created_by_name,
    n.created_at,
    n.updated_at
FROM Notifications n
LEFT JOIN Subjects s ON n.target_subject_id = s.id
LEFT JOIN AdminUsers au ON n.created_by = au.id;

SELECT 'Πίνακας Notifications δημιουργήθηκε επιτυχώς!' AS Status;
