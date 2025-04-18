# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Add node_modules and ActiveAdmin stylesheets to asset paths
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Gem.loaded_specs['activeadmin'].full_gem_path + '/app/assets/stylesheets'

# Precompile additional assets
Rails.application.config.assets.precompile += %w( active_admin.css active_admin.js )
