# Refinement view file for any additions to the users view
# which will be treated as the raw view file

include: "/views/base/users.view"
include: "/views/pop_base/method3_base.view.lkml"

view: +users {
  extends: [method3_base]
  dimension_group: pop_date_field {
    sql: ${created_raw} ;;
    group_label: "Customer Signup Date"
  }

  ## DIMENSIONS ##
  dimension: age_tiers {
    type: tier
    description: "Age Tiers of Customers (15-25, 26-35, 36-50, 51-65, 65 & Above"
    tiers: [15,26,36,51,66]
    sql: ${age};;
    style: integer
    label: "Age Tiers"
  }
  dimension: days_from_signup {
    type: number
    sql: DATE_DIFF(CURRENT_DATE(),${created_date},day) ;;
    label: "Days from Signup"
  }
  dimension: dynamic_cohort_date {
    type: string
    label_from_parameter: date_granularity
    sql:
      {% if date_granularity._parameter_value == 'day' %}
        DATE_DIFF(CURRENT_DATE(),${created_date},day)
      {% elsif date_granularity._parameter_value == 'week' %}
        DATE_DIFF(CURRENT_DATE(),${created_date},week)
      {% elsif date_granularity._parameter_value == 'month' %}
        DATE_DIFF(CURRENT_DATE(),${created_date},month)
      {% elsif date_granularity._parameter_value == 'quarter' %}
        DATE_DIFF(CURRENT_DATE(),${created_date},quarter)
      {% else %}
        DATE_DIFF(CURRENT_DATE(),${created_date},day)
      {% endif %};;
  }
  dimension: dynamic_created_date {
    type: string
    label_from_parameter: date_granularity
    sql:
      {% if date_granularity._parameter_value == 'day' %}
        ${created_date}
      {% elsif date_granularity._parameter_value == 'week' %}
        ${created_week}
      {% elsif date_granularity._parameter_value == 'month' %}
        ${created_month}
      {% elsif date_granularity._parameter_value == 'quarter' %}
        ${created_quarter}
      {% else %}
        ${created_date}
      {% endif %};;
  }
  dimension_group: signup_period  {
    type: duration
    sql_start: ${created_date} ;;
    sql_end: current_date() ;;
    intervals: [day, week, month, quarter]
    convert_tz: no
  }
  dimension: is_new_customer {
    type: yesno
    sql: ${days_from_signup} <= 90 ;;
    label: "New Customer"
  }
  dimension: new_vs_existing_customers {
    type: string
    description: "New Customers (signup date <= 90 days) and Existing Customers (signup date > 90 days)"
    sql:
      case
        when DATE_DIFF(DATE(CURRENT_DATE()),${created_date},DAY) <= 90
          then 'New Customers'
        else 'Existing Customers'
      end ;;
    label: "New vs Existing Customers"
  }

  ## MEASURES ##
  measure: average_days_since_signup {
    type: average
    sql: ${days_from_signup} ;;
    label: "Average Days Since Signup"
  }
  measure: average_months_since_signup {
    type: average
    sql: ${days_from_signup} ;;
    label: "Average Months Since Signup"
  }
  measure: total_users {
    type: count_distinct
    sql: ${id} ;;
    label: "Total Users"
  }
  measure: dynamic_sum {
    type: sum
    sql: ${TABLE}.{% parameter measure_to_add_up %} ;;
    value_format_name: "decimal_0"
  }

  ## PARAMETERS ##
  parameter: date_granularity {
    type: unquoted
    allowed_value: {
      label: "By Day"
      value: "day"
    }
    allowed_value: {
      label: "By Week"
      value: "week"
    }
    allowed_value: {
      label: "By Month"
      value: "month"
    }
    allowed_value: {
      label: "By Quarter"
      value: "quarter"
    }
  }
}
