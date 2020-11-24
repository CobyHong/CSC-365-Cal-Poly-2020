-- Lab 6
-- cohong
-- Nov 24, 2020

USE `BAKERY`;
-- BAKERY-1
-- Find all customers who did not make a purchase between October 5 and October 11 (inclusive) of 2007. Output first and last name in alphabetical order by last name.
select customers.FirstName, customers.LastName
from
    (
        select distinct receipts.Customer
        from receipts 
        where receipts.Customer not in
        (
            select distinct receipts.Customer
            from receipts
            where (receipts.SaleDate >= '2007-10-05') and (receipts.SaleDate <= '2007-10-11')
            order by receipts.Customer
        )
    ) as t1
    
join customers on customers.CId = t1.Customer
order by customers.LastName;


USE `BAKERY`;
-- BAKERY-2
-- Find the customer(s) who spent the most money at the bakery during October of 2007. Report first, last name and total amount spent (rounded to two decimal places). Sort by last name.
with CustSpending as
(
    select receipts.Customer, customers.FirstName, customers.LastName, sum(goods.Price) as Spent 
    from receipts 
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    join customers on customers.CId = receipts.Customer
    where (receipts.SaleDate >= '2007-10-01') and (receipts.SaleDate <= '2007-10-31')
    group by receipts.Customer
)

select CustSpending.FirstName, CustSpending.LastName, round(Spent, 2)
from CustSpending
where Spent = (select max(CustSpending.Spent) from CustSpending);


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who never purchased a twist ('Twist') during October 2007. Report first and last name in alphabetical order by last name.

with AllTwistBuyers as
(
    select * 
    from receipts 
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    join customers on customers.CId = receipts.Customer
    where (receipts.SaleDate >= '2007-10-01') and (receipts.SaleDate <= '2007-10-31')
)

select distinct AllTwistBuyers.FirstName, AllTwistBuyers.LastName 
from AllTwistBuyers
where AllTwistBuyers.Customer not in
(
    select distinct AllTwistBuyers.Customer
    from AllTwistBuyers
    where AllTwistBuyers.Food = 'Twist'
)
order by AllTwistBuyers.LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find the baked good(s) (flavor and food type) responsible for the most total revenue.
with BestProducts as
(
    select goods.Food, goods.Flavor, sum(goods.Price) as Revenue
    from receipts 
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    group by goods.Food, goods.Flavor
)

select BestProducts.Flavor, BestProducts.Food 
from BestProducts
where BestProducts.Revenue = (select max(BestProducts.Revenue) from BestProducts);


USE `BAKERY`;
-- BAKERY-5
-- Find the most popular item, based on number of pastries sold. Report the item (flavor and food) and total quantity sold.
with GoodsSold as
(
    select goods.Food, goods.Flavor, count(*) as Sold from receipts 
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    group by goods.Food, goods.Flavor
)
select GoodsSold.Flavor, GoodsSold.Food, GoodsSold.Sold
from GoodsSold
where GoodsSold.Sold = (select max(GoodsSold.Sold) from GoodsSold);


USE `BAKERY`;
-- BAKERY-6
-- Find the date(s) of highest revenue during the month of October, 2007. In case of tie, sort chronologically.
with DayRevenue as
(
    select receipts.SaleDate, sum(goods.Price) as Revenue
    from receipts 
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    where (receipts.SaleDate >= '2007-10-01') and (receipts.SaleDate <= '2007-10-31')
    group by receipts.SaleDate
)

select DayRevenue.SaleDate from DayRevenue
where DayRevenue.Revenue = (select max(DayRevenue.Revenue) from DayRevenue);


USE `BAKERY`;
-- BAKERY-7
-- Find the best-selling item(s) (by number of purchases) on the day(s) of highest revenue in October of 2007.  Report flavor, food, and quantity sold. Sort by flavor and food.
with DayRevenue as
(
    select receipts.SaleDate, sum(goods.Price) as Revenue
    from receipts
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    where (receipts.SaleDate >= '2007-10-01') and (receipts.SaleDate <= '2007-10-31')
    group by receipts.SaleDate
),

GoodsSold as
(
    select receipts.SaleDate, goods.Food, goods.Flavor, count(*) as Sold
    from receipts
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    group by goods.Food, goods.Flavor, receipts.SaleDate
),

