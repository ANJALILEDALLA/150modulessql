DROP TABLE IF EXISTS module.passenger_flights;
CREATE TABLE module.passenger_flights (
  Passenger_id  VARCHAR(10),
  Flight_id     VARCHAR(10),
  Departure_date DATE
);

DROP TABLE IF EXISTS module.flight_details;
CREATE TABLE module.flight_details (
  Flight_id          VARCHAR(10),
  Departure_airport  VARCHAR(10),
  Arrival_airport    VARCHAR(10)
);

INSERT INTO module.passenger_flights VALUES
('P001','F101','2025-03-02'),
('P001','F102','2025-04-02'),
('P001','F103','2025-05-10'),
('P001','F104','2025-06-09'),
('P001','F105','2024-08-02'),
('P001','F106','2024-05-19'),
('P001','F107','2024-09-20'),
('P001','F108','2024-04-29'),
('P001','F109','2024-05-01'),
('P001','F110','2024-12-04'),
('P001','F111','2025-01-07'),
('P001','F112','2025-03-06'),
('P002','F101','2024-11-15'),
('P002','F103','2025-02-14'),
('P002','F106','2024-10-02'),
('P002','F109','2025-01-05'),
('P002','F110','2025-04-20'),
('P002','F112','2025-05-22'),
('P003','F108','2023-07-01');

INSERT INTO module.flight_details VALUES
('F101','JFK','LAX'),
('F102','JFK','ORD'),
('F103','JFK','ATL'),
('F104','JFK','LAX'),
('F105','JFK','SEA'),
('F106','JFK','MIA'),
('F107','JFK','DFW'),
('F108','JFK','SFO'),
('F109','JFK','LAS'),
('F110','JFK','BOS'),
('F111','JFK','PHX'),
('F112','JFK','DEN');


/*141)Identify passengers with more than 5 flights from the same airport since last 1 year from current date.
 Display passenger id, departure airport code and number of flights.*/
SELECT
  pf.Passenger_id,
  fd.Departure_airport AS departure_airport_code,
  COUNT(*) AS num_flights
FROM module.passenger_flights pf
JOIN module.flight_details fd
  ON pf.Flight_id = fd.Flight_id
WHERE pf.Departure_date >= DATE_SUB(UTC_DATE(), INTERVAL 1 YEAR)
GROUP BY pf.Passenger_id, fd.Departure_airport
HAVING COUNT(*) > 5
ORDER BY pf.Passenger_id, fd.Departure_airport;
