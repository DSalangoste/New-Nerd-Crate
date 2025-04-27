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
    cy.visit('/crate_types/23'); // All-in-one Crate
    
    // Debug: Log the page content to see what's actually there
    cy.get('body').then($body => {
      cy.log('Page content:', $body.html());
    });
    
    // Try a more generic selector first
    cy.get('button').contains('Add to Cart').should('exist').click();
    
    // Alternative approach if the above doesn't work
    // cy.get('form').contains('Add to Cart').click();
    
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

    // Debug: Log the form content to see what's actually there
    cy.get('form').then($form => {
      cy.log('Form content:', $form.html());
      
      // Log all form values
      const formData = new FormData($form[0]);
      for (let pair of formData.entries()) {
        cy.log('Form field:', pair[0], pair[1]);
      }
      
      // Log form attributes
      cy.log('Form action:', $form.attr('action'));
      cy.log('Form method:', $form.attr('method'));
      cy.log('Form data-turbo:', $form.attr('data-turbo'));
    });

    // Check for any validation errors before submission
    cy.get('.field_with_errors').should('not.exist').then(() => {
      cy.log('No validation errors found');
    });

    // Disable Turbo and any other JS that might interfere
    cy.get('form').invoke('attr', 'data-turbo', 'false');
    cy.get('form').invoke('attr', 'data-remote', 'false');
    
    // Intercept both POST and GET requests to handle the redirect
    cy.intercept('POST', '**/checkout').as('checkoutSubmission');
    cy.intercept('GET', '**/orders/*').as('orderRedirect');

    // Place order - try multiple approaches
    cy.get('body').then($body => {
      cy.log('Attempting to submit form...');
      
      // Try to find the button by ID
      if ($body.find('#place-order-button').length) {
        cy.log('Found button by ID');
        cy.get('#place-order-button').click({ force: true });
      } 
      // Try to find by class and text
      else if ($body.find('.btn-primary').contains('Place Order').length) {
        cy.log('Found button by class and text');
        cy.get('.btn-primary').contains('Place Order').click({ force: true });
      }
      // Try to find by input type and value
      else if ($body.find('input[type="submit"][value="Place Order"]').length) {
        cy.log('Found button by input type and value');
        cy.get('input[type="submit"][value="Place Order"]').click({ force: true });
      }
      // Try to find by any submit button
      else if ($body.find('input[type="submit"]').length) {
        cy.log('Found generic submit button');
        cy.get('input[type="submit"]').last().click({ force: true });
      }
      // Last resort: submit the form directly
      else {
        cy.log('No button found, submitting form directly');
        cy.get('form').submit();
      }
    });
    
    // Wait for the form submission response and follow the redirect
    cy.wait('@checkoutSubmission').then((interception) => {
      cy.log('Form submission response:', interception.response);
      if (interception.response.statusCode !== 302) {
        cy.log('Server responded with error:', interception.response.body);
      } else {
        const redirectUrl = interception.response.headers.location;
        cy.log('Redirect location:', redirectUrl);
        
        // Visit the redirect URL directly
        cy.visit(redirectUrl);
      }
    });
    
    // Check for any error messages that appeared
    cy.get('.alert-danger').should('not.exist').then(() => {
      cy.log('No error messages found');
    });
    
    // Wait for the success message
    cy.get('.alert-success').should('be.visible').and('contain', 'Order created successfully!');
    
    // Additional verification steps
    cy.get('table').should('exist'); // Verify order details table exists
    cy.get('td').should('contain', addressData.firstName); // Verify shipping name
    cy.get('td').should('contain', addressData.street); // Verify shipping address
  });
}); 