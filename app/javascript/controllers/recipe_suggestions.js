import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["card", "button"];

  connect() {
    this.selectedCardId = null;
  }

  select(event) {
    // The user can only select one card at a time
    this.cardTargets.forEach(card => card.classList.remove("selected"));
    event.currentTarget.classList.add("selected");

    // each card must have an id? So it can be identified later
    this.buttonTarget.classList.add("disabled");
    this.buttonTarget.href = "#";
    this.selectedCardId = event.currentTarget.dataset.id;
    this.buttonTarget.classList.remove("disabled");
    this.buttonTarget.href = `/match/${this.selectedCardId}`;
  }
}
