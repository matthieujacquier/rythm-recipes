import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]

  select(event) {
    const card = event.currentTarget
    const id = card.dataset.id
    const route = card.dataset.route

    fetch(route, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ music_suggestion_id: id })
    })
    .then(response => {
      if (response.redirected) {
        window.location.href = response.url
      }
    })
  }
}
