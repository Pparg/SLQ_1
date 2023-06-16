#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOAL OPPONENT_GOAL
do
  #saltar la primera linea 
  if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
  then
    #checkeando que winer y opponent no esten en la base de datos
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    #entrando a la base de datos winner si no esta presente en la base de datos
    if [[ -z $WINNER_ID ]]
    then
      INSERT_TEAM_WINNER="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')" )"
      echo Inserted into teams winner, $WINNER
    fi
    #entrando a la base de datos opponent si no esta presente en la base de datos
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_TEAM_OPPONENT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      echo Inserted into teams opponent, $OPPONENT
    fi
    #recuperar el id de winner y el de opponent
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")" 
    #entrando el resto de datos a la base de datos
    INSERT_GAMES="$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND',$WINNER_ID, $OPPONENT_ID,$WINNER_GOAL,$OPPONENT_GOAL)")"
    echo Inserted into games
  fi
done
