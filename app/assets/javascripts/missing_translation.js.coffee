jQuery ->
  $("span.translation_missing").each ->
    missing = $(this).attr("title")
    $(this).wrap("<a href=\"/translations/new?missing=#{encodeURIComponent(missing)}\" target=\"_blank\"></a>")
