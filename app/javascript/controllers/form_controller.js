import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step", "shuffleOutput", "foodOutput", "genreShuffleOutput", "musicFormat"];

  connect() {
    const urlParams = new URLSearchParams(window.location.search);
    const stepIndex = parseInt(urlParams.get("step"), 10);

    if (!isNaN(stepIndex)) {
      this.showStep(stepIndex);
    } else {
      this.showStep(0);
    }

    const formatInput = document.querySelector('input[name="music_format_selection"]:checked');
    if (formatInput && this.hasMusicFormatTarget) {
      this.musicFormatTarget.classList.remove("d-none");
    }
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

    // Reselecting difficulty — trigger visibility check for music format
    if (inputName === "difficulty_selection") {
      this.toggleMusicFormatDisplay();
    }

    // Shuffle logic (unchanged)
    if (inputName === "food_type_selection" && selectedValue === "Shuffle") {
      const foodOptions = ["Meat", "Vegan", "Vegetarian", "Seafood"];
      const randomFood = foodOptions[Math.floor(Math.random() * foodOptions.length)];
      const foodInput = document.querySelector(`input[name="food_type_selection"][value="${randomFood}"]`);
      if (foodInput) foodInput.checked = true;



      if (this.hasShuffleOutputTarget) {
        this.shuffleOutputTarget.classList.remove("d-none");
      }

      if (this.hasFoodOutputTarget) {
        this.foodOutputTarget.innerHTML = `Alright, we're gonna cook a ${randomFood} dish.<br>How difficult should the preparation be?`;
      }
    }

    // Genre shuffle logic (unchanged)
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

  handleShuffleClick(event) {
    event.preventDefault();

    const foodOptions = ["Meat", "Vegan", "Vegetarian", "Seafood"];
    const randomFood = foodOptions[Math.floor(Math.random() * foodOptions.length)];
    this.selectedShuffle = randomFood;

    // ❌ Uncheck all current selections (including Shuffle)
    document.querySelectorAll('input[name="food_type_selection"]').forEach(input => {
      input.checked = false;
    });

    // ✅ Check the randomly selected one
    const selectedInput = document.querySelector(`input[name="food_type_selection"][value="${randomFood}"]`);
    if (selectedInput) selectedInput.checked = true;

    // 🟣 Update modal content
    const modalBody = document.getElementById("shuffleModalBody");
    modalBody.innerText = `We'll surprise you with a ${randomFood} dish!`;

    // 🟣 Show the modal
    const modal = new bootstrap.Modal(document.getElementById("shuffleModal"));
    modal.show();
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

  confirmShuffle() {
    if (!this.selectedShuffle) return;

    // Set the checked value again to ensure state
    const foodInput = document.querySelector(`input[name="food_type_selection"][value="${this.selectedShuffle}"]`);
    if (foodInput) foodInput.checked = true;

    // Update the next step prompt
    if (this.hasFoodOutputTarget) {
      this.foodOutputTarget.innerHTML =
        `Alright, we're gonna cook a ${this.selectedShuffle} dish.<br>How difficult should the preparation be?`;
    }

    // Close the modal
    const modal = bootstrap.Modal.getInstance(document.getElementById("shuffleModal"));
    if (modal) modal.hide();

    // Advance to the next step
    this.showStep(1);
  }

}
