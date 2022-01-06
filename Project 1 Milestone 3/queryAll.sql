USE wlvaxinfo2;

/*1*/
/*
	The date literal in the last line needs to be provided 
    by the user as the current date.
*/
SELECT CONCAT(first_name, " ", last_name) AS name, 
	CASE
		WHEN
			MONTH(today) < MONTH(dob)
            OR (MONTH(today) = MONTH(dob)
            AND DAY(today) < DAY(dob))
		THEN
			YEAR(today) - YEAR(dob) - 1
		ELSE
			YEAR(today) - YEAR(dob)
		END AS age
FROM folk, (SELECT "2021-12-15" AS today) AS temp;

/*2*/
SELECT city, state, COUNT(res_id) as resident_count
FROM (residence NATURAL JOIN place)
	JOIN folk ON residence.place_id = folk.res_id
GROUP BY city
ORDER BY resident_count DESC;

/*3*/
SELECT state, count(residence.place_id)
FROM place LEFT OUTER JOIN residence ON place.place_id = residence.place_id
GROUP BY state
ORDER BY state ASC;

/*4*/
/*
	The two date literals in the second to last line need to be provided 
    by the user and the int literal in the last line needs to be provided
    by the user as a place_2.
*/
SELECT PIN
FROM registered_for
WHERE date BETWEEN "2021-12-15" AND "2022-02-28"
AND place_id = 2;

/*5*/
/*
	The list literal in the second to last line needs to be provided 
    by the user as a list of coordinates's and the int literal in the
    last line needs to be provided by the user as a month.
*/
SELECT COUNT(DISTINCT PIN) as staff_within_five_miles
FROM dispatched_to NATURAL JOIN health_center NATURAL JOIN place
WHERE POWER(coord_x, 2) + POWER(coord_y, 2) <= 25
	AND (coord_x, coord_y) NOT IN ((0.0, 0.0), (1.0, 1.0))
    AND MONTH(date) = 12;

/*6*/
/*
	The string literal in the third to last line needs to be provided 
    by the user as a city name and the int literal in the
    last line needs to be provided by the user as a month.
*/
SELECT place.*
FROM place NATURAL JOIN health_center NATURAL JOIN registered_for
	JOIN
	(SELECT city, MONTH(date) as month, MAX(popularity) AS most_pop
	FROM place NATURAL JOIN health_center NATURAL JOIN registered_for
		NATURAL JOIN
		(SELECT place_id, COUNT(PIN) AS popularity
        FROM place NATURAL JOIN health_center NATURAL JOIN registered_for
        GROUP BY city, MONTH(date), place_id) AS pop_info
	GROUP BY city, month) AS max_pop_info ON place.city = max_pop_info.city
						AND MONTH(registered_for.date) = max_pop_info.month
WHERE place.city = "The Primary Keys" AND MONTH(date) = 01
GROUP BY place.city, max_pop_info.month, place_id
HAVING COUNT(PIN) = ROUND(AVG(most_pop), 0);

/*7*/
/*
	The string literal in the last line needs to be provided 
    by the user as a state name.
*/
SELECT folk.*
FROM folk NATURAL JOIN
	((SELECT PIN, state, COUNT(dispatched_to.place_id) as num_dispatched
	FROM dispatched_to NATURAL JOIN health_center NATURAL JOIN place
	GROUP BY PIN, state) AS dispatch_info
    JOIN
    (SELECT state, COUNT(place_id) as num_hcs
    FROM health_center NATURAL JOIN place
    GROUP BY state) as state_hc_info
    ON dispatch_info.state = state_hc_info.state
		AND dispatch_info.num_dispatched = state_hc_info.num_hcs)
WHERE dispatch_info.state = "Oheyo";

/*8*/
SELECT folk.*
FROM folk NATURAL JOIN
	(SELECT PIN, POWER(hc_place_info.coord_x - res_place_info.coord_x, 2)
		+ POWER(hc_place_info.coord_y - res_place_info.coord_y, 2) as squared_distance
	FROM (place as hc_place_info) NATURAL JOIN health_center NATURAL JOIN
		registered_for NATURAL JOIN folk JOIN (place as res_place_info)
		ON folk.res_id = res_place_info.place_id) AS dist_to_reg
	JOIN
    (SELECT PIN, MIN(POWER(hc_place_info.coord_x - res_place_info.coord_x, 2)
			+ POWER(hc_place_info.coord_y - res_place_info.coord_y, 2)) as squared_distance
	FROM folk JOIN (place as res_place_info)
		ON folk.res_id = res_place_info.place_id,
		health_center NATURAL JOIN (place as hc_place_info)
	GROUP BY (PIN)) AS closest_hc
    ON dist_to_reg.PIN = closest_hc.PIN
WHERE dist_to_reg.squared_distance > closest_hc.squared_distance; 

/*9*/
/*
	Test call of the function. All arguments must be provided
	by the user.
*/
SELECT num_folks_registered(1, 1337, 2021); 