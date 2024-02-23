#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
 then
   echo "Please provide an element as an argument."
  else
   if [[ $1 =~ [0-9] ]] 
    then
      ELEMENT_LOOKUP=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number='$1'")
    else
      ELEMENT_LOOKUP=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1' OR name='$1'")
   fi
   if [[ -z $ELEMENT_LOOKUP ]]
    then
      echo "I could not find that element in the database."
    else
      FORMATED_LOOKUP=$(echo "$ELEMENT_LOOKUP" | sed -r 's/\|/\n/g')
      echo $FORMATED_LOOKUP | while read TYPE_ID NUMBER SYMBOL NAME MASS MELTING BOILING TYPE
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
   fi
fi