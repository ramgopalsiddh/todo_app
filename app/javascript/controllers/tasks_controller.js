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
            .then(response => response.json())
        
    }

    delete(event) {
      const id = event.target.dataset.id;
      const csrfToken = document.querySelector("[name='csrf-token']").content;
  
      fetch(`/tasks/${id}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': csrfToken
        }
      })
        .then(response => {
          if (response.ok) {
            const taskId = response.headers.get("Turbo-Frame");
            const frame = document.getElementById(taskId);
            frame.remove();
          }
        });
    }
}
