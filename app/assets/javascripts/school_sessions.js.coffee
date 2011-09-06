jQuery ->
  $( "#schools" ).tabs()
  $( ".source p" ).hide()
  $( "a.sourceLink" ).click ->
    $(this).closest( "fieldset" ).find( ".source p" ).slideToggle( "fast" )
