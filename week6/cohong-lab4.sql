-- Lab 4
-- cohong
-- Oct 21, 2020

USE `STUDENTS`;
-- STUDENTS-1
-- Find all students who study in classroom 111. For each student list first and last name. Sort the output by the last name of the student.
select FirstName, LastName from list
where classroom = 111
order by LastName;


USE `STUDENTS`;
-- STUDENTS-2
-- For each classroom report the grade that is taught in it. Report just the classroom number and the grade number. Sort output by classroom in descending order.
select distinct classroom, grade from list
order by classroom desc;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all teachers who teach fifth grade. Report first and last name of the teachers and the room number. Sort the output by room number.
select distinct teachers.First, teachers.Last, teachers.classroom
from teachers 
inner join list on teachers.classroom = list.classroom
where list.grade = 5
order by teachers.classroom;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all students taught by OTHA MOYER. Output first and last names of students sorted in alphabetical order by their last name.
select distinct FirstName, LastName
from list
inner join teachers on teachers.classroom = list.classroom
where teachers.First = "OTHA" and teachers.last = "MOYER"
order by list.LastName;


USE `STUDENTS`;
-- STUDENTS-5
-- For each teacher teaching grades K through 3, report the grade (s)he teaches. Each name has to be reported exactly once. Sort the output by grade and alphabetically by teacher’s last name for each grade.
select distinct teachers.First, teachers.Last, list.grade
from teachers inner join list on teachers.classroom = list.classroom
where list.grade <= 3
order by grade, teachers.Last;


USE `BAKERY`;
-- BAKERY-1
-- Find all chocolate-flavored items on the menu whose price is under $5.00. For each item output the flavor, the name (food type) of the item, and the price. Sort your output in descending order by price.
select Flavor, Food, Price
from goods
where flavor = "Chocolate" and Price < 5
order by Price desc;


USE `BAKERY`;
-- BAKERY-2
-- Report the prices of the following items (a) any cookie priced above $1.10, (b) any lemon-flavored items, or (c) any apple-flavored item except for the pie. Output the flavor, the name (food type) and the price of each pastry. Sort the output in alphabetical order by the flavor and then pastry name.
select Flavor, Food, Price
from goods
where (price > 1.1 and Food = "Cookie") or (Flavor = "Lemon") or (Flavor = "Apple" and Food != "Pie")
order by Flavor, Food;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who made a purchase on October 3, 2007. Report the name of the customer (last, first). Sort the output in alphabetical order by the customer’s last name. Each customer name must appear at most once.
select distinct LastName, FirstName
from customers
inner join receipts on customers.CId = receipts.Customer
where receipts.SaleDate = "2007-10-03"
order by LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find all different cakes purchased on October 4, 2007. Each cake (flavor, food) is to be listed once. Sort output in alphabetical order by the cake flavor.
select distinct Flavor, Food
from goods
inner join items on goods.GId = items.Item
inner join receipts on items.Receipt = receipts.RNumber
where Food = "Cake" and receipts.SaleDate = "2007-10-04"
order by Flavor;


USE `BAKERY`;
-- BAKERY-5
-- List all pastries purchased by ARIANE CRUZEN on October 25, 2007. For each pastry, specify its flavor and type, as well as the price. Output the pastries in the order in which they appear on the receipt (each pastry needs to appear the number of times it was purchased).
select distinct Flavor, Food, Price
from goods
inner join items on items.Item = goods.GId
inner join receipts on receipts.RNumber = items.Receipt
inner join customers on customers.CId = receipts.Customer
where customers.Firstname = "ARIANE" and customers.LastName = "CRUZEN" and receipts.SaleDate = "2007-10-25";


USE `BAKERY`;
-- BAKERY-6
-- Find all types of cookies purchased by KIP ARNN during the month of October of 2007. Report each cookie type (flavor, food type) exactly once in alphabetical order by flavor.

select distinct Flavor, Food
from goods
inner join items on items.Item = goods.GId
inner join receipts on receipts.RNumber = items.Receipt
inner join customers on customers.CId = receipts.Customer
WHERE customers.Firstname = "KIP" AND customers.LastName = "ARNN" AND receipts.SaleDate >= "2007-10-01" AND receipts.SaleDate <= "2007-10-31" AND Food = "Cookie"
order by Flavor;


USE `CSU`;
-- CSU-1
-- Report all campuses from Los Angeles county. Output the full name of campus in alphabetical order.
select campus
from campuses
where County = "Los Angeles"
order by campus;


