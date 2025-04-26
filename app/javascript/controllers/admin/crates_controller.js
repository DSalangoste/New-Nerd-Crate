import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="admin--crates"
export default class extends Controller {
  connect() {
    console.log("Admin crates controller connected")
  }
} 