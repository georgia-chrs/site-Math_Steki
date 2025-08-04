// Διαχείριση Βάσεων Σχολών - Admin Panel JavaScript

let currentFiles = [];
let editingFileId = null;
let selectedFile = null;

// DOM Elements
const alertContainer = document.getElementById('alert-container');
const tableLoading = document.getElementById('table-loading');
const filesTable = document.getElementById('files-table');
const filesTbody = document.getElementById('files-tbody');
const filesCount = document.getElementById('files-count');
const searchInput = document.getElementById('search-input');
const addNewBtn = document.getElementById('add-new-btn');
const refreshBtn = document.getElementById('refresh-btn');

// Modal Elements
const fileModal = document.getElementById('file-modal');
const modalTitle = document.getElementById('modal-title');
const fileForm = document.getElementById('file-form');
const closeModal = document.querySelector('.close');
const cancelBtn = document.getElementById('cancel-btn');

// Form Elements
const fileTitle = document.getElementById('file-title');
const fileYear = document.getElementById('file-year');
const fileLykeio = document.getElementById('file-lykeio');
const fileField = document.getElementById('file-field');
const fileDescription = document.getElementById('file-description');
const fileInput = document.getElementById('file-input');
const fileUploadArea = document.getElementById('file-upload-area');
const fileInfo = document.getElementById('file-info');
const selectedFilename = document.getElementById('selected-filename');

// Statistics Elements
const totalFilesEl = document.getElementById('total-files');
const gelFilesEl = document.getElementById('gel-files');
const epalFilesEl = document.getElementById('epal-files');
const latestYearEl = document.getElementById('latest-year');

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    loadFiles();
    setupEventListeners();
});

// Event Listeners
function setupEventListeners() {
    addNewBtn.addEventListener('click', () => openModal());
    refreshBtn.addEventListener('click', loadFiles);
    searchInput.addEventListener('input', filterFiles);
    
    // Modal events
    closeModal.addEventListener('click', () => closeModalFunc());
    cancelBtn.addEventListener('click', () => closeModalFunc());
    fileForm.addEventListener('submit', handleSubmit);
    
    // File upload events
    fileUploadArea.addEventListener('click', () => fileInput.click());
    fileUploadArea.addEventListener('dragover', handleDragOver);
    fileUploadArea.addEventListener('drop', handleDrop);
    fileInput.addEventListener('change', handleFileSelect);
    
    // Close modal when clicking outside
    window.addEventListener('click', (event) => {
        if (event.target === fileModal) {
            closeModalFunc();
        }
    });
}

// Load Files
async function loadFiles() {
    try {
        tableLoading.style.display = 'block';
        filesTable.style.display = 'none';
        
        const response = await fetch('/api/vaseis-scholon');
        if (!response.ok) throw new Error('Σφάλμα λήψης αρχείων');
        
        currentFiles = await response.json();
        displayFiles(currentFiles);
        updateStatistics(currentFiles);
        
        tableLoading.style.display = 'none';
        filesTable.style.display = 'table';
        
    } catch (error) {
        console.error('Σφάλμα φόρτωσης αρχείων:', error);
        showAlert('Σφάλμα φόρτωσης αρχείων βάσεων σχολών', 'error');
        tableLoading.style.display = 'none';
    }
}

