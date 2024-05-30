# View file used to incorporate Method 2 of PoP filters: Allows users to choose periods with parameters
view: method2_base {
  extension: required  #view cannot be used on its own amd must be extended - also hides view from end users

# ## ------------------ HELPER DIMENSIONS & PARAMETERS  ------------------ ##

  dimension_group: pop_date_field {
    type: time
    sql: "Must be overwritten within a refinement or extension";;
    timeframes: [raw,
      time,
      date,
      day_of_week,
      day_of_week_index,
      day_of_year,
      week,
      month,
      month_name,
      month_num,
      day_of_month,
      quarter,
      year]
    convert_tz: no
  }

  parameter: choose_breakdown {
    label: "Choose Grouping (Rows)"
    view_label: "_PoP"
    type: unquoted
    default_value: "Month"
    allowed_value: {label: "Month Name" value:"Month"}
    allowed_value: {label: "Day of Year" value: "DOY"}
    allowed_value: {label: "Day of Month" value: "DOM"}
    # allowed_value: {label: "Day of Week" value: "DOW"}
    allowed_value: {value: "Date"}
  }

  parameter: choose_comparison {
    label: "Choose Comparison (Pivot)"
    view_label: "_PoP"
    type: unquoted
    default_value: "Year"
    allowed_value: {value: "Year" }
    allowed_value: {value: "Quarter"}
    allowed_value: {value: "Month"}
    # allowed_value: {value: "Week"}
  }

  # ## ------------------ DIMENSIONS TO PLOT ------------------ ##

  dimension: pop_row  {
    view_label: "_PoP"
    label_from_parameter: choose_breakdown
    type: string
    order_by_field: sort_by1 # Important
    sql:
        {% if choose_breakdown._parameter_value == 'Month' %} ${pop_date_field_month_name}
        {% elsif choose_breakdown._parameter_value == 'DOY' %} ${pop_date_field_day_of_year}
        {% elsif choose_breakdown._parameter_value == 'DOM' %} ${pop_date_field_day_of_month}
        {% elsif choose_breakdown._parameter_value == 'Date' %} ${pop_date_field_date}
        {% else %}NULL{% endif %} ;;
  }

  dimension: pop_pivot {
    view_label: "_PoP"
    label_from_parameter: choose_comparison
    type: string
    order_by_field: sort_by2 # Important
    sql:
        {% if choose_comparison._parameter_value == 'Year' %} ${pop_date_field_year}
        {% elsif choose_comparison._parameter_value == 'Quarter' %} ${pop_date_field_quarter}
        {% elsif choose_comparison._parameter_value == 'Month' %} ${pop_date_field_month_name}
        {% else %}NULL{% endif %} ;;
  }


  # These hidden dimensions are just to make sure the dimensions sort correctly
  dimension: sort_by1 {
    hidden: yes
    type: number
    sql:
        {% if choose_breakdown._parameter_value == 'Month' %} ${pop_date_field_month_num}
        {% elsif choose_breakdown._parameter_value == 'DOY' %} ${pop_date_field_day_of_year}
        {% elsif choose_breakdown._parameter_value == 'DOM' %} ${pop_date_field_day_of_month}
        {% elsif choose_breakdown._parameter_value == 'Date' %} ${pop_date_field_date}
        {% else %}NULL{% endif %} ;;
  }

  dimension: sort_by2 {
    hidden: yes
    type: string
    sql:
        {% if choose_comparison._parameter_value == 'Year' %} ${pop_date_field_year}
        {% elsif choose_comparison._parameter_value == 'Month' %} ${pop_date_field_quarter}
        {% elsif choose_comparison._parameter_value == 'Month' %} ${pop_date_field_month_num}
        {% elsif choose_comparison._parameter_value == 'Week' %} ${pop_date_field_week}
        {% else %}NULL{% endif %} ;;
  }
}
