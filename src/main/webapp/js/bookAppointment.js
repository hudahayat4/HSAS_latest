let currentStep = 0;
const steps = document.querySelectorAll(".step");
const sections = document.querySelectorAll(".section");

const backBtn = document.querySelector(".previous");
const nextBtn = document.querySelector(".nexts");

let selectedDate = null;
let selectedTime = null;

// -----------------------------
// STEP NAVIGATION
// -----------------------------
function updateUI() {
    steps.forEach((step, i) => step.classList.toggle("active", i === currentStep));
    sections.forEach((section, i) => section.classList.toggle("active", i === currentStep));

    if (currentStep === 0) {
        backBtn.style.display = "none";
        nextBtn.textContent = "Next";
        nextBtn.type = "button";
        nextBtn.disabled = false;
        nextBtn.className = "btn nexts"; // reset class
    } else if (currentStep === 1) {
        backBtn.style.display = "inline-block";
        nextBtn.textContent = "Submit";
        nextBtn.type = "submit"; // now it will submit
        nextBtn.disabled = !(selectedDate && selectedTime);
        nextBtn.className = "btn btn-info btn-submit"; // add btn-submit here
    } else if (currentStep === 2) {
        backBtn.style.display = "none";
        nextBtn.style.display = "none"; // hide next button
    } else {
        backBtn.style.display = "inline-block";
        nextBtn.textContent = "Next";
        nextBtn.type = "button";
        nextBtn.disabled = false;
        nextBtn.className = "btn nexts"; // reset class
    }
}


function nextStep() {
	if (currentStep === 0) {
	        currentStep++;
	        updateUI();
	        return;
	    }

	if (currentStep === 1) {

	        // submit form only here
	        document.getElementById("appointmentForm").submit();

	        return;
    	}
}

function prevStep() {
    if (currentStep > 0) {
        currentStep--;
        updateUI();
    }
}

// Initialize on page load
updateUI();

// -----------------------------
// PACKAGE SELECTION
// -----------------------------
function selectPackage(card, packageId, packageName) {

    console.log("CLICKED:", packageId);

    document.getElementById("packageId").value = packageId;
    document.getElementById("confirmPackage").innerText = packageName;

    document.querySelectorAll(".package-card")
        .forEach(c => c.classList.remove("active"));

    card.classList.add("active");
}

// -----------------------------
// CALENDAR
// -----------------------------
const currentMonth = document.querySelector(".current-month");
const calendarDates = document.querySelector(".calendar-dates");
const monthBtns = document.querySelectorAll(".month-btn");

let today = new Date();
today.setHours(0,0,0,0);

let date = new Date();

function renderCalendar() {
    const year = date.getFullYear();
    const month = date.getMonth();

    const prevLastDay = new Date(year, month, 0).getDate();
    const totalMonthDay = new Date(year, month + 1, 0).getDate();
    const startWeekDay = new Date(year, month, 1).getDay();

    calendarDates.innerHTML = "";

    for (let i = 0; i < 42; i++) {
        let day = i - startWeekDay + 1;
        const li = document.createElement("li");

        if(day <= 0){
            li.textContent = prevLastDay + day;
            li.classList.add("padding-day");
        } else if(day > totalMonthDay){
            li.textContent = day - totalMonthDay;
            li.classList.add("padding-day");
        } else {
            li.textContent = day;
            li.classList.add("month-day");
			const selectedDay = new Date(year, month, day);
			selectedDay.setHours(0,0,0,0);

			if (selectedDay < today) {
			    li.classList.add("disabled-date");
			}
            if(day === today.getDate() && month === today.getMonth() && year === today.getFullYear()){
                li.classList.add("current-day");
            }

            // Click event for selecting a date
			li.addEventListener("click", function() {

			    const selectedDay = new Date(year, month, day);
			    selectedDay.setHours(0,0,0,0);

			    if (selectedDay < today) {
			        Swal.fire({
			            icon: "error",
			            title: "Invalid Date",
			            text: "Past dates cannot be selected.",
			            confirmButtonColor: "#17a2b8"
			        });
			        return;
			    }

			    document.querySelectorAll(".calendar-dates li")
			        .forEach(l => l.classList.remove("selected"));

			    this.classList.add("selected");

			    const m = String(month + 1).padStart(2, "0");
			    const d = String(day).padStart(2, "0");

			    selectedDate = `${year}-${m}-${d}`;
			    document.getElementById("apptDate").value = selectedDate;
				selectDate(day, month, year);

			    updateConfirmText();
			    updateUI();
			});
        }

        calendarDates.appendChild(li);
    }
    currentMonth.textContent = date.toLocaleDateString("en-US", { month: "long", year: "numeric" });
}

// Month navigation buttons
monthBtns.forEach(btn => {
    btn.addEventListener("click", () => {
        if(btn.classList.contains("prev")) date.setMonth(date.getMonth() - 1);
        else date.setMonth(date.getMonth() + 1);
        renderCalendar();
    });
});

// Initial render
renderCalendar();

// -----------------------------
// TIME SLOTS
// -----------------------------
document.querySelectorAll(".time-slots li").forEach(slot => {
    slot.addEventListener("click", function() {
        document.querySelectorAll(".time-slots li").forEach(s => s.classList.remove("selected"));
        this.classList.add("selected");
        selectedTime = this.innerText;
        document.getElementById("apptTime").value = selectedTime;
        updateConfirmText();
        updateUI(); // enable submit if on step 2
    });
});



// -----------------------------
// UPDATE CONFIRMATION TEXT
// -----------------------------
function updateConfirmText() {
    document.getElementById("confirmDate").innerText =
        (selectedDate || "-") + " " + (selectedTime || "-");
}


// Inside your loop generating the calendar days:
const dateToRender = new Date(currentYear, currentMonth, dayNumber);

if (dateToRender < today) {
    dateElement.classList.add("disabled-date");
    dateElement.style.pointerEvents = "none"; // Non-clickable
    dateElement.style.opacity = "0.4";
} else {
    dateElement.onclick = () => selectDate(dayNumber, currentMonth, currentYear);
}

function selectDate(day, month, year) {

    const formattedDate =
        `${year}-${String(month + 1).padStart(2,'0')}-${String(day).padStart(2,'0')}`;

    fetch(`AppointmentController?action=checkAvailability&date=${formattedDate}`)
        .then(res => res.json())
        .then(bookedTimes => {

            console.log("Booked Times:", bookedTimes);

            document.querySelectorAll(".time-slots li").forEach(slot => {

                slot.classList.remove("booked");
                slot.classList.remove("selected");

                const slotTime = slot.textContent.trim();

                console.log("Checking:", slotTime);

                if (bookedTimes.includes(slotTime)) {
                    console.log("MATCH:", slotTime);
                    slot.classList.add("booked");
                }
            });
        });
}