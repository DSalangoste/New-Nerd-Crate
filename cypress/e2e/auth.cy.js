describe('Authentication', () => {
  const baseEmail = 'test@example.com'
  const password = 'password123'
  let createdEmail = ''

  beforeEach(() => {
    cy.visit('/')
  })

  it('should sign up successfully', () => {
    cy.visit('/users/sign_up')
    
    // Generate a unique email using timestamp
    createdEmail = `test${Date.now()}@example.com`
    
    // Fill in the form
    cy.get('#user_email').type(createdEmail)
    cy.get('#user_password').type(password)
    cy.get('#user_password_confirmation').type(password)
    
    // Submit the form and wait for response
    cy.get('input[type="submit"]').click()
    
    // Wait for success message
    cy.url().should('not.include', '/users/sign_up')
    cy.get('.alert-success').should('be.visible')
      .and('contain', 'Welcome! You have signed up successfully')
  })

  it('should show error for taken email', () => {
    cy.visit('/users/sign_up')
    
    // Fill in the form with the base email
    cy.get('#user_email').type(baseEmail)
    cy.get('#user_password').type(password)
    cy.get('#user_password_confirmation').type(password)
    
    // Submit the form
    cy.get('input[type="submit"]').click()
    
    // Check for error message - look for either alert-danger or error message in the form
    cy.get('body').then(($body) => {
      if ($body.find('.alert-danger').length) {
        cy.get('.alert-danger').should('be.visible')
          .and('contain', 'Email has already been taken')
      } else {
        cy.get('#user_email').should('have.class', 'is-invalid')
        cy.get('.invalid-feedback').should('be.visible')
          .and('contain', 'Email has already been taken')
      }
    })
  })

  it('should login successfully', () => {
    // First create a new user
    cy.visit('/users/sign_up')
    const loginEmail = `test${Date.now()}@example.com`
    cy.get('#user_email').type(loginEmail)
    cy.get('#user_password').type(password)
    cy.get('#user_password_confirmation').type(password)
    cy.get('input[type="submit"]').click()
    
    // Wait for signup success
    cy.url().should('not.include', '/users/sign_up')
    
    // Now try to login
    cy.visit('/users/sign_in')
    cy.get('#user_email').type(loginEmail)
    cy.get('#user_password').type(password)
    cy.get('input[type="submit"]').click()
    
    // Wait for redirect and check for success message
    cy.url().should('not.include', '/users/sign_in')
    cy.get('.alert-success').should('be.visible')
      .and('contain', 'Signed in successfully')
  })

  it('should show error for invalid credentials', () => {
    cy.visit('/users/sign_in')
    cy.get('#user_email').type('wrong@example.com')
    cy.get('#user_password').type('wrongpassword')
    cy.get('input[type="submit"]').click()
    
    // Check for error message - look for either alert-danger or error message in the form
    cy.get('body').then(($body) => {
      if ($body.find('.alert-danger').length) {
        cy.get('.alert-danger').should('be.visible')
          .and('contain', 'Invalid Email or password')
      } else {
        cy.get('#user_email').should('have.class', 'is-invalid')
        cy.get('.invalid-feedback').should('be.visible')
          .and('contain', 'Invalid Email or password')
      }
    })
  })
}) 