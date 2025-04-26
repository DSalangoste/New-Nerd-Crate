describe('Authentication', () => {
  const testUser = {
    email: 'test@example.com',
    password: 'password123'
  }

  beforeEach(() => {
    cy.visit('/')
  })

  it('should sign up successfully', () => {
    cy.visit('/users/sign_up')
    cy.get('#user_email').type(testUser.email)
    cy.get('#user_password').type(testUser.password)
    cy.get('#user_password_confirmation').type(testUser.password)
    cy.get('input[type="submit"]').click()
    
    // Wait for redirect and check for success message
    cy.url().should('not.include', '/users/sign_up')
    cy.get('.alert-success').should('be.visible')
      .and('contain', 'Welcome! You have signed up successfully')
  })

  it('should show error for taken email', () => {
    cy.visit('/users/sign_up')
    cy.get('#user_email').type(testUser.email)
    cy.get('#user_password').type(testUser.password)
    cy.get('#user_password_confirmation').type(testUser.password)
    cy.get('input[type="submit"]').click()
    
    // Check for error message
    cy.get('.alert-danger').should('be.visible')
      .and('contain', 'Email has already been taken')
  })

  it('should login successfully', () => {
    cy.visit('/users/sign_in')
    cy.get('#user_email').type(testUser.email)
    cy.get('#user_password').type(testUser.password)
    cy.get('input[type="submit"]').click()
    
    // Wait for redirect and check for success message
    cy.url().should('not.include', '/users/sign_in')
    cy.get('.alert-success').should('be.visible')
      .and('contain', 'Signed in successfully')
  })

  it('should show error for invalid credentials', () => {
    cy.visit('/users/sign_in')
    cy.get('#user_email').type('wrong@example.com')
    cy.get('#user_password').type('wrongpass')
    cy.get('input[type="submit"]').click()
    
    // Check for error message
    cy.get('.alert-danger').should('be.visible')
      .and('contain', 'Invalid Email or password')
  })
}) 