module ConditionalHtmlHelper
  # Implements the Paul Irish IE conditional comments HTML tag--in HAML.
  # http://paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/
  def cc_html(options={}, &blk)
    attrs = options.map { |(k, v)| " #{h k}='#{h v}'" }.join('')
    [ "<!--[if lt IE 7 ]> <html#{attrs} class='ie6'> <![endif]-->",
      "<!--[if IE 7 ]>    <html#{attrs} class='ie7'> <![endif]-->",
      "<!--[if IE 8 ]>    <html#{attrs} class='ie8'> <![endif]-->",
      "<!--[if IE 9 ]>    <html#{attrs} class='ie9'> <![endif]-->",
      "<!--[if (gt IE 9)|!(IE)]><!--> <html#{attrs}> <!--<![endif]-->",
      capture_haml(&blk).strip,
      "</html>"
    ].join("\n")
  end

  def h(str); Rack::Utils.escape_html(str); end
end

