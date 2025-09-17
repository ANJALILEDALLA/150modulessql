

/*132)Write an SQL to get the date of the last Sunday as per today's date. If you are solving the problem on Sunday then it should 
still return the date of last Sunday (not current date).
Note : Dates are displayed as per UTC time zone.*/
SELECT DATE_SUB(UTC_DATE(),
                INTERVAL (CASE WHEN DAYOFWEEK(UTC_DATE()) = 1 THEN 7
                               ELSE DAYOFWEEK(UTC_DATE()) - 1 END) DAY) AS last_sunday_utc;
