// Add for Bootstrap

//= require jquery3
//= require popper
//= require bootstrap-sprockets

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


// Function to update the current time, day, and date
function updateDateTime() {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    
    const now = new Date();
    const dayOfWeek = days[now.getDay()];
    const month = months[now.getMonth()];
    const date = now.getDate();
    const year = now.getFullYear();
    let hours = now.getHours();
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const seconds = now.getSeconds().toString().padStart(2, '0');
    const ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    hours = hours ? hours : 12; 
  
    const currentTimeString = `${hours}:${minutes}:${seconds} ${ampm},`;
    const currentDateString = `${dayOfWeek}, ${month} ${date}, ${year}`;
    
    document.getElementById('currentDateTime').textContent = `${currentTimeString} ${currentDateString}`;
  }
  
  // Update the date and time immediately
  updateDateTime();
  
  // Update the date and time every second
  setInterval(updateDateTime, 100);