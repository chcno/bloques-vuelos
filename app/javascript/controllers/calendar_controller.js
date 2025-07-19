import { Controller } from "@hotwired/stimulus"
import { Calendar } from "@fullcalendar/core"
import dayGridPlugin from "@fullcalendar/daygrid"
import timeGridPlugin from "@fullcalendar/timegrid"
import interactionPlugin from "@fullcalendar/interaction"

export default class extends Controller {
  connect() {
    console.log("✅ FullCalendar Stimulus Controller conectado!")

    const calendarEl = this.element

    const calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
      initialView: 'timeGridWeek',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay'
      },
        // ⏰ Aquí defines el rango horario visible:
  slotMinTime: "06:00:00",  // Empieza a las 6 a.m.
  slotMaxTime: "22:00:00",  // Termina a las 6 p.m.
      events: '/flight_blocks/calendar.json',
      editable: true,
      eventDrop: this.handleEventDrop.bind(this),
      eventContent: this.renderEventContent.bind(this),
        eventDidMount: this.handleEventDidMount.bind(this)

    })

    calendar.render()
  }

  handleEventDrop(info) {
    if (info.event.id.startsWith("maintenance-")) {
      alert("⚠️ Los mantenimientos no se pueden mover.")
      info.revert()
      return
    }

    console.log("Evento movido, id:", info.event.id)
    console.log("✅ PATCH URL:", `/flight_blocks/${info.event.id}`)

    const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    const newStart = info.event.start.toISOString()
    const newEnd = info.event.end ? info.event.end.toISOString() : null

    fetch(`/flight_blocks/${info.event.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": token
      },
      body: JSON.stringify({
        flight_block: {
          start_time: newStart,
          end_time: newEnd
        }
      })
    })
      .then(response => {
        console.log("🔴 STATUS FETCH:", response.status)
        if (response.ok) {
          console.log("✅ Bloque actualizado en el servidor!")
        } else {
          console.error("🚫 Error actualizando bloque.")
          info.revert()
        }
      })
      .catch(error => {
        console.error("🚫 Error de red:", error)
        info.revert()
      })
  }

  renderEventContent(arg) {
    const isMaintenance = arg.event.id.startsWith("maintenance-");
    const editUrl = `/flight_blocks/${arg.event.id}/edit`;

    return {
      html: `
             <div class="flex flex-col w-full">
        <span class="text-[10px] text-white-500">${arg.timeText} </span>
        <div class="flex justify-between items-center">
          <span class="text-xs text-white-800">${arg.event.title}</span>
             

          ${
            isMaintenance
            ? ''
            : `<a href="${editUrl}" 
                  class="text-indigo-600 hover:text-indigo-900 text-xs ml-2" 
                  title="Editar bloque"
                  onclick="event.stopPropagation()">
                ✏️
               </a>`
          }
        </div>
      `
    };
  }
  handleEventDidMount(info) {
  let tooltip = info.event.title;

  if (info.event.extendedProps.notes) {
    tooltip += `\nNotas: ${info.event.extendedProps.notes}`;
  }

  info.el.setAttribute("title", tooltip);
}

}
