view: products {
  sql_table_name: `thelook.products` ;;
  drill_fields: [id]

  ## DIMENSIONS ##
  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
    label: "ID"
  }
  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    drill_fields: [category, sku]
    label: "Brand"
    link: {
      label: "Google Link"
      url: "http://www.google.com/search?q={{ value }}"
    }
    link: {
      label: "Facebook Link"
      url: "http://www.facebook.com/search?q={{ value }}"
    }
  }
  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    label: "Category"
  }
  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
    label: "Cost"
  }
  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
    label: "Department"
  }
  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
    label: "Distribution Center ID"
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    label: "Name"
  }
  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
    label: "Retail Price"
  }
  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    label: "SKU"
  }

  ## MEASURES ##
  measure: count {
    type: count
    drill_fields: [detail*]
    label: "Count"
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  name,
  distribution_centers.name,
  distribution_centers.id,
  inventory_items.count,
  order_items.count
  ]
  }

}
