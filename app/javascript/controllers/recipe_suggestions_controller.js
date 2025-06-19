import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "button", "error"]

  connect() {
    this.selectedCardId = null

    // Attach close listener once when controller connects
    const closeBtn = this.errorTarget.querySelector('.close-btn')
    if (closeBtn) {
      closeBtn.addEventListener('click', () => {
        this.errorTarget.classList.remove('show')
      })
    }
  }

  select(event) {
    this.cardTargets.forEach(card => card.classList.remove("selected"))
    const clickedCard = event.currentTarget
    clickedCard.classList.add("selected")

    this.selectedCardId = clickedCard.dataset.id
    document.getElementById("selected-recipe-id").value = this.selectedCardId

    this.buttonTarget.classList.remove("disabled")

    // Clear error if previously shown
    this.errorTarget.classList.remove('show')
    const messageSpan = this.errorTarget.querySelector('.message')
    if (messageSpan) messageSpan.textContent = ""
  }

  validate(event) {
    if (!this.selectedCardId) {
      event.preventDefault()

      const alertBox = this.errorTarget
      const messageSpan = alertBox.querySelector('.message')

      if (messageSpan) {
        messageSpan.textContent = "❗ Holy macaroni! Looks like you forgot to select a recipe."
      }

      alertBox.classList.add('show')
    }
  }
}
