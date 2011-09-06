jQuery ->
  if $( "#special_date_event option:selected" ).val == "Other"
    $( "#special_date_details" ).show()
    $( "#special_date_description" ).addClass "required"
  else
    $( "#special_date_details" ).hide()
    $( "#special_date_description" ).removeClass "required"
  $( "form[id*='edit_special_date']").validate()

jQuery ->
  $( "#special_date_event" ).change ->
    if @value == "Other"
      $( "#special_date_details" ).show()
      $( "#special_date_description" ).addClass "required"
    else
      $( "#special_date_details" ).hide()
      $( "#special_date_description" ).removeClass "required"

#jQuery ->
  #$( ".calendar_update" ).bind( "ajax:complete" ) ->
    #$("#calendar").html( e.responseText )
