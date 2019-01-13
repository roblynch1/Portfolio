from calculator import Calculator


calc = Calculator()

def show_menu():                                #menu function
    print "\n"
    print "############################"
    print "SCIENTIFIC CALCULATOR 1.0"
    print "Press 1  for Addition"
    print "Press 2  for Subtraction"
    print "Press 3  for Multiplication"
    print "Press 4  for Division"
    print "Press 5  for the Exponent"
    print "Press 6  for the Square Root"
    print "Press 7  for the Square"
    print "Press 8  for Factorial"
    print "Press 9  for Sine"
    print "Press 10 for Cosine"
    print "Press 11 for Tangent"
    print "Q to quit"
    print "############################\n"
    
while True:
    show_menu()
    s_input = raw_input("Input menu choice: ").lower()
    if s_input == "q":              #if user wants to quit, this breaks the loop to print 'thank you' and end the program
        break
        
    try:
        choice = int(s_input)       #convert the choice to an integer
    except:
        print 'Invalid input'       #if user doesn't enter an integer, they return to main menu again
        raw_input("Press 'Enter' to return to the main menu") 
        continue        
        
    if choice < 1 or choice > 11:    #if the number they enter is outside of 1 through to 11 they return to main menu
        print "Invalid input"
        raw_input("Press 'Enter' to return to the main menu") 
        continue       
    
    if choice == 1:                             #graphics printed after selection from menu to indicate the function they've chosen
        print "######### ADDITION #########\n"
    if choice == 2:
        print "####### SUBTRACTION ########\n"
    if choice == 3:
        print "###### MULTIPLICATION ######\n"
    if choice == 4:
        print "######### DIVISION #########\n"
    if choice == 5:
        print "######### EXPONENT #########\n"
    if choice == 6:
        print "####### SQUARE ROOT ########\n"
    if choice == 7:
        print "########## SQUARE ##########\n"
    if choice == 8:
        print "######## FACTORIAL #########\n"
    if choice == 9:
        print "########### SINE ###########\n"
    if choice == 10:
        print "########## COSINE ##########\n"
    if choice == 11:
        print "########## TANGENT #########\n"        
    
    if choice >= 1 and choice <= 5:                             #loop to take in 2 numbers for the first 5 operations
        while True:                                             #loop to ensure user enters a correct numeric figure
            try:
                s_input1 = raw_input("Enter first number: ")
                firstnum = float(s_input1)
                s_input2 = raw_input("Enter second number: ")
                secondnum = float(s_input2)                
                break                                           #breaks out of loop and moves to calculation section
            except:
                print 'Invalid input'
                raw_input("Press 'Enter' to try again: ")
                continue                                        
                
        if choice == 1:                                                 #import calculator operations here and print answer to screen
            result = calc.add(firstnum, secondnum)
            message = "Answer: {} + {} =".format(s_input1, s_input2) 
        elif choice == 2:
            result = calc.subtract(firstnum, secondnum)
            message = "Answer: {} - {} =".format(s_input1, s_input2)
        elif choice == 3:
            result = calc.multiply(firstnum, secondnum)
            message = "Answer: {} * {} =".format(s_input1, s_input2)
        elif choice == 4:
            result = calc.divide(firstnum, secondnum)
            message = "Answer: {} / {} =".format(s_input1, s_input2)
        elif choice == 5:
            result = calc.exponent(firstnum, secondnum)
            message = "Answer: {} to the power of {} =".format(s_input1, s_input2)            
        else:
            message = "Sorry, we didn't understand your choice"
                
        print message, result                 

        if 'q' == raw_input("Q to quit / Enter to continue: ").lower():         #Choice to quit program or return to menu after calculation
            break

    if choice >= 6 and choice <= 11:
        while True:                                                 #loop to take in 1 number for the last 6 operations
            try:
                s_input = raw_input("Enter number: ")
                floatnum = float(s_input)
                break                  
            except:
                print 'Invalid input'
                raw_input("Press 'Enter' to try again: ")
                continue                
                
        if choice == 6:                                                 #import calculator operations here and print answer to screen
            result = calc.square_root(floatnum)
            message = "Answer: Square root of {} = ".format(s_input)
        elif choice == 7:
            result = calc.square(floatnum)
            message = "Answer: {} squared = ".format(s_input)
        elif choice == 8:
            result = calc.factorial(floatnum)
            message = "Answer: Factorial {} = ".format(s_input)
        elif choice == 9:
            result = calc.sine(floatnum)
            message = "Answer: The sine of {} = ".format(s_input)
        elif choice == 10:
            result = calc.cosine(floatnum)
            message = "Answer: The cosine of {} = ".format(s_input)       
        elif choice == 11:
            result = calc.tangent(floatnum)
            message = "Answer: The tangent of {} = ".format(s_input)            
        else:
            message = "Sorry, we didn't understand your choice"
                
        print message, result                  

        if 'q' == raw_input("Q to quit / Enter to continue: ").lower():
            break

    
print "Thank you"        