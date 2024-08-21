###  Period over Period Method 7: Compare any period with the previous preceding period of the same length

# Like Method 2, but here we define any date filter (not just current) and
# compare it to the previous period of the same length - great for single value visualization comparisons

view: method7_base {

  filter: date_filter {
    view_label: "_PoP {{ _view._name | replace: '_',' ' | capitalize}}"
    description: "Use this date filter in combination with the timeframes dimension for dynamic date filtering"
    type: date
    convert_tz: no
  }

  dimension_group: pop_date_field {
    type: time
    hidden: yes
    # sql: "Must be overwritten within a refinement or extension";;
    timeframes: [date,raw]
    convert_tz: no
  }

  dimension_group: filter_start_date {
    hidden: yes
    type: time
    timeframes: [raw,date]
    #You can replace the '2013-01-01' with the first date in your database
    sql: CASE WHEN {% date_start date_filter %} IS NULL THEN '2013-01-01' ELSE CAST({% date_start date_filter %} AS DATE) END;;
    convert_tz: no
  }

  dimension_group: filter_end_date {
    hidden: yes
    type: time
    timeframes: [raw,date]
    sql: CASE WHEN {% date_end date_filter %} IS NULL THEN CURRENT_DATE() ELSE CAST({% date_end date_filter %} AS DATE) END;;
    convert_tz: no
  }

  dimension: interval {
    hidden: yes
    type: number
    sql: DATE_DIFF(${filter_end_date_raw}, ${filter_start_date_raw}, DAY) ;;
  }

#start date of the previous period
  dimension: previous_start_date {
    hidden: yes
    type: string
    sql: DATE_ADD(${filter_start_date_raw}, INTERVAL- ${interval} DAY);;
  }


  dimension: timeframes {
    view_label: "_PoP {{ _view._name | replace: '_',' ' | capitalize}}"
    type: string
    case: {
      when: {
        sql: ${is_current_period} = true;;
        label: "Selected Period"
      }
      when: {
        sql: ${is_previous_period} = true;;
        label: "Previous Period"
      }
      else: "Not in time period"
    }
  }

## For filtered measures


  dimension: is_current_period {
    hidden: yes
    type: yesno
    sql: ${pop_date_field_date} >= ${filter_start_date_date} AND ${pop_date_field_date} < ${filter_end_date_date} ;;
  }

  dimension: is_previous_period {
    hidden: yes
    type: yesno
    sql: ${pop_date_field_date} >= ${previous_start_date} AND ${pop_date_field_date} < ${filter_start_date_date} ;;
  }

  # measure: selected_period_order_revenue {
  #   view_label: "_PoP"
  #   type: sum
  #   sql: ${sale_price} ;;
  #   filters: [is_current_period: "yes"]
  #   value_format_name: decimal_1
  # }
  # measure: previous_period_order_revenue {
  #   view_label: "_PoP"
  #   type: sum
  #   sql: ${sale_price} ;;
  #   filters: [is_previous_period: "yes"]
  #   value_format_name: decimal_1
  # }

  dimension: ytd_only {hidden:yes}
  dimension: mtd_only {hidden:yes}
  dimension: wtd_only {hidden:yes}

}