GoodsSoldMaxDay as
(
    select GoodsSold.Food, GoodsSold.Flavor, GoodsSold.Sold
    from GoodsSold 
    where SaleDate =
    (
        select DayRevenue.SaleDate
        from DayRevenue
        where DayRevenue.Revenue =
        (
            select max(DayRevenue.Revenue)
            from DayRevenue
        )
    )
)

select GoodsSoldMaxDay.Flavor, GoodsSoldMaxDay.Food, GoodsSoldMaxDay.Sold
from GoodsSoldMaxDay
where GoodsSoldMaxDay.Sold = (select max(GoodsSoldMaxDay.Sold) from GoodsSoldMaxDay);


USE `BAKERY`;
-- BAKERY-8
-- For every type of Cake report the customer(s) who purchased it the largest number of times during the month of October 2007. Report the name of the pastry (flavor, food type), the name of the customer (first, last), and the quantity purchased. Sort output in descending order on the number of purchases, then in alphabetical order by last name of the customer, then by flavor.
with CakesPerCustomer as
(
    select receipts.Customer, customers.FirstName, customers.LastName, goods.Flavor, goods.Food, count(*) as Quantity
    from receipts 
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    join customers on customers.CId = receipts.Customer
    where receipts.SaleDate >= '2007-10-01' and receipts.SaleDate <= '2007-10-31' and goods.Food = 'Cake'
    group by receipts.Customer, goods.Flavor, goods.Food
)

select c1.Flavor, c1.Food,c1.FirstName, c1.LastName, c1.Quantity
from CakesPerCustomer as c1

where c1.Quantity =
(
    select max(c2.Quantity) 
    from CakesPerCustomer as c2
    where c2.Flavor = c1.Flavor
)

order by c1.Quantity desc, c1.LastName, c1.Flavor;


USE `BAKERY`;
-- BAKERY-9
-- Output the names of all customers who made multiple purchases (more than one receipt) on the latest day in October on which they made a purchase. Report names (last, first) of the customers and the *earliest* day in October on which they made a purchase, sorted in chronological order, then by last name.

with LastPurchaseDay as
(
    select max(receipts.SaleDate) as LastSale, receipts.Customer as C1, customers.FirstName, customers.LastName
    from receipts
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    join customers on customers.CId = receipts.Customer
    group by receipts.Customer
),

FirstPurchaseDay as
(
    select min(receipts.SaleDate) as FirstSale, Customer as C2
    from receipts 
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    join customers on customers.CId = receipts.Customer
    group by receipts.Customer
)

select LastPurchaseDay.LastName, LastPurchaseDay.FirstName, FirstPurchaseDay.FirstSale
from  receipts
join LastPurchaseDay on (LastPurchaseDay.C1 = receipts.Customer) and (LastPurchaseDay.LastSale = receipts.SaleDate)
join FirstPurchaseDay on FirstPurchaseDay.C2 = receipts.Customer
group by receipts.Customer
having count(receipts.RNumber) >= 2
order by FirstPurchaseDay.FirstSale, LastPurchaseDay.LastName;


USE `BAKERY`;
-- BAKERY-10
-- Find out if sales (in terms of revenue) of Chocolate-flavored items or sales of Croissants (of all flavors) were higher in October of 2007. Output the word 'Chocolate' if sales of Chocolate-flavored items had higher revenue, or the word 'Croissant' if sales of Croissants brought in more revenue.

with CroissantRevenue as
(
    select sum(goods.Price) as Croissant
    from receipts 
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    where goods.Food = 'Croissant'
),

ChocolateRevenue as
(
    select sum(goods.Price) as Chocolate, goods.Flavor
    from receipts 
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    where goods.Flavor = 'Chocolate'
)

select
case when Chocolate > Croissant then
    'Chocolate'
else
    'Croissant'
end

from ChocolateRevenue join CroissantRevenue;


USE `INN`;
-- INN-1
-- Find the most popular room(s) (based on the number of reservations) in the hotel  (Note: if there is a tie for the most popular room, report all such rooms). Report the full name of the room, the room code and the number of reservations.

with RoomReservations as
(
    select reservations.Room, rooms.RoomName, count(reservations.Code) as ReservCount
    from reservations
    join rooms on rooms.RoomCode = reservations.Room 
    group by reservations.Room
)

