include CalendarHelper

module ApplicationHelper

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
      if ( @school_session && d === @school_session.week_of ) ||
          ( @schedule && d === @schedule.week_of ) ||
          ( @special_date && d === @special_date.week_of ) ||
          ( @selected_week && d === @selected_week )
        [ d.mday, { :class => "selectedDate" } ]
      else
        [ link_to( d.mday.to_s, url_for( :action => :new, :controller => request.symbolized_path_parameters[:controller] ) + "?edit_date=" + d.to_s ), { :class => "monday" } ]
      end
    end
  end

  def active_icon(status)
    if status
      image_tag "active.png", :width => 24
    else
      image_tag "inactive.png", :width => 24
    end
  end

end
