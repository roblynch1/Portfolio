#Establish Car class
class Car(object):
    # implement the car object.
     def __init__(self):
        self.__make = ''
        
class PetrolCar(Car):               #establish each Car class
    def __init__(self):
        Car.__init__(self)

class DieselCar(Car):
    def __init__(self):
        Car.__init__(self)
      
class ElectricCar(Car):
    def __init__(self):
        Car.__init__(self)

class HybridCar(Car):
    def __init__(self):
        Car.__init__(self)

#Dealership class        
class Dealership(object):

    def __init__(self):                 #creation of each car list
        self.petrol_cars = []
        self.diesel_cars = []
        self.electric_cars = []        
        self.hybrid_cars = []

    def create_initial_stock(self):             #add inital stock to each car list
        for i in range(20):
           self.petrol_cars.append(PetrolCar())
        for i in range(8):
            self.diesel_cars.append(DieselCar())
        for i in range(4):
            self.electric_cars.append(ElectricCar())
        for i in range(8):
            self.hybrid_cars.append(HybridCar())

    def initial_stock_menu(self):               #display the inital stock for each car
        print "\n"    
        print "########### AUNGIER CAR RENTAL ############"
        print "### WE HAVE THE FOLLOWING CARS IN STOCK ###"
        print 'Petrol cars in stock ' + str(len(self.petrol_cars))
        print 'Diesel cars in stock ' + str(len(self.diesel_cars))
        print 'Electric cars in stock ' + str(len(self.electric_cars))
        print 'Hybrid cars in stock ' + str(len(self.hybrid_cars))
        print "###########################################\n"
        
    def current_stock(self):                    #display the current/up to date stock of cars
        print "\n"
        print "########### AUNGIER CAR RENTAL ############"
        print "### WE HAVE THE FOLLOWING CARS IN STOCK ###"
        print 'Petrol cars in stock {}'.format(self.petrol_current_stock())
        print 'Diesel cars in stock {}'.format(self.diesel_current_stock())
        print 'Electric cars in stock {}'.format(self.electric_current_stock())
        print 'Hybrid cars in stock {}'.format(self.hybrid_current_stock())
        print "###########################################\n"    
        
    def total_stock(self):                      #used to track the total amount of cars currently in stock
        total_stock = (len(self.petrol_cars)) + (len(self.electric_cars)) + (len(self.hybrid_cars)) + len(self.diesel_cars)
        return total_stock

    def petrol_current_stock(self):             #keep track of current stock of petrol cars
        petrol_current_stock  = (len(self.petrol_cars))
        return petrol_current_stock
        
    def diesel_current_stock(self): 
        diesel_current_stock = (len(self.diesel_cars))
        return diesel_current_stock
        
    def electric_current_stock(self):
        electric_current_stock = (len(self.electric_cars))
        return electric_current_stock       
        
    def hybrid_current_stock(self):
        hybrid_current_stock = (len(self.hybrid_cars))
        return hybrid_current_stock
    
    
    def rent_car(self, car_list, amount):           
        if len(car_list) < amount:                  #ensures user can't rent more than whats in stock
            print 'Sorry, there are not enough cars in stock, please make another selection '
            return
        total = 0
        while total < amount:
           car_list.pop()                           #while the total in stock is < amount requested you can rent a car
           total = total + 1

    def return_car(self, car_list, car_type, amount): 
        for i in range(amount):                     #returns the amount of cars to the chosen car pool
           car_list.append(car_type)    

           
    def rent_or_return_menu(self):                  #inital rent or return menu, quit option and invalid input handle
        while True:
            print 'What would you like to do?'
            print 'To rent a car type rent'
            print 'To return a car type return'
            print 'Press q to quit\n'
            choice = raw_input().lower()
            if choice == 'q':
                print "Thank you for your custom, come again soon!"
                break                                 
            elif choice == 'rent':
                self.rent_decision()                #proceed to rent decision if rent option is chosen
            elif choice == 'return':
                self.return_decision()              #process to return decision if return option is chosen     
            else:
                print "You didn't enter a valid option, please try again\n"


          
    def rent_menu(self):                            #rent menu options
         print '\n'
         print 'What type of car would you like to rent?'
         print "For Petrol press p"
         print "For Diesel press d"
         print "For Electric press e"
         print "For Hyrbid press h"
         print "Q to quit\n"      
         
    def menu_car_choice(self, menu_choice):         #generic handle for the car type chosen, handles invalid inputs also
        while True:
            if menu_choice == 'p' or 'd' or 'e' or 'h':
                choice = raw_input(menu_choice)
                return choice
                break
            else:
                print "You didn't enter one of the options, please try again\n"
 
 
    def menu_number_choice(self, number_choice):    #generic handle for the number of cars entered by user, handles invalid inputs
        while True:
            try:
                str = raw_input(number_choice)
                num_choice = int(str)
            except:
                print "Please enter a number, please try again\n"
            else:
                if num_choice >= 1:
                    return num_choice
                    break
                else:
                    print "Please enter 1 or more cars, please try again\n"
                    
    
    def rent_decision(self):                        
        while True:
            if self.total_stock() == 0:             #ensures user can't rent anymore if there's 0 cars left in chosen car pool
                print 'Sorry but there are no more cars to rent at this time, some cars should be returning soon\n'
                break
            else:
                self.current_stock()                
                self.rent_menu()
                car_type = self.menu_car_choice("Please choose an option: ").lower()
                if car_type == 'q':                 #quit option to return to main menu
                    print "RETURNING TO MAIN MENU\n"
                    self.current_stock()
                    break
                else:                               #else proceed with renting, input amount of car to rent, then show the current stock of cars
                    quantity = self.menu_number_choice("How many would you like?\n")
                    self.rent_process(car_type,quantity)
                    self.current_stock()
                    break
                     

                 
    def rent_process(self, car_type, quantity):     #takes car type user wants and the quantity to rent, handles invalid inputs
        if car_type == 'p':
            self.rent_car(self.petrol_cars, quantity)     
        elif car_type == 'd':
            self.rent_car(self.diesel_cars, quantity)   
        elif car_type == 'e':
            self.rent_car(self.electric_cars, quantity)   
        elif car_type == 'h':
            self.rent_car(self.hybrid_cars, quantity)   
        else:
            print "Your input was invalid, please try again"                


    def return_menu(self):                          #return menu options
         print '\n'
         print 'What type of car would you like to return?'
         print "For Petrol press p"
         print "For Diesel press d"
         print "For Electric press e"
         print "For Hyrbid press h"
         print "Q to quit\n"      
         
   
    def return_decision(self):                      
        while True:
            if self.total_stock() == 40:            #check if all cars are in stock, therefore no more cars can be returned
                print 'Sorry but we have all our cars back in stock, are you sure you rented from us?\n'
                break
            else:
                self.current_stock()                #show the current cars available, present the return menu options
                self.return_menu()
                car_choice = self.menu_car_choice("Please choose an option: ").lower()      
                if car_choice == 'q':
                    print "RETURNING TO MAIN MENU\n"
                    break
                else:                               #else proceed with return, input amount of car to return, then show the current stock of cars
                    quantity = self.menu_number_choice("How many would you like?\n")
                    self.return_process(car_choice,quantity)
                    self.current_stock()                    
                    break
                     
                 
    def return_process(self, car_choice, quantity): #use of dictionaries to store max allowed in each car type, link car type to stock levels and car type also.
        maxcarstock = {"p":20, "e":4, "h":8, "d":8}
        stockcartype = {"p":self.petrol_current_stock(),"d":self.diesel_current_stock(),"e":self.electric_current_stock(),"h":self.hybrid_current_stock()}
	cartype = {"p":PetrolCar(), "e":ElectricCar(), "h":HybridCar(), "d":DieselCar()}
        carlistdict = {"p":self.petrol_cars, "e":self.electric_cars,"h":self.hybrid_cars,"d":self.diesel_cars} 
        try:
            if quantity > maxcarstock[car_choice] - stockcartype[car_choice]:           #ensures user can't return higher amount than max pool amount
                print "Sorry but that is too many cars to return, please try again\n"
            else:
                self.return_car(carlistdict[car_choice],cartype[car_choice],quantity)       
        except:
            print "Your input was invalid, please try again"                            #error handle
