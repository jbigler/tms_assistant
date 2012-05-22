# http://grosser.it/2012/02/04/do-not-show-i18n-missing-translation-tooltips-in-production/
# config/initializers/disable_i18n_tooltips.rb
# missing translations
# - Do not show tooltips in production/test
# - Do not raise ( speedup) for every missing translations
I18n::Backend::Base.class_eval do
  def translate_with_default(locale, key, options = {})
    if options[:rescue_format] == :html && ['test','production'].include?(Rails.env)
      default = key.to_s.gsub('_', ' ').gsub(/\b('?[a-z])/) { $1.capitalize }
      options.reverse_merge!(default: default)
    end
    translate_without_default(locale, key, options)
  end

  alias_method_chain :translate, :default
end

