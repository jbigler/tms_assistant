jQuery ->
# Apply a class on mouse over and remove it on mouse out.
  $('table.calendar tbody tr').hover ->
    $(this).toggleClass('highlight')
  $('table.calendar tbody tr').click ->
    href = $(this).find("a").attr("href")
    if href
      location.href = href

  
      #// Assign a click handler that grabs the URL 
      #// from the first cell and redirects the user.
      #$('#link-table tr').click(function ()
      #{
        #location.href = $(this).find('td a').attr('href');
      #});
    #});
