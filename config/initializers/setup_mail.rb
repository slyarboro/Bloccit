if Rails.env.development? || Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address:        'smtp.sendgrid.net',
    port:           '2525',
    authentication: :plain,
    user_name:      ENV['SENDGRID_USERNAME'],
    password:       ENV['SENDGRID_PASSWORD'],
    domain:         'heroku.com',
    enable_starttls_auto: true
  }
end

# SendGrid username and password masked; assigned to environment variables (provide reference point without disclosing data values) for security purposes
# sensitive data (ex: API keys, passwords, etc) should not be stored in Github; instead: Figaro gem
