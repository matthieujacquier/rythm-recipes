// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
document.addEventListener("DOMContentLoaded", () => {
    const cards = document.querySelectorAll(".card-product");

    cards.forEach(card => {
      card.addEventListener("click", () => {
        // Only one card can be selected at a time
        // This Removes selection highlight from all cards!
        cards.forEach(c => c.classList.remove("selected-recipe"));

        // Adds the highlight selection to the clicked card
        card.classList.add("selected-recipe");

        const recipeId = card.dataset.id;

        fetch("/matches", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content")
          },
          body: JSON.stringify({ recipe_id: recipeId })
        })
        .then(response => response.json())
        .then(data => {
          console.log("Recipe selected:", data); // Redirect to the recipe page
        });
      });
    });
  });
import FormController from "./form_controller"
application.register("form", FormController)
