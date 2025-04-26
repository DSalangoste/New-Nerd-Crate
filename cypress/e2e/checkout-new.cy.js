/// <reference types="cypress" />

describe('Checkout Flow - New Approach', () => {
  const testUser = {
    email: 'test@example.com',
    password: 'password123'
  };

  const addressData = {
    firstName: 'John',
    lastName: 'Doe',
    street: '123 Test St',
    city: 'Test City',
    state: 'ON',
    postalCode: 'M5V 2T6',
    phone: '1234567890'
  };

  beforeEach(() => {
    // Login before each test
    cy.visit('/users/sign_in');
    cy.get('#user_email').type(testUser.email);
    cy.get('#user_password').type(testUser.password);
    cy.get('input[name="commit"]').click();
    cy.url().should('not.include', '/users/sign_in');
  });

  it('should complete checkout successfully', () => {
    // Add item to cart
    cy.visit('/crate_types/3'); // Anime Crate Small
    cy.get('button.btn.btn-primary.btn-lg').contains('Add to Cart').click();
    cy.get('.alert-success').should('be.visible');

    // Go to cart
    cy.visit('/cart');
    cy.get('table tbody tr').should('exist');

    // Proceed to checkout
    cy.get('a.btn-primary').contains('Proceed to Checkout').click();
    cy.url().should('include', '/checkout');

    // Select shipping method
    cy.get('#shipping_method').select('standard');

    // If there are existing addresses, select "Use a new address"
    cy.get('body').then($body => {
      if ($body.find('#use_new_shipping').length > 0) {
        cy.get('#use_new_shipping').click();
        // Force the form to be visible
        cy.get('#new_shipping_address').invoke('removeClass', 'd-none');
      }
    });

    // Fill shipping address
    cy.get('input[name="shipping_address[first_name]"]').type(addressData.firstName);
    cy.get('input[name="shipping_address[last_name]"]').type(addressData.lastName);
    cy.get('input[name="shipping_address[address_line_1]"]').type(addressData.street);
    cy.get('input[name="shipping_address[city]"]').type(addressData.city);
    cy.get('select[name="shipping_address[state]"]').select(addressData.state);
    cy.get('input[name="shipping_address[postal_code]"]').type(addressData.postalCode);
    cy.get('input[name="shipping_address[phone]"]').type(addressData.phone);

    // If there are existing addresses, select "Use a new address" for billing
    cy.get('body').then($body => {
      if ($body.find('#use_new_billing').length > 0) {
        cy.get('#use_new_billing').click();
        // Force the form to be visible
        cy.get('#new_billing_address').invoke('removeClass', 'd-none');
      }
    });

    // Fill billing address
    cy.get('input[name="billing_address[first_name]"]').type(addressData.firstName);
    cy.get('input[name="billing_address[last_name]"]').type(addressData.lastName);
    cy.get('input[name="billing_address[address_line_1]"]').type(addressData.street);
    cy.get('input[name="billing_address[city]"]').type(addressData.city);
    cy.get('select[name="billing_address[state]"]').select(addressData.state);
    cy.get('input[name="billing_address[postal_code]"]').type(addressData.postalCode);
    cy.get('input[name="billing_address[phone]"]').type(addressData.phone);

    // Place order
    cy.get('input[type="submit"]').contains('Place Order').click();

    // Verify order confirmation
    cy.url().should('include', '/orders');
    cy.get('.alert-success').should('be.visible').and('contain', 'Order created successfully!');
  });
}); 