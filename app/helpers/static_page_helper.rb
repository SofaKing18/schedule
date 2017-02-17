# helper StaticPage
module StaticPageHelper
  def calendar_array
    UserEvent.current_events("#{params[:year]}.#{params[:month]}.01").rows
  end

  def generate_month_array
    [].tap do |month| calendar_array.map do |row|
        month[row[1]] = [] if month[row[1]].nil?
        month[row[1]].push([row[2][-2, 2], row[0].to_i,row[3]])
      end
    end
  end

  def convert_to_html_calendar
    generate_month_array.compact.map.with_index do |week, i|
      making_week_row(week, i)
    end
  end

  def making_week_row(week, i)
  	dt = Time.zone.now
  	repeat = i.zero? ? 7 - week.size : 0
  	"<tr data-text=#{i}>" + fill_by_empty_dates_html(repeat) +
    week.map do |day|
      today = (day[0].to_i == dt.day) &&
        (dt.year == params[:year].to_i) &&
        (dt.month == params[:month].to_i)
      href = "/static_page/day?year=#{dt.year}&month=#{dt.month}&day=#{day[0]}"
      "<td class='event_count #{'today' if today}' data-href='#{href}'>" +
        day[0] +'<br> Events: '+ day[2].to_s + '</td>'
    end.join + '</tr>'
  end

  def fill_by_empty_dates_html(time)
    '<td></td>' * time
  end

  def draw_calendar
    convert_to_html_calendar.join("\n").html_safe
  end

  def month_name_and_year
	"#{Date::MONTHNAMES[params[:month].to_i]} #{params[:year]}"
  end

  def prev_month_year
	year = params[:year].to_i
  	month = params[:month].to_i
  	if month-1 == 0 then
  		year -= 1
  		month = 13
  	end
  	[month-1, year]
  end

  def next_month_year
  	year = params[:year].to_i
  	month = params[:month].to_i
  	if month+1 > 12 then
  		year += 1
  		month = 0
  	end
  	[month+1, year]
  end

  def link_for_month_year(arr)
  	"?month=#{arr[0]}&year=#{arr[1]}"
  end
end
