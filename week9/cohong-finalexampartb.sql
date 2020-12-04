-- Final Exam Part b
-- cohong
-- Dec 4, 2020

USE `BAKERY`;
-- BAKERY-1
-- Find all Cookies (any flavor) or Lemon-flavored items (any type) that have been purchased on either Saturday or Sunday (or both days). List each food and flavor once. Sort by food then flavor.
with CookiesAndLemons as
(
    select goods.Food, goods.Flavor, receipts.SaleDate
    from receipts 
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    where goods.food = 'Cookie' or goods.flavor = 'Lemon'
)

select Food, Flavor
from CookiesAndLemons
where DAYOFWEEK(CookiesAndLemons.SaleDate) = 1 or DAYOFWEEK(CookiesAndLemons.SaleDate) = 7
group by food, flavor
order by food, flavor;


USE `BAKERY`;
-- BAKERY-2
-- For customers who have purchased at least one Cookie, find the customer's favorite flavor(s) of Cookie based on number of purchases.  List last name, first name, flavor and purchase count. Sort by customer last name, first name, then flavor.
with CustomerPurchases as
(
    select receipts.Customer, goods.Flavor, Count(*) as Purchases
    from receipts, customers, goods, items
    where (receipts.Customer = customers.CId) and (receipts.RNumber = items.Receipt) and (goods.GId = items.item) and (goods.Food = 'Cookie')
    group by items.item, receipts.Customer, goods.Flavor
),

MaxPurchaseCount as
(
    select CookieBuyers.Customer, customers.LastName, customers.FirstName, Max(CookieBuyers.Purchases) as PurchasesCount
    from customers, (
                        select receipts.Customer, goods.Flavor, Count(*) as Purchases
                        from receipts, customers, goods, items
                        where (receipts.Customer = customers.CId) and (receipts.RNumber = items.Receipt) and (goods.GId = items.item) and (goods.Food = 'Cookie')
                        group by items.item, receipts.Customer, goods.Flavor
                    ) as CookieBuyers
    where customers.CId = CookieBuyers.Customer
    group by CookieBuyers.Customer, customers.LastName, customers.FirstName
)

select MaxPurchaseCount.LastName, MaxPurchaseCount.FirstName, CustomerPurchases.Flavor, CustomerPurchases.Purchases as PurchaseCount
from CustomerPurchases, MaxPurchaseCount
Where CustomerPurchases.Customer = MaxPurchaseCount.Customer And CustomerPurchases.Purchases = MaxPurchaseCount.PurchasesCount
order by lastname, flavor;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who purchased a Cookie on two or more consecutive days. List customer ID, first, and last name. Sort by customer ID.
with cookielovers as
(
    select customers.CId, customers.FirstName, customers.LastName, receipts.SaleDate
    from customers
    join receipts on receipts.Customer = customers.CId
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    where goods.Food = 'Cookie'
)

select distinct c1.CId, c1.LastName, c1.FirstName
from cookielovers as c1
join cookielovers as c2 on c2.CId = c1.CId
where c2.SaleDate = (c1.SaleDate + interval 1 day)
order by c1.CId;


USE `BAKERY`;
-- BAKERY-4
-- Find customers who have purchased every Almond-flavored item or who have purchased every Walnut-flavored item. Include customers who have purchased all items of both flavors. Report customer ID, first name and last name. Sort by customer ID.
with TheBuyers as
(
    select customers.CId, customers.LastName, customers.FirstName, goods.Food, goods.Flavor
    from receipts 
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    join customers on customers.CId = receipts.Customer
    where goods.Flavor = 'Almond' or goods.Flavor = 'Walnut'
    group by customers.CId, customers.LastName, customers.FirstName, goods.Food, goods.Flavor
    order by customers.LastName, goods.Flavor
),

