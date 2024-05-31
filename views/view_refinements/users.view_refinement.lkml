# Refinement view file for any additions to the users view
# which will be treated as the raw view file

include: "/views/base/users.view"
include: "/views/pop_base/method6_base.view.lkml"

view: +users {
  extends: [method6_base]
  dimension_group: pop_date_field {
    sql: ${created_raw} ;;
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
  measure: total_users {
    type: count_distinct
    sql: ${id} ;;
    label: "Total Users"
  }
}
