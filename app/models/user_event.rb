class UserEvent < ApplicationRecord
	belongs_to :User
	validates :name, :start_date, presence: true

	scope :current_events, -> (date_arg) {
		date = date_arg #.to_date.strftime("%Y-%m-%d")
		connection.select_all("
		;WITH RECURSIVE EventsInThisMonth as (
			SELECT date_trunc('MONTH',DATE '#{date}')::DATE as day union
			SELECT (day+interval '1 day')::DATE from EventsInThisMonth
			WHERE
			day < date_trunc('MONTH',DATE '#{date}'+interval '1 month')::DATE-1
		)
		SELECT
			extract(DOW from day) as DOW
			,to_char(day, 'IYYYIW')::INT
			,day
			,one_day.cnt + every_day.cnt + every_week.cnt + every_month.cnt + every_year.cnt CNT
		FROM EventsInThisMonth d
		LEFT JOIN LATERAL (select count(id) as cnt from user_events where	start_date::date = d.day and  coalesce(repeat_type, 0) = 0 ) one_day on TRUE
		LEFT JOIN LATERAL (select count(id) as cnt from user_events where d.day between start_date::date and coalesce(end_date, d.day)::date and repeat_type = 1) every_day on 	TRUE
		LEFT JOIN LATERAL (select count(id) as cnt from user_events where d.day between start_date::date and coalesce(end_date, d.day)::date and (d.day::date-start_date::date)::INT % 7 = 0 and repeat_type = 2) every_week on 	TRUE
		LEFT JOIN LATERAL (select count(id) as cnt from user_events where d.day between start_date::date and coalesce(end_date, d.day)::date and date_part('day',start_date)=date_part('day', d.day) and repeat_type = 3) every_month on 	TRUE
		LEFT JOIN LATERAL (select count(id) as cnt from user_events where d.day between start_date::date and coalesce(end_date, d.day)::date and date_part('day',start_date)=date_part('day', d.day) and date_part('month',start_date)=date_part('month',d.day) and repeat_type = 4) every_year on 	TRUE
		
		ORDER BY  d.DAY
		")
	}
end
