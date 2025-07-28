import express from 'express';
import bcrypt from 'bcryptjs';
import { getStudents,createAnnouncement,deleteAnnouncement, createStudent, deleteStudent, getTeachers,getAnnouncements, getUserByUsername, getStudent, getProgressNotes, getGradesByStudent } from './db.js';

import fs from 'fs/promises'; //για το text

const app = express();
app.use(express.json());
app.use(express.static('public'));



/*

app.get("/students", async (req, res) => {
    const students = await getStudents();
    res.send(students);
});

app.get('/student/:id', async (req, res) => {
  try {
    const id = req.params.id;
    const student = await getStudent(id); // Πρέπει να επιστρέφει αντικείμενο ή null
    if (!student) return res.status(404).send('Student not found');
    res.json(student);
  } catch (err) {
    console.error(err);
    res.status(500).send('Internal Server Error');
  }
});
*/
app.get("/students", async (req, res) => {
  try {
    const students = await getStudents(); // Η getStudents πρέπει να επιστρέφει array με τους μαθητές
    res.json(students);
  } catch (err) {
    console.error(err);
    res.status(500).send('Internal Server Error');
  }
});


app.get('/grades/:student_id', async (req, res) => {
  try {
    const student_id = req.params.student_id;
    const grades = await getGradesByStudent(student_id); // Πρέπει να υπάρχει στο db.js
    res.json(grades);
  } catch (err) {
    console.error(err);
    res.status(500).send('Internal Server Error');
  }
});


app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  try {
    const user = await getUserByUsername(username);
    console.log('Βρέθηκε χρήστης:', user); // <-- Δες τι επιστρέφει
    if (!user) {
      return res.status(401).json({ error: "Λάθος στοιχεία!" });
    }
    const isMatch = await bcrypt.compare(password, user.password_hash);
    console.log('bcrypt σύγκριση:', isMatch); // <-- Δες αν ταιριάζει
    if (!isMatch) {
      return res.status(401).json({ error: "Λάθος στοιχεία!" });
    }
    res.status(200).json({ message: "Επιτυχής σύνδεση!", userType: user.role });
  } catch (err) {
    console.error(err);
    res.status(500).send('Internal Server Error');
  }
});


app.get('/student/:id', async (req, res) => {
  try {
    const id = req.params.id;
    const student = await getStudent(id);
    if (!student) return res.status(404).send('Student not found');
    res.json(student);
  } catch (err) {
    console.error(err);
    res.status(500).send('Internal Server Error');
  }
});

app.get('/announcements', async (req, res) => {
  try {
    const announcements = await getAnnouncements(); // Πρέπει να υπάρχει στο db.js
    res.json(announcements);
  } catch (err) {
    console.error(err);
    res.status(500).send('Internal Server Error');
  }
});

/*
app.post("/login", async (req, res) => {
  const { username, password } = req.body;


    const user = await getUserByUsername(username);
    if (!user) {
      return res.status(401).json({ error: "Λάθος στοιχεία!" });
    }

    // Έλεγχος κωδικού
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ error: "Λάθος στοιχεία!" });
    }

    // Επιτυχής σύνδεση
    res.status(200).json({ message: "Επιτυχής σύνδεση!" });
});




app.post('/login', async (req, res) => {
  
  const { username, password } = req.body;
  try {
    


    const user = await getUserByUsername(username);
    if (!user) {
      return res.status(401).json({ error: "Λάθος στοιχεία!" });
    }

    // Έλεγχος κωδικού
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ error: "Λάθος στοιχεία!" });
    }
  } catch (err) {
    console.error(err);
    res.status(500).send('Internal Server Error');
  }
});

*/
app.get('/progress/:student_id', async (req, res) => {
  try {
    const student_id = req.params.student_id;
    const notes = await getProgressNotes(student_id); // Πρέπει να υπάρχει στο db.js
    res.json(notes);
  } catch (err) {
    console.error(err);
    res.status(500).send('Internal Server Error');
  }
});





// Επιστροφή όλων των ανακοινώσεων
app.get('/announcements', async (req, res) => {
  const announcements = await getAnnouncements();
  res.json(announcements);
});

// Δημιουργία ανακοίνωσης
app.post('/announcements', async (req, res) => {
  const { title, content } = req.body;
  // Πρέπει να βάλεις το admin_id του συνδεδεμένου admin
  await createAnnouncement(title, content, 1);
  res.status(201).json({ message: 'OK' });
});

// Διαγραφή ανακοίνωσης
app.delete('/announcements/:id', async (req, res) => {
  await deleteAnnouncement(req.params.id);
  res.status(204).end();
});








app.post('/save-edit', async (req, res) => {
  const { id, content } = req.body;
  let data = {};
  try {
    const file = await fs.readFile('app.json', 'utf8');
    data = JSON.parse(file);
  } catch (e) {}
  data[id] = content;
  await fs.writeFile('app.json', JSON.stringify(data, null, 2));
  res.json({ success: true });
});

app.get('/footer-links', async (req, res) => {
  try {
    const file = await fs.readFile('app.json', 'utf8');
    res.json(JSON.parse(file));
  } catch (e) {
    res.json({});
  }
});




app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});


app.listen(8080, () => console.log('Server running on 8080'));

