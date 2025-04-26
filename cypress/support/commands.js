// Custom command to login
Cypress.Commands.add('login', (email, password) => {
  cy.visit('/users/sign_in')
  cy.get('#user_email').type(email)
  cy.get('#user_password').type(password)
  cy.get('input[type="submit"]').click()
})

// Custom command to add item to cart
Cypress.Commands.add('addToCart', () => {
  cy.get('.crate-type-card').first().click()
  cy.get('button').contains('Add to Cart').click()
})

// Custom command to fill address form
Cypress.Commands.add('fillAddressForm', (prefix, data) => {
  cy.get(`#${prefix}_first_name`).type(data.firstName)
  cy.get(`#${prefix}_last_name`).type(data.lastName)
  cy.get(`#${prefix}_street_address`).type(data.streetAddress)
  cy.get(`#${prefix}_city`).type(data.city)
  cy.get(`#${prefix}_state`).type(data.state)
  cy.get(`#${prefix}_postal_code`).type(data.postalCode)
  cy.get(`#${prefix}_country`).type(data.country)
  cy.get(`#${prefix}_phone`).type(data.phone)
}) 