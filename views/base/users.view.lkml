view: users {
  sql_table_name: `thelook.users` ;;
  drill_fields: [id]

  ## DIMENSIONS ##
  dimension: id {
    primary_key: yes
    # hidden: yes
    type: number
    sql: ${TABLE}.id ;;
    label: "ID"
  }
  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
    label: "Age"
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
    drill_fields: [users.id, order_items_users_cv.total_gross_revenue]
    label: "Country"
  }
  dimension_group: created {
    hidden: yes
    type: time
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
    sql: ${TABLE}.created_at ;;
    label: "Created"
    convert_tz: no
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
}
