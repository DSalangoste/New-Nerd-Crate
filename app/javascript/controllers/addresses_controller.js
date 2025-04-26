import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="addresses"
export default class extends Controller {
  connect() {
    console.log("Addresses controller connected")
  }
} 