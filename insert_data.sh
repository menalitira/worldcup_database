#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Read data from CSV file
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Skip header row
  if [[ $YEAR != "year" ]]
  then
    # Insert winner into teams table if not exists
    TEAM_EXISTS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    if [[ -z $TEAM_EXISTS ]]
    then
      INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams: $WINNER"
      fi
    fi

    # Insert opponent into teams table if not exists
    TEAM_EXISTS=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    if [[ -z $TEAM_EXISTS ]]
    then
      INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams: $OPPONENT"
      fi
    fi

   # get winner_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  # Insert game into games table
  INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_RESULT == "INSERT 0 1" ]]
  then
    echo "Inserted game: $YEAR, $ROUND, $WINNER vs $OPPONENT ($WINNER_GOALS-$OPPONENT_GOALS)"
  fi

  fi
done
 
