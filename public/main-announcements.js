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
      </div>
    `;
  });
  container.innerHTML = html;
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