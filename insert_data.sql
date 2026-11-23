

-- PURPOSE: This file contains the sample Horse Racing data to be used with the corresponding schema.sql file
-- ROWS:    It contains 100 rows of data
-- NOTES:
-- 	    The Horse Observations are completely made up for the sake of functionality and testing
-- 	    Other values like horses and jockeys should correspond to real life data.
-- 	    There are currently 5 races included in this data. This should be represented in any queries 

PRAGMA foreign_keys = ON;

-- Ranch: 4 ROWS

INSERT INTO Ranch (ranch_id, ranch_name, location, trainer_name) VALUES
    (1, 'Green Valley Ranch', 'Kentucky', 'Alex Morgan'),
    (2, 'Silver Creek Stables', 'Tennessee', 'Jordan Blake'),
    (3, 'Oakwood Racing Farm', 'Virginia', 'Taylor Brooks'),
    (4, 'Blue Ridge Ranch', 'North Carolina', 'Casey Reed');


-- Jockey: 8 ROWS

INSERT INTO Jockey (jockey_id, first_name, last_name, gender, date_of_birth, nationality) VALUES
    (1, 'Ethan', 'Carter', 'Male', '1995-03-12', 'American'),
    (2, 'Olivia', 'Hayes', 'Female', '1998-07-24', 'American'),
    (3, 'Noah', 'Bennett', 'Male', '1992-11-05', 'Canadian'),
    (4, 'Sophia', 'Reed', 'Female', '1997-01-18', 'British'),
    (5, 'Liam', 'Foster', 'Male', '1994-09-30', 'American'),
    (6, 'Ava', 'Mitchell', 'Female', '2000-05-14', 'Australian'),
    (7, 'Lucas', 'Ward', 'Male', '1991-12-02', 'Irish'),
    (8, 'Mia', 'Collins', 'Female', '1999-04-09', 'American');


-- Horses: 12 ROWS
INSERT INTO Horses (horse_id, ranch_id, name, date_of_birth, gender, breed, color) VALUES
    (1, 1, 'Thunder Strike', '2019-04-12', 'Male',
        'Thoroughbred', 'Bay'),
    (2, 1, 'Golden Breeze', '2020-03-20', 'Female',
        'Thoroughbred', 'Chestnut'),
    (3, 1, 'Midnight Star', '2018-06-15', 'Male',
        'Thoroughbred', 'Black'),
    (4, 2, 'Silver Comet', '2019-02-08', 'Male',
        'Thoroughbred', 'Gray'),
    (5, 2, 'Ruby Runner', '2021-05-11', 'Female',
        'Thoroughbred', 'Chestnut'),
    (6, 2, 'Storm Chaser', '2018-09-27', 'Male',
        'Quarter Horse', 'Brown'),
    (7, 3, 'Autumn Glory', '2020-08-19', 'Female',
        'Thoroughbred', 'Bay'),
    (8, 3, 'Rapid River', '2019-01-23', 'Male',
        'Thoroughbred', 'Dark Bay'),
    (9, 3, 'Velvet Moon', '2021-04-06', 'Female',
        'Arabian', 'Gray'),
    (10, 4, 'Blue Horizon', '2018-07-14', 'Male',
        'Thoroughbred', 'Black'),
    (11, 4, 'Dancing Flame', '2020-10-02', 'Female',
        'Thoroughbred', 'Chestnut'),
    (12, 4, 'Wild Spirit', '2019-12-17', 'Male',
        'Quarter Horse', 'Palomino'),
    (13, 4, 'Potager', '2017-02-04', 'Male',
        'Thoroughbred', 'Bay');

-- Race: 6 ROWS
-- Includes completed, in-progress, scheduled, and cancelled races.

INSERT INTO Race (race_id, race_name, field_number, race_date, course, distance, surface, status) VALUES
    (1, 'Spring Classic', 6, '2026-03-14',
        'Churchill Downs', 1600, 'Dirt', 'Completed'),
    (2, 'Bluegrass Stakes', 6, '2026-04-18',
        'Keeneland', 1800, 'Turf', 'Completed'),
    (3, 'Summer Sprint', 6, '2026-06-20',
        'Belmont Park', 1200, 'Dirt', 'Completed'),
    (4, 'Autumn Championship', 6, '2026-09-12',
        'Churchill Downs', 2000, 'Turf', 'Completed'),
    (5, 'Harvest Cup', 6, '2026-10-20',
        'Keeneland', 1600, 'Synthetic', 'In Progress'),
    (6, 'Winter Invitational', 4, '2026-12-05',
        'Blue Ridge Track', 1400, 'Dirt', 'Scheduled');


-- Race Entry: 34 ROWS
-- Horses and jockeys participate in multiple races. Includes scratched and withdrawn horses.

