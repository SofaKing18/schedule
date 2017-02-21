#  with PgSQL queryies
class UserEvent < ApplicationRecord
  belongs_to :User
  validates :name, :start_date, presence: true
  validate :end_date_cannot_be_in_the_past

  def end_date_cannot_be_in_the_past
    if end_date.present? && end_date < start_date
      errors.add(:end_date, "can't lower than start date")
    end
  end 

  scope :events_in_month, lambda { |date, user_id = 0|
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
			,one_day.usr_ev + every_day.usr_ev + every_week.usr_ev + every_month.usr_ev + every_year.cnt usr_ev
		FROM EventsInThisMonth d
		LEFT JOIN LATERAL (select count(id) as cnt, count(case when user_id=#{user_id} then 1 else null end) usr_ev from user_events where ((hidden!=true) or (hidden=true and user_id = #{user_id})) and start_date::date = d.day and  coalesce(repeat_type, 0) = 0 ) one_day on TRUE
		LEFT JOIN LATERAL (select count(id) as cnt, count(case when user_id=#{user_id} then 1 else null end) usr_ev from user_events where ((hidden!=true) or (hidden=true and user_id = #{user_id})) and d.day between start_date::date and coalesce(end_date, d.day)::date and repeat_type = 1) every_day on 	TRUE
		LEFT JOIN LATERAL (select count(id) as cnt, count(case when user_id=#{user_id} then 1 else null end) usr_ev from user_events where ((hidden!=true) or (hidden=true and user_id = #{user_id})) and d.day between start_date::date and coalesce(end_date, d.day)::date and (d.day::date-start_date::date)::INT % 7 = 0 and repeat_type = 2) every_week on 	TRUE
		LEFT JOIN LATERAL (select count(id) as cnt, count(case when user_id=#{user_id} then 1 else null end) usr_ev from user_events where ((hidden!=true) or (hidden=true and user_id = #{user_id})) and d.day between start_date::date and coalesce(end_date, d.day)::date and date_part('day',start_date)=date_part('day', d.day) and repeat_type = 3) every_month on 	TRUE
		LEFT JOIN LATERAL (select count(id) as cnt, count(case when user_id=#{user_id} then 1 else null end) usr_ev from user_events where ((hidden!=true) or (hidden=true and user_id = #{user_id})) and d.day between start_date::date and coalesce(end_date, d.day)::date and date_part('day',start_date)=date_part('day', d.day) and date_part('month',start_date)=date_part('month',d.day) and repeat_type = 4) every_year on 	TRUE

		ORDER BY  d.DAY
		")
  }
  scope :event_in_day, lambda { |date, user_id = 0|
    connection.select_all("
		SELECT
			d.name,
			d.user_id,
			d.start_date,
			u.last_name,
			d.id
		FROM user_events d
		JOIN Users u on u.id = d.user_id  AND ((hidden!=true) or (hidden=true and user_id = #{user_id}))
		WHERE (start_date::date = '#{date}'::date and  coalesce(repeat_type, 0) = 0 ) or
		('#{date}'::date between start_date::date and coalesce(end_date, '#{date}'::date)::date and repeat_type = 1) or
		('#{date}'::date between start_date::date and coalesce(end_date, '#{date}'::date)::date and ('#{date}'::date-start_date::date)::INT % 7 = 0 and repeat_type = 2) or
		('#{date}'::date between start_date::date and coalesce(end_date, '#{date}'::date)::date and date_part('day',start_date)=date_part('day', '#{date}'::date) and repeat_type = 3) or
		('#{date}'::date between start_date::date and coalesce(end_date, '#{date}'::date)::date and date_part('day',start_date)=date_part('day', '#{date}'::date) and date_part('month',start_date)=date_part('month','#{date}'::date) and repeat_type = 4)

		ORDER BY ID DESC
		")
  }
  def repeat_types_array
    ['None', 'Every day', 'Every week', 'Every month', 'Every year']
  end

  def repeat
    repeat_types_array[repeat_type || 0]
  end
end
