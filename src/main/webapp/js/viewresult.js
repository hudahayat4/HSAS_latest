document.getElementById("viewResultBtn").addEventListener("click", function () {
    const resultSection = document.getElementById("resultSection");

    resultSection.classList.remove("d-none"); // show results
    this.style.display = "none";              // optional: hide button
});

