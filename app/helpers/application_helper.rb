include CalendarHelper
include FoundationRailsHelper::FlashHelper

module ApplicationHelper

  def congregation_name
    if @congregation and @congregation.name
      ": " + @congregation.name
    end
  end

  def calendar_back_path
    url_for( :action => :index, :controller => request.symbolized_path_parameters[:controller] ) + "/update_calendar?calendar_date=" +
      ( @calendar_date << 1 ).to_s +
      if @selected_week then "&selected_week=" + @selected_week.to_s else "" end
  end

  def calendar_forward_path
    url_for( :action => :index, :controller => request.symbolized_path_parameters[:controller] ) + "/update_calendar?calendar_date=" +
      ( @calendar_date >> 1 ).to_s + #+ request.symbolized_path_parameters.to_s +
      if @selected_week then "&selected_week=" + @selected_week.to_s else "" end
  end

  def render_calendar_cell( d )
    if d.wday == 1
      if ( @schedule && d == @schedule.week_of ) ||
         ( @special_date && d == @special_date.week_of )
        [ d.mday, { :class => "selectedDate" } ]
      elsif (@school_session)
        state = @calendar_states[d]
        case state
        when "assigned"
          [ d.mday, { :class => "assignedDate" } ]
        when "completed"
          [ d.mday, { :class => "completedDate" } ]
        when "cancelled"
          [ d.mday, { :class => "cancelledDate" } ]
        end
      #elsif @selected_week && d == @selected_week
        #[ d.mday, { :class => "selectedDate" } ]
      end
      [ link_to( d.mday.to_s, url_for( :action => :new, :controller => request.symbolized_path_parameters[:controller] ) + "?edit_date=" + d.to_s ) ]
    end
  end

  def active_icon(status)
    if status
      image_tag "active.png", :width => 24
    else
      image_tag "inactive.png", :width => 24
    end
  end

  def b(value, options = {})
    options = {
      :true => :positive,
      :false => :negative,
      :scope => [:boolean],
      :locale => I18n.locale, # <- It makes easy to avoid conditional run
    }.merge options
    
    # avoid passing nil, or some desctructive value
    # what can be easily happened
    boolean = !!(value || false)
    key = boolean.to_s.to_sym

    t(options[key], :scope => options[:scope], :locale => options[:locale])
  end

end
