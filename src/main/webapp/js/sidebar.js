document.addEventListener("DOMContentLoaded", function () {
    const hamburger = document.querySelector("#toggle-btn");
    const sidebar = document.querySelector("#sidebar");

    if (hamburger && sidebar) {
        hamburger.addEventListener("click", function () {
            sidebar.classList.toggle("expand");
        });
    }
});
