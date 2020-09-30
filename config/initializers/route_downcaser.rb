# config/initializers/route_downcaser.rb

RouteDowncaser.configuration do |config|
    config.redirect = true
  
    config.exclude_patterns = [
      /assets\//i,
      /fonts\//i,
      /active_storage\//i
    ]
  end