view: inventory_items {
  sql_table_name: `thelook.inventory_items` ;;
  drill_fields: [id]

  ## DIMENSIONS ##
  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
    label: "ID"
  }
  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
    label: "Cost"
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
    label: "Created"
  }
  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
    label: "Product Brand"
  }
  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
    label: "Product Category"
  }
  dimension: product_department {
    type: string
    sql: ${TABLE}.product_department ;;
    label: "Product Department"
  }
  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
    label: "Product Distribution Center ID"
  }
  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
    label: "Product ID"
  }
  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
    label: "Product Name"
  }
  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.product_retail_price ;;
    label: "Product Retail Price"
  }
  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
    label: "Product SKU"
  }
  dimension_group: sold {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.sold_at ;;
    label: "Sold Date"
  }

}
