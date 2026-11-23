
-- QUERIES

-- Requirement 1: Filtering and Sorting
-- Shows which horses were listed to be in good physical condition before a race. Displays the additional notes each of them may have had.
-- This will be useful for betters or predictors to at least get some information regarding a horses condition before a race.

SELECT
    Horses.horse_id,
    Horses.name AS horse_name,
    Race.race_name,
    Race.race_date,
    HorseObservation.demeanour,
    HorseObservation.behavior,
    HorseObservation.physical_condition,
    HorseObservation.additional_notes
FROM HorseObservation
INNER JOIN Horses
    ON HorseObservation.horse_id = Horses.horse_id
INNER JOIN Race
    ON HorseObservation.race_id = Race.race_id
WHERE HorseObservation.physical_condition = 'Good'
ORDER BY Race.race_date DESC, Horses.name ASC;

-- Requirement 2: Inner Join
-- Determines what ranch each of the horses belong to
-- Useful for predictors to see what reputation ranch each horse belongs to

SELECT
    Horses.horse_id,
    Horses.name AS horse_name,
    Horses.breed,
    Ranch.ranch_name,
    Ranch.location
FROM Horses
INNER JOIN Ranch
    ON Horses.ranch_id = Ranch.ranch_id
ORDER BY Ranch.ranch_name, Horses.name;

-- Requirement 3: Left Join
-- Shows what horses have and have not been entered into a race.
-- This can be useful for showing which horses have not been registered for a race. 

SELECT
    Horses.horse_id,
    Horses.name AS horse_name,
    RaceEntry.race_id,
    RaceEntry.entry_status
FROM Horses
LEFT JOIN RaceEntry
    ON Horses.horse_id = RaceEntry.horse_id
ORDER BY Horses.name;

-- Requirement 4: Three-Table Join
-- Shows which horses competed in a race, their jockeys, and their finishing position
-- Good for previous race analysis which is extremely important when making predictions 

SELECT
    Race.race_name,
    Race.race_date,
    Horses.name AS horse_name,
    Jockey.first_name || ' ' || Jockey.last_name AS jockey_name,
    RaceResult.finishing_position,
    RaceResult.time AS finishing_time
FROM RaceResult
INNER JOIN Race
    ON RaceResult.race_id = Race.race_id
INNER JOIN Horses
    ON RaceResult.horse_id = Horses.horse_id
INNER JOIN Jockey
    ON RaceResult.jockey_id = Jockey.jockey_id
ORDER BY Race.race_date DESC, RaceResult.finishing_position ASC;

-- Requirement 5: Aggregate Query
-- Determines how many races are organized for each type of racing terrain
-- This is useful for seeing if a majority of races are going to be held on a specific type of terrain for a race

SELECT
    surface,
    COUNT(*) AS total_races
FROM Race
GROUP BY surface
ORDER BY total_races DESC;

-- Requirement 6: Group By and Having
-- Shows which jockeys have participated in at least 2 race entries
-- This can be useful for looking at jockey assignments and participation

SELECT
    Jockey.jockey_id,
    Jockey.first_name || ' ' || Jockey.last_name AS jockey_name,
    COUNT(RaceEntry.race_id) AS total_race_entries
FROM Jockey
INNER JOIN RaceEntry
    ON Jockey.jockey_id = RaceEntry.jockey_id
GROUP BY
    Jockey.jockey_id,
    Jockey.first_name,
    Jockey.last_name
HAVING COUNT(RaceEntry.race_id) >= 2
ORDER BY total_race_entries DESC;

-- Requirement 7: Subquery
-- Shows which horses have had a finishing record better than the average finish position among all recorded race results
-- Good for identifying high performance horses 

SELECT
    Horses.horse_id,
    Horses.name AS horse_name,
    RaceResult.finishing_position,
    RaceResult.race_id
FROM Horses
INNER JOIN RaceResult
    ON Horses.horse_id = RaceResult.horse_id
WHERE RaceResult.finishing_position < (SELECT AVG(finishing_position) FROM RaceResult)
ORDER BY RaceResult.finishing_position ASC;

-- Requirement 8: Set Operation
-- Shows which horses are currently entered in a race or have recorded a result
-- Useful for creating a list of horses with current or old race history

SELECT
    horse_id
FROM RaceEntry
WHERE entry_status = 'Entered'

UNION

SELECT
    horse_id
FROM RaceResult

ORDER BY horse_id;

-- Requirement 9: View
-- Shows all race results for each horse, jockey, and even displays the race details.
-- This would be very useful for getting a list of race result information for each horse without the use of multiple joins
-- *Uses the view described in schema.sql

SELECT
    race_name,
    race_date,
    course,
    distance,
    surface,
    horse_name,
    jockey_name,
    finishing_position,
    finishing_time
FROM vw_race_results
ORDER BY
    race_date DESC,
    finishing_position ASC;