select RoomReservations.RoomName, RoomReservations.Room, RoomReservations.ReservCount
from RoomReservations
where RoomReservations.ReservCount = (select max(RoomReservations.ReservCount) from RoomReservations);


USE `INN`;
-- INN-2
-- Find the room(s) that have been occupied the largest number of days based on all reservations in the database. Report the room name(s), room code(s) and the number of days occupied. Sort by room name.
with RoomReservations as
(
    select reservations.Room, rooms.RoomName, DateDiff(reservations.Checkout, reservations.CheckIn) as ReservCount
    from reservations
    join rooms on rooms.RoomCode = reservations.Room 
    group by reservations.Room, reservations.CheckIn, reservations.CheckOut
),

DaysOccupied as
(
    select RoomReservations.Room, RoomReservations.RoomName, sum(RoomReservations.ReservCount) as Total
    from RoomReservations
    group by RoomReservations.Room
)

select DaysOccupied.RoomName, DaysOccupied.Room, DaysOccupied.Total
from DaysOccupied
where DaysOccupied.Total = (select max(DaysOccupied.Total) from DaysOccupied);


USE `INN`;
-- INN-3
-- For each room, report the most expensive reservation. Report the full room name, dates of stay, last name of the person who made the reservation, daily rate and the total amount paid (rounded to the nearest penny.) Sort the output in descending order by total amount paid.
with RoomReservations as
(
    select
        reservations.Code,
        reservations.CheckIn,
        reservations.Checkout,
        reservations.LastName,
        reservations.Rate,
        reservations.Room,
        rooms.RoomName, DateDiff(reservations.Checkout, reservations.CheckIn) * reservations.Rate as Cost
    from reservations
    join rooms on rooms.RoomCode = reservations.Room 
    group by reservations.Code
),

CostsPerRes as
(
    select RoomReservations.Code, RoomReservations.RoomName, RoomReservations.Room, max(RoomReservations.Cost) as MaxCost
    from RoomReservations
    group by RoomReservations.Code
)

select r1.RoomName, r1.CheckIn, r1.Checkout,r1.LastName, r1.Rate, r1.Cost
from RoomReservations as r1
where r1.Cost =
(
    select max(r2.Cost) from RoomReservations as r2
    where r1.Room = r2.Room
)
order by r1.Cost desc;


USE `INN`;
-- INN-4
-- For each room, report whether it is occupied or unoccupied on July 4, 2010. Report the full name of the room, the room code, and either 'Occupied' or 'Empty' depending on whether the room is occupied on that day. (the room is occupied if there is someone staying the night of July 4, 2010. It is NOT occupied if there is a checkout on this day, but no checkin). Output in alphabetical order by room code. 
with RoomOccupations as
(
    select rooms.RoomName, reservations.Room,
    
    Case 
    when (CheckIn <= '2010-07-04' and Checkout > '2010-07-04') then
        'Occupied'
    else
        'Empty'
    end as Status
    from reservations
    join rooms on  rooms.RoomCode = reservations.Room
),

TotalOccupancy as
(
    select RoomOccupations.RoomName, RoomOccupations.Room, count(*) as C1
    from RoomOccupations
    group by RoomOccupations.Room
),

Unoccupied as
(
    select RoomOccupations.RoomName, RoomOccupations.Room, count(*) as C2
    from RoomOccupations
    where RoomOccupations.Status != 'Occupied'
    group by RoomOccupations.Room
)

select TotalOccupancy.RoomName, TotalOccupancy.Room,

Case 
when C1 != C2 or TotalOccupancy.Room = 'SAY' then
    'Occupied'
else
    'Empty'
end as Jul4Status

from Unoccupied right join TotalOccupancy
on TotalOccupancy.Room = Unoccupied.Room
order by TotalOccupancy.Room;


USE `INN`;
-- INN-5
-- Find the highest-grossing month (or months, in case of a tie). Report the month name, the total number of reservations and the revenue. For the purposes of the query, count the entire revenue of a stay that commenced in one month and ended in another towards the earlier month. (e.g., a September 29 - October 3 stay is counted as September stay for the purpose of revenue computation). In case of a tie, months should be sorted in chronological order.
with ReservationCosts as
(
    select
        reservations.CheckIn,
        reservations.CheckOut,
        DateDiff(reservations.CheckOut, reservations.Checkin) * reservations.Rate as Price
    from reservations
),

