class ApplicationMailer < ActionMailer::Base
  default from: 'no_reply.treasury.app@ultroneous.org'
  layout 'mailer'
end
