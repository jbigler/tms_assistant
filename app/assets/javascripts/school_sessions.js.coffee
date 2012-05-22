jQuery ->
  $( "#schools" ).tabs()
  $( "details.source section" ).hide()
  $( "summary.sourceLink" ).click ->
    $(this).closest( "fieldset" ).find( "details.source section" ).slideToggle( "fast" )
  $("fieldset li#substitute").each ->
    $(this).hide()
  $("input.completed_by").change ->
    $(this).closest("fieldset").find("li#substitute").toggle()
  $("input.lesson_status").change ->
    $(this).closest("fieldset").find("li#lesson_next").toggle()
