CREATE DATABASE IF NOT EXISTS wlvaxinfo2;

USE wlvaxinfo2;

create table place (
	place_id			numeric(16),
    
    street_number		int,
    street_name			varchar(50),
    city				varchar(50),
    state				varchar(15),
    zipcode				numeric(5),
    
    coord_x				double,
    coord_y				double,
    
    primary key (place_id)
);

create table residence (
	place_id			numeric(16),
    unique (place_id),
    foreign key (place_id) references place(place_id)
		on update cascade
		on delete cascade
);

create table health_center (
	place_id			numeric(16),
    unique (place_id),
    foreign key (place_id) references place(place_id)
		on update cascade
		on delete cascade
);

create table folk (
	PIN					numeric(16),
	first_name			varchar(20),
    last_name			varchar(20),
    dob 				date,
    
    work_phone			numeric(10),
    mobile_phone		numeric(10),
    home_phone			numeric(10),
    
    res_id		numeric(16) not null,
    
    foreign key (res_id) references residence(place_id)
		on update cascade,
    primary key (PIN)
);

create table email_address (
	PIN					numeric(16),
    address				varchar(50),
    foreign key (PIN) references folk(PIN)
		on update cascade
		on delete cascade
);

create table health_staff (
	PIN 				numeric(16),
    is_cheif 			enum("Yes", "No"),
    foreign key (PIN) references folk(PIN)
		on update cascade
		on delete cascade
);

create table registered_for (
	PIN					numeric(16),
    place_id			numeric(16),
    date				date,
    primary key (PIN),
    foreign key (PIN) references folk(PIN)
		on update cascade
		on delete cascade,
    foreign key (place_id) references health_center(place_id)
		on update cascade
		on delete cascade
);

create table dispatched_to (
	PIN					numeric(16),
    place_id			numeric(16),
    date				date,
    foreign key (PIN) references health_staff(PIN)
		on update cascade
		on delete cascade,
    foreign key (place_id) references health_center(place_id)
		on update cascade
		on delete cascade
);

create table vaccine_order (
	healthcenter_id		numeric(16),
    number_of_doses		int,
    delivery_date		date,
    modification_time	datetime,
    unique (healthcenter_id),
    foreign key (healthcenter_id) references health_center(place_id)
		on update cascade
        on delete cascade
);

DELIMITER //
CREATE FUNCTION num_folks_registered(month int, loc_x double, loc_y double) RETURNS int DETERMINISTIC
BEGIN
	DECLARE returnVal int;
	SELECT COUNT(DISTINCT PIN)
		FROM registered_for NATURAL JOIN folk
        JOIN place ON folk.res_id = place.place_id
		WHERE POWER(coord_x - loc_x, 2) + POWER(coord_y - loc_y, 2) <= 100
			AND MONTH(date) = month
	INTO returnVal;
	RETURN returnVal;
END
// DELIMITER ;

CREATE TRIGGER regist_insert AFTER INSERT ON registered_for
FOR EACH ROW
    UPDATE vaccine_order
    SET number_of_doses = number_of_doses + 1,
		modification_time = NOW()
    WHERE healthcenter_id = NEW.place_id;
    
CREATE INDEX reg_date_index
ON registered_for (date);

CREATE INDEX coord_index
ON place (coord_x, coord_y);

CREATE INDEX city_index
ON place (city);

CREATE INDEX state_index
ON place (state);