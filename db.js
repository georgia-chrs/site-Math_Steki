// db.js
import mysql from 'mysql2'
import dotenv from 'dotenv'

dotenv.config()

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DB, // εδώ βάζεις "school_db"
  port: process.env.MYSQL_PORT,
}).promise();

// ---------- ΜΑΘΗΤΕΣ ----------
export async function getStudents() {
  const [rows] = await pool.query('SELECT * FROM Students');
  return rows;
}
export async function getStudent(id) {
  const [rows] = await pool.query('SELECT * FROM Students WHERE student_id = ?', [id]);
  return rows[0];
}

export async function createStudent(first_name, last_name, father_name, username, password_hash) {
    const [result] = await pool.query(
        `INSERT INTO Students (first_name, last_name, father_name, username, password_hash) VALUES (?, ?, ?, ?, ?)`,
        [first_name, last_name, father_name, username, password_hash]
    );
    return getStudents(result.insertId);
}

export async function deleteStudent(id) {
    const [result] = await pool.query(
        "DELETE FROM Students WHERE student_id = ?",
        [id]
    );
    return result.affectedRows > 0;
}



// ---------- ΚΑΘΗΓΗΤΕΣ (αν χρειαστεί) ----------
export async function getTeachers() {
    const [rows] = await pool.query("SELECT * FROM Teachers");
    return rows;
}

export async function getUserByUsername(username) {
  // Ψάχνει πρώτα στους Admins
  let [rows] = await pool.query("SELECT *, 'admin' as role FROM Admins WHERE username = ?", [username]);
  if (rows.length > 0) return rows[0];
  // Μετά στους Students
  [rows] = await pool.query("SELECT *, 'student' as role FROM Students WHERE username = ?", [username]);
  if (rows.length > 0) return rows[0];
  return null;
}

export async function getProgressNotes(student_id) {
  const [rows] = await pool.query(
    `SELECT p.note, p.date_recorded, c.class_name, t.first_name AS teacher_first, t.last_name AS teacher_last
     FROM ProgressNotes p
     JOIN Classes c ON p.class_id = c.class_id
     JOIN Teachers t ON p.teacher_id = t.teacher_id
     WHERE p.student_id = ? ORDER BY p.date_recorded DESC`,
    [student_id]
  );
  return rows;
}
// Κάλεσε τη συνάρτηση με το id του μαθητή (π.χ. 1)


export async function getGradesByStudent(student_id) {
  const [rows] = await pool.query(
    `SELECT g.grade, g.comments, g.date_recorded, c.class_name
     FROM Grades g
     JOIN Enrollments e ON g.enrollment_id = e.enrollment_id
     JOIN Classes c ON e.class_id = c.class_id
     WHERE e.student_id = ?`,
    [student_id]
  );
  return rows;
}


export async function getAnnouncements() {
  const [rows] = await pool.query(
    `SELECT notification_id, title, content, created_at FROM Notifications ORDER BY created_at DESC`
  );
  return rows;
}



export async function createAnnouncement(title, content, admin_id) {
  await pool.query(
    `INSERT INTO Notifications (title, content, created_by) VALUES (?, ?, ?)`,
    [title, content, admin_id]
  );
}

export async function deleteAnnouncement(id) {
  await pool.query(
    `DELETE FROM Notifications WHERE notification_id = ?`,
    [id]
  );
}

(async () => {
    const teacher = await getTeachers(); // Only get the note with id=2
    console.log(teacher);
})();

(async () => {
    const student = await getStudents(); // Only get the note with id=2
    console.log(student);
})();