import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="admin--dashboard"
export default class extends Controller {
  connect() {
    console.log("Admin dashboard controller connected")
  }
} 