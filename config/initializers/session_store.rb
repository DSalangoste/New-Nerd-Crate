# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, 
  key: '_nerdcrate_session',
  secure: Rails.env.production?,
  expire_after: 12.hours 