import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reviews"
export default class extends Controller {
  connect() {
    console.log("Reviews controller connected")
  }
} 