// Display Files
function displayFiles(files) {
    if (files.length === 0) {
        filesTbody.innerHTML = `
            <tr>
                <td colspan="8" style="text-align: center; padding: 40px; color: #666;">
                    Δεν υπάρχουν αρχεία βάσεων σχολών
                </td>
            </tr>
        `;
        filesCount.textContent = 'Κανένα αρχείο';
        return;
    }

    filesTbody.innerHTML = files.map((file, index) => `
        <tr>
            <td>${index + 1}</td>
            <td class="file-cell" title="${file.title}">
                <strong>${file.title}</strong>
                ${file.description ? `<br><small style="color: #666;">${file.description}</small>` : ''}
            </td>
            <td>${file.year}</td>
            <td>
                <span class="badge ${file.lykeio === 'ΓΕΛ' ? 'badge-gel' : 'badge-epal'}">
                    ${file.lykeio}
                </span>
            </td>
            <td>${file.field}</td>
            <td>${file.file_size || 'Άγνωστο'}</td>
            <td>${file.upload_date || 'Άγνωστη'}</td>
            <td class="actions-cell">
                <button onclick="viewFile(${file.id})" class="btn-success" title="Προβολή">
                    👁️
                </button>
                <button onclick="downloadFile(${file.id})" class="btn-secondary" title="Λήψη">
                    📥
                </button>
                <button onclick="editFile(${file.id})" class="btn-primary" title="Επεξεργασία">
                    ✏️
                </button>
                <button onclick="deleteFile(${file.id})" class="btn-danger" title="Διαγραφή">
                    🗑️
                </button>
            </td>
        </tr>
    `).join('');

    filesCount.textContent = `${files.length} αρχεία`;
}

// Update Statistics
function updateStatistics(files) {
    totalFilesEl.textContent = files.length;
    
    const gelFiles = files.filter(f => f.lykeio === 'ΓΕΛ').length;
    const epalFiles = files.filter(f => f.lykeio === 'ΕΠΑΛ').length;
    
    gelFilesEl.textContent = gelFiles;
    epalFilesEl.textContent = epalFiles;
    
    const years = files.map(f => parseInt(f.year)).filter(y => !isNaN(y));
    const latestYear = years.length > 0 ? Math.max(...years) : '-';
    latestYearEl.textContent = latestYear;
}

// Filter Files
function filterFiles() {
    const searchTerm = searchInput.value.toLowerCase().trim();
    
    if (!searchTerm) {
        displayFiles(currentFiles);
        return;
    }
    
    const filteredFiles = currentFiles.filter(file => 
        file.title.toLowerCase().includes(searchTerm) ||
        file.year.includes(searchTerm) ||
        file.lykeio.toLowerCase().includes(searchTerm) ||
        file.field.toLowerCase().includes(searchTerm) ||
        (file.description && file.description.toLowerCase().includes(searchTerm))
    );
    
    displayFiles(filteredFiles);
}

// Modal Functions
function openModal(file = null) {
    editingFileId = file ? file.id : null;
    modalTitle.textContent = file ? 'Επεξεργασία Βάσης Σχολών' : 'Προσθήκη Νέας Βάσης Σχολών';
    
    // Reset form
    fileForm.reset();
    selectedFile = null;
    fileInfo.style.display = 'none';
    
    // Fill form if editing
    if (file) {
        fileTitle.value = file.title;
        fileYear.value = file.year;
        fileLykeio.value = file.lykeio;
        fileField.value = file.field;
        fileDescription.value = file.description || '';
    }
    
    fileModal.style.display = 'block';
}

function closeModalFunc() {
    fileModal.style.display = 'none';
    editingFileId = null;
    selectedFile = null;
}

// File Upload Handlers
function handleDragOver(e) {
    e.preventDefault();
    fileUploadArea.classList.add('dragover');
}

function handleDrop(e) {
    e.preventDefault();
    fileUploadArea.classList.remove('dragover');
    
    const files = e.dataTransfer.files;
    if (files.length > 0) {
        handleFileSelection(files[0]);
    }
}

function handleFileSelect(e) {
    const files = e.target.files;
    if (files.length > 0) {
        handleFileSelection(files[0]);
    }
}

function handleFileSelection(file) {
    if (file.type !== 'application/pdf') {
        showAlert('Μόνο PDF αρχεία επιτρέπονται', 'error');
        return;
    }
    
    if (file.size > 10 * 1024 * 1024) { // 10MB
        showAlert('Το αρχείο είναι πολύ μεγάλο (μέγιστο 10MB)', 'error');
        return;
    }
    
    selectedFile = file;
    selectedFilename.textContent = file.name;
    fileInfo.style.display = 'block';
}

