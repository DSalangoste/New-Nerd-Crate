import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="wishlists"
export default class extends Controller {
  connect() {
    console.log("Wishlists controller connected")
  }
} 