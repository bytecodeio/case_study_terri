view: method6_base {
  extension: required
#   # ----- USER FILTERS (Period over Period) ----- #
  filter: first_period_filter {
    view_label: "_PoP"
    group_label: "Arbitrary Period Comparisons"
    description: "Choose the first date range to compare against. This must be before the second period"
    type: date
  }

  filter: second_period_filter {
    view_label: "_PoP"
    group_label: "Arbitrary Period Comparisons"
    description: "Choose the second date range to compare to. This must be after the first period"
    type: date
  }

# ## ------------------ HIDDEN HELPER DIMENSIONS  ------------------ ##

  dimension_group: pop_date_field {
    type: time
    sql:  ;;
    timeframes: [date,raw]
  }
  dimension: days_from_start_first {
    view_label: "_PoP"
    hidden: yes
    type: number
    sql: DATE_DIFF(${pop_date_field_raw}, {% date_start first_period_filter %}, day) ;;
  }

  dimension: days_from_start_second {
    view_label: "_PoP"
    hidden: yes
    type: number
    sql: DATE_DIFF(${pop_date_field_raw}, {% date_start second_period_filter %}, day) ;;
  }

# ## ------------------ DIMENSIONS TO PLOT ------------------ ##

  dimension: days_from_first_period {
    view_label: "_PoP"
    description: "Select for Grouping (Rows)"
    group_label: "Arbitrary Period Comparisons"
    type: number
    sql:
            CASE
            WHEN ${days_from_start_second} >= 0
            THEN ${days_from_start_second}
            WHEN ${days_from_start_first} >= 0
            THEN ${days_from_start_first}
            END;;
    label: "Days from Start of Period"
  }

  dimension: period_selected {
    view_label: "_PoP"
    group_label: "Arbitrary Period Comparisons"
    label: "First or second period"
    description: "Select for Comparison (Pivot)"
    type: string
    sql:
            CASE
                WHEN {% condition first_period_filter %}${pop_date_field_raw} {% endcondition %}
                THEN 'First Period'
                WHEN {% condition second_period_filter %}${pop_date_field_raw} {% endcondition %}
                THEN 'Second Period'
                END ;;
  }
}
