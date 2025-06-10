import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="matches"
export default class extends Controller {
  static targets = ["source"]

  connect() {
  }

  copy() {
    console.log(this.sourceTarget.value)
    navigator.clipboard.writeText(this.sourceTarget.value)
    copyBtn.innerHTML = "<i class='fa-solid fa-check'></i> Link was copied to clipboard!"

    setTimeout(() => {
      copyBtn.innerHTML = '<i class="fa-solid fa-share"></i> Share your cooking experience'
    }, 2000)
  }
}