USE `CSU`;
-- CSU-2
-- For each year between 1994 and 2000 (inclusive) report the number of students who graduated from California Maritime Academy Output the year and the number of degrees granted. Sort output by year.
select degrees.Year, degrees.Degrees
from degrees
inner join campuses on campuses.Id = degrees.CampusId
where campuses.Campus = "California Maritime Academy" and degrees.Year <= 2000
order by degrees.Year;


USE `CSU`;
-- CSU-3
-- Report undergraduate and graduate enrollments (as two numbers) in ’Mathematics’, ’Engineering’ and ’Computer and Info. Sciences’ disciplines for both Polytechnic universities of the CSU system in 2004. Output the name of the campus, the discipline and the number of graduate and the number of undergraduate students enrolled. Sort output by campus name, and by discipline for each campus.
select distinct campuses.campus, disciplines.Name, discEnr.Gr, discEnr.Ug
from degrees
inner join campuses on campuses.id = degrees.CampusId
inner join discEnr on discEnr.CampusId = campuses.id
inner join disciplines on disciplines.Id = discEnr.Discipline
where (disciplines.Name = "Engineering" or disciplines.Name = "Mathematics" or disciplines.Name = "Computer and Info. Sciences") and campuses.campus like "%Polytechnic%"
order by campuses.campus, disciplines.Name;


USE `CSU`;
-- CSU-4
-- Report graduate enrollments in 2004 in ’Agriculture’ and ’Biological Sciences’ for any university that offers graduate studies in both disciplines. Report one line per university (with the two grad. enrollment numbers in separate columns), sort universities in descending order by the number of ’Agriculture’ graduate students.
select t1.campus, Agriculture, Biology
from (select distinct campuses.campus, discEnr.Gr as Agriculture
from (select Name,Id as DId from disciplines) as disciplines
join discEnr on discEnr.Discipline = disciplines.DId
join (select Id, Campus, Location, Year as Founded from campuses) as campuses 
on discEnr.CampusId = campuses.Id
where disciplines.Name = 'Agriculture'
and discEnr.gr > 0
and discEnr.year = 2004) as t1

join

(select distinct campuses.campus, discEnr.Gr as Biology
from (select Name,Id as DId FROM disciplines) as disciplines
join discEnr on discEnr.Discipline = disciplines.DId
join (select Id, Campus, Location, Year as Founded from campuses) as campuses 
on discEnr.CampusId = campuses.Id
where disciplines.Name = 'Biological Sciences'
and discEnr.gr > 0
and discEnr.year = 2004) as t2

on t1.campus = t2.campus
order by Agriculture desc;


USE `CSU`;
-- CSU-5
-- Find all disciplines and campuses where graduate enrollment in 2004 was at least three times higher than undergraduate enrollment. Report campus names, discipline names, and both enrollment counts. Sort output by campus name, then by discipline name in alphabetical order.
select campus, name, ug, gr
from (select Name, Id as DId from disciplines) as disciplines
join discEnr on discEnr.Discipline = disciplines.DId
join (select campuses.Id, Campus, Location, Year as Founded from campuses) as campuses on CampusId = campuses.Id
where discEnr.gr / 3 > discEnr.ug and discEnr.year = 2004
order by campuses.campus, disciplines.name;


USE `CSU`;
-- CSU-6
-- Report the amount of money collected from student fees (use the full-time equivalent enrollment for computations) at ’Fresno State University’ for each year between 2002 and 2004 inclusively, and the amount of money (rounded to the nearest penny) collected from student fees per each full-time equivalent faculty. Output the year, the two computed numbers sorted chronologically by year.
select fees.year, enrollments.FTE * fee as COLLECTED,ROUND((enrollments.FTE * fee) / faculty.FTE, 2) as 'PER FACULTY'
from fees
join campuses on campuses.Id = fees.CampusId
join faculty on faculty.CampusId = campuses.Id and faculty.year = fees.year
join enrollments on enrollments.year = fees.year and enrollments.CampusId = campuses.Id
where fees.year <= 2004 and fees.year >= 2002 and campuses.campus = 'Fresno State University';


USE `CSU`;
-- CSU-7
-- Find all campuses where enrollment in 2003 (use the FTE numbers), was higher than the 2003 enrollment in ’San Jose State University’. Report the name of campus, the 2003 enrollment number, the number of faculty teaching that year, and the student-to-faculty ratio, rounded to one decimal place. Sort output in ascending order by student-to-faculty ratio.
select t2.Campus, students, Faculty,ROUND(STUDENTS / Faculty, 1) AS RATIO FROM
(SELECT FTE FROM campuses JOIN
enrollments ON CampusId = Id
WHERE enrollments.year = 2003
AND Campus = 'San Jose State University') t1
JOIN 
(SELECT Campus,enrollments.FTE AS Students,faculty.FTE AS Faculty FROM campuses JOIN
    enrollments ON enrollments.CampusId = Id
    JOIN faculty ON faculty.CampusId = Id AND faculty.year = 2003
    WHERE enrollments.year = 2003
    AND Campus <> 'San Jose State University' 
) t2
ON t2.STUDENTS > t1.FTE
ORDER BY RATIO
;


