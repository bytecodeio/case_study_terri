view: users {
  sql_table_name: `thelook.users` ;;
  drill_fields: [id]

  ## DIMENSIONS ##
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    label: "ID"
  }
  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
    label: "Age"
  }
  dimension: age_tiers {
    type: tier
    description: "Age Tiers of Customers (15-25, 26-35, 36-50, 51-65, 65 & Above"
    tiers: [15,26,36,51,66]
    sql: ${age};;
    style: integer
    label: "Age Tiers"
  }
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    label: "City"
  }
  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    label: "Country"
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
    label: "Created"
  }
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    label: "Email"
  }
  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
    label: "First Name"
  }
  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
    label: "Gender"
  }
  dimension: is_new_customer {
    type: yesno
    sql: ${days_from_signup} <= 90 ;;
    label: "New Customer"
  }
  dimension: is_existing_customer{
    hidden: yes
    type: string
  }
  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
    label: "Last Name"
  }
  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
    label: "Latitude"
  }
  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
    label: "Longitude"
  }
  dimension: new_vs_existing_customers {
    type: string
    description: "New Customers (signup date <= 90 days) and Existing Customers (signup date > 90 days)"
    sql:
      case
        when DATE_DIFF(DATE(CURRENT_DATE()),${created_date},DAY) <= 90
          then 'New Customers'
        else 'Existing Customer'
      end ;;
    label: "New vs Existing Customers"
  }
  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
    label: "Postal Code"
  }
  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    label: "State"
  }
  dimension: street_address {
    type: string
    sql: ${TABLE}.street_address ;;
    label: "Street Address"
  }
  dimension: days_from_signup {
    type: number
    sql: DATE_DIFF(CURRENT_DATE(),${created_date},day) ;;
    label: "Days from Signup"
  }
  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
    label: "Traffic Source"
  }

  ## MEASURES ##
  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
    label: "Count"
  }
  measure: total_users {
    type: count_distinct
    sql: ${id} ;;
    label: "Total Users"
  }
}
