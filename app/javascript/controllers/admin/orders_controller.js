import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="admin--orders"
export default class extends Controller {
  connect() {
    console.log("Admin orders controller connected")
  }
} 