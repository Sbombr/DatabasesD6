import sqlite3

# Function for error checking IDs for things like races. 
# If the ID entered is not possible, then return a error
def validate_id(value):

    if not value.isdigit():
        print("Invalid ID. Please enter a positive number.")
        return False

    if int(value) <= 0:
        print("ID must be greater than zero.")
        return False

    return True

# This return the horse observations for all horses of a specific race.
# This satisfies the 6: Additional meaningful operation
#   This is probably the most interesting part of the database so I classified it as the most meaningful
def view_race_observations(conn):

    cursor = conn.cursor()

    print("\n================================")
    print("       RACE HORSE OBSERVATIONS")
    print("================================")

    race_id = input("Enter Race ID: ")

    if not validate_id(race_id):
        return

    try:
        # Check whether the race exists
        cursor.execute("""
            SELECT race_name, race_date, course
            FROM Race
            WHERE race_id = ?
        """, (race_id,))

        race = cursor.fetchone()

        if not race:
            print("Race not found.")
            return

        print(f"\nRace: {race[0]}")
        print(f"Date: {race[1]}")
        print(f"Course: {race[2]}")

        # Retrieve observations for all horses in the race
        cursor.execute("""
            SELECT
                h.horse_id,
                h.name,
                ho.demeanour,
                ho.behavior,
                ho.physical_condition,
                ho.additional_notes
            FROM HorseObservation AS ho
            JOIN Horses AS h
                ON ho.horse_id = h.horse_id
            WHERE ho.race_id = ?
            ORDER BY h.name
        """, (race_id,))

        observations = cursor.fetchall()

        if observations:

            print("\n========== HORSE OBSERVATIONS ==========")

            for observation in observations:

                print("\n----------------------------------------")
                print(f"Horse ID: {observation[0]}")
                print(f"Horse Name: {observation[1]}")
                print(f"Demeanour: {observation[2]}")
                print(f"Behaviour: {observation[3]}")
                print(f"Physical Condition: {observation[4]}")
                print(f"Additional Notes: {observation[5]}")
                print("----------------------------------------")

            print(f"\nTotal Observations: {len(observations)}")

        else:
            print("\nNo horse observations recorded for this race.")

    except sqlite3.Error as e:
        print("Database error:", e)

    finally:
        cursor.close()

# This is a general lookup that allows users to look for specific horses, jockeys, races, etc...
# This satisfies the 1: Search or Browse Data operation
def browse_data(conn):

    cursor = conn.cursor()

    while True:
        print("\n================================")
        print("          BROWSE DATA")
        print("================================")
        print("1. View Ranches")
        print("2. View Horses")
        print("3. View Jockeys")
        print("4. View Races")
        print("5. View Race Entries")
        print("6. Search Horses")
        print("7. Search Jockeys")
        print("8. Return to Main Menu")

        choice = input("\nEnter your choice: ")

        # Pretty self-explanatory, just print information and use user input when needed
        if choice == "1":
            cursor.execute("""
                SELECT ranch_id, ranch_name, location, trainer_name
                FROM Ranch
            """)

            rows = cursor.fetchall()

            print("\n--- RANCHES ---")
            for row in rows:
                print(f"ID: {row[0]} | Name: {row[1]} | "
                      f"Location: {row[2]} | Trainer: {row[3]}")

        elif choice == "2":
            cursor.execute("""
                SELECT horse_id, name, date_of_birth, gender,
                       breed, color, ranch_id
                FROM Horses
            """)

            rows = cursor.fetchall()

            print("\n--- HORSES ---")
            for row in rows:
                print(f"ID: {row[0]} | Name: {row[1]} | "
                      f"DOB: {row[2]} | Gender: {row[3]} | "
                      f"Breed: {row[4]} | Color: {row[5]} | "
                      f"Ranch ID: {row[6]}")

        elif choice == "3":
            cursor.execute("""
                SELECT jockey_id, first_name, last_name,
                       gender, date_of_birth, nationality
                FROM Jockey
            """)

            rows = cursor.fetchall()

            print("\n--- JOCKEYS ---")
            for row in rows:
                print(f"ID: {row[0]} | Name: {row[1]} {row[2]} | "
                      f"Gender: {row[3]} | DOB: {row[4]} | "
                      f"Nationality: {row[5]}")

        elif choice == "4":
            cursor.execute("""
                SELECT race_id, race_name, field_number,
                       race_date, course, distance, surface, status
                FROM Race
            """)

            rows = cursor.fetchall()

            print("\n--- RACES ---")
            for row in rows:
                print(f"ID: {row[0]} | Race: {row[1]} | "
                      f"Field: {row[2]} | Date: {row[3]} | "
                      f"Course: {row[4]} | Distance: {row[5]} | "
                      f"Surface: {row[6]} | Status: {row[7]}")

        elif choice == "5":
            cursor.execute("""
                SELECT
                    re.race_id,
                    r.race_name,
                    h.name,
                    j.first_name || ' ' || j.last_name,
                    re.entry_status
                FROM RaceEntry AS re
                JOIN Race AS r ON re.race_id = r.race_id
                JOIN Horses AS h ON re.horse_id = h.horse_id
                JOIN Jockey AS j ON re.jockey_id = j.jockey_id
                ORDER BY re.race_id
            """)

            rows = cursor.fetchall()

            print("\n--- RACE ENTRIES ---")
            for row in rows:
                print(f"Race ID: {row[0]} | Race: {row[1]} | "
                      f"Horse: {row[2]} | Jockey: {row[3]} | "
                      f"Status: {row[4]}")

        elif choice == "6":
            search = input("\nEnter horse name to search: ")

            cursor.execute("""
                SELECT horse_id, name, breed, color
                FROM Horses
                WHERE name LIKE ?
            """, ('%' + search + '%',))

            rows = cursor.fetchall()

            print("\n--- HORSE SEARCH RESULTS ---")

            if rows:
                for row in rows:
                    print(f"ID: {row[0]} | Name: {row[1]} | "
                          f"Breed: {row[2]} | Color: {row[3]}")
            else:
                print("No horses found.")

        elif choice == "7":
            search = input("\nEnter jockey name to search: ")

            cursor.execute("""
                SELECT jockey_id, first_name, last_name, nationality
                FROM Jockey
                WHERE first_name LIKE ?
                   OR last_name LIKE ?
            """, ('%' + search + '%', '%' + search + '%'))

            rows = cursor.fetchall()

            print("\n--- JOCKEY SEARCH RESULTS ---")

            if rows:
                for row in rows:
                    print(f"ID: {row[0]} | Name: {row[1]} {row[2]} | "
                          f"Nationality: {row[3]}")
            else:
                print("No jockeys found.")

        elif choice == "8":
            break

        else:
            print("Invalid choice. Please try again.")

