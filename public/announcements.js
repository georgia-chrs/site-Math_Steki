async function loadAnnouncements() {
  const res = await fetch('/announcements');
  const announcements = await res.json();
  const container = document.querySelector('.announcements');
  let html = '';






  announcements.forEach(a => {
    html += `
      <div class="announcement">
        <div class="date-time">${new Date(a.created_at).toLocaleString('el-GR')}</div>
        <div class="title">${a.title}</div>
        <div class="content-1">${a.content}</div>
        <button class="delete-btn" data-id="${a.notification_id}">Διαγραφή</button>
      </div>
    `;
  });
  container.innerHTML = html;

  // Διαγραφή ανακοίνωσης
  document.querySelectorAll('.delete-btn').forEach(btn => {
    btn.addEventListener('click', async (e) => {
      const id = btn.getAttribute('data-id');
      if (confirm('Σίγουρα θέλετε να διαγράψετε;')) {
        await fetch(`/announcements/${id}`, { method: 'DELETE' });
        loadAnnouncements();
      }
    });
  });
}

// Προσθήκη ανακοίνωσης
const form = document.getElementById('add-announcement-form');
if (form) {


  
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const title = document.getElementById('announcement-title').value;
    const content = document.getElementById('announcement-content').value;
    await fetch('/announcements', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title, content })
    });
    e.target.reset();
    loadAnnouncements();
  });
}
document.addEventListener('DOMContentLoaded', loadAnnouncements);




document.querySelectorAll('.footer-links').forEach(el => {
  el.addEventListener('blur', async () => {
    const id = el.getAttribute('data-id');
    const content = el.innerText;
    await fetch('/save-edit', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id, content })
    });
  });
});