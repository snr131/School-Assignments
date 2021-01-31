-- QUESTION 1. How many airplanes have listed speeds? What is the minimum listed speed and the maximum listed speed?

SELECT COUNT(*)
FROM planes;

SELECT COUNT(*)
FROM planes
WHERE speed > 0;

SELECT COUNT(*)
FROM planes
WHERE speed IS NULL;

SELECT MAX(speed), MIN(speed)
FROM planes;

-- ANSWER: Of the 3322 planes listed in this dataset, 23 have values greater than 0. 3299 have NULL values.432 is the maximum listed speed. 90 is the minimum listed speed.

-- QUESTION 2. What is the total distance flown by all of the planes in January 2013? What is the total distance flown by all of the planes in January 2013 where the tailnum is missing?

SELECT SUM(distance)
FROM flights
WHERE month = 1 AND year = 2013;

SELECT SUM(distance)
FROM flights
WHERE month = 1 AND year = 2013 AND tailnum = '';

-- ANSWER: The total distance flown by all planes in January 2013 is 27,188,805 miles. The total distance flown by all planes in January 2013 with missing tailnum values is 81,763 miles.

-- QUESTION 3: What is the total distance flown for all planes on July 5, 2013 grouped by aircraft manufacturer? Write this statement first using an INNER JOIN, then using a LEFT OUTER JOIN. How do your results compare?

SELECT planes.manufacturer, SUM(flights.distance)           
FROM flights 
INNER JOIN planes          
ON flights.tailnum=planes.tailnum
WHERE flights.day = 5 AND flights.month = 7 AND flights.year = 2013
GROUP BY planes.manufacturer;       

/*
The output looks like this. Notice there are manufacturers listed to the left of each distance sum, even though we already know there are records in this dataset with no tailnum listed.
AIRBUS	195089
AIRBUS INDUSTRIE 78786
AMERICAN AIRCRAFT INC 2199
BARKER JACK L 937
BOEING 335028
BOMBARDIER INC 31160
CANADAIR 1142
CESSNA 2898
DOUGLAS	1089
EMBRAER	77909
GULFSTREAM AEROSPACE 1157
MCDONNELL DOUGLAS 7486
MCDONNELL DOUGLAS AIRCRAFT CO 15690
MCDONNELL DOUGLAS CORPORATION 4767 
*/

SELECT planes.manufacturer, SUM(distance) FROM flights
LEFT OUTER JOIN planes
ON flights.tailnum=planes.tailnum
WHERE flights.day = 5 AND flights.month = 7 AND flights.year = 2013
GROUP BY planes.manufacturer;

/*
The output looks like this. Notice there a null manufacturer with a sum of all distances without a tailnum.
AIRBUS	195089
AIRBUS INDUSTRIE 78786
BOEING	335028
	127671
EMBRAER 77909
CANADAIR 1142
BOMBARDIER INC 31160
MCDONNELL DOUGLAS 7486
AMERICAN AIRCRAFT INC 2199
MCDONNELL DOUGLAS AIRCRAFT CO 15690
MCDONNELL DOUGLAS CORPORATION 4767
CESSNA 2898
GULFSTREAM AEROSPACE 1157
DOUGLAS	1089
BARKER JACK L 937
*/

-- ANSWER: The total distances flown July 5, 2013, grouped by manufacturer, are commented above. You'll notice that Inner Join does not show a sum for those distances without tailnums, whereas the Outer Left Join does.

-- QUESTION 4. Write and answer at least one question of your own choosing that joins information from at least three of the tables in the flights database.
 
-- ANSWER: My mother often travels between her home in Houston (arr IAH), and to visit me in NYC. I want to suggest the airline name, plane manufacturer and model, along with the originating airport name that have the smallest delay.

-- Which NYC airports fly to IAH? The output shows EWR, LGA, and JFK.
SELECT DISTINCT(flights.origin) 
FROM flights
WHERE flights.dest = 'IAH';

-- I am joining the flights, airlines, and to the flights table.
SELECT airlines.name, planes.manufacturer, planes.model, airports.name, AVG(flights.arr_delay)
FROM planes
LEFT JOIN flights
ON planes.tailnum = flights.tailnum
LEFT JOIN airlines
ON flights.carrier = airlines.carrier
LEFT JOIN airports
ON airports.faa = flights.origin
WHERE flights.dest = 'IAH' AND flights.arr_delay IS NOT NULL
GROUP BY 3
ORDER BY 5 ASC;

-- The best choice is to fly out of NYC from LaGuardia airport via United Air Lines Inc. on a Boeing 737-524.