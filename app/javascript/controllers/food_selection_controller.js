import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
   console.log("CONTROLLER CONNECTED");
  }

  submitForm(event) {
    const selectedValue = event.target.value;
    if (selectedValue !== "Shuffle") {
      this.element.submit();
    }
  }

  handleShuffle(event) {
    const selectedValue = event.target.value;
    const shuffleInfoDiv = this.element.querySelector("#shuffle-info");

    if (selectedValue === "Shuffle") {
      const foodTypes = ["Meat", "Vegan", "Vegetarian", "Fish"];
      const randomType = foodTypes[Math.floor(Math.random() * foodTypes.length)];
       alert(`Thanks for trusting us! We decided a ${randomType} dish would be perfect for you!`);
      shuffleInfoDiv.style.display = "block";
      this.element.submit();
    } else {
      shuffleInfoDiv.style.display = "none";
    }
  }

  reshuffle() {
    alert("Reshuffling!");
    const shuffleRadioButton = this.element.querySelector('input[value="Shuffle"]');
    if (shuffleRadioButton) {
      shuffleRadioButton.checked = true;
      this.element.submit();
    }
  }
}