BuyerCount as
(
    select TheBuyers.CId, TheBuyers.LastName, TheBuyers.FirstName, TheBuyers.Flavor, count(*) as LovesIt
    from TheBuyers
    group by TheBuyers.CId, TheBuyers.LastName, TheBuyers.FirstName, TheBuyers.Flavor
),

ShowOnly as
(
    select BuyerCount.CId, BuyerCount.FirstName, BuyerCount.LastName
    from BuyerCount
    where (BuyerCount.LovesIt = 4 and BuyerCount.Flavor = 'Almond') or (BuyerCount.LovesIt = 1 and BuyerCount.Flavor = 'Walnut') 
    group by BuyerCount.CId, BuyerCount.LastName, BuyerCount.FirstName
)


select * from ShowOnly
order by ShowOnly.CId;


USE `INN`;
-- INN-1
-- Find all rooms that are vacant during the entire date range June 1st and June 8th, 2010 (inclusive). Report room codes, sorted alphabetically.
select distinct reservations.Room
from reservations
where reservations.Room not in
(
    select distinct reservations.Room
    from reservations
    where  (reservations.CheckIn <= "2010-06-01" and reservations.Checkout >= "2010-06-01") or
	       (reservations.CheckIn <= "2010-06-02" and reservations.Checkout >= "2010-06-02") or
	       (reservations.CheckIn <= "2010-06-03" and reservations.Checkout >= "2010-06-03") or
	       (reservations.CheckIn <= "2010-06-04" and reservations.Checkout >= "2010-06-04") or
	       (reservations.CheckIn <= "2010-06-05" and reservations.Checkout >= "2010-06-05") or
	       (reservations.CheckIn <= "2010-06-06" and reservations.Checkout >= "2010-06-06") or
	       (reservations.CheckIn <= "2010-06-07" and reservations.Checkout >= "2010-06-07") or
	       (reservations.CheckIn <= "2010-06-08" and reservations.Checkout >= "2010-06-08")
)
order by reservations.Room;


USE `INN`;
-- INN-2
-- For calendar year 2010, create a monthly report for room with code AOB. List each calendar month and the number of reservations that began in that month. Include a plus or minus sign, indicating whether the month is at/above (+) or below (-) the average number of reservations per month for the room. Sort in chronological order by month.
with AVGPerMonth as
(
    select (count(*)/12) as AvgCount
    from
    (
        select *
        from reservations
        where YEAR(reservations.CheckIn) = 2010 and reservations.Room = 'AOB' 
    ) as AvgAllMonth
),

MonthData as
(
    select MONTH(reservations.CheckIn) as mon
    from reservations
    where YEAR(reservations.CheckIn) = 2010 and reservations.Room = 'AOB'
    order by mon
),

with_count as
(
    select mon, count(*) as ResCount
    from MonthData
    group by mon
)

select
case
when mon = 1 then 'January'
when mon = 2 then 'February'
when mon = 3 then 'March'
when mon = 4 then 'April'
when mon = 5 then 'May'
when mon = 6 then 'June'
when mon = 7 then 'July'
when mon = 8 then 'August'
when mon = 9 then 'September'
when mon = 10 then 'October'
when mon = 11 then 'November'
when mon = 12 then 'December'
end as Month,
with_count.ResCount,
case
when AvgCount > with_count.ResCount then '-'
when AvgCount < with_count.ResCount then '+'
end as ComparedToAvg
from with_count
join AVGPerMonth;


USE `INN`;
-- INN-3
-- For each room, find the longest vacancy (number of nights) between a reservation and the next reservation in the same room. Exclude from consideration the "last" reservation in each room, for which there is no future reservation. List room code and the length in nights of the longest vacancy. Report 0 if there are no periods of vacancy for a given room. Sort by room code.
with distance_between_dates as
(
    select r1.room, r1.checkout, r2.checkin, datediff(r2.checkin, r1.checkout) as difference
    from reservations as r1
    join reservations as r2 on r2.room = r1.room
    where datediff(r2.checkin, r1.checkout) >= 0
    order by r1.room
),