// Form Submit
async function handleSubmit(e) {
    e.preventDefault();
    
    const title = fileTitle.value.trim();
    const year = fileYear.value;
    const lykeio = fileLykeio.value;
    const field = fileField.value;
    const description = fileDescription.value.trim();
    
    // Validation
    if (!title || !year || !lykeio || !field) {
        showAlert('Παρακαλώ συμπληρώστε όλα τα υποχρεωτικά πεδία', 'error');
        return;
    }
    
    if (!editingFileId && !selectedFile) {
        showAlert('Παρακαλώ επιλέξτε ένα PDF αρχείο', 'error');
        return;
    }
    
    try {
        const saveBtn = document.getElementById('save-btn');
        saveBtn.disabled = true;
        saveBtn.textContent = 'Αποθήκευση...';
        
        const formData = {
            title,
            year,
            lykeio,
            field,
            description,
            filename: selectedFile ? selectedFile.name : undefined
        };
        
        // Add file data if new file is selected
        if (selectedFile) {
            const fileData = await fileToBase64(selectedFile);
            formData.fileData = fileData;
        }
        
        const url = editingFileId ? `/api/vaseis-scholon/${editingFileId}` : '/api/vaseis-scholon';
        const method = editingFileId ? 'PUT' : 'POST';
        
        const response = await fetch(url, {
            method,
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(formData)
        });
        
        const result = await response.json();
        
        if (response.ok) {
            showAlert(
                editingFileId ? 'Η βάση σχολών ενημερώθηκε επιτυχώς' : 'Η βάση σχολών προστέθηκε επιτυχώς',
                'success'
            );
            closeModalFunc();
            loadFiles();
        } else {
            throw new Error(result.error || 'Σφάλμα αποθήκευσης');
        }
        
    } catch (error) {
        console.error('Σφάλμα αποθήκευσης:', error);
        showAlert('Σφάλμα αποθήκευσης: ' + error.message, 'error');
    } finally {
        const saveBtn = document.getElementById('save-btn');
        saveBtn.disabled = false;
        saveBtn.textContent = 'Αποθήκευση';
    }
}

// File Actions
function viewFile(id) {
    window.open(`/api/vaseis-scholon/${id}/download`, '_blank');
}

function downloadFile(id) {
    const link = document.createElement('a');
    link.href = `/api/vaseis-scholon/${id}/download`;
    link.download = '';
    link.click();
}

function editFile(id) {
    const file = currentFiles.find(f => f.id === id);
    if (file) {
        openModal(file);
    }
}

async function deleteFile(id) {
    const file = currentFiles.find(f => f.id === id);
    if (!file) return;
    
    if (!confirm(`Είστε σίγουροι ότι θέλετε να διαγράψετε τη βάση σχολών "${file.title}";`)) {
        return;
    }
    
    try {
        const response = await fetch(`/api/vaseis-scholon/${id}`, {
            method: 'DELETE'
        });
        
        const result = await response.json();
        
        if (response.ok) {
            showAlert('Η βάση σχολών διαγράφηκε επιτυχώς', 'success');
            loadFiles();
        } else {
            throw new Error(result.error || 'Σφάλμα διαγραφής');
        }
        
    } catch (error) {
        console.error('Σφάλμα διαγραφής:', error);
        showAlert('Σφάλμα διαγραφής: ' + error.message, 'error');
    }
}

// Utility Functions
function fileToBase64(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => resolve(reader.result);
        reader.onerror = error => reject(error);
    });
}

function showAlert(message, type = 'success') {
    const alertClass = type === 'success' ? 'alert-success' : 'alert-error';
    const alertHTML = `
        <div class="alert ${alertClass}">
            ${message}
            <button onclick="this.parentElement.remove()" style="float: right; background: none; border: none; font-size: 18px; cursor: pointer;">&times;</button>
        </div>
    `;
    
    alertContainer.innerHTML = alertHTML;
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        const alertElement = alertContainer.querySelector('.alert');
        if (alertElement) {
            alertElement.remove();
        }
    }, 5000);
}
