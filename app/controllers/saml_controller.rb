# app/controllers/saml_controller.rb
class SamlController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:auth, :acs, :metadata, :slo]
  before_action :authenticate_user!, only: [:auth]
  
  # SSO Initiation (from SP)
  def auth
    service_provider = ServiceProvider.find_by(entity_id: params[:sp_entity_id])
    
    unless service_provider&.active?
      render json: { error: 'Invalid service provider' }, status: :forbidden
      return
    end

    # Generate SAML response
    response_xml = generate_saml_response(service_provider, current_user)
    
    # Log the authentication
    AuditLog.log_action(
      'saml_sso',
      user: current_user,
      resource: service_provider,
      metadata: { sp_entity_id: service_provider.entity_id },
      ip: request.remote_ip
    )
    
    # Return SAML response to SP
    render inline: saml_response_form(service_provider.acs_url, response_xml)
  end

  # Assertion Consumer Service (receive AuthnRequest from SP)
  def acs
    saml_response = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    
    if saml_response.is_valid?
      # Process successful authentication
      render json: { message: 'Authentication successful' }
    else
      render json: { error: 'Invalid SAML response' }, status: :unprocessable_entity
    end
  end

  # IdP Metadata
  def metadata
    settings = saml_settings
    meta = OneLogin::RubySaml::Metadata.new
    
    render xml: meta.generate(settings), content_type: 'application/xml'
  end

  # Single Logout
  def slo
    logout_request = OneLogin::RubySaml::Logoutrequest.new(params[:SAMLRequest])
    
    if logout_request.is_valid?
      sign_out current_user if user_signed_in?
      render json: { message: 'Logout successful' }
    else
      render json: { error: 'Invalid logout request' }, status: :unprocessable_entity
    end
  end

  private

  def generate_saml_response(service_provider, user)
    settings = saml_settings(service_provider)
    
    response = OneLogin::RubySaml::Response.new
    response.settings = settings
    response.issuer = settings.issuer
    response.name_id = user.email
    
    # Add user attributes
    response.attributes['email'] = user.email
    response.attributes['first_name'] = user.first_name
    response.attributes['last_name'] = user.last_name
    response.attributes['full_name'] = user.full_name
    response.attributes['role'] = user.role
    
    # Sign the response
    response_xml = response.create(settings)
    Base64.strict_encode64(response_xml)
  end

  def saml_settings(service_provider = nil)
    settings = OneLogin::RubySaml::Settings.new
    
    # IdP settings
    settings.issuer = SAML_SETTINGS[:issuer]
    settings.idp_sso_target_url = SAML_SETTINGS[:idp_sso_target_url]
    settings.idp_cert = SAML_SETTINGS[:certificate]
    settings.private_key = SAML_SETTINGS[:private_key]
    settings.certificate = SAML_SETTINGS[:certificate]
    settings.name_identifier_format = SAML_SETTINGS[:name_identifier_format]
    
    # SP settings (if provided)
    if service_provider
      settings.assertion_consumer_service_url = service_provider.acs_url
      settings.sp_entity_id = service_provider.entity_id
    end
    
    # Security settings
    settings.security[:authn_requests_signed] = true
    settings.security[:logout_requests_signed] = true
    settings.security[:logout_responses_signed] = true
    settings.security[:metadata_signed] = true
    settings.security[:digest_method] = XMLSecurity::Document::SHA256
    settings.security[:signature_method] = XMLSecurity::Document::RSA_SHA256
    
    settings
  end

  def saml_response_form(acs_url, saml_response)
    <<-HTML
      <!DOCTYPE html>
      <html>
        <head>
          <title>SAML SSO</title>
        </head>
        <body onload="document.forms[0].submit()">
          <form method="post" action="#{acs_url}">
            <input type="hidden" name="SAMLResponse" value="#{saml_response}" />
            <noscript>
              <input type="submit" value="Continue" />
            </noscript>
          </form>
        </body>
      </html>
    HTML
  end
end