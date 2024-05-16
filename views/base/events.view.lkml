view: events {
  sql_table_name: `thelook.events` ;;
  drill_fields: [id]

  ## DIMENSIONS ##
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    label: "ID"
  }
  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
    label: "Browser"
  }
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    label: "City"
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
    label: "Created"
  }
  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
    label: "Event Type"
  }
  dimension: ip_address {
    type: string
    sql: ${TABLE}.ip_address ;;
    label: "IP Address"
  }
  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
    label: "Postal Code"
  }
  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
    label: "Sequence Number"
  }
  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
    label: "Session ID"
  }
  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    label: "State"
  }
  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
    label: "Traffic Source"
  }
  dimension: uri {
    type: string
    sql: ${TABLE}.uri ;;
    label: "URI"
  }
  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
    label: "User ID"
  }

  ## MEASURES ##
  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.id, users.first_name]
    label: "Count"
  }
}
