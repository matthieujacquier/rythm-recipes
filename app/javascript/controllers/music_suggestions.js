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
}
