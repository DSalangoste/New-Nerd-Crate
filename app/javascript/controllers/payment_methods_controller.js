import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="payment-methods"
export default class extends Controller {
  connect() {
    console.log("PaymentMethods controller connected")
  }
} 