class CustomReportsClonesController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id
  before_filter :authorize
  before_filter :find_custom_reports, only: :new

  def new
    @custom_reports_clone = CustomReportsClone.new
    @custom_reports_clone.target_project = @project
    @custom_reports_clone.source_project = Project.find(params[:source_project]) unless params[:source_project].blank?

    respond_to do |format|
      format.html
      format.json { render json: @custom_reports_clone.source_project_reports }
    end
  end

  def create
    params.required(:custom_reports_clone).permit! if params.class.method_defined? :required
    
    @custom_reports_clone = CustomReportsClone.new(params[:custom_reports_clone])
    @custom_reports_clone.target_project = @project
    @custom_reports_clone.user = User.current

    if @custom_reports_clone.valid?
      @custom_reports_clone.clone_custom_reports

      redirect_to project_custom_reports_path, :notice => l(:message_custom_reports_cloned)
    else
      render action: 'new'
    end
  end

  private

  def find_custom_reports
    custom_reports = @project.custom_reports.visible
    grouped_reports = custom_reports.group_by(&:is_public)
    @own_custom_reports = grouped_reports[false]
    @public_custom_reports = grouped_reports[true]
  end
end