time_was_vacant as
(
    select distance_between_dates.room, min(distance_between_dates.difference) as vacant
    from distance_between_dates
    group by distance_between_dates.room, distance_between_dates.checkout having min(distance_between_dates.difference)
    order by distance_between_dates.room
),

get_max_for_each_room as
(
    select time_was_vacant.room, max(time_was_vacant.vacant) as max_vacancy
    from time_was_vacant
    group by time_was_vacant.room
)


select rooms.roomCode,
case
when get_max_for_each_room.max_vacancy is null then 0
else get_max_for_each_room.max_vacancy
end as LongestVacancy
from get_max_for_each_room
right join rooms on rooms.roomCode = get_max_for_each_room.Room
order by rooms.roomCode;


USE `AIRLINES`;
-- AIRLINES-1
-- List the name of every airline along with the number of that airline's flights which depart from airport ACV. If an airline does not fly from ACV, show the number 0. Sort alphabetically by airline name.
with flyACV as
(
    select airlines.name, count(*) as flycount
    from airlines
    join flights on flights.Airline = airlines.Id
    join airports on airports.Code = flights.Source
    where airports.code = 'ACV'
    group by airlines.name
)

select airlines.name,
case
when flycount is null then 0
else flycount
end as FlightsfromACV
from airlines
left join flyACV on flyACV.name = airlines.name
order by airlines.name;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the airports with the highest and lowest percentages of inbound flights on Frontier Airlines. For example, airport ANQ is the destination of 10 flights, 1 of which is a Frontier flight, yielding a "Frontier percentage" of 10. Report airport code and Frontier percentage rounded to two decimal places. Sort by airport code.
with Everyone_flights as
(
    select flights.Destination, count(*) as everyone_count
    from airlines
    join flights on flights.Airline = airlines.Id
    join airports on airports.Code = flights.source
    group by flights.Destination
    order by flights.Destination
),

frontier_flights as
(
    select flights.Destination, count(*) as frontier_count
    from airlines
    join flights on flights.Airline = airlines.Id
    join airports on airports.Code = flights.source
    where airlines.Abbr = 'Frontier'
    group by flights.Destination
    order by flights.Destination
),

percent_calc as
(
    select frontier_flights.Destination, round(frontier_count/everyone_count * 100, 2) as FrontierPct
    from frontier_flights
    join Everyone_flights on Everyone_flights.Destination = frontier_flights.Destination
),

get_min as
(
    select min(FrontierPct) as counted
    from percent_calc
),

get_max as
(
    select max(FrontierPct) as counted
    from percent_calc
)

select percent_calc.Destination, percent_calc.FrontierPct
from percent_calc
join get_max
join get_min
where (percent_calc.FrontierPct = get_max.counted) or (percent_calc.FrontierPct = get_min.counted)
order by percent_calc.Destination;


USE `AIRLINES`;
-- AIRLINES-3
-- If a passenger begins a one-transfer flight at airport ACV, which intermediate transfer airport(s) will allow the greatest number of possible final destinations? List the origin airport, transfer airport, and number of different possible destinations. Sort by the transfer airport.
with possible_flights as
(
    select flights.Source, flights.Destination, flights.FlightNo
    from flights
    where flights.Source = 'ACV'
),

possible_transfers as
(
    select possible_flights.Source, possible_flights.Destination, count(distinct flights.Destination) as AllPossibleDest
    from possible_flights
    join flights on flights.Source = possible_flights.Destination
    where flights.Destination != 'ACV'
    group by flights.Source
),

get_max as
(
    select max(possible_transfers.AllPossibleDest) as counted
    from possible_transfers
)

select possible_transfers.Source, possible_transfers.Destination, possible_transfers.AllPossibleDest
from possible_transfers
join get_max
where possible_transfers.AllPossibleDest = get_max.counted
order by possible_transfers.Destination;


