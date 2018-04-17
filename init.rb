Redmine::Plugin.register :redmine_custom_reports_clone do
  name 'Redmine Custom Reports Clone plugin'
  author 'Roberto Piccini'
  description <<-eos
    it enables the cloning of 'custom reports' from a selected project in the current one
  eos
  version '2.0.0'
  url 'https://github.com/piccio/redmine_custom_reports_clone'
  author_url 'https://github.com/piccio'

  project_module :custom_reports do
    permission :clone_custom_reports, { custom_reports_clones: [:new, :create] }
  end

  Rails.application.paths['app/overrides'] ||= []
  Rails.application.paths['app/overrides'] << File.expand_path('../lib/overrides', __FILE__)
end
