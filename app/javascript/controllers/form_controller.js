import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['step']

  goToNext(event) {
    const nextStep = parseInt(event.target.dataset.nextStep, 10);
    const currentStep = nextStep - 1;

    this.stepTargets[currentStep].classList.add('d-none');
    this.stepTargets[nextStep].classList.remove('d-none');
  }

  goToPrevious(event) {
    const prevStep = parseInt(event.target.dataset.previousStep, 10);
    const currentStep = prevStep + 1;

    this.stepTargets[currentStep].classList.add('d-none');
    this.stepTargets[prevStep].classList.remove('d-none');
  }
}
