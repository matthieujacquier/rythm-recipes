import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['step']

  goToStep(event) {
    const nextStep = parseInt(event.target.dataset.nextStep, 10);
    const currentStep = nextStep - 1;

    this.stepTargets[currentStep].classList.add('d-none');
    this.stepTargets[nextStep].classList.remove('d-none');
  }
}
