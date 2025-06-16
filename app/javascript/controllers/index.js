// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
import RecipeSuggestionsController from "./recipe_suggestions_controller";
application.register("recipe-suggestions", RecipeSuggestionsController);
import MusicSuggestionsController from "./music_suggestions_controller";
application.register("music-suggestions", MusicSuggestionsController);
import FormController from "./form_controller"
application.register("form", FormController)
