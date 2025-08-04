// Get student username from session storage
function getStudentUsername() {
  return sessionStorage.getItem('username');
}

async function loadStudentInfo() {
  try {
    const username = getStudentUsername();
    if (!username) {
      document.getElementById('loadingMessage').textContent = 'Δεν βρέθηκε σύνδεση μαθητή. Παρακαλώ συνδεθείτε ξανά.';
      return null;
    }

    const response = await fetch(`/api/student/profile/${username}`);
    if (response.ok) {
      const studentData = await response.json();
      return studentData;
    } else {
      throw new Error('Δεν ήταν δυνατή η φόρτωση των στοιχείων μαθητή');
    }
  } catch (error) {
    console.error('Error loading student info:', error);
    document.getElementById('loadingMessage').textContent = 'Σφάλμα κατά τη φόρτωση των στοιχείων μαθητή.';
    return null;
  }
}

async function loadCalendarEntries(studentId) {
  try {
    const response = await fetch(`/api/calendar/${studentId}`);
    if (response.ok) {
      const calendarEntries = await response.json();
      return calendarEntries;
    } else {
      console.error('Failed to load calendar entries');
      return [];
    }
  } catch (error) {
    console.error('Error loading calendar entries:', error);
    return [];
  }
}

// Load announcements (simple - all announcements)
async function loadStudentAnnouncements() {
  try {
    const response = await fetch(`/announcements`);
    if (response.ok) {
      const announcements = await response.json();
      return announcements;
    } else {
      console.error('Failed to load announcements');
      return [];
    }
  } catch (error) {
    console.error('Error loading announcements:', error);
    return [];
  }
}

// Convert announcements to calendar events
function convertAnnouncementsToEvents(announcements) {
  return announcements.map(announcement => {
    // Use start_date or created_at for event date
    const eventDate = announcement.start_date || announcement.created_at.split('T')[0];
    
    return {
      id: `announcement_${announcement.notification_id}`,
      title: `📢 ${announcement.title}`,
      eventType: 'announcement',
      eventDescription: announcement.content,
      eventDate: eventDate,
      priority: announcement.priority,
      announcement_type: announcement.notification_type,
      external_link: announcement.external_link,
      pdf_attachment: announcement.pdf_attachment,
      subject_name: announcement.subject_name,
      target_class: announcement.target_class
    };
  });
}

// Merge calendar entries and announcements
function mergeCalendarAndAnnouncements(calendarEntries, announcements) {
  const announcementEvents = convertAnnouncementsToEvents(announcements);
  return [...calendarEntries, ...announcementEvents];
}

function displayStudentInfo(student) {
  const studentInfo = document.getElementById('studentInfo');
  const studentDetails = document.getElementById('studentDetails');
  
  studentDetails.innerHTML = `
    <div><strong>Όνομα:</strong> ${student.first_name} ${student.last_name}</div>
    <div><strong>Τάξη:</strong> ${student.class}</div>
    <div><strong>Τηλέφωνο:</strong> ${student.phone}</div>
  `;
  
  studentInfo.style.display = 'block';
}

function displayCalendarEntries(calendarEntries) {
  const calendarContent = document.getElementById('calendarContent');
  const loadingMessage = document.getElementById('loadingMessage');
  const noEventsMessage = document.getElementById('noEventsMessage');
  
  loadingMessage.style.display = 'none';
  
  if (calendarEntries.length === 0) {
    noEventsMessage.style.display = 'block';
    return;
  }
  
  // Populate filters
  populateFilters(calendarEntries);
  
  // Display calendar entries
  updateCalendarDisplay(calendarEntries);
  
  calendarContent.style.display = 'block';
}

function populateFilters(calendarEntries) {
  const eventTypeFilter = document.getElementById('eventTypeFilter');
  const subjectFilter = document.getElementById('subjectFilter');
  
  // Event types
  const eventTypes = [...new Set(calendarEntries.map(entry => entry.event_type).filter(Boolean))];
  const firstEventOption = eventTypeFilter.querySelector('option[value=""]');
  eventTypeFilter.innerHTML = '';
  eventTypeFilter.appendChild(firstEventOption);
  
  eventTypes.forEach(type => {
    const option = document.createElement('option');
    option.value = type;
    option.textContent = type;
    eventTypeFilter.appendChild(option);
  });
  
  // Subjects
  const subjects = [...new Set(calendarEntries.map(entry => entry.subject_name).filter(Boolean))];
  const firstSubjectOption = subjectFilter.querySelector('option[value=""]');
  subjectFilter.innerHTML = '';
  subjectFilter.appendChild(firstSubjectOption);
  
  subjects.forEach(subject => {
    const option = document.createElement('option');
    option.value = subject;
    option.textContent = subject;
    subjectFilter.appendChild(option);
  });
  
  // Add event listeners for filtering
  eventTypeFilter.addEventListener('change', () => filterEntries(calendarEntries));
  subjectFilter.addEventListener('change', () => filterEntries(calendarEntries));
}

