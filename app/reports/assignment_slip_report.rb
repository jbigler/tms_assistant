require "prawn/measurement_extensions"

class AssignmentSlipReport

  # Only print assigned lessons
  #
  def initialize( assignments, meeting_day )
    @assignments = assignments
    if meeting_day
      @meeting_day = meeting_day
    else
      @meeting_day = 1
    end
    @no_assignments = @assignments.size
    @no_pages = Integer( ( @no_assignments.to_f / 4 ).ceil )
  end

  def to_pdf
    pdf = Prawn::Document.new(:page_layout => :landscape, 
                              :left_margin => 1.cm,    # different
                              :right_margin => 1.cm,    # units
                              :top_margin => 1.cm,    # work
                              :bottom_margin => 1.cm, # well 
                              :page_size => 'A4')

    pdf.font_families.update( "FreeSerifFamily" => {
      :normal => "#{Rails.root}/fonts/FreeSerif.ttf",
      :italic => "#{Rails.root}/fonts/FreeSerifItalic.ttf",
      :bold => "#{Rails.root}/fonts/FreeSerifBold.ttf",
      :bold_italic => "#{Rails.root}/fonts/FreeSerifBoldItalic.ttf"
    } )
    pdf.font "FreeSerifFamily", :size => 12

    assignment_no = 0
    Rails.logger.info( "Number of pages: " + @no_pages.to_s )
    @no_pages.times do |page|

      pdf.define_grid( :columns => 2, :rows => 2, :gutter => 1.8.cm )

      pdf.grid.rows.times do |r|
        pdf.grid.columns.times do |c|

          box = pdf.grid( r, c )
          if assignment_no + 1 > @no_assignments
            break
          end
          assignment = @assignments[assignment_no]
          assignment_no += 1

          generate_text( assignment, pdf, box )
        end
      end
      pdf.start_new_page unless page == @no_pages - 1
    end
    pdf.render
  end

  def generate_text( assignment, pdf, box )
    pdf.bounding_box( box.top_left, :width => box.width, :height => box.height ) do
      half = box.width / 2
      row_height = box.height / 10

      pdf.font_size 12

      header = I18n.t( 'reports.slips.header' )
      student = [{ :text => I18n.t( 'reports.slips.student' ) }, { :text => assignment.student.display_name, :styles => [:bold] } ]# + assignment.schedule_item.source
      talk_no = [{ :text => I18n.t( 'reports.slips.talk_no' ) }, { :text => assignment.abbrev, :styles => [:bold] } ]# + assignment.schedule_item.source
      day = [{ :text => I18n.t( 'reports.slips.date' ) }, { :text => determine_date( assignment.week_of ), :styles => [:bold] } ]# + assignment.schedule_item.source
      if assignment.class.method_defined? :assistant and  assignment.assistant
        assistant = [{ :text => I18n.t( 'reports.slips.assistant' ) }, { :text => assignment.assistant.display_name, :styles => [:bold] } ]# + assignment.schedule_item.source
      else
        assistant = [{ :text => I18n.t( 'reports.slips.assistant' ) }, { :text => "", :styles => [:bold] } ]# + assignment.schedule_item.source
      end
      if assignment.schedule_item.source
        source = [{ :text => I18n.t( 'reports.slips.source' ) }, { :text => assignment.schedule_item.source, :styles => [:bold] } ]# + assignment.schedule_item.source
      else
        source = [{ :text => I18n.t( 'reports.slips.source' ) }, { :text => "", :styles => [:bold] } ]# + assignment.schedule_item.source
      end
      if assignment.schedule_item.title
        title = [{ :text => I18n.t( 'reports.slips.title' ) }, { :text => assignment.schedule_item.title, :styles => [:bold] } ]
      else
        title = [{ :text => I18n.t( 'reports.slips.title' ) }, { :text => "", :styles => [:bold] } ]
      end
      if assignment.class.method_defined? :setting and assignment.setting
        setting = [{ :text => I18n.t( 'reports.slips.setting' ) }, { :text => assignment.setting.setting_source.number.to_s, :styles => [:bold] } ]
      else
        setting = [{ :text => I18n.t( 'reports.slips.setting' ) }, { :text => "", :styles => [:bold] } ]
      end
      if assignment.type == "BibleHighlights"
        school = [{ :text => I18n.t( 'reports.slips.school' ) }, { :text => "1", :styles => [:bold] } ]
      else
        school = [{ :text => I18n.t( 'reports.slips.school' ) }, { :text => assignment.school.position.to_s, :styles => [:bold] } ]
      end

      lesson = ""
      footer_01 = I18n.t( 'reports.slips.footer1' )
      if assignment.class.method_defined? :lesson and assignment.lesson
        lesson = assignment.lesson.lesson_source.chapter
      else
        lesson = "______"
      end
      footer_02 =  I18n.t( 'reports.slips.footer2', :lesson => lesson )
      footer_03 = I18n.t( 'reports.slips.footer3' )
      footer_04 = I18n.t( 'reports.slips.footer4' )
      pdf.text( header, :align => :center )
      pdf.formatted_text_box( student, :at => [pdf.bounds.left, pdf.bounds.top - 20 ] , :width => half, :overflow => :shrink_to_fit, :single_line => true )

      pdf.formatted_text_box( talk_no, :at => [pdf.bounds.left + half, pdf.bounds.top - 20 ] , :width => half / 2, :overflow => :shrink_to_fit )
      pdf.formatted_text_box( day, :at => [pdf.bounds.left + half + half / 2, pdf.bounds.top - 20 ] , :width => half / 2, :overflow => :shrink_to_fit )

      pdf.formatted_text_box( assistant, :at => [pdf.bounds.left, pdf.bounds.top - 40 ] , :width => half, :overflow => :shrink_to_fit, :single_line => true )
      pdf.formatted_text_box( source, :at => [pdf.bounds.left + half, pdf.bounds.top - 40 ] , :width => half, :overflow => :shrink_to_fit, :single_line => true )
      pdf.formatted_text_box( title, :at => [pdf.bounds.left, pdf.bounds.top - 60 ], :height => 20, :overflow => :shrink_to_fit, :single_line => true )

      pdf.formatted_text_box( setting, :at => [pdf.bounds.left, pdf.bounds.top - 80 ], :width => half )
      pdf.formatted_text_box( school, :at => [pdf.bounds.left + half, pdf.bounds.top - 80 ], :height => 20, :width => half )

      pdf.bounding_box( [pdf.bounds.left, pdf.bounds.top - 110], :width => box.width ) do
        pdf.font_size 10
        pdf.text( footer_01 )
        pdf.text( footer_02, :align => :justify, :inline_format => true, :indent_paragraphs => 10 )
        pdf.text( footer_03, :align => :justify, :inline_format => true, :indent_paragraphs => 10 )
        pdf.move_down 5
        pdf.text( footer_04 )
      end
    end
  end

  def determine_date( week_of )
    if @meeting_day == 1
      I18n.l( week_of )
    elsif @meeting_day == 0
      I18n.l( week_of + 6 )
    else
      I18n.l( week_of + ( @meeting_day - 1 ) )
    end
  end
end
