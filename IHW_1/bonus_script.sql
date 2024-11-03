SELECT
    a.airport_code,
    COALESCE(d.departure_flights_num, 0) AS departure_flights_num,
    COALESCE(d.departure_psngr_num, 0) AS departure_psngr_num,
    COALESCE(arrival.arrival_flights_num, 0) AS arrival_flights_num,
    COALESCE(arrival.arrival_psngr_num, 0) AS arrival_psngr_num
FROM
    travel.airports a
JOIN (
    SELECT
        f.departure_airport AS airport_code,
        COUNT(DISTINCT f.flight_id) AS departure_flights_num,
        COUNT(tf.ticket_no) AS departure_psngr_num
    FROM
        travel.flights f
    JOIN travel.ticket_flights tf ON f.flight_id = tf.flight_id
    GROUP BY f.departure_airport
) AS d ON a.airport_code = d.airport_code
JOIN (
    SELECT
        f.arrival_airport AS airport_code,
        COUNT(DISTINCT f.flight_id) AS arrival_flights_num,
        COUNT(tf.ticket_no) AS arrival_psngr_num
    FROM
        travel.flights f
    JOIN travel.ticket_flights tf ON f.flight_id = tf.flight_id
    GROUP BY f.arrival_airport
) AS arrival ON a.airport_code = arrival.airport_code
ORDER BY a.airport_code;
