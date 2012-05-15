jQuery ->
  table_locale = $('table.data').attr("data-locale")
  $('table.data').dataTable
    bJQueryUI: true,
    sPaginationType: "full_numbers",
    oLanguage: "sUrl": "/media/datatables/#{table_locale}.txt"
