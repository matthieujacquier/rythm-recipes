import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="matches"
export default class extends Controller {
  static targets = ["source"]

  copy() {
    console.log(this.sourceTarget.value)
    navigator.clipboard.writeText(this.sourceTarget.value)
    copyBtn.innerHTML = "<i class='fa-solid fa-check'></i> Link was copied to clipboard!"

    setTimeout(() => {
      copyBtn.innerHTML = '<i class="fa-solid fa-share"></i> Share your combo'
    }, 2000)
  }
}
