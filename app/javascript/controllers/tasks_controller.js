import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log(this.element)
  }
    
  toggle(e) {
    const id = e.target.dataset.id
    const csrfToken = document.querySelector("[name='csrf-token']").content

    fetch(`/tasks/${id}/toggle`, {
      method: 'POST',
      mode: 'cors',
      cache: 'no-cache',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({ completed: e.target.checked })
    })
      .then(response => {
      // this is refrsh a specific turbo frame after toggle executed
    if (response.ok) {
      response.text().then(function(stream) {
        const frameId = `task_${id}`;
        const frame = document.getElementById(frameId);
          if (frame) {
            frame.innerHTML = stream;
          }
        });
      }
    });
  }


  async delete(e) {
    e.preventDefault();
    const id = e.target.dataset.id;
    const csrfToken = document.querySelector("[name='csrf-token']").content;

    const response = await fetch(`/tasks/${id}`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': csrfToken,
        'Accept': 'text/vnd.turbo-stream.html'
      }
    });

    if (response.ok) {
      const taskId = `task_${id}`;
      const frame = document.getElementById(taskId);
      if (frame) {
        frame.remove();
      }
    }
  }
}
