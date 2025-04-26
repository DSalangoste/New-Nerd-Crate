// Custom command for login
Cypress.Commands.add('login', (email, password) => {
  cy.visit('/users/sign_in')
  cy.get('#user_email').type(email)
  cy.get('#user_password').type(password)
  cy.get('input[type="submit"]').click()
  cy.url().should('not.include', '/users/sign_in')
})

// Custom command for adding Anime Crate Small to cart
Cypress.Commands.add('addToCart', () => {
  cy.visit('/crate_types/3') // Using Anime Crate Small since Large is redirecting
  cy.get('button').contains('Add to Cart').click()
  cy.get('.alert-success').should('be.visible')
})

// Custom command for filling address form
Cypress.Commands.add('fillAddressForm', (prefix, data) => {
  cy.get(`input[id*="${prefix}"][id*="first_name"]`).type(data.firstName)
  cy.get(`input[id*="${prefix}"][id*="last_name"]`).type(data.lastName)
  cy.get(`input[id*="${prefix}"][id*="street"]`).type(data.streetAddress)
  cy.get(`input[id*="${prefix}"][id*="city"]`).type(data.city)
  cy.get(`input[id*="${prefix}"][id*="state"]`).type(data.state)
  cy.get(`input[id*="${prefix}"][id*="postal"]`).type(data.postalCode)
  cy.get(`input[id*="${prefix}"][id*="country"]`).type(data.country)
  cy.get(`input[id*="${prefix}"][id*="phone"]`).type(data.phone)
})

// Custom command for waiting for page load
Cypress.Commands.add('waitForPageLoad', () => {
  cy.window().then((win) => {
    return new Cypress.Promise((resolve) => {
      if (win.document.readyState === 'complete') {
        resolve()
      } else {
        win.addEventListener('load', resolve)
      }
    })
  })
}) 