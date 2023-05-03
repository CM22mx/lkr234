view: flights {
  #sql_table_name: demo_db.flights ;;
  derived_table: {
    sql: SELECT arr_delay, arr_time, cancelled, carrier,  dep_delay, dep_time,
                destination, distance, diverted, flight_num, flight_time, id2,
                origin, tail_num, taxi_in, taxi_out
                ,(arr_time - dep_time)  ttt
        FROM demo_db.flights
        WHERE {% condition origin_flight %} origin {% endcondition %}
        AND
        {% if is_cancelled._parameter_value == "'Yes'" %}
             (cancelled = "Y")
            {% elsif is_cancelled._parameter_value == "'No'" %}
            (cancelled = "N")
            {% else %}
            1 = 1
            {% endif %}
        AND
           {% if is_diverted._parameter_value == "'Yes'" %}
            (arr_time is null or (arr_time - dep_time) >= 20)
            {% elsif is_diverted._parameter_value == "'No'" %}
            (arr_time - dep_time) <= 19
            {% else %}
            1 = 1
            {% endif %}
        ;;
   # persist_for: "90 minutes"
  }

dimension:  ttt {
  type: number
  sql: ${TABLE}.ttt;;
  }

  dimension: arr_delay {
    type: number
    sql: ${TABLE}.arr_delay ;;
  }

  dimension_group: arr {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.arr_time ;;
  }

  dimension: cancelled {
    type: string
    sql: ${TABLE}.cancelled ;;
  }

  dimension: carrier {
    type: string
    sql: ${TABLE}.carrier ;;
  }

  dimension: dep_delay {
    type: number
    sql: ${TABLE}.dep_delay ;;
  }

  dimension_group: dep {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.dep_time ;;
  }

  dimension: destination {
    type: string
    sql: ${TABLE}.destination ;;
  }

  dimension: distance {
    type: number
    sql: ${TABLE}.distance ;;
  }

  dimension: diverted {
    type: string
    sql: ${TABLE}.diverted ;;
  }

  dimension: flight_num {
    type: string
    sql: ${TABLE}.flight_num ;;
  }

  dimension: flight_time {
    type: number
    sql: ${TABLE}.flight_time ;;
  }

  dimension: id2 {
    type: number
    sql: ${TABLE}.id2 ;;
  }

  dimension: origin {
    type: string
    sql: ${TABLE}.origin ;;
  }

  dimension: tail_num {
    type: string
    sql: ${TABLE}.tail_num ;;
  }

  dimension: taxi_in {
    type: number
    sql: ${TABLE}.taxi_in ;;
  }

  dimension: taxi_out {
    type: number
    sql: ${TABLE}.taxi_out ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  parameter: is_cancelled {
    type: string
    allowed_value: { value: "Yes"}
    allowed_value: { value: "No"}
  }

  parameter: is_diverted {
    type: string
    allowed_value: { value: "Yes"}
    allowed_value: { value: "No"}
  }

  filter: origin_flight {
    suggest_explore: flights
    suggest_dimension: flights.origin
  }

  filter: destination_flight {
    suggest_explore: flights
    suggest_dimension: flights.destination
  }
}
