import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="addresses"
export default class extends Controller {
  static targets = ["existingForm", "newForm", "existingInput"]

  connect() {
    console.log("Addresses controller connected")
    this.toggleForms()
  }

  toggleForms() {
    const useExisting = this.element.querySelector('input[type="radio"][value="existing"]').checked
    this.existingFormTarget.classList.toggle('d-none', !useExisting)
    this.newFormTarget.classList.toggle('d-none', useExisting)
    this.existingInputTarget.value = useExisting
  }

  toggle(event) {
    this.toggleForms()
  }
} 