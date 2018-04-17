$.fillCustomReportsProject = function(data) {
  $('form#custom-reports-clone select#custom_reports_clone_custom_report_ids').empty();

  $.each(data, function( index, value ) {
    var id = value.id;
    var title = value.name;

    $('form#custom-reports-clone select#custom_reports_clone_custom_report_ids').append(new Option(title, id));
  });
};

$.getCustomReportsProject = function() {
  // reset source project select
  $('form#custom-reports-clone select#custom_reports_clone_source_project_id').val('');

  $('form#custom-reports-clone select#custom_reports_clone_source_project_id').on('change', function () {
    $.get( $(this).data('url'), { source_project: $(this).val() }, $.fillCustomReportsProject, 'json' );
  });
};

$(document).ready(function() {
  $.getCustomReportsProject();
});
