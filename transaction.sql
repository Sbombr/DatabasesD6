-- Transation Example

-- The example involves registering a horse and recording a Pre-race observation
-- Steps:
-- 1. Creqate a race entry for the horse and jockey
-- 2. Record the horses pre-race condition and behavior

-- Begin the transaction
BEGIN TRANSACTION;

-- Here we make a race entry for a horse and jockey who already exist in the database
-- If they did not exist, we would have to make a entry into the Horses or Jockeys database depending on whos missing

INSERT INTO RaceEntry (
    race_id,
    horse_id,
    jockey_id,
    entry_status
)
VALUES (
    3, 4, 4, 'Entered'
);

-- Now that the horse is registered, we can make a horse observation for the given race and horse id
INSERT INTO HorseObservation (
    race_id,
    horse_id,
    demeanour,
    behavior,
    physical_condition,
    additional_notes
)
VALUES (
    3, 4, 'Calm', 'Alert and responsive', 'Good',
    'Horse appears ready for competition.'
);

-- Combining the two inserts would useful so that there would not be any incomplete data if the horse observation insert faces an error
-- There is a good argument that there should always be a race entry, but I believe this example is still useful for demonstrating the 
-- 	importance of atomicity in a database

-- For the following example, we will automatically rollback the data insert as to not mess with the current database values
ROLLBACK;


