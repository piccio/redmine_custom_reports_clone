class CustomReportsClone < ActiveRecord::Base
  has_no_table
  # 'has_many :custom_reports' gives custom_report_ids method,
  # differently 'belongs_to :source_project' doesn't give source_project_id method and must exist a table column
  column :target_project_id, :integer
  column :source_project_id, :integer
  column :user_id, :integer

  belongs_to :target_project, class_name: 'Project'
  belongs_to :source_project, class_name: 'Project'
  belongs_to :user
  has_many :custom_reports

  validates :target_project,
            presence: true,
            inclusion: { in: Project.visible }
  validates :source_project,
            presence: true,
            inclusion: { in: -> (crc) { crc.source_projects } }
  validates :user,
            presence: true,
            inclusion: { in: User.all }
  validates :custom_reports,
            presence: true
  validate :custom_reports_included_in_source_project_reports

  def source_projects
    Project.visible - [target_project]
  end

  def source_project_reports
    if source_project
      source_project.custom_reports.visible
    else
      []
    end
  end

  # can't chained after_save because tableless hasn't save metod
  def clone_custom_reports
    custom_reports.each do |cr|
      cloned = cr.deep_clone include: :series do |original, kopy|
        # set target project and author on report copy and skip series copies:
        # unlike custom report, they don't have any relationship with project
        if kopy.respond_to? :project
          kopy.project = target_project
          kopy.user = user
        end
      end
      # raise exception if cloned custom reports are invalid (should be impossible)
      cloned.save!
    end
  end

  private

  def custom_reports_included_in_source_project_reports
    if custom_reports.detect { |d| !source_project_reports.include?(d) }
      errors.add(:custom_reports, l(:custom_reports_not_included_in_source_project_reports_error))
    end
  end
end