# Peforms joins from horses and race entries to combine the data for viewing.
# Satifies the 2: Display related data functionality
def view_race_entries(conn):

    cursor = conn.cursor()

    print("\n================================")
    print("       VIEW RACE INFORMATION")
    print("================================")

    race_id = input("Enter Race ID: ")

    if not validate_id(race_id):
        return

    cursor.execute("""
        SELECT race_id, race_name, race_date, course,
               distance, surface, status, field_number
        FROM Race
        WHERE race_id = ?
    """, (race_id,))

    race = cursor.fetchone()

    if not race:
        print("Race not found.")
        return

    print("\n--- RACE INFORMATION ---")
    print(f"Race ID: {race[0]}")
    print(f"Race Name: {race[1]}")
    print(f"Date: {race[2]}")
    print(f"Course: {race[3]}")
    print(f"Distance: {race[4]}")
    print(f"Surface: {race[5]}")
    print(f"Status: {race[6]}")
    print(f"Field Number: {race[7]}")

    cursor.execute("""
        SELECT
            h.horse_id,
            h.name,
            j.first_name || ' ' || j.last_name AS jockey_name,
            re.entry_status
        FROM RaceEntry AS re
        JOIN Horses AS h
            ON re.horse_id = h.horse_id
        JOIN Jockey AS j
            ON re.jockey_id = j.jockey_id
        WHERE re.race_id = ?
        ORDER BY h.name
    """, (race_id,))

    entries = cursor.fetchall()

    print("\n--- ENTERED HORSES ---")

    if entries:
        for entry in entries:
            print(f"Horse ID: {entry[0]} | "
                  f"Horse: {entry[1]} | "
                  f"Jockey: {entry[2]} | "
                  f"Status: {entry[3]}")
    else:
        print("No horses are currently entered in this race.")

    print(f"\nTotal Entries: {len(entries)}")

# Uses the view from the schema to combine horses, races, jockeys, and almost all relevant racing information
# Satifies the 5: Summary or report
def race_results_report(conn):

    cursor = conn.cursor()

    while True:

        print("\n================================")
        print("       RACE RESULTS REPORT")
        print("================================")
        print("1. View All Race Results")
        print("2. View Results By Race ID")
        print("3. View Results By Horse")
        print("4. Return to Main Menu")

        choice = input("\nEnter your choice: ")

        if choice == "1":

            cursor.execute("""
                SELECT
                    race_id,
                    race_name,
                    race_date,
                    horse_name,
                    jockey_name,
                    finishing_position,
                    finishing_time
                FROM vw_race_results
                ORDER BY race_date DESC, race_id, finishing_position
            """)

            results = cursor.fetchall()

            print("\n--- ALL RACE RESULTS ---")

            if results:
                for row in results:
                    print(
                        f"\nRace: {row[1]} (ID: {row[0]})"
                        f"\nDate: {row[2]}"
                        f"\nHorse: {row[3]}"
                        f"\nJockey: {row[4]}"
                        f"\nFinishing Position: {row[5]}"
                        f"\nFinishing Time: {row[6]}"
                    )
                    print("--------------------------------")

            else:
                print("No race results available.")

        elif choice == "2":

            race_id = input("\nEnter Race ID: ")

            if not validate_id(race_id):
                return

            cursor.execute("""
                SELECT
                    race_id,
                    race_name,
                    race_date,
                    horse_name,
                    jockey_name,
                    finishing_position,
                    finishing_time
                FROM vw_race_results
                WHERE race_id = ?
                ORDER BY finishing_position
            """, (race_id,))

            results = cursor.fetchall()

            print("\n--- RACE RESULTS ---")

            if results:
                for row in results:
                    print(
                        f"Position: {row[5]} | "
                        f"Horse: {row[3]} | "
                        f"Jockey: {row[4]} | "
                        f"Time: {row[6]}"
                    )
            else:
                print("No results found for this race.")

        elif choice == "3":

            horse_name = input("\nEnter Horse Name: ")

            cursor.execute("""
                SELECT
                    race_name,
                    race_date,
                    horse_name,
                    jockey_name,
                    finishing_position,
                    finishing_time
                FROM vw_race_results
                WHERE horse_name LIKE ?
                ORDER BY race_date DESC
            """, ('%' + horse_name + '%',))

            results = cursor.fetchall()

            print("\n--- HORSE RACE HISTORY ---")

            if results:
                for row in results:
                    print(
                        f"\nRace: {row[0]}"
                        f"\nDate: {row[1]}"
                        f"\nHorse: {row[2]}"
                        f"\nJockey: {row[3]}"
                        f"\nFinishing Position: {row[4]}"
                        f"\nFinishing Time: {row[5]}"
                    )
                    print("--------------------------------")

            else:
                print("No race history found for this horse.")

        elif choice == "4":
            break

        else:
            print("Invalid choice. Please try again.")

