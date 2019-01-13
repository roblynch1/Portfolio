## lucky door prize
while True:
    print 'Behind each door there is a prize'
    print 'Pick door 1, 2 or 3'
    print "Enter 'Q' to quit"
    choice = raw_input().lower()
    if choice == 'q':
        break
    if choice == '1':
        print ("Congratulations, you have won a holiday.")
    elif choice == '2':
        print ("Congratulations, you have won a car.")
    elif choice == '3':
        print ("Congratulations, you have won a hippo!")
    else:
        print ("You didn't make a valid choice.")
print ("Have a nice day.")