function filterEntries(allEntries) {
  const eventTypeFilter = document.getElementById('eventTypeFilter').value;
  const subjectFilter = document.getElementById('subjectFilter').value;
  
  let filteredEntries = allEntries;
  
  if (eventTypeFilter) {
    filteredEntries = filteredEntries.filter(entry => entry.event_type === eventTypeFilter);
  }
  
  if (subjectFilter) {
    filteredEntries = filteredEntries.filter(entry => entry.subject_name === subjectFilter);
  }
  
  updateCalendarDisplay(filteredEntries);
}

function updateCalendarDisplay(calendarEntries) {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  // Separate upcoming and past events
  const upcomingEvents = calendarEntries
    .filter(entry => {
      const entryDate = new Date(entry.eventDate || entry.entry_date);
      return entryDate >= today;
    })
    .sort((a, b) => {
      const dateA = new Date(a.eventDate || a.entry_date);
      const dateB = new Date(b.eventDate || b.entry_date);
      return dateA - dateB;
    });
    
  const pastEvents = calendarEntries
    .filter(entry => {
      const entryDate = new Date(entry.eventDate || entry.entry_date);
      return entryDate < today;
    })
    .sort((a, b) => {
      const dateA = new Date(a.eventDate || a.entry_date);
      const dateB = new Date(b.eventDate || b.entry_date);
      return dateB - dateA;
    });
  
  // Display upcoming events
  const upcomingEventsList = document.getElementById('upcomingEventsList');
  if (upcomingEvents.length === 0) {
    upcomingEventsList.innerHTML = '<div style="color: #666; font-style: italic;">Δεν υπάρχουν προσεχή γεγονότα</div>';
  } else {
    upcomingEventsList.innerHTML = upcomingEvents.map(entry => createEventCard(entry, true)).join('');
  }
  
  // Display past events
  const pastEventsList = document.getElementById('pastEventsList');
  if (pastEvents.length === 0) {
    pastEventsList.innerHTML = '<div style="color: #666; font-style: italic;">Δεν υπάρχουν παλαιότερα γεγονότα</div>';
  } else {
    pastEventsList.innerHTML = pastEvents.map(entry => createEventCard(entry, false)).join('');
  }
}

