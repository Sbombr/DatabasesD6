
-- PURPOSE: This is the schema table for the related Horse racing database project. 
--	    Consult the ERD table for a full overview of entities and relationships

-- Enable foreign-key enforcement for this connection.
PRAGMA foreign_keys = ON;

-- Drop tables if necessary
DROP VIEW IF EXISTS vw_race_results;
DROP TABLE IF EXISTS HorseObservation;
DROP TABLE IF EXISTS RaceResult;
DROP TABLE IF EXISTS RaceEntry;
DROP TABLE IF EXISTS Horses;
DROP TABLE IF EXISTS Jockey;
DROP TABLE IF EXISTS Race;
DROP TABLE IF EXISTS Ranch;

-- Ranch Entity
-- Holds information about a specific ranches.
CREATE TABLE Ranch (
    ranch_id INTEGER PRIMARY KEY,
    ranch_name TEXT NOT NULL UNIQUE,
    location TEXT NOT NULL,
    trainer_name TEXT NOT NULL
);

-- Jockey Entity
-- Holds information about various Jockeys.
CREATE TABLE Jockey (
    jockey_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    gender TEXT NOT NULL
        CHECK (gender IN ('Male', 'Female')),
    date_of_birth TEXT NOT NULL,
    nationality TEXT NOT NULL
);

-- Horses Entity
-- Holds information about a horse and its information
CREATE TABLE Horses (
    horse_id INTEGER PRIMARY KEY,
    ranch_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    date_of_birth TEXT NOT NULL,
    gender TEXT NOT NULL
        CHECK (gender IN ('Male', 'Female')),
    breed TEXT NOT NULL,
    color TEXT NOT NULL,

    FOREIGN KEY (ranch_id)
        REFERENCES Ranch(ranch_id)

    CHECK (length(trim(name)) > 0)
);

-- Race Entity
-- Holds information for a specific race. How long it is, the surface, what type it is.
CREATE TABLE Race (
    race_id INTEGER PRIMARY KEY,
    race_name TEXT NOT NULL,
    field_number INTEGER NOT NULL
        CHECK (field_number > 0),
    race_date TEXT NOT NULL,
    course TEXT NOT NULL,
    distance INTEGER NOT NULL
        CHECK (distance > 0),
    surface TEXT NOT NULL
        CHECK (surface IN ('Dirt', 'Turf', 'Synthetic')),
    status TEXT NOT NULL DEFAULT 'Scheduled'
        CHECK (
            status IN (
                'Scheduled',
                'In Progress',
                'Completed',
                'Cancelled'
            )
        )
);

-- Race Entry Entity
-- Checks to see if a horse is entered into a race. May have to switch status to scratched or withdrawn.
CREATE TABLE RaceEntry (
    race_id INTEGER NOT NULL,
    horse_id INTEGER NOT NULL,
    jockey_id INTEGER NOT NULL,
    entry_status TEXT NOT NULL DEFAULT 'Entered'
        CHECK (
            entry_status IN (
                'Entered',
                'Scratched',
                'Withdrawn'
            )
        ),

    PRIMARY KEY (race_id, horse_id),

    FOREIGN KEY (race_id)
        REFERENCES Race(race_id)

    FOREIGN KEY (horse_id)
        REFERENCES Horses(horse_id)

    FOREIGN KEY (jockey_id)
        REFERENCES Jockey(jockey_id)
);

-- Race Result Entity
-- Holds the result of a specific horse for a specific race
CREATE TABLE RaceResult (
    result_id INTEGER PRIMARY KEY,
    race_id INTEGER NOT NULL,
    horse_id INTEGER NOT NULL,
    jockey_id INTEGER NOT NULL,
    finishing_position INTEGER NOT NULL
        CHECK (finishing_position > 0),
    time TEXT NOT NULL,

    FOREIGN KEY (race_id, horse_id)
        REFERENCES RaceEntry(race_id, horse_id)

    FOREIGN KEY (jockey_id)
        REFERENCES Jockey(jockey_id)

    UNIQUE (race_id, horse_id),
    UNIQUE (race_id, finishing_position),

    CHECK (length(trim(time)) > 0)
);

-- Horse Observation Entity
-- Used to hold qualatative information about a horse before it races
CREATE TABLE HorseObservation (
    observation_id INTEGER PRIMARY KEY,
    race_id INTEGER NOT NULL,
    horse_id INTEGER NOT NULL,
    demeanour TEXT NOT NULL,
    behavior TEXT NOT NULL,
    physical_condition TEXT NOT NULL,
    additional_notes TEXT DEFAULT '',

    FOREIGN KEY (race_id)
        REFERENCES Race(race_id)

    FOREIGN KEY (horse_id)
        REFERENCES Horses(horse_id)
);

-- Useful Index
-- Additional useful index for observations by horse and race.
CREATE INDEX idx_observation_horse_race
    ON HorseObservation(horse_id, race_id);

-- Useful View
-- Combines race results with race, horse, and jockey data.
CREATE VIEW vw_race_results AS
SELECT
    r.race_id,
    r.race_name,
    r.race_date,
    r.course,
    r.distance,
    r.surface,
    rr.result_id,
    h.horse_id,
    h.name AS horse_name,
    j.jockey_id,
    j.first_name || ' ' || j.last_name AS jockey_name,
    rr.finishing_position,
    rr.time AS finishing_time
    FROM RaceResult AS rr
	JOIN Race AS r
    	ON rr.race_id = r.race_id
    JOIN Horses AS h
        ON rr.horse_id = h.horse_id
    JOIN Jockey AS j
        ON rr.jockey_id = j.jockey_id;

