import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  connect() {
    if (this.hasInputTarget && this.hasPreviewTarget) {
      this.inputTarget.addEventListener("change", this.handleFileSelect.bind(this))
    }
  }

  handleFileSelect(event) {
    const file = event.target.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        this.previewTarget.src = e.target.result
        this.previewTarget.classList.remove("hidden")
      }
      reader.readAsDataURL(file)
    }
  }
} 