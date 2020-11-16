-- Lab 5
-- cohong
-- Nov 2, 2020

USE `AIRLINES`;
-- AIRLINES-1
-- Find all airports with exactly 17 outgoing flights. Report airport code and the full name of the airport sorted in alphabetical order by the code.
select flights.source, airports.name
from flights
join airports on airports.code = flights.Source
group by flights.source having count(*) = 17;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the number of airports from which airport ANP can be reached with exactly one transfer. Make sure to exclude ANP itself from the count. Report just the number.
select count(distinct f1.source)
from flights as f1
join flights as f2
where f1.destination = f2.source and f2.destination = "ANP" and f1.source != "ANP";


USE `AIRLINES`;
-- AIRLINES-3
-- Find the number of airports from which airport ATE can be reached with at most one transfer. Make sure to exclude ATE itself from the count. Report just the number.
select count(distinct f1.source)
from flights as f1
join flights as f2
where (f1.destination = f2.source and f2.destination = "ATE" and f1.source != "ATE") or f1.destination = "ATE";


USE `AIRLINES`;
-- AIRLINES-4
-- For each airline, report the total number of airports from which it has at least one outgoing flight. Report the full name of the airline and the number of airports computed. Report the results sorted by the number of airports in descending order. In case of tie, sort by airline name A-Z.
select airlines.Name, count(distinct flights.Source) as Airports
from airlines
join flights on flights.Airline = airlines.Id
group by airlines.Name
order by Airports desc, airlines.Name;


USE `BAKERY`;
-- BAKERY-1
-- For each flavor which is found in more than three types of items offered at the bakery, report the flavor, the average price (rounded to the nearest penny) of an item of this flavor, and the total number of different items of this flavor on the menu. Sort the output in ascending order by the average price.
select goods.Flavor, round(avg(goods.price),2) as AveragePrice, count(*) as DifferentPastries
from goods
group by goods.Flavor
having DifferentPastries > 3
order by AveragePrice;


USE `BAKERY`;
-- BAKERY-2
-- Find the total amount of money the bakery earned in October 2007 from selling eclairs. Report just the amount.
select sum(goods.price) 
from items
join goods on goods.GId = items.Item
join receipts on receipts.RNumber = items.Receipt 
where goods.Food = 'Eclair' and receipts.SaleDate >= '2007-10-01' and receipts.SaleDate <= '2007-10-31';


USE `BAKERY`;
-- BAKERY-3
-- For each visit by NATACHA STENZ output the receipt number, sale date, total number of items purchased, and amount paid, rounded to the nearest penny. Sort by the amount paid, greatest to least.
select receipts.RNumber, receipts.SaleDate, count(*) as NumberOfItems, round(sum(goods.Price),2) as CheckAmount
from customers
join receipts on receipts.Customer = customers.CId
join items on items.Receipt = receipts.RNumber
join goods on goods.GId = items.Item
where LastName = "STENZ" and FirstName = "NATACHA"
group by receipts.RNumber, receipts.SaleDate
order by CheckAmount desc;


USE `BAKERY`;
-- BAKERY-4
-- For the week starting October 8, report the day of the week (Monday through Sunday), the date, total number of purchases (receipts), the total number of pastries purchased, and the overall daily revenue rounded to the nearest penny. Report results in chronological order.
select dayname(receipts.SaleDate) as Day, receipts.SaleDate, count(distinct items.Receipt) as Receipts, count(*) as Items, round(sum(goods.Price), 2) as Revenue
from receipts
join items on items.Receipt = receipts.RNumber
join goods on goods.GId = items.Item
where receipts.SaleDate > '2007-10-07' and receipts.SaleDate < '2007-10-15'
group by Day, receipts.SaleDate
order by receipts.SaleDate;


USE `BAKERY`;
-- BAKERY-5
-- Report all dates on which more than ten tarts were purchased, sorted in chronological order.
select receipts.SaleDate
from receipts
join items on items.Receipt = receipts.RNumber 
join goods on goods.GId = items.Item
where food = "Tart"
group by receipts.SaleDate
having count(*) > 10;


