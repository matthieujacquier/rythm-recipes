import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "button"]

  connect() {
    this.selectedCardId = null
  }

  select(event) {
    // Highlight card
    this.cardTargets.forEach(card => card.classList.remove("selected"))
    event.currentTarget.classList.add("selected")

    // Store selected ID
    this.selectedCardId = event.currentTarget.dataset.id

    // Enable button
    this.buttonTarget.classList.remove("disabled")

    // Inject ID into form

    const hiddenInput = document.getElementById("music-suggestion-id")
    hiddenInput.value = this.selectedCardId

    // Submit form immediately
    document.getElementById("music-selection-form").submit()
  }

}
