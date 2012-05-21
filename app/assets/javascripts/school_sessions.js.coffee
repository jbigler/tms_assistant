jQuery ->
  $( "#schools" ).tabs()
  $( "details.source section" ).hide()
  $( "summary.sourceLink" ).click ->
    $(this).closest( "fieldset" ).find( "details.source section" ).slideToggle( "fast" )
