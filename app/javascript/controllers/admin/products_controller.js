import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="admin--products"
export default class extends Controller {
  connect() {
    console.log("Admin products controller connected")
  }
} 