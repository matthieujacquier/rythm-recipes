# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "controllers", to: "controllers.js"
pin "controllers/recipe_suggestions_controller", to: "controllers/recipe_suggestions_controller.js"
pin "controllers/music_suggestions_controller", to: "controllers/music_suggestions_controller.js"
pin "controllers/form_controller", to: "controllers/form_controller.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