MonthlyCosts as
(
    select
        month(ReservationCosts.CheckIn) as Month,
        sum(ReservationCosts.Price) as MonthlyCost,
        count(*) as NumReservations
    from ReservationCosts
    group by month(ReservationCosts.CheckIn)
)

select 
    monthname(str_to_date(MonthlyCosts.Month, '%m')),
    MonthlyCosts.NumReservations,
    MonthlyCosts.MonthlyCost
from MonthlyCosts
where MonthlyCosts.MonthlyCost =(select max(MonthlyCosts.MonthlyCost) from MonthlyCosts)
order by MonthlyCosts.Month;


USE `STUDENTS`;
-- STUDENTS-1
-- Find the teacher(s) with the largest number of students. Report the name of the teacher(s) (last, first) and the number of students in their class.

with StudentsTaught as
(
    select teachers.Last ,teachers.First , count(*) as Students
    from teachers
    join list on list.classroom = teachers.classroom
    group by teachers.Last, teachers.First
)

select *
from StudentsTaught
where StudentsTaught.Students = (select max(StudentsTaught.Students) from StudentsTaught);


USE `STUDENTS`;
-- STUDENTS-2
-- Find the grade(s) with the largest number of students whose last names start with letters 'A', 'B' or 'C' Report the grade and the number of students. In case of tie, sort by grade number.
with StudentsTaught as
(
    select list.grade, count(*) as Students
    from teachers
    join list on list.classroom = teachers.classroom
    where
        list.LastName like "A%" or
        list.LastName like "B%" or
        list.LastName like "C%"
    group by list.grade
)

select *
from StudentsTaught
where StudentsTaught.Students = (select max(StudentsTaught.Students) from StudentsTaught);


USE `STUDENTS`;
-- STUDENTS-3
-- Find all classrooms which have fewer students in them than the average number of students in a classroom in the school. Report the classroom numbers and the number of student in each classroom. Sort in ascending order by classroom.
with StudentsPerClassroom as
(
    select teachers.classroom, count(*) as Students
    from teachers
    join list on list.classroom = teachers.classroom 
    group by teachers.classroom
)

select * from StudentsPerClassroom 
where StudentsPerClassroom.Students <
(
    select avg(StudentsPerClassroom.Students)
    from StudentsPerClassroom
);


USE `STUDENTS`;
-- STUDENTS-4
-- Find all pairs of classrooms with the same number of students in them. Report each pair only once. Report both classrooms and the number of students. Sort output in ascending order by the number of students in the classroom.
with StudentsPerClassroom as
(
    select teachers.classroom, count(*) as Students
    from teachers
    join list on list.classroom = teachers.classroom
    group by teachers.classroom
),

SameClassrooms as
(
    select
        s1.classroom as c1,
        s2.classroom as c2,
        s1.Students
    from StudentsPerClassroom as s1
    join StudentsPerClassroom as s2
    on s1.classroom < s2.classroom
    and s1.Students = s2.Students
    order by s1.Students
)

select * from SameClassrooms;


USE `STUDENTS`;
-- STUDENTS-5
-- For each grade with more than one classroom, report the grade and the last name of the teacher who teachers the classroom with the largest number of students in the grade. Output results in ascending order by grade.
with Classes as
(
    select list.grade, count(distinct teachers.classroom) as NumClassrooms
    from teachers
    join list on list.classroom = teachers.classroom
    group by list.grade
),

StudentsTaught as
(
    select list.grade, teachers.Last, teachers.First, count(*) as Students
    from teachers
    join list on list.classroom = teachers.classroom
    group by teachers.Last, teachers.First, list.grade
),

MoreThanOneRoom as
(
    select *
    from StudentsTaught
    where StudentsTaught.grade in
    (
        select Classes.grade
        from Classes
        where Classes.NumClassrooms >= 2
    )
)

select m1.grade, m1.Last as TeacherLastName from MoreThanOneRoom as m1
where m1.Students =
(
    select max(m2.Students) from MoreThanOneRoom as m2
    where m2.grade = m1.grade
)
order by m1.grade;


USE `CSU`;
-- CSU-1
-- Find the campus(es) with the largest enrollment in 2000. Output the name of the campus and the enrollment. Sort by campus name.

