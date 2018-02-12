# Rails.configuration.to_prepare do
#   # plugin does its actions only if custom_reports plugin is present
#   if Redmine::Plugin.registered_plugins[:redmine_custom_reports].present?
#     unless MailHandler.included_modules.include? RedmineHtmlMailHandler::MailHandlerPatch
#       MailHandler.send(:include, RedmineHtmlMailHandler::MailHandlerPatch)
#     end
#   end
# end

Redmine::Plugin.register :redmine_custom_reports_clone do
  name 'Redmine Custom Reports Clone plugin'
  author 'Roberto Piccini'
  description <<-eos
    it enables the cloning of 'custom reports' from a selected project in the current one
  eos
  version '0.0.1'
  url 'https://github.com/piccio/redmine_custom_reports_clone'
  author_url 'https://github.com/piccio'
  requires_redmine version: '2.6.0'

  project_module :custom_reports do
    permission :clone_custom_reports, { custom_reports_clones: [:new, :create] }
  end

  Rails.application.paths['app/overrides'] ||= []
  Rails.application.paths['app/overrides'] << File.expand_path('../app/overrides', __FILE__)
end
