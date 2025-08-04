-- Remove CREATE DATABASE and USE statements (Oracle does not support them)
-- Δημιουργία βάσης
CREATE DATABASE school_db;
USE school_db;

-- Πίνακας Admins
CREATE TABLE Admins (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);

-- Πίνακας Students
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    father_name VARCHAR(50),
    username VARCHAR(50) UNIQUE,
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Πίνακας Teachers
CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    username VARCHAR(50) UNIQUE,
    password_hash VARCHAR(255)
);

-- Πίνακας Courses
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    description TEXT
);

-- Πίνακας Classes
CREATE TABLE Classes (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(50),
    course_id INT,
    teacher_id INT,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);

-- Πίνακας Enrollments
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    class_id INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

-- Πίνακας Grades
CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT,
    grade FLOAT,
    comments TEXT,
    date_recorded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id)
);

-- Πίνακας Notifications
CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES Admins(admin_id)
);

-- Πίνακας Files
CREATE TABLE Files (
    file_id INT PRIMARY KEY AUTO_INCREMENT,
    file_name VARCHAR(255),
    file_path VARCHAR(255),
    file_type VARCHAR(50),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uploaded_by INT,
    FOREIGN KEY (uploaded_by) REFERENCES Admins(admin_id)
);

-- Πίνακας Προόδου Μαθητών
CREATE TABLE ProgressNotes (
    note_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    teacher_id INT NOT NULL,
    note TEXT NOT NULL,
    date_recorded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id),
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);


-- Δοκιμαστικά δεδομένα
INSERT INTO Admins (username, password_hash) VALUES ('admin', '123456');
INSERT INTO Teachers (first_name, last_name, username, password_hash) VALUES ('Γιώργος', 'Παπαδόπουλος', 'gpap', '123');
INSERT INTO Courses (course_name, description) VALUES ('Μαθηματικά', 'Μάθημα Μαθηματικών Α Λυκείου');
INSERT INTO Classes (class_name, course_id, teacher_id) VALUES ('Α1 Μαθηματικών', 1, 1);
INSERT INTO Students (first_name, last_name, father_name, username, password_hash) VALUES ('Μαρία', 'Ιωάννου', 'Νίκος', 'mariaio', '123');
INSERT INTO Enrollments (student_id, class_id) VALUES (1, 1);
INSERT INTO Grades (enrollment_id, grade, comments) VALUES (1, 18.5, 'Πολύ καλή πρόοδος');
INSERT INTO ProgressNotes (student_id, class_id, teacher_id, note)
VALUES (1, 1, 1, 'Σήμερα ήταν διαβασμένη και συμμετείχε ενεργά.');


INSERT INTO Admins (username, password_hash) VALUES ('admin', '$2b$10$Jgugq7famjoLDGhsGxum9u/LYPhd6MpDoPkLUlpKsDHCYJ3SoiPcK');
UPDATE Students SET password_hash = '$2b$10$Jgugq7famjoLDGhsGxum9u/LYPhd6MpDoPkLUlpKsDHCYJ3SoiPcK' WHERE username = 'mariaio';

INSERT INTO Notifications (title, content, created_by)
VALUES 
('Νέο πρόγραμμα μαθημάτων', 'Ανακοινώθηκε το νέο πρόγραμμα μαθημάτων για το καλοκαίρι.', 1),
('Εκδήλωση ολοκλήρωσης εαρινών μαθημάτων', 'Σας προσκαλούμε στην εκδήλωση ολοκλήρωσης των μαθημάτων.', 1),
('Ξεκίνημα εγγραφών', 'Οι εγγραφές για τη νέα σχολική χρονιά ξεκίνησαν!', 1),
('Ενημέρωση για διακοπές', 'Το φροντιστήριο θα παραμείνει κλειστό την επόμενη εβδομάδα λόγω διακοπών.', 1);
