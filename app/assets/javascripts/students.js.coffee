jQuery ->
  $( "section.supp_data" ).tabs()
  $("#new_family").change ->
    $("#student_family_id").toggle()
