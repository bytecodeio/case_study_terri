view: distribution_centers {
  sql_table_name: `thelook.distribution_centers` ;;
  drill_fields: [id]

  ## DIMENSIONS ##
  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
    label: "ID"
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
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    label: "Name"
  }

  ## MEASURES ##
  measure: count {
    type: count
    drill_fields: [id, name, products.count]
    label: "Count"
  }
}
