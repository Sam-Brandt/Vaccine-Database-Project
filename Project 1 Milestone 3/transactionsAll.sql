USE wlvaxinfo2;

/*1*/
/*
	All literals must be provided as place information by the user.
*/
INSERT INTO place
VALUES (7, 100, "Test Street", "Transaction City",
"Calichussets", 48148, 100, 200);

/*2*/
/*
	All literals must be provided as PINs by the user.
*/
UPDATE folk
SET PIN = 13
WHERE PIN = 1;

/*3*/
/*
	All literals must be provided as registration infomation by the user.
*/
INSERT INTO registered_for VALUES (12, 6, "2022-02-14")
ON DUPLICATE KEY
UPDATE
place_id = 6, date = "2022-02-14";

/*4*/
/*
	The int literal in the last line must be provided as a
    place_id by the user.
*/
DELETE FROM place
WHERE place_id IN (SELECT place_id FROM health_center)
	AND place_id = 2;
    
    
/*5*/
/*
	The int literal in the last line must be provided as a
    place_id by the user and the double literals in the second
    to last line must be provided as cooridinate information
    by the user.
*/
UPDATE place
SET coord_x = 1.0, coord_y = 2.0
WHERE place_id = 2;