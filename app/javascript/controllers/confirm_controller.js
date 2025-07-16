// controllers/confirm_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  confirm(event) {
    if (!confirm(this.data.get("message"))) {
      event.preventDefault()
    }
  }
}