USE `CSU`;
-- CSU-1
-- For each campus that averaged more than $2,500 in fees between the years 2000 and 2005 (inclusive), report the campus name and total of fees for this six year period. Sort in ascending order by fee.
select campuses.campus, sum(fees.fee) as Total
from campuses
join fees on fees.CampusId = campuses.Id
where fees.year >= 2000 and fees.year <= 2005 
group by campuses.campus 
having avg(fees.fee) > 2500
order by Total;


USE `CSU`;
-- CSU-2
-- For each campus for which data exists for more than 60 years, report the campus name along with the average, minimum and maximum enrollment (over all years). Sort your output by average enrollment.
select campuses.campus, avg(enrollments.Enrolled) as average, min(enrollments.Enrolled) as minimum, max(enrollments.Enrolled) as maximum
from campuses 
join enrollments on enrollments.campusId = campuses.Id 
group by campuses.campus
having count(enrollments.year) > 60
order by maximum;


USE `CSU`;
-- CSU-3
-- For each campus in LA and Orange counties report the campus name and total number of degrees granted between 1998 and 2002 (inclusive). Sort the output in descending order by the number of degrees.

select campuses.campus, sum(degrees.degrees) as total
from campuses 
join degrees on degrees.CampusId = campuses.Id 
where (County = "Los Angeles" or County = "Orange") and degrees.Year >= 1998 and degrees.Year <= 2002
group by campuses.campus
order by total desc;


USE `CSU`;
-- CSU-4
-- For each campus that had more than 20,000 enrolled students in 2004, report the campus name and the number of disciplines for which the campus had non-zero graduate enrollment. Sort the output in alphabetical order by the name of the campus. (Exclude campuses that had no graduate enrollment at all.)
select campuses.campus, count(*) 
from campuses
join enrollments on enrollments.campusId = campuses.Id 
join discEnr on discEnr.campusId = campuses.Id
where enrollments.year = 2004 and enrollments.enrolled > 20000 and discEnr.Gr > 0
group by campuses.campus
order by campus;


USE `INN`;
-- INN-1
-- For each room, report the full room name, total revenue (number of nights times per-night rate), and the average revenue per stay. In this summary, include only those stays that began in the months of September, October and November. Sort output in descending order by total revenue. Output full room names.
Select rooms.RoomName, sum(datediff(reservations.Checkout, reservations.CheckIn) * reservations.Rate) as TotalRevenue, round(avg(datediff(reservations.Checkout, reservations.CheckIn) * reservations.Rate), 2) as AverageStay
from rooms
join reservations on reservations.Room = rooms.RoomCode 
where reservations.CheckIn > "2010-08-31" and reservations.CheckIn < "2010-12-01"
group by rooms.RoomName
order by TotalRevenue desc;


USE `INN`;
-- INN-2
-- Report the total number of reservations that began on Fridays, and the total revenue they brought in.
Select count(*) as Stays, sum(reservations.Rate * datediff(reservations.CheckOut, reservations.CheckIn)) as Revenue
from rooms
join reservations on reservations.Room = rooms.RoomCode 
where dayname(CheckIn) = "Friday";


USE `INN`;
-- INN-3
-- List each day of the week. For each day, compute the total number of reservations that began on that day, and the total revenue for these reservations. Report days of week as Monday, Tuesday, etc. Order days from Sunday to Saturday.
Select dayname(reservations.CheckIn) as Day, count(*) as Stays, sum(datediff(reservations.CheckOut, reservations.CheckIn) * reservations.Rate) as revenue
from rooms
join reservations on reservations.Room = rooms.RoomCode 
group by Day
order by Field(Day, "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");


