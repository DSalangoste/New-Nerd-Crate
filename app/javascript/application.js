// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"

// Bootstrap
import "bootstrap"

// Add CSRF token to all AJAX requests
document.addEventListener('DOMContentLoaded', function() {
  const token = document.querySelector('meta[name="csrf-token"]')?.content;
  if (token) {
    const headers = new Headers({
      'X-CSRF-Token': token,
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });

    // Add CSRF token to fetch requests
    const originalFetch = window.fetch;
    window.fetch = function(url, options = {}) {
      options.headers = { ...headers, ...options.headers };
      return originalFetch(url, options);
    };

    // Add CSRF token to XMLHttpRequest
    const originalXHR = window.XMLHttpRequest;
    window.XMLHttpRequest = function() {
      const xhr = new originalXHR();
      const originalOpen = xhr.open;
      xhr.open = function() {
        const result = originalOpen.apply(this, arguments);
        this.setRequestHeader('X-CSRF-Token', token);
        return result;
      };
      return xhr;
    };
  }
});
