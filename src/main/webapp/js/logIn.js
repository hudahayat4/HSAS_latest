//Toggle customer/staff form
const customerBtn = document.getElementById('customerBtn');
const staffBtn = document.getElementById('staffBtn');
const customerForm = document.getElementById('customerForm');
const staffForm = document.getElementById('staffForm');

customerBtn.addEventListener('click', () => {
  customerBtn.classList.add('active');
  staffBtn.classList.remove('active');
  customerForm.style.display = 'block';
  staffForm.style.display = 'none';
});

staffBtn.addEventListener('click', () => {
  staffBtn.classList.add('active');
  customerBtn.classList.remove('active');
  staffForm.style.display = 'block';
  customerForm.style.display = 'none';
});

//Password visibility toggle
function setupToggle(inputId, toggleId) {
  const input = document.getElementById(inputId);
  const toggle = document.getElementById(toggleId);
  toggle.addEventListener('click', () => {
    const icon = toggle.querySelector('i');
    if (input.type === 'password') {
      input.type = 'text';
      icon.classList.remove('bi-eye-slash-fill');
      icon.classList.add('bi-eye-fill');
    } else {
      input.type = 'password';
      icon.classList.remove('bi-eye-fill');
      icon.classList.add('bi-eye-slash-fill');
    }
  });
}

setupToggle('custPassword', 'toggleCustPassword');
setupToggle('Password', 'toggleStaffPassword');

//Hide error message bila click kotak (Customer)
const errorMsgCustomer = document.getElementById('errorMsgCustomer');
if(errorMsgCustomer){
  document.getElementById('custUsername').addEventListener('focus', () => {
    errorMsgCustomer.style.display = 'none';
  });
  document.getElementById('custPassword').addEventListener('focus', () => {
    errorMsgCustomer.style.display = 'none';
  });
}

//Hide error message bila click kotak (Staff)
const errorMsgStaff = document.getElementById('errorMsgStaff');
if(errorMsgStaff){
  document.getElementById('Username').addEventListener('focus', () => {
    errorMsgStaff.style.display = 'none';
  });
  document.getElementById('Password').addEventListener('focus', () => {
    errorMsgStaff.style.display = 'none';
  });
}
