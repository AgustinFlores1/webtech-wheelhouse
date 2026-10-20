Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Exactly two origins, never "*":
    # - the published personal page on GitHub Pages (the origin has no path: not /webtech-lab-01)
    # - the local server used while developing the page (VS Code Live Server)
    origins "https://agustinflores1.github.io", "http://127.0.0.1:5500"
 
    # Only the price list, and only GET: the page reads, it never writes.
    # The repairs and POST /services need the token, so they are not opened to any origin.
    resource "/api/v1/services", headers: :any, methods: [ :get ]
    resource "/api/v1/services/*", headers: :any, methods: [ :get ]
  end
end