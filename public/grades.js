async function loadGrades(studentId) {
  const res = await fetch(`/grades/${studentId}`);
  const grades = await res.json();
  const container = document.querySelector('.student-container1');
  let html = '<h2>Βαθμοί</h2><table><tr><th>Μάθημα</th><th>Βαθμός</th><th>Σχόλια</th><th>Ημ/νία</th></tr>';
  grades.forEach(g => {
    html += `<tr>
      <td>${g.class_name}</td>
      <td>${g.grade}</td>
      <td>${g.comments || ''}</td>
      <td>${new Date(g.date_recorded).toLocaleDateString()}</td>
    </tr>`;
  });
  html += '</table>';
  container.innerHTML += html;
}

document.addEventListener('DOMContentLoaded', () => {
  loadGrades(1); // id μαθητή
});