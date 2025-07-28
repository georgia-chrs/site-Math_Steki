async function fetchStudents() {
  const res = await fetch('/students');
  const students = await res.json();
  const container = document.getElementById('students-container');
  container.innerHTML = '';
  students.forEach(student => {
    const div = document.createElement('div');
    div.className = 'student';
    div.innerHTML = `
      <div class="student-name">${student.first_name} ${student.last_name}</div>
      <div class="student-father">Πατέρας: ${student.father_name}</div>
      <div class="student-username">Username: ${student.username}</div>
    `;
    container.appendChild(div);
  });
}


document.getElementById('fetch-students-btn').addEventListener('click', fetchStudents);