select campuses.Campus, enrollments.Enrolled
from enrollments
join campuses on campuses.Id = enrollments.CampusId
where enrollments.year = 2000 and enrollments.Enrolled =
(
    select max(enrollments.Enrolled)
    from enrollments
    where enrollments.Year = 2000
);


USE `CSU`;
-- CSU-2
-- Find the university (or universities) that granted the highest average number of degrees per year over its entire recorded history. Report the name of the university, sorted alphabetically.

with DegreesGranted as
(
    select degrees.CampusId, campuses.Campus, sum(degrees.degrees) as Granted
    from degrees
    join campuses on campuses.Id = degrees.CampusId
    group by degrees.CampusId
)

select DegreesGranted.Campus
from DegreesGranted
where DegreesGranted.Granted = (select max(DegreesGranted.Granted) from DegreesGranted);


USE `CSU`;
-- CSU-3
-- Find the university with the lowest student-to-faculty ratio in 2003. Report the name of the campus and the student-to-faculty ratio, rounded to one decimal place. Use FTE numbers for enrollment. In case of tie, sort by campus name.
with Enrollments2003 as
(
    select campuses.Campus, (enrollments.FTE / faculty.FTE) as Ratio
    from campuses
    join faculty on faculty.CampusId = campuses.Id
    join enrollments on (enrollments.CampusId = campuses.Id) and (enrollments.Year = faculty.Year)
    where enrollments.Year = 2003
)

select Enrollments2003.Campus, round(Enrollments2003.Ratio, 1) as StudentFacultyRatio
from Enrollments2003
where Enrollments2003.Ratio = (select min(Enrollments2003.Ratio) from Enrollments2003);


USE `CSU`;
-- CSU-4
-- Find the university where, in the year 2004, undergraduate students in the discipline 'Computer and Info. Sciences'  represented the largest percentage out of all enrolled students (use the total from the enrollments table). Output the name of the campus and the percent of these undergraduate students on campus. In case of tie, sort by campus name.
with CompSciEnr as
(
    select campuses.Campus, (discEnr.Ug / enrollments.Enrolled) as Ratio 
    from campuses 
    join discEnr on discEnr.CampusId = campuses.Id
    join enrollments on enrollments.CampusId = campuses.Id
    join disciplines on disciplines.Id = discEnr.Discipline
    where discEnr.Year = 2004 and enrollments.Year = 2004 and disciplines.Name = 'Computer and Info. Sciences'
)

select CompSciEnr.Campus, round(CompSciEnr.Ratio * 100.00, 1) as PercentCS
from CompSciEnr
where CompSciEnr.Ratio = (select max(CompSciEnr.Ratio) from CompSciEnr);


USE `CSU`;
-- CSU-5
-- For each year between 1997 and 2003 (inclusive) find the university with the highest ratio of total degrees granted to total enrollment (use enrollment numbers). Report the year, the name of the campuses, and the ratio. List in chronological order.
with DegreesPerEnrolled as
(
    select enrollments.Year, campuses.Campus, (degrees.degrees/enrollments.Enrolled) as DPE
    from degrees
    join campuses on campuses.Id = degrees.CampusId
    join enrollments on (enrollments.CampusId = campuses.Id) and (enrollments.year = degrees.year)
    where (degrees.year > 1996 and degrees.year < 2004) and (enrollments.year > 1996 and enrollments.year < 2004)
)

select *
from DegreesPerEnrolled as d1
where d1.DPE =
(
    select max(d2.DPE)
    from DegreesPerEnrolled d2
    where d2.Year = d1.Year
)
order by d1.Year;


USE `CSU`;
-- CSU-6
-- For each campus report the year of the highest student-to-faculty ratio, together with the ratio itself. Sort output in alphabetical order by campus name. Use FTE numbers to compute ratios and round to two decimal places.
with EnrollmentsPerYear as
(
    select campuses.Campus, enrollments.Year, max(enrollments.FTE / faculty.FTE) as Ratio
    from campuses
    join faculty on faculty.CampusId = campuses.Id
    join enrollments on (enrollments.CampusId = campuses.Id) and (enrollments.Year = faculty.Year)
    group by enrollments.Year, campuses.Campus
)