USE `INN`;
-- INN-1
-- Find all modern rooms with a base price below $160 and two beds. Report room code and full room name, in alphabetical order by the code.
select RoomCode, roomName
from rooms
where rooms.decor = "modern" and rooms.basePrice < 160 and rooms.beds = 2
order by RoomCode;


USE `INN`;
-- INN-2
-- Find all July 2010 reservations (a.k.a., all reservations that both start AND end during July 2010) for the ’Convoke and sanguine’ room. For each reservation report the last name of the person who reserved it, checkin and checkout dates, the total number of people staying and the daily rate. Output reservations in chronological order.
select reservations.lastName,
(select reservations.CheckIn) as checkin,
(select reservations.checkOut) as checkout,
(select reservations.Adults + reservations.Kids) as Guests,
Rate
from rooms
inner join reservations on reservations.Room = rooms.roomCode
WHERE roomName = "Convoke and sanguine" AND reservations.CheckIn >= "2010-07-01" AND reservations.CheckOut <= "2010-07-31"
order by checkout;


USE `INN`;
-- INN-3
-- Find all rooms occupied on February 6, 2010. Report full name of the room, the check-in and checkout dates of the reservation. Sort output in alphabetical order by room name.
select distinct roomName,
(select reservations.CheckIn) as checkin,
(select reservations.CheckOut) as checkout
from rooms
inner join reservations on reservations.Room = rooms.RoomCode 
where reservations.CheckIn <= "2010-02-06" and reservations.CheckOut > "2010-02-06"
order by roomName;


USE `INN`;
-- INN-4
-- For each stay by GRANT KNERIEN in the hotel, calculate the total amount of money, he paid. Report reservation code, room name (full), checkin and checkout dates, and the total stay cost. Sort output in chronological order by the day of arrival.

select distinct reservations.Code,
rooms.roomName,
reservations.CheckIn,
reservations.CheckOut,
(select reservations.rate * DATEDIFF(reservations.checkOut, reservations.CheckIn)) as paid
FROM rooms
inner join reservations on reservations.Room = rooms.RoomCode 
where reservations.LastName = "KNERIEN" and reservations.FirstName = "GRANT"
order by reservations.CheckIn;


USE `INN`;
-- INN-5
-- For each reservation that starts on December 31, 2010 report the room name, nightly rate, number of nights spent and the total amount of money paid. Sort output in descending order by the number of nights stayed.
select distinct rooms.roomName,
(select reservations.Rate) as rate, 
(select DATEDIFF(reservations.checkOut, reservations.CheckIn)) as Nights, 
(select reservations.rate * DATEDIFF(reservations.checkOut, reservations.CheckIn)) as Money
from rooms
inner join reservations on reservations.Room = rooms.RoomCode
where reservations.checkIn = "2010-12-31"
order by Nights desc;


USE `INN`;
-- INN-6
-- Report all reservations in rooms with double beds that contained four adults. For each reservation report its code, the room abbreviation, full name of the room, check-in and check out dates. Report reservations in chronological order, then sorted by the three-letter room code (in alphabetical order) for any reservations that began on the same day.
select reservations.Code, rooms.RoomCode, rooms.roomName, reservations.checkIn, reservations.checkOut
from rooms
inner join reservations on reservations.Room = rooms.RoomCode 
where reservations.adults = 4 and rooms.bedType = "Double"
order by reservations.checkIn, rooms.RoomCode;


USE `MARATHON`;
-- MARATHON-1
-- Report the overall place, running time, and pace of TEDDY BRASEL.
select place, runtime, pace 
from marathon
where FirstName = "TEDDY" and LastName = "BRASEL";


USE `MARATHON`;
-- MARATHON-2
-- Report names (first, last), overall place, running time, as well as place within gender-age group for all female runners from QUNICY, MA. Sort output by overall place in the race.
select FirstName, LastName, Place, runtime, groupplace 
from marathon
where Sex = "F" and Town = "QUNICY" and State = "MA"
order by Place;


