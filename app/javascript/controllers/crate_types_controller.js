import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="crate-types"
export default class extends Controller {
  connect() {
    console.log("CrateTypes controller connected")
  }
} 