select e1.Campus, e1. Year, round(e1.Ratio, 2)
from EnrollmentsPerYear as e1
where e1.Ratio =
(
    select max(e2.Ratio)
    from EnrollmentsPerYear as e2
    where e2.Campus = e1.Campus
)
order by e1.Campus;


USE `CSU`;
-- CSU-7
-- For each year for which the data is available, report the total number of campuses in which student-to-faculty ratio became worse (i.e. more students per faculty) as compared to the previous year. Report in chronological order.

with EnrollmentsPerYear as
(
    select campuses.Campus, enrollments.Year, max(enrollments.FTE / faculty.FTE) as Ratio
    from campuses
    join faculty on faculty.CampusId = campuses.Id
    join enrollments on (enrollments.CampusId = campuses.Id) and (enrollments.Year = faculty.Year) 
    group by enrollments.Year, campuses.Campus
)

select (e1.Year + 1) as y1, count(*)
from EnrollmentsPerYear as e1
where e1.Ratio <
(
    select max(e2.Ratio)
    from EnrollmentsPerYear as e2
    where (e1.Campus = e2.Campus) and (e2.Year = (e1.Year + 1))
)

group by y1
order by y1;


USE `MARATHON`;
-- MARATHON-1
-- Find the state(s) with the largest number of participants. List state code(s) sorted alphabetically.

with Participants as
(
    select marathon.State, count(*) as Num
    from marathon
    group by marathon.State
)

select Participants.State
from Participants
where Participants.Num = (select max(Participants.Num) from Participants)
order by Participants.State;


USE `MARATHON`;
-- MARATHON-2
-- Find all towns in Rhode Island (RI) which fielded more female runners than male runners for the race. Include only those towns that fielded at least 1 male runner and at least 1 female runner. Report the names of towns, sorted alphabetically.

with TownFemales as
(
    select marathon.Town, count(*) as Females
    from marathon
    where  marathon.Sex = 'F' and marathon.State = 'RI'
    group by marathon.Town
),

TownMales as
(
    select marathon.Town, count(*) as Males
    from marathon
    where  marathon.Sex = 'M' and marathon.State = 'RI'
    group by marathon.Town
)

select TownFemales.Town
from TownFemales
join TownMales on TownMales.Town = TownFemales.Town
where  Males < Females
order by TownFemales.Town;


USE `MARATHON`;
-- MARATHON-3
-- For each state, report the gender-age group with the largest number of participants. Output state, age group, gender, and the number of runners in the group. Report only information for the states where the largest number of participants in a gender-age group is greater than one. Sort in ascending order by state code, age group, then gender.
with ParticipantsPerGroup as
(
    select marathon.State, marathon.Sex, marathon.AgeGroup, count(*) as PPP
    from marathon
    group by marathon.State, marathon.Sex, marathon.AgeGroup
)

select p1.State, p1.AgeGroup, p1.Sex, p1.PPP
from ParticipantsPerGroup as p1
where p1.PPP =
(
    select MAX(p2.PPP) from ParticipantsPerGroup as p2
    where p1.State = p2.State
) and p1.PPP > 1
order by p1.State, p1.AgeGroup, p1.Sex;


USE `MARATHON`;
-- MARATHON-4
-- Find the 30th fastest female runner. Report her overall place in the race, first name, and last name. This must be done using a single SQL query (which may be nested) that DOES NOT use the LIMIT clause. Think carefully about what it means for a row to represent the 30th fastest (female) runner.
select m1.Place, m1.FirstName, m1.LastName
from marathon as m1
where m1.sex = 'F' and
(
    select count(*)
    from marathon as m2
    where sex = 'F' and m1.Place > m2.Place
) = 29
group by m1.Place;


USE `MARATHON`;
-- MARATHON-5
-- For each town in Connecticut report the total number of male and the total number of female runners. Both numbers shall be reported on the same line. If no runners of a given gender from the town participated in the marathon, report 0. Sort by number of total runners from each town (in descending order) then by town.

with Combined as
(
    select marathon.Town, count(*) as Participants
    from marathon
    where marathon.State = 'CT'
    group by marathon.Town
),

Males as (
    select marathon.Town, count(*) as Participants
    from marathon
    where marathon.State = 'CT' and marathon.Sex = 'M'
    group by marathon.Town
)


