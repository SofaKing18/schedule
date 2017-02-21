# helper StaticPage
module StaticPageHelper
  def calendar_array
    first_month_day = "#{params[:year]}.#{params[:month]}.01"
    UserEvent.events_in_month(first_month_day, current_user.id).rows
  end

  def generate_month_array
    [].tap do |month|
      calendar_array.map do |row|
        month[row[1]] = [] if month[row[1]].nil?
        month[row[1]].push([row[2][-2, 2], row[0].to_i, row[3], row[4]])
      end
    end
  end

  def convert_to_html_calendar
    generate_month_array.compact.map.with_index do |week, i|
      making_week_row(week, i)
    end
  end

  def making_week_row(week, i)
    repeat = i.zero? ? 7 - week.size : 0
    # fill by empty dates
    (1..repeat).to_a.each { week.unshift([nil, nil, nil, nil]) }
    content_tag(:tr, 'data-text' => i) do
      week.collect do |day|
        concat make_day_td(day)
      end
    end
  end

  def make_day_td(day)
    content_tag(:td, safe_join(day_content(day)), 'data-href' => href_for_day(day[0]), class: day_class(day))
  end

  def day_content(day)
    return [] if day[0].nil?
    [content_tag(:span, day[0], class: 'day').concat(content_tag(:span, "Events: #{day[2]}"))]
  end

  def day_class(day)
    return if day[0].nil?
    "#{'own_events' if day[3] > 0} event_count #{'today' if today?(day[0])}"
  end

  def today?(day)
    dt = Time.zone.now
    day.to_i == dt.day && dt.year == params[:year].to_i &&
      dt.month == params[:month].to_i
  end

  def href_for_day(day)
    "/static_page/day?year=#{params[:year]}&month=#{params[:month]}&day=#{day}"
  end

  def fill_by_empty_dates_html(time)
    content_tag(:td) * time
  end

  def draw_calendar
    safe_join(convert_to_html_calendar)
  end

  def month_name_and_year
    "#{Date::MONTHNAMES[params[:month].to_i]} #{params[:year]}"
  end

  def prev_month_year
    year = params[:year].to_i
    month = params[:month].to_i
    if (month - 1).zero?
      year -= 1
      month = 13
    end
    [month - 1, year]
  end

  def next_month_year
    year = params[:year].to_i
    month = params[:month].to_i
    if month + 1 > 12
      year += 1
      month = 0
    end
    [month + 1, year]
  end

  def link_for_month_year(arr)
    "?month=#{arr[0]}&year=#{arr[1]}"
  end

  def event_in_day
    day = "#{params[:year]}.#{params[:month]}.#{params[:day]}"
    UserEvent.event_in_day(day, current_user.id).rows
  end
end
