jQuery ->
  if $( "#special_date_event option:selected" ).val == "Other"
    $( "#special_date_details" ).show()
    $( "#special_date_description" ).attr('data-validate', 'true')
  else
    $( "#special_date_details" ).hide()
    $( "#special_date_description" ).removeAttr('data-validate')
  $( "form[id*='edit_special_date']").validate()

jQuery ->
  $( "#special_date_event" ).change ->
    if @value == "Other"
      $( "#special_date_description" ).attr('data-validate', 'true')
      $( "#special_date_details" ).show()
    else
      $( "#special_date_description" ).removeAttr('data-validate')
      $( "#special_date_details" ).hide()

#jQuery ->
  #$( ".calendar_update" ).bind( "ajax:complete" ) ->
    #$("#calendar").html( e.responseText )
