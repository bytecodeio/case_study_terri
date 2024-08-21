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
      label: "Brand Comparisons Dashboard"
      url: "https://looker.bytecode.io/dashboards/6K9wPzBSBUyuDGk4YvYFaN?Brand={{ value | url_encode }}&Category="
    }
    link: {
      label: "Google Link"
      url: "http://www.google.com/search?q={{ value }}"
    }
    link: {
      label: "Facebook Link"
      url: "http://www.facebook.com/search?q={{ value }}"
    }
  }
  dimension: brand_group {
    type: string
    sql: case
          when {% condition brand_selector %} ${brand} {% endcondition %} then ${brand}
          else 'Other Brands'
        end;;
    label: "Brand Group"
    description: "Group created for brand comparison dashboard to group the selected brand and compare to the rest"
  }
  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    drill_fields: [brand]
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

   # ----- Filters ------
  filter: brand_selector {
    suggest_dimension: brand
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