USE `INN`;
-- INN-4
-- For each room list full room name and report the highest markup against the base price and the largest markdown (discount). Report markups and markdowns as the signed difference between the base price and the rate. Sort output in descending order beginning with the largest markup. In case of identical markup/down sort by room name A-Z. Report full room names.
Select rooms.roomname, max(reservations.rate - rooms.basePrice) as Markup, min(reservations.rate - rooms.basePrice) as Discount
from rooms
join reservations on reservations.Room = rooms.RoomCode
group by rooms.roomname
order by Markup desc, rooms.roomname;


USE `INN`;
-- INN-5
-- For each room report how many nights in calendar year 2010 the room was occupied. Report the room code, the full name of the room, and the number of occupied nights. Sort in descending order by occupied nights. (Note: this should be number of nights during 2010. Some reservations extend beyond December 31, 2010. The ”extra” nights in 2011 must be deducted).
select RoomCode, RoomName, sum(Days) as DaysOccupied
from
    (
        select rooms.RoomCode, rooms.RoomName,
        case
            when Year(reservations.CheckOut) = 2010 and Year(reservations.CheckIn) = 2010 
                then datediff(reservations.CheckOut, reservations.CheckIn)
            when Year(reservations.CheckOut) = 2011 and Year(reservations.CheckIn) = 2010 
                then datediff("2010-12-31", reservations.CheckIn)
            when Year(reservations.CheckOut) = 2011 and Year(reservations.CheckIn) = 2009 
                then 365
        end as Days
        
        from rooms
        join reservations on reservations.Room = rooms.RoomCode
        where (Year(reservations.Checkout) >= 2010 and Year(reservations.CheckIn) <= 2010) or (Year(reservations.Checkout) >= 2011 and Year(reservations.CheckIn) <= 2010)
    ) as r1
    
group by RoomCode, RoomName
order by DaysOccupied desc;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- For each performer, report first name and how many times she sang lead vocals on a song. Sort output in descending order by the number of leads. In case of tie, sort by performer first name (A-Z.)
select Band.Firstname, count(*)
from Vocals
join Band on Band.Id = Vocals.Bandmate 
where VocalType = 'lead'
group by Vocals.Bandmate
order by count(*) desc;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report how many different instruments each performer plays on songs from the album 'Le Pop'. Include performer's first name and the count of different instruments. Sort the output by the first name of the performers.
select Band.Firstname, count(distinct Instruments.Instrument)
from Instruments
join Band on Band.Id = Instruments.Bandmate
join Tracklists on Tracklists.Song = Instruments.Song
join Albums on Albums.Title = "Le Pop" and Albums.Aid = Tracklists.Album
group by Band.Firstname
order by Band.Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List each stage position along with the number of times Turid stood at each stage position when performing live. Sort output in ascending order of the number of times she performed in each position.

select Performance.StagePosition as TuridPosition, count(*) as 'count'
from Performance
join Band on Band.Id = Bandmate 
where Band.Firstname = "Turid"
group by Performance.StagePosition
order by `count`;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Report how many times each performer (other than Anne-Marit) played bass balalaika on the songs where Anne-Marit was positioned on the left side of the stage. List performer first name and a number for each performer. Sort output alphabetically by the name of the performer.

select Firstname , count(*)
from
    (
        select distinct Performance.Song as Song,Band.Firstname,Instrument
        from Performance
        join Instruments on  Instruments.Song = Performance.Song
        join Band on Band.Id = Instruments.Bandmate
        where Band.Firstname != 'Anne-Marit' and Instruments.Instrument = 'bass balalaika'
    ) as t1
    
    join

    (
        select Performance.Song as Song
        from Performance
        join Band on Band.Id = Performance.Bandmate
        where Performance.StagePosition = 'left' and Band.Firstname  = 'Anne-Marit'
    ) as t2
    
    on t1.Song = t2.Song

