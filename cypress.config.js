const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    baseUrl: 'http://localhost:3000',
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    experimentalRunAllSpecs: true,
    viewportWidth: 1280,
    viewportHeight: 720,
    defaultCommandTimeout: 10000,
    retries: {
      runMode: 2,
      openMode: 0
    },
    // Add support for ES modules
    experimentalModifyObstructiveCode: true,
    experimentalSourceRewriting: true,
    // Disable TypeScript checking for now
    typescript: {
      ignoreTsErrors: true
    },
    // Add these settings for better stability
    chromeWebSecurity: false,
    video: false,
    screenshotOnRunFailure: true,
    // Add support for ES modules
    experimentalModifyObstructiveCode: true,
    experimentalSourceRewriting: true,
    // Add support for TypeScript
    supportFile: 'cypress/support/e2e.js',
    specPattern: 'cypress/e2e/**/*.{js,jsx,ts,tsx}'
  },
}) 