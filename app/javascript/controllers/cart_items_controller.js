import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart-items"
export default class extends Controller {
  connect() {
    console.log("CartItems controller connected")
  }
} 