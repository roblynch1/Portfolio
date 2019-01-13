import unittest


from dealership import Car, PetrolCar, DieselCar, ElectricCar, HybridCar, Dealership

#test class for the dealership
class TestCar(unittest.TestCase):

    def setUp(self):
        self.aungier = Dealership()
        
    def test_create_initial_stock(self):                #test the setup of the initial stock for each car type
        aungier = Dealership()
        self.assertEqual([],aungier.petrol_cars)
        for i in range(20):                             #load petrol with 20 cars
           aungier.petrol_cars.append(PetrolCar())
        self.assertEqual(20,len(aungier.petrol_cars))
        
        self.assertEqual([],aungier.diesel_cars)
        for i in range(8):                              #load diesel with 8 cars
           aungier.diesel_cars.append(DieselCar())
        self.assertEqual(8,len(aungier.diesel_cars))
           
        self.assertEqual([],aungier.electric_cars)
        for i in range(4):
           aungier.electric_cars.append(ElectricCar())       
        self.assertEqual(4,len(aungier.electric_cars))
        
        self.assertEqual([],aungier.hybrid_cars)  
        for i in range(8):
           aungier.hybrid_cars.append(HybridCar())        
        self.assertEqual(8,len(aungier.hybrid_cars))        
        
    def test_rent_petrol_car(self):                     #test each car pool reduces by amount rented
        aungier = Dealership()
        self.assertEqual([],aungier.petrol_cars)
        for i in range(20):                             #load petrol with 20 cars
           aungier.petrol_cars.append(PetrolCar())
        aungier.rent_car(aungier.petrol_cars,5)         #rent 5 cars
        self.assertEqual(15,len(aungier.petrol_cars))   #15 cars are left in the petrol car pool
        
    def test_rent_diesel_car(self):
        aungier = Dealership()
        self.assertEqual([],aungier.diesel_cars)
        for i in range(8):
           aungier.diesel_cars.append(DieselCar())
        aungier.rent_car(aungier.diesel_cars,2)
        self.assertEqual(6,len(aungier.diesel_cars))         
        
    def test_rent_electric_car(self):
        aungier = Dealership()
        self.assertEqual([],aungier.electric_cars)
        for i in range(4):
           aungier.electric_cars.append(ElectricCar())
        aungier.rent_car(aungier.electric_cars,2)
        self.assertEqual(2,len(aungier.electric_cars))        
        
    def test_rent_hybrid_car(self):
        aungier = Dealership()
        self.assertEqual([],aungier.hybrid_cars)
        for i in range(8):
           aungier.hybrid_cars.append(HybridCar())
        aungier.rent_car(aungier.hybrid_cars,3)
        self.assertEqual(5,len(aungier.hybrid_cars))         
        
    def test_return_of_petrol_cars(self):               ##test each car pool increases by amount returned
        aungier = Dealership()
        self.assertEqual([],aungier.petrol_cars)
        for i in range(10):                             #load petrol with 10 cars
           aungier.petrol_cars.append(PetrolCar())
        aungier.return_car(aungier.petrol_cars,"p",10)  #return 10 cars
        self.assertEqual(20,len(aungier.petrol_cars))   #20 cars are left in the pool

    def test_return_of_diesel_cars(self):
        aungier = Dealership()
        self.assertEqual([],aungier.diesel_cars)
        for i in range(5):
           aungier.diesel_cars.append(DieselCar())
        aungier.return_car(aungier.diesel_cars,"d",3)
        self.assertEqual(8,len(aungier.diesel_cars))  

    def test_return_of_electric_cars(self):
        aungier = Dealership()
        self.assertEqual([],aungier.electric_cars)
        for i in range(1):
           aungier.electric_cars.append(ElectricCar())
        aungier.return_car(aungier.electric_cars,"e",3)
        self.assertEqual(4,len(aungier.electric_cars))  

    def test_return_of_hybrid_cars(self):
        aungier = Dealership()
        self.assertEqual([],aungier.hybrid_cars)
        for i in range(1):
           aungier.hybrid_cars.append(HybridCar())
        aungier.return_car(aungier.hybrid_cars,"h",3)
        self.assertEqual(4,len(aungier.hybrid_cars))     


if __name__ == '__main__':
    unittest.main()
