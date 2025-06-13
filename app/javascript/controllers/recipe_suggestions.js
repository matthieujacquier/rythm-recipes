import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "button"]

  connect() {
    this.selectedCardId = null
  }

  select(event) {
    // Unselect all, then select clicked
    this.cardTargets.forEach(card => card.classList.remove("selected"))
    const clickedCard = event.currentTarget
    clickedCard.classList.add("selected")

    this.selectedCardId = clickedCard.dataset.id

    // Fill hidden input
    const hiddenInput = document.getElementById("selected-recipe-id")
    hiddenInput.value = this.selectedCardId

    // Enable button
    this.buttonTarget.classList.remove("disabled")
  }
}