group by Firstname 
order by Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Report all instruments (in alphabetical order) that were played by three or more people.
select distinct Instruments.Instrument
from Instruments
group by Instruments.Instrument
having count(distinct Instruments.Bandmate) >= 3
order by Instruments.Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- For each performer, list first name and report the number of songs on which they played more than one instrument. Sort output in alphabetical order by first name of the performer
select Band.Firstname, count(*)
from Band
join
    (
        select Instruments.Bandmate 
        from Instruments
        group by Instruments.Bandmate, Instruments.Song
        having count(Instruments.Instrument) > 1
    ) as t1
    
    on Band.Id = Bandmate

group by Band.Id
order by Band.Firstname;


USE `MARATHON`;
-- MARATHON-1
-- List each age group and gender. For each combination, report total number of runners, the overall place of the best runner and the overall place of the slowest runner. Output result sorted by age group and sorted by gender (F followed by M) within each age group.
select marathon.AgeGroup, marathon.Sex, count(*) as Total, min(marathon.Place) as BestPlacing, max(marathon.Place) as SlowestPacing
from marathon 
group by marathon.AgeGroup, marathon.Sex
order by marathon.AgeGroup;


USE `MARATHON`;
-- MARATHON-2
-- Report the total number of gender/age groups for which both the first and the second place runners (within the group) are from the same state.
select count(*)
from
    (
        select count(*)
        from marathon 
        where GroupPlace < 3
        group by marathon.State
        having count(*) > 1
    ) as result;


USE `MARATHON`;
-- MARATHON-3
-- For each full minute, report the total number of runners whose pace was between that number of minutes and the next. In other words: how many runners ran the marathon at a pace between 5 and 6 mins, how many at a pace between 6 and 7 mins, and so on.
select minute(marathon.pace), count(*) as `count`
from marathon
group by minute(marathon.pace);


USE `MARATHON`;
-- MARATHON-4
-- For each state with runners in the marathon, report the number of runners from the state who finished in top 10 in their gender-age group. If a state did not have runners in top 10, do not output information for that state. Report state code and the number of top 10 runners. Sort in descending order by the number of top 10 runners, then by state A-Z.
select distinct marathon.State, count(*) over(partition by marathon.State) as NumberOfTop10
from marathon
where GroupPlace < 11 
order by NumberOfTop10 desc;


USE `MARATHON`;
-- MARATHON-5
-- For each Connecticut town with 3 or more participants in the race, report the town name and average time of its runners in the race computed in seconds. Output the results sorted by the average time (lowest average time first).
select marathon.Town, round(avg(time_to_sec(marathon.RunTime)), 1) as AverageTimeInSeconds 
from marathon
where marathon.State = "CT"
group by marathon.Town having count(*) > 2
order by AverageTimeInSeconds;


USE `STUDENTS`;
-- STUDENTS-1
-- Report the last and first names of teachers who have between seven and eight (inclusive) students in their classrooms. Sort output in alphabetical order by the teacher's last name.
select teachers.Last, teachers.First
from teachers 
join list on list.classroom = teachers.classroom
group by teachers.Last, teachers.First having count(*) >= 7 and count(*) <= 8
order by teachers.Last;


USE `STUDENTS`;
-- STUDENTS-2
-- For each grade, report the grade, the number of classrooms in which it is taught, and the total number of students in the grade. Sort the output by the number of classrooms in descending order, then by grade in ascending order.

select list.grade, count(distinct list.classroom) as Classrooms, count(*) as Students
from list
group by list.grade
order by Classrooms desc, list.grade;


USE `STUDENTS`;
-- STUDENTS-3
-- For each Kindergarten (grade 0) classroom, report classroom number along with the total number of students in the classroom. Sort output in the descending order by the number of students.
select list.classroom, count(*) as total
from list
where list.grade = 0
group by list.classroom
order by total desc;


USE `STUDENTS`;
-- STUDENTS-4
-- For each fourth grade classroom, report the classroom number and the last name of the student who appears last (alphabetically) on the class roster. Sort output by classroom.
select list.classroom, max(list.Lastname) as LastOnRoster
from list
where list.grade = 4
group by list.classroom;


