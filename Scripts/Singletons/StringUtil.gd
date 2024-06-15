extends Node

func IntToString(number: int) -> String:
	var numberString = str(number);
	if (numberString.length() == 1): 
		numberString = "0" + numberString;
	
	return numberString;
