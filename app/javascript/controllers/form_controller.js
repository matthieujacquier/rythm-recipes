import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step", "shuffleOutput", "foodOutput", "genreShuffleOutput", "musicFormat"];

  connect() {
  }

  goToStep(event) {
  const targetStepIndex = parseInt(event.target.dataset.step, 10);
  const selectedValue = event.target.value;
  const inputName = event.target.name;
  const selectedFood = document.querySelector('input[name="food_type_selection"]:checked')?.value;

  const currentStepIndex = this.stepTargets.findIndex(el => !el.classList.contains("d-none"));

  // Hide music format when going back
  if (this.hasMusicFormatTarget && targetStepIndex < currentStepIndex) {
    this.musicFormatTarget.classList.add("d-none");
  }

  // Update food description if selected
  if (selectedFood && this.hasFoodOutputTarget) {
    this.foodOutputTarget.innerHTML = `Alright, we're gonna cook a ${selectedFood} dish.<br>How difficult should the preparation be?`;
  }

  if (inputName === "food_type_selection" && selectedValue === "Shuffle") {
    const foodOptions = ["Meat", "Vegan", "Vegetarian", "Seafood"];
    const randomFood = foodOptions[Math.floor(Math.random() * foodOptions.length)];
    const foodInput = document.querySelector(`input[name="food_type_selection"][value="${randomFood}"]`);
    if (foodInput) foodInput.checked = true;

    alert("Thank you for trusting us! We'll surprise you with a " + randomFood + " dish!");

    if (this.hasShuffleOutputTarget) {
      this.shuffleOutputTarget.innerText = `🎲 Your surprise food type is: ${randomFood}`;
      this.shuffleOutputTarget.classList.remove("d-none");
    }

    if (this.hasFoodOutputTarget) {
      this.foodOutputTarget.innerHTML = `Alright, we're gonna cook a ${randomFood} dish.<br>How difficult should the preparation be?`;
    }
  }

  else if (inputName === "music_genres[]") {
    if (selectedValue === "Shuffle" && event.target.checked) {
      document.querySelectorAll('input[name="music_genres[]"]').forEach(input => {
        input.checked = false;
      });

      const genreOptions = ["Pop", "Rock", "Hip-Hop", "Rap", "R&B", "Indie", "Electronic", "Dance", "Alternative", "Jazz", "Classical", "Folk", "Country", "Metal", "Punk", "Blues", "Reggae", "Soul", "Funk", "Techno", "Afro"];
      const randomGenre = genreOptions[Math.floor(Math.random() * genreOptions.length)];
      const genreInput = document.querySelector(`input[name="music_genres[]"][value="${randomGenre}"]`);
      if (genreInput) genreInput.checked = true;

      alert(`Surprise! We picked '${randomGenre}' for your music genre.`);

      if (this.hasGenreShuffleOutputTarget) {
        this.genreShuffleOutputTarget.innerText = `🎧 Your surprise genre is: ${randomGenre}`;
        this.genreShuffleOutputTarget.classList.remove("d-none");
      }

      event.target.checked = false;
    } else {
      if (this.hasGenreShuffleOutputTarget) {
        this.genreShuffleOutputTarget.classList.add("d-none");
        this.genreShuffleOutputTarget.innerText = "";
      }
    }

    this.toggleMusicFormatDisplay();
  }

  this.showStep(targetStepIndex);
}


submit() {
  this.element.querySelector("form").submit();
  setTimeout(() => {
    window.location.href = response.url
  }, 200)
}

  toggleMusicFormatDisplay() {
    const anyChecked = Array.from(document.querySelectorAll('input[name="music_genres[]"]'))
      .some(input => input.checked);

    if (this.hasMusicFormatTarget) {
      this.musicFormatTarget.classList.toggle("d-none", !anyChecked);
    }
  }

  showStep(index) {
    this.stepTargets.forEach((step, i) => {
      step.classList.toggle("d-none", i !== index);
    });
  }
}
