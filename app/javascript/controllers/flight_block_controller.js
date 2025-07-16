import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["instructor", "safety", "student2"]

  connect() {
    console.log("✅ Stimulus flight_block_controller conectado!")

    // Si hay un valor seleccionado al cargar, mostrar campos correctos
    const select = this.element.querySelector("[name='flight_block[flight_type]']")
    if (select && select.value) {
      this.showFields(select.value)
    }
  }

  change(event) { 
    const value = event.target.value
    console.log("➡️ Cambió tipo de vuelo:", value)
    this.showFields(value)
  }

  showFields(type) {
    // Ocultar todos
    this.instructorTarget.classList.add("hidden")
    this.safetyTarget.classList.add("hidden")
    this.student2Target.classList.add("hidden")

    if (type === "instruccion") {
      this.instructorTarget.classList.remove("hidden")
    }
    if (type === "safety") {
      this.safetyTarget.classList.remove("hidden")
    }
    if (type === "compartido") {
      this.student2Target.classList.remove("hidden")
    }
    // prueba_acc → no muestra nada extra
  }
}