# This adds a horse observation for a specific horse in a race.
# Satisfies 3: Add Data
def add_horse_observation(conn):

    cursor = conn.cursor()

    print("\n--- Add Horse Observation ---")

    # get the race for which this observation is being recorded
    race_id = input("Enter race ID: ")

    if not validate_id(race_id):
        return

    # Which horse is this being recorded
    horse_id = input("Enter horse ID: ")

    demeanour = input("Enter demeanour: ")
    behavior = input("Enter behaviour: ")
    condition = input("Enter physical condition: ")
    notes = input("Additional notes: ")

    # Perform the insert and commit if successful
    try:
        cursor.execute("""
            INSERT INTO HorseObservation (
                race_id,
                horse_id,
                demeanour,
                behavior,
                physical_condition,
                additional_notes
            )
            VALUES (?, ?, ?, ?, ?, ?)
        """, (
            race_id,
            horse_id,
            demeanour,
            behavior,
            condition,
            notes
        ))

        conn.commit()

        print("Horse observation successfully added.")

    except sqlite3.Error as e:
        conn.rollback()
        print("Database error:", e)

    finally:
        cursor.close()

# Updates the race entry for a specific horse to either be entered, scratched, or withdrawn
# Satisfies 4: Update or Delete data 
def update_race_entry(conn):

    cursor = conn.cursor()

    print("\n--- Update Race Entry ---")

    # Get necessary row to which we are updating
    race_id = input("Enter race ID: ")

    if not validate_id(race_id):
        return

    horse_id = input("Enter horse ID: ")

    print("1. Entered")
    print("2. Scratched")
    print("3. Withdrawn")

    # Get the new status, putting them as numbers prevents any input of incorrect form
    choice = input("Select new status: ")

    statuses = {
        "1": "Entered",
        "2": "Scratched",
        "3": "Withdrawn"
    }

    if choice not in statuses:
        print("Invalid selection.")
        cursor.close()
        return

    status = statuses[choice]

    # Perform the update and ensure that it was successfully updated.
    try:
        cursor.execute("""
            UPDATE RaceEntry
            SET entry_status = ?
            WHERE race_id = ?
            AND horse_id = ?
        """, (status, race_id, horse_id))

        if cursor.rowcount > 0:
            conn.commit()
            print("Race entry successfully updated.")
        else:
            conn.rollback()
            print("Race entry not found.")

    except sqlite3.Error as e:
        conn.rollback()
        print("Database error:", e)

    finally:
        cursor.close()

# Main that stems to all other functions containing their exact purpose
def main():

    # Initialize database to pass to other functions
    conn = sqlite3.connect("Race_Base.db")

    conn.execute("PRAGMA foreign_keys = ON")

    # Simple while loop to go to different options
    while True:

        print("\n================================")
        print("     HORSE RACING DATABASE")
        print("================================")

        print("1. Search / Browse Data")
        print("2. View Race Information")
        print("3. Add Horse Observation")
        print("4. Manage Race Entries")
        print("5. View Reports")
        print("6. View Race Horse Observations")
        print("7. Exit")

        choice = input("\nEnter your choice: ")

        if choice == "1":
            browse_data(conn)
        elif choice == "2":
            view_race_entries(conn)
        elif choice == "3":
            add_horse_observation(conn)
        elif choice == "4":
            update_race_entry(conn)
        elif choice == "5":
            race_results_report(conn)
        elif choice == "6":
            view_race_observations(conn)
        elif choice == "7":
            print("Exiting Horse Racing Database...")
            break

        else:
            print("Invalid choice. Please try again.")

    conn.close()


if __name__ == "__main__":
    main()