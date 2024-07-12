PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  INPUT=$1
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    O_AN=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number = $INPUT")
    O_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $INPUT")
    O_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $INPUT")
    O_TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number = $INPUT")
    O_AM=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $INPUT")
    O_MP=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number =$INPUT")
    O_BP=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $INPUT")
  else
   O_AN=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT' OR name = '$INPUT'")
   O_NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$INPUT' OR name = '$INPUT'")
   O_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$INPUT' OR name = '$INPUT'")
   O_TYPE=$($PSQL "SELECT type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$INPUT' OR name = '$INPUT'")
   O_AM=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol = '$INPUT' OR name = '$INPUT'")
   O_MP=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol = '$INPUT' OR name = '$INPUT'")
   O_BP=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol = '$INPUT' OR name = '$INPUT'")
  fi

  if [[ -z $O_AN ]]
  then
    echo "I could not find that element in the database."
  else
    echo -e "The element with atomic number $O_AN is $O_NAME ($O_SYMBOL). It's a $O_TYPE, with a mass of $O_AM amu. $O_NAME has a melting point of $O_MP celsius and a boiling point of $O_BP celsius."
  fi
fi