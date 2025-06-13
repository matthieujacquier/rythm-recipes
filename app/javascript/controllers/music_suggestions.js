// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static targets = ["card", "button"]

//   connect() {
//     console.log("music_suggestions Stimulus controller connected")
//     this.selectedCardId = null
//   }

//   select(event) {
//     this.cardTargets.forEach(card => card.classList.remove("selected"))
//     event.currentTarget.classList.add("selected")

//     this.selectedCardId = event.currentTarget.dataset.id

//     this.buttonTarget.classList.remove("disabled")
//     this.buttonTarget.href = `/recipe_suggestions`
//   }
// }

import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["card", "button"]
  connect() {
    console.log("music_suggestions Stimulus controller connected")
    this.selectedCardId = null
  }
  select(event) {
    this.cardTargets.forEach(card => card.classList.remove("selected"))
    event.currentTarget.classList.add("selected")
    this.selectedCardId = event.currentTarget.dataset.id
    this.buttonTarget.classList.remove("disabled")
  }
  submitForm(event) {
    event.preventDefault(); // Prevent default form submission
    if (this.selectedCardId) {
      // Optionally, you can do something with this.selectedCardId
      // For example, you can send it to the server or use it in the next step
      this.element.submit(); // Submit the form programmatically
    } else {
      alert("Please select a music suggestion before proceeding.");
    }
  }
}
