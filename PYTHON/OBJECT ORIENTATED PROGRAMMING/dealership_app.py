
from dealership import Car
from dealership import Dealership

aungier = Dealership()
aungier.create_initial_stock()


while True:
    aungier.initial_stock_menu()
    aungier.rent_or_return_menu()
    proceed = raw_input("Are you sure you want to quit? y/n: ").lower()
    if proceed == 'y':
        break
    elif proceed == 'n':
        continue    
    else:
        print "\n"
        print "Error, please try again"
        continue





