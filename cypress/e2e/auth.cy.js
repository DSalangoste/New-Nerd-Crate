describe('Authentication', () => {
  const testUser = {
    email: 'test@example.com',
    password: 'password123'
  }

  beforeEach(() => {
    cy.visit('/')
  })

  it('should sign up successfully', () => {
    // Happy path - successful signup
    cy.visit('/users/sign_up')
    cy.get('#user_email').type(testUser.email)
    cy.get('#user_password').type(testUser.password)
    cy.get('#user_password_confirmation').type(testUser.password)
    cy.get('input[type="submit"]').click()
    cy.url().should('not.include', '/users/sign_up')
    cy.get('.alert').should('contain', 'Welcome! You have signed up successfully')
  })

  it('should show error for taken email', () => {
    // Unhappy path - email already taken
    cy.visit('/users/sign_up')
    cy.get('#user_email').type(testUser.email)
    cy.get('#user_password').type(testUser.password)
    cy.get('#user_password_confirmation').type(testUser.password)
    cy.get('input[type="submit"]').click()
    cy.get('.alert').should('contain', 'Email has already been taken')
  })

  it('should login successfully', () => {
    // Happy path - successful login
    cy.login(testUser.email, testUser.password)
    cy.url().should('not.include', '/users/sign_in')
    cy.get('.alert').should('contain', 'Signed in successfully')
  })

  it('should show error for invalid credentials', () => {
    // Unhappy path - invalid credentials
    cy.login('wrong@example.com', 'wrongpass')
    cy.get('.alert').should('contain', 'Invalid email or password')
  })
}) 