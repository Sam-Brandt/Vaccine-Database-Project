USE wlvaxinfo2;

drop index state_index ON place;
drop index city_index ON place;
drop index coord_index ON place;
drop index reg_date_index ON registered_for;
drop trigger regist_insert;
drop function num_folks_registered;
drop table vaccine_order;
drop table dispatched_to;
drop table registered_for;
drop table health_staff;
drop table email_address;
drop table folk;
drop table health_center;
drop table residence;
drop table place;