jQuery ->
  $( "#schools" ).tabs()
  $( "details.source p" ).hide()
  $( "summary.sourceLink" ).click ->
    $(this).closest( "fieldset" ).find( "details.source p" ).slideToggle( "fast" )
