// Mock Data
const appointments = [
    { day: 'Tue', date: '7', name: 'Nazmeen', time: '10:00am', bg: '#fff5f5' },
    { day: 'Fri', date: '11', name: 'Humaira', time: '11:00am', bg: '#f0faff' },
    { day: 'Mon', date: '13', name: 'Afiqah', time: '10:00am', bg: '#f9f9f9' }
];

const prescriptions = [
    { name: 'Humaira', type: 'Lipid Profile', date: '18/08/25', time: '10:00 AM', status: 'Read' },
    { name: 'Elena', type: 'Blood uric acid', date: '19/09/25', time: '10:00 AM', status: 'Unread' }
];

document.addEventListener('DOMContentLoaded', () => {
    renderAppointments();
    renderPrescriptions();
});

function renderAppointments() {
    const container = document.getElementById('appointment-list');
    container.innerHTML = appointments.map(apt => `
        <div class="apt-item" style="background-color: ${apt.bg}">
            <div class="apt-date-box">
                <div style="font-size: 10px; color: #888;">${apt.day}</div>
                <div style="font-size: 18px; font-weight: bold;">${apt.date}</div>
            </div>
            <div class="apt-info">
                <div style="font-weight: 600;">${apt.name}</div>
                <div style="font-size: 12px; color: #888;">${apt.time}</div>
            </div>
            <div style="margin-left: auto; color: #ccc;">></div>
        </div>
    `).join('');
}

function renderPrescriptions() {
    const container = document.getElementById('prescription-grid');
    container.innerHTML = prescriptions.map(rx => `
        <div class="rx-card">
            <div class="rx-avatar"></div>
            <h4 style="margin: 10px 0 5px;">${rx.name}</h4>
            <span class="tag">${rx.type}</span>
            <hr style="border: 0; border-top: 1px solid #f0f0f0; margin: 15px 0;">
            <div style="display: flex; justify-content: space-between; font-size: 12px;">
                <span>🕒 ${rx.time}</span>
            </div>
            <div style="text-align: left; font-size: 13px; font-weight: bold; margin-top: 5px;">
                ${rx.date}
            </div>
            <button class="status-btn ${rx.status === 'Read' ? 'btn-read' : 'btn-unread'}">
                ${rx.status}
            </button>
        </div>
    `).join('');
}