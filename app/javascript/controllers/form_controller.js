import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step", "shuffleOutput", "genreShuffleOutput"];

  connect() {
    console.log("✅ form_controller connected");
  }

  goToStep(event) {
    const targetStepIndex = parseInt(event.target.dataset.step, 10);
    const selectedValue = event.target.value;
    const inputName = event.target.name;



    if (inputName === "food_type_selection" && selectedValue === "Shuffle") {
      const foodOptions = ["Meat", "Vegan", "Vegetarian", "Fish"];
      const randomFood = foodOptions[Math.floor(Math.random() * foodOptions.length)];
      const foodInput = document.querySelector(`input[name="food_type_selection"][value="${randomFood}"]`);
      if (foodInput) foodInput.checked = true;

      alert("Thank you for trusting us! We'll surprise you with a " + randomFood + " dish!");

      if (this.hasShuffleOutputTarget) {
        this.shuffleOutputTarget.innerText = `🎲 Your surprise food type is: ${randomFood}`;
        this.shuffleOutputTarget.classList.remove("d-none");
      }
    }  else if (inputName === "music_genres[]") {
  if (selectedValue === "Shuffle" && event.target.checked) {
    document.querySelectorAll('input[name="music_genres[]"]').forEach(input => {
      if (input.value !== "Shuffle") input.checked = false;
    });

    event.target.checked = true;

    const genreOptions = ["Pop", "Rock", "Hip-Hop", "Rap", "R&B", "Indie", "Electronic", "Dance", "Alternative", "Jazz", "Classical", "Folk", "Country", "Metal", "Punk", "Blues", "Reggae", "Soul", "Funk", "Techno"];
    const randomGenre = genreOptions[Math.floor(Math.random() * genreOptions.length)];
    const genreInput = document.querySelector(`input[name="music_genres[]"][value="${randomGenre}"]`);
    if (genreInput) genreInput.checked = true;

    alert("Surprise! We picked '" + randomGenre + "' for your music genre.");

    if (this.hasGenreShuffleOutputTarget) {
      this.genreShuffleOutputTarget.innerText = `🎧 Your surprise genre is: ${randomGenre}`;
      this.genreShuffleOutputTarget.classList.remove("d-none");
    }
  }

  if (selectedValue === "Shuffle" && !event.target.checked) {
    if (this.hasGenreShuffleOutputTarget) {
      this.genreShuffleOutputTarget.classList.add("d-none");
      this.genreShuffleOutputTarget.innerText = "";
    }
  }
}

    this.showStep(targetStepIndex);
  }

  showStep(index) {
    this.stepTargets.forEach((step, i) => {
      step.classList.toggle("d-none", i !== index);
    });
  }
}