USE `MARATHON`;
-- MARATHON-3
-- Find the results for all 34-year old female runners from Connecticut (CT). For each runner, output name (first, last), town and the running time. Sort by time.
select FirstName, LastName, town, runtime 
from marathon
where Age = 34 and Sex = "F" and State = "CT"
order by runtime;


USE `MARATHON`;
-- MARATHON-4
-- Find all duplicate bibs in the race. Report just the bib numbers. Sort in ascending order of the bib number. Each duplicate bib number must be reported exactly once.
select BibNumber
from marathon
group by BibNumber
having count(*) > 1
order by BibNumber;


USE `MARATHON`;
-- MARATHON-5
-- List all runners who took first place and second place in their respective age/gender groups. List gender, age group, name (first, last) and age for both the winner and the runner up (in a single row). Order the output by gender, then by age group.
select first.sex, first.agegroup, first.firstname, first.lastname, first.age, second.firstname, second.lastname, second.age
from marathon as first, marathon as second
where (first.groupplace = 1 and second.groupplace = 2) and (first.agegroup = second.agegroup) and (first.sex = second.sex)
order by first.sex, first.agegroup;


USE `AIRLINES`;
-- AIRLINES-1
-- Find all airlines that have at least one flight out of AXX airport. Report the full name and the abbreviation of each airline. Report each name only once. Sort the airlines in alphabetical order.
select distinct Name, Abbr
from airlines 
inner join flights on flights.Airline = airlines.id 
where flights.Destination = "AXX"
order by Name;


USE `AIRLINES`;
-- AIRLINES-2
-- Find all destinations served from the AXX airport by Northwest. Re- port flight number, airport code and the full name of the airport. Sort in ascending order by flight number.

select flights.FlightNo, flights.Destination, airports.name
from airports 
inner join flights on flights.Destination = airports.code
inner join airlines on airlines.Id = flights.Airline
where flights.Source = "AXX" and airlines.Abbr = "Northwest";


USE `AIRLINES`;
-- AIRLINES-3
-- Find all *other* destinations that are accessible from AXX on only Northwest flights with exactly one change-over. Report pairs of flight numbers, airport codes for the final destinations, and full names of the airports sorted in alphabetical order by the airport code.
SELECT firstFlight.FlightNo, secondFlight.FlightNo, secondFlight.Destination, airports.name AS Code FROM
(SELECT * FROM flights
JOIN airlines
ON flights.Airline = airlines.id
WHERE airlines.Abbr = "Northwest" AND flights.Source = "AXX") AS firstFlight
JOIN
(SELECT * FROM flights
JOIN airlines
ON flights.Airline = airlines.id
WHERE airlines.Abbr = "Northwest" AND flights.Destination != "AXX") AS secondFlight
ON firstFlight.Destination = secondFlight.Source
JOIN airports
ON secondFlight.Destination = airports.code;


USE `AIRLINES`;
-- AIRLINES-4
-- Report all pairs of airports served by both Frontier and JetBlue. Each airport pair must be reported exactly once (if a pair X,Y is reported, then a pair Y,X is redundant and should not be reported).
select distinct t1.Source, t1.Destination
from

(
select distinct Source, Destination
from flights
join airlines on flights.Airline = airlines.Id
where airlines.Name = 'Frontier Airlines'
) as t1

join

(
select distinct Source, Destination
from flights
join airlines on flights.Airline = airlines.Id
where airlines.Name = 'JetBlue Airways'
) as t2

on t1.Destination = t2.Destination 
and t1.Source = t2.Source
and t1.Source < t2.Destination;


USE `AIRLINES`;
-- AIRLINES-5
-- Find all airports served by ALL five of the airlines listed below: Delta, Frontier, USAir, UAL and Southwest. Report just the airport codes, sorted in alphabetical order.
select distinct t1.source
from

(
select distinct flights.Source
from flights
join airlines on airlines.Id = flights.Airline
where airlines.Name = 'Frontier Airlines'
) as t1

join

(
select distinct flights.Source
from flights
join airlines on airlines.Id = flights.Airline
where airlines.Name = 'Southwest Airlines'
) as t2
on t1.Source = t2.Source

join

(
select distinct flights.Source
from flights
join airlines on airlines.Id = flights.Airline
where airlines.Name = 'US Airways'
) as t3
on t2.Source = t3.Source

join

(
select distinct flights.Source
from flights
join airlines on airlines.Id = flights.Airline
where airlines.Name = 'Delta Airlines'
) as t4
on t3.Source = t4.Source

join

(select distinct Source
from flights
join airlines on airlines.Id = flights.Airline
where airlines.Name = 'United Airlines'
) as t5
On t4.Source = t5.Source

