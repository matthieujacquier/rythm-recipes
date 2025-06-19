import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "button", "error"]

  connect() {
    this.selectedCardId = null
  }

  select(event) {
    this.cardTargets.forEach(card => card.classList.remove("selected"))
    const clickedCard = event.currentTarget
    clickedCard.classList.add("selected")

    this.selectedCardId = clickedCard.dataset.id
    document.getElementById("selected-recipe-id").value = this.selectedCardId

    this.buttonTarget.classList.remove("disabled")
    this.errorTarget.textContent = "" // clear any existing error
  }

  validate(event) {
    if (!this.selectedCardId) {
      event.preventDefault()
      this.errorTarget.textContent = "❗ Please select a recipe before continuing."
    }
  }
}
