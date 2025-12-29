# config/initializers/saml.rb

SAML_SETTINGS = {
  assertion_consumer_service_url: "#{ENV.fetch('APP_URL', 'http://localhost:3000')}/saml/acs",
  issuer: ENV.fetch('APP_URL', 'http://localhost:3000'),
  idp_sso_target_url: "#{ENV.fetch('APP_URL', 'http://localhost:3000')}/saml/auth",
  idp_cert_fingerprint_algorithm: "http://www.w3.org/2000/09/xmldsig#sha256",
  name_identifier_format: "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress",
  certificate: File.read(Rails.root.join('config/saml/saml_cert.pem')),
  private_key: File.read(Rails.root.join('config/saml/saml_key.pem'))
}.freeze