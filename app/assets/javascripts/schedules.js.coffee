jQuery ->
  if $("#schedule_has_review").is(":checked")
    $("#student_assignments").hide()
  else
    $("#schedule_has_review").change ->
      $("#student_assignments").toggle()

