describe('Checkout Flow', () => {
  const testUser = {
    email: 'test@example.com',
    password: 'password123'
  }

  const addressData = {
    firstName: 'John',
    lastName: 'Doe',
    streetAddress: '123 Main St',
    city: 'Toronto',
    state: 'Ontario',
    postalCode: 'M5V 2T6',
    country: 'Canada',
    phone: '1234567890'
  }

  beforeEach(() => {
    cy.login(testUser.email, testUser.password)
  })

  it('should complete checkout successfully', () => {
    // Happy path - successful checkout
    // Add item to cart
    cy.visit('/crate_types')
    cy.addToCart()
    
    // Go to cart
    cy.visit('/cart')
    cy.get('.cart-items').should('exist')
    
    // Proceed to checkout
    cy.get('button').contains('Proceed to Checkout').click()
    
    // Fill shipping and billing addresses
    cy.fillAddressForm('shipping_address', addressData)
    cy.fillAddressForm('billing_address', addressData)
    
    // Place order
    cy.get('button').contains('Place Order').click()
    
    // Verify order confirmation
    cy.url().should('include', '/orders')
    cy.get('.alert').should('contain', 'Order was successfully created')
  })

  it('should show error for empty cart checkout', () => {
    // Unhappy path - empty cart
    cy.visit('/cart')
    cy.get('.cart-items').should('not.exist')
    cy.get('button').contains('Proceed to Checkout').should('be.disabled')
  })

  it('should show error for invalid shipping address', () => {
    // Unhappy path - invalid shipping address
    cy.visit('/crate_types')
    cy.addToCart()
    
    cy.visit('/cart')
    cy.get('button').contains('Proceed to Checkout').click()
    
    // Submit with empty required fields
    cy.get('button').contains('Place Order').click()
    
    // Verify validation errors
    cy.get('.alert').should('contain', 'Please fix the errors below')
    cy.get('.field_with_errors').should('exist')
  })
}) 