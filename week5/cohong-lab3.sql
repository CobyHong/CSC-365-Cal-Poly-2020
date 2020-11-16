-- Lab 3
-- cohong
-- Oct 14, 2020

USE `cohong`;
-- BAKERY-1
-- Using a single SQL statement, reduce the prices of Lemon Cake and Napoleon Cake by $2.
update goods
set Price = Price - 2
where (Flavor = "Lemon" AND FOOD = "Cake") OR (Flavor = "Napoleon" AND Food = "Cake");


USE `cohong`;
-- BAKERY-2
-- Using a single SQL statement, increase by 15% the price of all Apricot or Chocolate flavored items with a current price below $5.95.
update goods
set Price = Price + (0.15 * Price)
where (Flavor = "Chocolate" or Flavor = "Apricot") and Price < 5.95;


USE `cohong`;
-- BAKERY-3
-- Add the capability for the database to record payment information for each receipt in a new table named payments (see assignment PDF for task details)
drop table if exists payments;

create table payments(
    Receipt int,
    Amount numeric(10,2),
    PaymentSettled Datetime,
    PaymentType varchar(100),
    foreign key (Receipt) references receipts (RNumber),
    primary key (Receipt, Amount, PaymentSettled, PaymentType)
);


USE `cohong`;
-- BAKERY-4
-- Create a database trigger to prevent the sale of Meringues (any flavor) and all Almond-flavored items on Saturdays and Sundays.
create trigger restrict_weekends before  insert on items

for each row
    begin

    declare goods_food varchar(100); -- no meringues.
    DECLARE goods_flavor varchar(100); -- no almond flavor.
    declare receipts_date date; -- no weekend sales.

    select Food into goods_food from goods where GId = new.Item;
    select Flavor into goods_flavor from goods where GId = new.Item;
    select SaleDate into receipts_date from receipts where RNumber = new.Receipt;

    if  (
            ((dayname(receipts_date) = "Saturday") or (dayname(receipts_date) = "Sunday")) and
            (goods_food = "Meringue" or goods_flavor = "Almond")
        ) then

        signal sqlstate '45000'
        set message_text = "No meringues until Monday";

    end if;
    end;


USE `cohong`;
-- AIRLINES-1
-- Enforce the constraint that flights should never have the same airport as both source and destination (see assignment PDF)
create trigger check_flight before insert on flights

for each row
    begin
    
    declare flights_source varchar(100);
    declare flights_dest varchar(100);
    
    set flights_source = new.SourceAirport;
    set flights_dest = new.DestAirport;
    
    if (flights_source = flights_dest) then
        signal sqlstate '45000'
        set message_text = "Source and Destination cannot be the same";

    end if;
    end;


USE `cohong`;
-- AIRLINES-2
-- Add a "Partner" column to the airlines table to indicate optional corporate partnerships between airline companies (see assignment PDF)
alter table airlines add Partner varchar(100);

create trigger self_partner_check before insert on airlines

for each row
    begin

    declare airlines_abbreviation varchar(100);
    declare airlines_partner varchar(100);
    
    set airlines_abbreviation = new.Abbreviation;
    set airlines_partner = new.Partner;
    
    if(airlines_abbreviation = airlines_partner) then
        signal sqlstate '45000'
        set message_text = "invalid self-partner"

    end if;
    end;
    

create trigger airline_exists_check before insert on airlines
for each row

    begin

    declare airline_exist int;

    if (NEW.Partner is not null) then
        select COUNT(*) from airlines where Abbreviation = new.Partner into airline_exist;
        if (airline_exist = 0) then
            signal sqlstate '45000'
            SET message_text = "Partner does not exist";
        end if;
    end if;
    end;
    

create trigger current_partner_already_check before insert on airlines
for each row
    begin

    declare current_partner varchar(100);

    IF (new.Partner is not null) then
        select Partner into current_partner from airlines where Abbreviation = new.Partner;
        if (current_partner is not null) then
            signal sqlstate '45000'
            set message_text = "Error with adding partner";
        end if;
    end if;
    end;


create trigger update_flight_check before update on airlines
for each row
    begin
    
    declare temp_airline varchar(100);
    declare temp_abbreviation varchar(100);
    declare temp_country varchar(100);
    declare curr_partner varchar(100);
    declare temp_id int;

    if (new.Partner is not null) then
        select Partner into curr_partner from airlines where Abbreviation = new.Partner;
        if (curr_partner is not  null and curr_partner != new.Abbreviation) then
            signal sqlstate '45000'
            set message_text = "Error with updating partner";
        end if;
    end if;
    end;
    

select * from airlines;

update airlines
set Partner = "Southwest" where Abbreviation = "JetBlue";

update airlines
set Partner = "JetBlue" where Abbreviation = "Southwest";


USE `cohong`;
-- KATZENJAMMER-1
-- Change the name of two instruments: 'bass balalaika' should become 'awesome bass balalaika', and 'guitar' should become 'acoustic guitar'. This will require several steps. You may need to change the length of the instrument name field to avoid data truncation. Make this change using a schema modification command, rather than a full DROP/CREATE of the table.
update Instruments
set Instrument = "awesome bass balalaika"
where Instrument = "bass balalaika";
    
update Instruments
set Instrument = "acoustic guitar"
where Instrument = "guitar";


USE `cohong`;
-- KATZENJAMMER-2
-- Keep in the Vocals table only those rows where Solveig (id 1 -- you may use this numeric value directly) sang, but did not sing lead.
delete from Vocals where (`Type` = 'lead' or BandMate != 1);


