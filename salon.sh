#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~ MY SALON ~~~~\n"

#SHOW SERVICES
 SERVICE() {
SHOW_SERVICES=$($PSQL "SELECT * FROM services ")
echo "$SHOW_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do
  echo "$SERVICE_ID) $SERVICE_NAME"
done

echo -e "\nSelect the service that you want:"
read SERVICE_ID_SELECTED
#IF DOESNT EXIST > SERVICES AGAIN
ID_SELECTED_TRUE=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $ID_SELECTED_TRUE ]]
then
  SERVICE
else
  #ELSE SELECT SERVICE ID(SERVICE_ID_SELECTED 
  #ADD PHONE NUMBER (CUSTOMER_PHONE)
  echo -e "\nEnter your number:"
  read CUSTOMER_PHONE
  
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE' ")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\n What is your name"
    read CUSTOMER_NAME
    #IF DOESNT HAVE NUMBER> ADD NAME(CUSTOMER_NAME) ADD NAME AND PHONE TO customers TABLE 
    ADING_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  
  fi
  SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\n At what time do you want your $SELECTED_SERVICE"
  read SERVICE_TIME
  
  GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' ")
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($GET_CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

#ADD TIME(SERVICE_TIME)
#CREATE ROW IN APPOINTMENTS WITH CUSTOMER_NAME SERVICE_ID_SELECTED CUSTOMER_PHONE SERVICE_TIME
echo "I have put you down for a$SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
fi
exit
 }
 SERVICE
