# Content Security Policy configuration
# Completely disabled in development to allow Swagger UI to work
# The RemoveCspMiddleware removes all CSP headers in development

Rails.application.configure do
  if Rails.env.development?
    # Explicitly prevent Rails from setting any CSP in development
    # This is done by not defining any CSP policy
    # The RemoveCspMiddleware will strip any CSP headers that might be set
  else
    # Production CSP configuration (uncomment and configure as needed)
    # config.content_security_policy do |policy|
    #   policy.default_src :self, :https
    #   policy.connect_src :self, :https
    #   policy.script_src :self, :https
    #   policy.style_src :self, :https
    # end
  end
end
  