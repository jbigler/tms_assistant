jQuery ->
# Apply a class on mouse over and remove it on mouse out.
  $('table.calendar tbody tr').live 'hover', ->
    $(this).toggleClass('highlight')
  $('table.calendar tbody tr').live 'click', ->
    href = $(this).find("a").attr("href")
    if href
      location.href = href

jQuery ->
  $(".datepicker").datepicker
