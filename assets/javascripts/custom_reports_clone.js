function fillCustomReportsProject(data) {
  $('form#custom-reports-clone select#custom_reports_clone_custom_report_ids').empty();
  for(var i in data) {
    var id = data[i].custom_report.id;
    var title = data[i].custom_report.name;
    $('form#custom-reports-clone select#custom_reports_clone_custom_report_ids').append(new Option(title, id));
  }
}

function getCustomReportsProject() {
  // reset source project select
  $('form#custom-reports-clone select#custom_reports_clone_source_project_id').val('');

  $('form#custom-reports-clone select#custom_reports_clone_source_project_id').on('change', function () {
    $.get( $(this).data('url'), { source_project: $(this).val() }, fillCustomReportsProject, 'json' );
  });
}

$(document).ready(function() {
  getCustomReportsProject();
});
