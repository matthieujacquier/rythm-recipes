import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open(event) {
    const modalId = event.currentTarget.dataset.modalId
    const modal = document.getElementById(modalId)
    modal.classList.add("show", "d-block")
    modal.removeAttribute("aria-hidden")
    modal.setAttribute("aria-modal", "true")
  }

  close(event) {
    event.preventDefault()
    const modal = event.currentTarget.closest(".modal")
    modal.classList.remove("show", "d-block")
    modal.setAttribute("aria-hidden", "true")
    modal.removeAttribute("aria-modal")
  }
}