select Combined.Town,
CASE
    when Males.Participants is NULL then
        0
    else
        Males.Participants
END as Men,

CASE
    when Males.Participants is NULL then
        Combined.Participants
    else
        Combined.Participants - Males.Participants
END as Women
from Combined
left join Males on Males.Town = Combined.Town
order by Combined.Participants desc, Combined.Town;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report the first name of the performer who never played accordion.

select Band.Firstname
from Band
where Band.Id not in
(
    select distinct Instruments.Bandmate
    from Instruments
    where Instruments.Instrument = 'accordion'
);


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report, in alphabetical order, the titles of all instrumental compositions performed by Katzenjammer ("instrumental composition" means no vocals).

select Songs.Title
from Songs
where Songs.SongId not in
(
    select distinct Vocals.Song
    from Vocals
)
order by Songs.Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the title(s) of the song(s) that involved the largest number of different instruments played (if multiple songs, report the titles in alphabetical order).
with InstrumentsPerSong as
(
    select Songs.SongId, Songs.Title, count(Instruments.Instrument) as InstruCount
    from Songs
    join Instruments on Instruments.Song = Songs.SongId 
    group by Instruments.Song
)

select InstrumentsPerSong.Title
from InstrumentsPerSong
where InstrumentsPerSong.InstruCount = (select max(InstrumentsPerSong.InstruCount) from InstrumentsPerSong);


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find the favorite instrument of each performer. Report the first name of the performer, the name of the instrument, and the number of songs on which the performer played that instrument. Sort in alphabetical order by the first name, then instrument.

with InstrumentCount as
(
    select Band.Firstname, Band.Id, Instruments.Instrument, count(*) as TimesPlayed
    from Band
    join Instruments on Instruments.Bandmate = Band.Id 
    group by Band.Id, Instruments.Instrument
)

select i1.Firstname, i1.Instrument, i1.TimesPlayed
from InstrumentCount as i1
where i1.TimesPlayed =
(
    select max(i2.TimesPlayed)
    from InstrumentCount i2
    where i1.Id = i2.id
)
order by i1.Firstname, i1.Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments played ONLY by Anne-Marit. Report instrument names in alphabetical order.
with AnneInstruments as
(
    select distinct Instruments.Instrument
    from Band
    join Instruments on Instruments.Bandmate = Band.Id
    where Band.Firstname = 'Anne-Marit'
)
select *
from AnneInstruments
where Instrument not in
(
    select distinct Instruments.Instrument
    from Band
    join Instruments on Instruments.Bandmate = Band.Id
    where Band.Firstname != 'Anne-Marit'
)
order by AnneInstruments.Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Report, in alphabetical order, the first name(s) of the performer(s) who played the largest number of different instruments.

with InstrumentCount as
(
    select Band.Firstname, Band.Id, count(distinct Instruments.Instrument) as NumIns
    from Band
    join Instruments on Instruments.Bandmate = Band.Id
    group by Band.Id
)

select InstrumentCount.Firstname from InstrumentCount
where InstrumentCount.NumIns = (select max(InstrumentCount.NumIns) from InstrumentCount)
order by InstrumentCount.Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Which instrument(s) was/were played on the largest number of songs? Report just the names of the instruments, sorted alphabetically (note, you are counting number of songs on which an instrument was played, make sure to not count two different performers playing same instrument on the same song twice).
with SongsPerInstrument as
(
    select Instruments.Instrument, count(distinct Instruments.Song) as Songs
    from Instruments
    join Songs on Songs.SongId = Instruments.Song
    group by Instruments.Instrument
)

select SongsPerInstrument.Instrument
from SongsPerInstrument
where SongsPerInstrument.Songs = (select max(SongsPerInstrument.Songs) from SongsPerInstrument);


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Who spent the most time performing in the center of the stage (in terms of number of songs on which she was positioned there)? Return just the first name of the performer(s), sorted in alphabetical order.

with TimeCenters as
(
    select Performance.Bandmate, Band.Firstname, count(*) as Centers
    from Performance
    join Band on Band.Id = Performance.Bandmate
    where Performance.StagePosition = 'center'
    group by Performance.Bandmate
)

select TimeCenters.Firstname from TimeCenters 
where TimeCenters.Centers = (select max(TimeCenters.Centers) from TimeCenters)
order by TimeCenters.Firstname;


