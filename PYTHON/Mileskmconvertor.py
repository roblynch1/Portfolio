print "#####################################"
print "This program calculates conversion from miles per hour"
print "You can choose between different conversions"
print "To convert Mile per hours to: " 
print "Select 1 to convert mph to kilometers per hour"
print "Select 2 to convert mph to meters per second"
print "Select 3 to convert mph to feet per second"
print "#####################################"

while True:
    strMph = raw_input("Enter how many mph you wish to convert >")
    mph = float(strMph)
    choice = raw_input("Input menu choice and hit return >")
    
    if choice =="1":
        kph = mph * 1.60934
        print "A speed of ", mph ,"mph converts to ", kph ,"kph."
    elif choice =="2":
        mps = mph * 0.44704
        print "A speed of ", mph ,"mph converts to ", mps ,"meters per second."
    elif choice =="3":
        fps = mph * 1.4667
        print "A speed of ", mph ,"mph converts to ", fps ,"feet per second."
    elif choice == "Q":
        break
    else:
        print "Invalid selection"
print "Thank you"   
