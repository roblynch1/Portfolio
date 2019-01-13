def converttofahr(userinput):
	f = (userinput * 9.0) / 5.0 + 32.0
	return f

def converttocel(userinput):
	c = (userinput - 32.0) * 5.0 / 9.0
	return c

choice = raw_input("To convert to Celsius press C\nTo convert to Fahrenheit press F\n").lower()

while True:
	if choice == "c":
		try:
			s_fah = float(raw_input("Enter Fahrenheit temp to convert to Celsius:"))
			cel = converttocel(s_fah)
			print "{} Fahrenheit is {} in Celsius".format(s_fah,cel)
			break
		except:
			print "Enter a numeric character"
			continue

	elif choice == "f":
		try: 
			s_cel = float(raw_input("Enter Celsius temp to convert to Fahrenheit:"))
			fahr = converttofahr(s_cel)
			print "{} Celsius is {} in Fahrenheit".format(s_cel,fahr)
			break
		except:
			print "Enter a numeric character"
			continue
		
		
