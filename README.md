### Project Overview
- The system is meant to keep track of horse racing data and allow users to input their own observation on horses before they are about to race.
- The intended users are for horse racing fans and betters.
- The major functionality is the ability for users to input thier own observations for each horse prior to a match. This is extremely important information for any better.
### DMBS
- Everything is done locally through sqlite3
### Database Setup
First you need to create the Race_Base.db database. One is already provided, but if you want to create your own, simply run sqlite 3 in your command prompt and perform the .read operation on the schema.sql then insert_data.sql scripts provided. If you want to test the database, transaction.sql and queries.sql will use your current database for some test prompts. *IMPORTANT: make sure that the database is named Race_Base.db, the application will not work if it is not.
### Application Setup
The Application uses python.
Once the database file is established, simply run the main.py python file with your python executable (3.12 and up should work). The only libraries needed on your python environment are sqlite3.
### Major Application Operations
1. Search / Browse Data
- This will allow you to look at information pertaining to horse racing. This includes horses, jockeys, ranches, etc...
2. View Race Information
- This will allow you to look at specific details on specific races. This includes horses participating, track length, etc...
3. Add Horse Observation
- This allows users to input thier own observations on a specific horse before a race starts.
4. Manage Race Entries
- This allows users to manage whether a horse has been scratched off of a specific race.
5. View Reports
- This will allow users to look at a multitude of different reports of horses past races, record, etc...
6. View Race Horse Observations
- This will report every horse observation made by all users for a specific race.
### Known Limitations
The main limitation is that this is not split for user and admin. This means that every user of this system can change horse status and add as many horse observations as they want. 
The way races are currently handeled is not user friendly. Races are looked up per user ID instead of asking for a specific name or giving a list of recent events.
