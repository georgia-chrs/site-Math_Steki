async function loadProgress(studentId) {
  const res = await fetch(`/progress/${studentId}`);
  const notes = await res.json();
  const container = document.querySelector('.student-container');
  let html = '<h2>Σημειώσεις Προόδου</h2>';
  notes.forEach(n => {
    html += `
      <div style="margin-bottom: 16px; padding: 12px; border-radius: 8px; background: #f7e7c1;">
        <div><strong>Μάθημα:</strong> ${n.class_name}</div>
        <div><strong>Καθηγητής:</strong> ${n.teacher_first} ${n.teacher_last}</div>
        <div><strong>Ημ/νία:</strong> ${new Date(n.date_recorded).toLocaleDateString()}</div>
        <div><strong>Σημείωση:</strong> ${n.note}</div>
      </div>
    `;
  });
  container.innerHTML = html;
}

document.addEventListener('DOMContentLoaded', () => {
  loadProgress(1); // id μαθητή
});