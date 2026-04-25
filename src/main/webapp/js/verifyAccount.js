document.addEventListener("DOMContentLoaded", function () {
  const inputs = document.querySelectorAll(".code-input");
  const errorMsg = document.getElementById("errorMsg");
  const resendLink = document.getElementById("resendLink");
  const cooldownMsg = document.getElementById("cooldownMsg");
  const alertPlaceholder = document.getElementById('liveAlertPlaceholder');

  // Auto focus pada kotak pertama
  if (inputs.length > 0) inputs[0].focus();

  // Input logic
  inputs.forEach((input, index) => {
    input.addEventListener("input", () => {
      if (!/^[0-9]$/.test(input.value)) {
        input.value = "";
        errorMsg.textContent = "Please enter numbers only.";
        return;
      } else {
        errorMsg.textContent = "";
      }
      if (input.value.length === 1 && index < inputs.length - 1) {
        inputs[index + 1].focus();
      }
    });

    input.addEventListener("keydown", (e) => {
      if (e.key === "Backspace" && input.value === "" && index > 0) {
        inputs[index - 1].focus();
      }
    });
  });

  // Resend link logic
  if (resendLink) {
    resendLink.addEventListener("click", function (e) {
      e.preventDefault();
      startCooldown();
      document.getElementById("resendForm").submit();
    });
  }

  // Cooldown function
  function startCooldown() {
    let timeLeft = 120;
    resendLink.classList.add("disabled");
    cooldownMsg.textContent = "You can resend again in " + timeLeft + "s.";

    const timer = setInterval(() => {
      timeLeft--;
      cooldownMsg.textContent = "You can resend again in " + timeLeft + "s.";
      if (timeLeft <= 0) {
        clearInterval(timer);
        resendLink.classList.remove("disabled");
        cooldownMsg.textContent = "";
      }
    }, 1000);
  }

  // Alert function (Bootstrap style)
  function appendAlert(message, type) {
    const wrapper = document.createElement('div');
    wrapper.innerHTML = [
      `<div class="alert alert-${type} alert-dismissible fade show" role="alert">`,
      `   <div>${message}</div>`,
      '   <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>',
      '</div>'
    ].join('');
    alertPlaceholder.append(wrapper);
  }

  // Auto trigger alert dari server (JSP inject)
  const serverMessage = document.getElementById("liveAlertPlaceholder").getAttribute("data-message");
  const serverType = document.getElementById("liveAlertPlaceholder").getAttribute("data-type");
  if (serverMessage) {
    appendAlert(serverMessage, serverType || "info");
  }
});

// Combine code function
function combineCode() {
  const inputs = document.querySelectorAll(".code-input");
  let fullCode = "";
  inputs.forEach(input => {
    fullCode += input.value;
  });
  document.getElementById("verificationCode").value = fullCode;
}