INSERT INTO RaceEntry (race_id, horse_id, jockey_id, entry_status) VALUES
    -- Race 1: Spring Classic
    (1, 1, 1, 'Entered'),
    (1, 2, 2, 'Entered'),
    (1, 3, 3, 'Entered'),
    (1, 4, 4, 'Entered'),
    (1, 5, 5, 'Entered'),
    (1, 6, 6, 'Entered'),

    -- Race 2: Bluegrass Stakes
    (2, 3, 1, 'Entered'),
    (2, 4, 2, 'Entered'),
    (2, 5, 3, 'Entered'),
    (2, 6, 4, 'Entered'),
    (2, 7, 5, 'Entered'),
    (2, 8, 6, 'Entered'),

    -- Race 3: Summer Sprint
    (3, 5, 7, 'Entered'),
    (3, 6, 8, 'Entered'),
    (3, 7, 1, 'Entered'),
    (3, 8, 2, 'Entered'),
    (3, 9, 3, 'Entered'),
    (3, 10, 4, 'Entered'),

    -- Race 4: Autumn Championship
    (4, 7, 2, 'Entered'),
    (4, 8, 3, 'Entered'),
    (4, 9, 4, 'Entered'),
    (4, 10, 5, 'Entered'),
    (4, 11, 6, 'Entered'),
    (4, 12, 7, 'Entered'),

    -- Race 5: Harvest Cup
    (5, 1, 8, 'Entered'),
    (5, 3, 1, 'Entered'),
    (5, 5, 2, 'Entered'),
    (5, 7, 3, 'Entered'),
    (5, 9, 4, 'Scratched'),
    (5, 11, 5, 'Entered'),

    -- Race 6: Winter Invitational
    (6, 2, 6, 'Entered'),
    (6, 4, 7, 'Entered'),
    (6, 6, 8, 'Withdrawn'),
    (6, 8, 1, 'Entered');


-- Race Result: 20 ROWS
-- Five classified finishers in each completed race. Positions are unique within each race.

INSERT INTO RaceResult (result_id, race_id, horse_id, jockey_id, finishing_position, time) VALUES
    -- Race 1: Spring Classic
    (1, 1, 1, 1, 1, '01:36.42'),
    (2, 1, 2, 2, 2, '01:36.91'),
    (3, 1, 3, 3, 3, '01:37.18'),
    (4, 1, 4, 4, 4, '01:38.04'),
    (5, 1, 5, 5, 5, '01:38.72'),

    -- Race 2: Bluegrass Stakes
    (6, 2, 5, 3, 1, '01:49.25'),
    (7, 2, 3, 1, 2, '01:49.61'),
    (8, 2, 4, 2, 3, '01:50.08'),
    (9, 2, 7, 5, 4, '01:50.66'),
    (10, 2, 8, 6, 5, '01:51.14'),

    -- Race 3: Summer Sprint
    (11, 3, 10, 4, 1, '01:09.37'),
    (12, 3, 7, 1, 2, '01:09.74'),
    (13, 3, 5, 7, 3, '01:10.02'),
    (14, 3, 8, 2, 4, '01:10.48'),
    (15, 3, 9, 3, 5, '01:11.06'),

    -- Race 4: Autumn Championship
    (16, 4, 10, 5, 1, '02:03.19'),
    (17, 4, 7, 2, 2, '02:03.87'),
    (18, 4, 8, 3, 3, '02:04.25'),
    (19, 4, 11, 6, 4, '02:05.11'),
    (20, 4, 12, 7, 5, '02:05.68');


-- Horse Observation: 16 ROWS
-- Different temperaments, behaviors, and conditions.

INSERT INTO HorseObservation (observation_id, race_id, horse_id, demeanour, behavior, physical_condition, additional_notes) VALUES
    (1, 1, 1, 'Calm', 'Responsive',
        'Excellent', 'Strong warm-up; no concerns'),
    (2, 1, 2, 'Energetic', 'Focused',
        'Good', 'Responded well to the jockey'),
    (3, 1, 3, 'Nervous', 'Restless',
        'Good', 'Needed extra time in the starting gate'),
    (4, 1, 4, 'Calm', 'Cooperative',
        'Excellent', 'Consistent stride during warm-up'),

    (5, 2, 5, 'Confident', 'Responsive',
        'Excellent', 'Maintained an even pace'),
    (6, 2, 6, 'Excitable', 'Pulling on reins',
        'Good', 'Required a longer warm-up'),
    (7, 2, 7, 'Calm', 'Focused',
        'Good', 'No unusual behavior observed'),

    (8, 3, 8, 'Alert', 'Fast starting',
        'Excellent', 'Quick acceleration'),
    (9, 3, 9, 'Nervous', 'Restless',
        'Fair', 'Monitor recovery after the race'),
    (10, 3, 10, 'Calm', 'Responsive',
        'Excellent', 'Strong finish'),

    (11, 4, 7, 'Focused', 'Cooperative',
        'Excellent', 'Good stamina during warm-up'),
    (12, 4, 8, 'Energetic', 'Responsive',
        'Good', 'No visible signs of discomfort'),
    (13, 4, 11, 'Calm', 'Steady',
        'Good', 'Maintained an even stride'),

    (14, 5, 1, 'Alert', 'Responsive',
        'Good', 'Pre-race assessment completed'),
    (15, 5, 3, 'Restless', 'Agitated',
        'Fair', 'Trainer advised additional monitoring'),
    (16, 6, 2, 'Calm', 'Cooperative',
        'Excellent', 'Initial pre-race assessment');

