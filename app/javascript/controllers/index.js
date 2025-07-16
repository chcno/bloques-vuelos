import { Application } from "@hotwired/stimulus"
import CalendarController from "./calendar_controller"
import FlightBlockController from "./flight_block_controller"

window.Stimulus = Application.start()
Stimulus.register("calendar", CalendarController)
Stimulus.register("flight-block", FlightBlockController)
