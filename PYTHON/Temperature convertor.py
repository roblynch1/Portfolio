print "If you wish to convert from Celcius enter 'C'"
print "If you wish to convert from Fahrenheit enter 'F'"

choice = raw_input().lower()

if choice == 'c': 
    str_inp = raw_input('Enter Celsius Temperature:')
    try:
        cel = float(str_inp)
        fahr = ( cel * 9.0 ) / 5.0 + 32.0
        print cel, 'degrees celcius is ', fahr, 'degrees Fahrenheit'
    except:
        print 'You must input numeric values for Celcius'
elif choice == 'f':
    str_inp = raw_input('Enter Fahrenheit Temperature:')
    try:
        fahr = float(str_inp)
        cel = (fahr - 32.0) * 5.0 / 9.0
        print fahr, 'degrees Fahrenheit is ', cel, 'degrees Celcius'
    except: 
        print 'You must input numeric values for Fahrenheit'
else:
    print "This program requires you to enter 'C' or 'F'"
print 'finished'