order by t1.Source;


USE `AIRLINES`;
-- AIRLINES-6
-- Find all airports that are served by at least three Southwest flights. Report just the three-letter codes of the airports — each code exactly once, in alphabetical order.
select Destination
from flights 
join airlines on airlines.Id = flights.Airline
where airlines.Name = 'Southwest Airlines'
group by Destination
having count(Destination) >= 3
order by Destination;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report, in order, the tracklist for ’Le Pop’. Output just the names of the songs in the order in which they occur on the album.
select Songs.Title
from Albums
inner join Tracklists on Tracklists.Album = Albums.AId
inner join Songs on Songs.SongId= Tracklists.Song
where Albums.Title = "Le Pop";


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- List the instruments each performer plays on ’Mother Superior’. Output the first name of each performer and the instrument, sort alphabetically by the first name.
select Band.FirstName, Instruments.Instrument
from Band
inner join Instruments on Instruments.Bandmate = Band.Id
inner join Songs on Songs.SongId = Instruments.Song
where Songs.Title = "Mother Superior"
order by Band.FirstName;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List all instruments played by Anne-Marit at least once during the performances. Report the instruments in alphabetical order (each instrument needs to be reported exactly once).
select distinct Instruments.Instrument
from Instruments
inner join Band on Band.Id = Instruments.Bandmate
inner join Performance on Performance.Bandmate = Band.Id
where Band.FirstName = "Anne-Marit"
order by Instruments.Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find all songs that featured ukalele playing (by any of the performers). Report song titles in alphabetical order.
select Songs.Title
from Songs
inner join Instruments on Instruments.Song = Songs.SongId
where Instruments.Instrument = "ukalele"
order by Songs.Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments Turid ever played on the songs where she sang lead vocals. Report the names of instruments in alphabetical order (each instrument needs to be reported exactly once).
select distinct Instruments.Instrument
from Songs 
join Instruments on Instruments.Song = Songs.SongId
join Band on Band.Id = Instruments.Bandmate
join Vocals on Vocals.Bandmate = Band.Id  and Vocals.Song = Songs.SongId
where Band.Firstname = 'Turid' and Vocals.VocalType = 'lead'
order by Instruments.Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Find all songs where the lead vocalist is not positioned center stage. For each song, report the name, the name of the lead vocalist (first name) and her position on the stage. Output results in alphabetical order by the song, then name of band member. (Note: if a song had more than one lead vocalist, you may see multiple rows returned for that song. This is the expected behavior).
select Songs.title, Band.Firstname, Performance.StagePosition
from Songs
inner join Performance on Performance.Song = Songs.SongId
inner join Band on Band.Id = Performance.Bandmate
inner join Vocals on Vocals.Bandmate = Band.Id and Songs.SongId = Vocals.Song
where Vocals.VocalType = "lead" and Performance.StagePosition != "center"
order by Songs.title, Band.Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Find a song on which Anne-Marit played three different instruments. Report the name of the song. (The name of the song shall be reported exactly once)
select Songs.Title
From Songs
inner join Instruments on Instruments.Song = Songs.SongId
inner join Band on Band.Id = Instruments.Bandmate
where Band.FirstName = "Anne-Marit"
group by Songs.Title
having count(*) = 3;


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Report the positioning of the band during ’A Bar In Amsterdam’. (just one record needs to be returned with four columns (right, center, back, left) containing the first names of the performers who were staged at the specific positions during the song).
select t3.Firstname as 'Right',
t1.Firstname as center,
t4.Firstname as Back,
t2.Firstname as 'Left'
from
(

(select *
from Songs 
join Performance on Performance.Song = Songs.SongId
join Band on Band.Id = Performance.Bandmate
where Songs.Title = 'A Bar in Amsterdam' and Performance.StagePosition = 'Center'
) as t1

JOIN

(select *
from Songs 
join Performance on Performance.Song = Songs.SongId
join Band on Band.Id = Performance.Bandmate
where Songs.Title = 'A Bar in Amsterdam' and Performance.StagePosition = 'Left'
) as t2

JOIN

(select *
from Songs 
join Performance on Performance.Song = Songs.SongId
join Band on Band.Id = Performance.Bandmate
where Songs.Title = 'A Bar in Amsterdam' and Performance.StagePosition = 'Right'
) as t3

JOIN

(select *
from Songs 
join Performance on Performance.Song = Songs.SongId
join Band on Band.Id = Performance.Bandmate
where Songs.Title = 'A Bar in Amsterdam' and StagePosition = 'Back'
) as t4

);


