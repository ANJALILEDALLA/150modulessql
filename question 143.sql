DROP TABLE IF EXISTS module.airbnb_listings;
CREATE TABLE module.airbnb_listings (
  property_id    INT,
  neighborhood   VARCHAR(40),
  cost_per_night INT,
  room_type      VARCHAR(40),
  amenities      TEXT
);

INSERT INTO module.airbnb_listings VALUES
(101,'Manhattan',80,'Entire home','tv; INTERNET; Kitchen;'),
(102,'Manhattan',80,'Entire home','TV; internet; Kitchen;'),
(103,'Brooklyn',65,'Apartment','TV; Internet; Air Conditioning;'),
(104,'Queens',50,'Entire home','TV; Internet; WiFi; Balcony;'),
(105,'Bronx',90,'Apartment','TV; Internet; Parking'),
(106,'Bronx',80,'Entire home','TV; Internet'),
(107,'Bronx',85,'Entire home','TV; Internet; Pool'),
(201,'Manhattan',70,'Private room','TV; Internet; Heating'),
(202,'Manhattan',75,'Shared room','TV; Internet'),
(203,'Brooklyn',60,'Entire home','Internet; Heating'),
(204,'Brooklyn',55,'Apartment','TV; Kitchen'),
(205,'Queens',45,'Entire home','WiFi; Balcony; Garden'),
(206,'Queens',55,'Entire home','TV; Internet; Heating'),
(207,'Bronx',95,'Apartment','TV; Internet; Gym');

/*143)Company X is analyzing Airbnb listings to help travelers find the most affordable yet well-equipped accommodations in
 various neighborhoods. Many users prefer to stay in entire homes or apartments instead of shared spaces and require essential
 amenities like TV and Internet for work or entertainment.

Your task is to find the cheapest Airbnb listing in each neighborhood that meets the following criteria:
.The property type must be either "Entire home" or "Apartment".
.The property must include both "TV" and "Internet" in its list of amenities.
.Among all qualifying properties in a neighborhood, return the one with the lowest nightly cost.
.If multiple properties have the same lowest cost, return the one with more number of amenities.
.The results(neighborhood, property_id, cost_per_night) should be sorted by neighborhood for better readability.
*/
WITH eligible AS (
  SELECT
    property_id,
    neighborhood,
    cost_per_night,
    amenities,
    /* count amenities by counting semicolons (data has trailing ;) */
    (LENGTH(amenities) - LENGTH(REPLACE(amenities,';',''))) AS amen_cnt
  FROM module.airbnb_listings
  WHERE LOWER(room_type) IN ('entire home','apartment')
    AND amenities REGEXP '(?i)(^|;)[[:space:]]*tv[[:space:]]*(;|$)'
    AND amenities REGEXP '(?i)(^|;)[[:space:]]*internet[[:space:]]*(;|$)'
),
ranked AS (
  SELECT
    neighborhood,
    property_id,
    cost_per_night,
    ROW_NUMBER() OVER (
      PARTITION BY neighborhood
      ORDER BY cost_per_night ASC, amen_cnt DESC, property_id ASC
    ) AS rn
  FROM eligible
)
SELECT neighborhood, property_id, cost_per_night
FROM ranked
WHERE rn = 1
ORDER BY neighborhood;