function createEventCard(entry, isUpcoming) {
  const eventTypeColor = getEventTypeColor(entry.eventType || entry.event_type);
  const eventDate = new Date(entry.eventDate || entry.entry_date);
  const isToday = eventDate.toDateString() === new Date().toDateString();
  
  // Handle different types of entries (calendar events vs announcements)
  const isAnnouncement = entry.eventType === 'announcement';
  const title = entry.title || entry.eventTitle;
  const description = entry.eventDescription || entry.description;
  const subjectName = entry.subject_name;
  
  return `
    <div class="event-card" style="
      margin-bottom: 15px; 
      padding: 15px; 
      border-radius: 8px; 
      background: white; 
      border-left: 4px solid ${eventTypeColor}; 
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      ${isToday ? 'border: 2px solid #007bff;' : ''}
      ${isAnnouncement ? 'background-color: #f8f9fa;' : ''}
    ">
      <div class="event-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
        <div class="event-title" style="font-weight: bold; color: #333;">
          ${title}
          ${isAnnouncement && entry.priority === 'urgent' ? ' <span style="color: #dc3545;">⚠️</span>' : ''}
          ${isAnnouncement && entry.priority === 'high' ? ' <span style="color: #fd7e14;">📌</span>' : ''}
        </div>
        <div class="event-date" style="color: #666; font-size: 14px;">
          ${eventDate.toLocaleDateString('el-GR')}
          ${isToday ? '<span style="color: #007bff; font-weight: bold;"> (Σήμερα)</span>' : ''}
        </div>
      </div>
      
      <div class="event-details">
        <div class="event-type" style="margin-bottom: 8px;">
          <span class="event-type-badge" style="
            background-color: ${eventTypeColor}; 
            color: white; 
            padding: 2px 8px; 
            border-radius: 12px; 
            font-size: 12px;
            font-weight: bold;
          ">
            ${isAnnouncement ? '📢 Ανακοίνωση' : (entry.eventType || entry.event_type)}
          </span>
          ${subjectName ? `<span style="margin-left: 10px; color: #666;">Μάθημα: ${subjectName}</span>` : ''}
          ${entry.target_class ? `<span style="margin-left: 10px; color: #666;">Τάξη: ${entry.target_class}</span>` : ''}
          ${isAnnouncement ? `
            <span class="priority-badge" style="
              margin-left: 10px;
              padding: 2px 6px;
              border-radius: 8px;
              font-size: 11px;
              background-color: ${getPriorityColor(entry.priority)};
              color: white;
            ">
              ${getPriorityText(entry.priority)}
            </span>
          ` : ''}
        </div>
        
        ${description ? `
          <div class="event-description" style="color: #555; line-height: 1.4; margin-top: 10px;">
            ${description.replace(/\n/g, '<br>')}
          </div>
        ` : ''}
        
        ${entry.external_link ? `
          <div class="event-link" style="margin-top: 10px;">
            <a href="${entry.external_link}" target="_blank" style="color: #007bff; text-decoration: none;">
              🔗 Περισσότερες πληροφορίες
            </a>
          </div>
        ` : ''}
        
        ${entry.pdf_attachment ? `
          <div class="event-pdf" style="margin-top: 10px;">
            <span style="color: #dc3545;">📄 PDF: ${entry.pdf_attachment}</span>
          </div>
        ` : ''}
      </div>
    </div>
  `;
}

function getEventTypeColor(eventType) {
  switch(eventType) {
    case 'Αναπλήρωση': return '#dc3545';
    case 'Διαγώνισμα': return '#ffc107';
    case 'Εργασία': return '#17a2b8';
    case 'Παρουσίαση': return '#28a745';
    case 'Ενημέρωση': return '#6c757d';
    default: return '#007bff';
  }
}

// Helper functions for announcements
function getPriorityColor(priority) {
  const colors = {
    'low': '#6c757d',
    'normal': '#007bff', 
    'high': '#fd7e14',
    'urgent': '#dc3545'
  };
  return colors[priority] || colors.normal;
}

function getPriorityText(priority) {
  const texts = {
    'low': 'Χαμηλή',
    'normal': 'Κανονική', 
    'high': 'Υψηλή',
    'urgent': 'Επείγουσα'
  };
  return texts[priority] || texts.normal;
}

// Initialize page
document.addEventListener('DOMContentLoaded', async function() {
  try {
    const student = await loadStudentInfo();
    if (!student) return;
    
    displayStudentInfo(student);
    
    const calendarEntries = await loadCalendarEntries(student.id);
    displayCalendarEntries(calendarEntries);
    
    // Load announcements and merge with calendar entries
    const announcements = await loadStudentAnnouncements(student.username);
    const allEntries = mergeCalendarAndAnnouncements(calendarEntries, announcements);
    displayCalendarEntries(allEntries);
    
  } catch (error) {
    console.error('Error initializing calendar page:', error);
    document.getElementById('loadingMessage').textContent = 'Σφάλμα κατά τη φόρτωση της σελίδας.';
  }
});

// Add styles
const style = document.createElement('style');
style.textContent = `
  .event-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    transition: all 0.2s ease;
  }
  
  @media (max-width: 768px) {
    #calendarView {
      grid-template-columns: 1fr !important;
    }
  }
`;
document.head.appendChild(style);

// Notification function
function showNotification(message, type = 'info') {
  // Create notification element
  const notification = document.createElement('div');
  notification.style.cssText = `
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 15px 20px;
    border-radius: 6px;
    color: white;
    font-weight: bold;
    z-index: 10000;
    max-width: 400px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
  `;
  
  // Set background color based on type
  switch(type) {
    case 'success':
      notification.style.background = '#28a745';
      break;
    case 'error':
      notification.style.background = '#dc3545';
      break;
    case 'warning':
      notification.style.background = '#ffc107';
      notification.style.color = '#333';
      break;
    default:
      notification.style.background = '#17a2b8';
  }
  
  notification.textContent = message;
  document.body.appendChild(notification);
  
  // Remove notification after 4 seconds
  setTimeout(() => {
    notification.remove();
  }, 4000);
}
