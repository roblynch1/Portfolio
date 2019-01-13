import unittest

from calculator import Calculator

#creation of class TestCalculator to test the calculator functionality
class TestCalculator(unittest.TestCase):

    def setUp(self):
        self.calc = Calculator()

	# the following tests each calculator operation

    def test_add(self):
        result = self.calc.add(2.2, 2.2)
        self.assertEqual(4.4, result)
        result = self.calc.add(2,4)
        self.assertEqual(6, result)
        result = self.calc.add(2, -2)
        self.assertEqual(0, result)

    def test_subtract(self):
        result = self.calc.subtract(2.5, 2.5)
        self.assertEqual(0, result)
        result = self.calc.subtract(2,4)
        self.assertEqual(-2, result)
        result = self.calc.subtract(2, -4)
        self.assertEqual(6, result)

    def test_multiply(self):
        result = self.calc.multiply(2.2, 2.2)
        self.assertAlmostEqual(4.84, result)
        result = self.calc.multiply(8.35,9.66)
        self.assertEqual(80.661, result)
        result = self.calc.multiply(41.555, -10)
        self.assertEqual(-415.55, result)
        result = self.calc.multiply(12, -56)
        self.assertEqual(-672, result)
        
    def test_divide(self):
        result = self.calc.divide(8, 2)
        self.assertEqual(4, result)
        result = self.calc.divide(7,3)
        self.assertEqual(2.3333333, result)
        result = self.calc.divide(25, -2)
        self.assertEqual(-12.5, result)
        result = self.calc.divide(6.6, 2.356)
        self.assertAlmostEqual(2.8013582, result)
        result = self.calc.divide(8.6, 3)
        self.assertAlmostEqual(2.8666667, result)         

    def test_exponent(self):
        result = self.calc.exponent(8, 2)
        self.assertEqual(64, result)
        result = self.calc.exponent(7,3)
        self.assertEqual(343, result)
        result = self.calc.exponent(4, -2)
        self.assertEqual(0.0625, result)

    def test_square_root(self):
        result = self.calc.square_root(16)
        self.assertEqual(4, result)
        result = self.calc.square_root(-3)
        self.assertEqual("Error, can't square root negative numbers", result)
        result = self.calc.square_root(51)
        self.assertAlmostEqual(7.141428429, result)
        result = self.calc.square_root(5.5)
        self.assertAlmostEqual(2.34520788, result)
        
    def test_square(self):
        result = self.calc.square(11)
        self.assertEqual(121, result)
        result = self.calc.square(4.6)
        self.assertAlmostEqual(21.16, result)
        result = self.calc.square(-6)
        self.assertEqual(36, result)
        result = self.calc.square(0)
        self.assertEqual(0, result)

    def test_factorial(self):
        result = self.calc.factorial(13)
        self.assertEqual(6227020800, result)
        result = self.calc.factorial(4.6)
        self.assertAlmostEqual(61.5539150063, result)
        result = self.calc.factorial(-6)
        self.assertEqual("Error, can't factor negative numbers", result)
        result = self.calc.factorial(0)
        self.assertEqual(1, result)  

    def test_sine(self):
        result = self.calc.sine(9)
        self.assertEqual(0.1564345, result)
        result = self.calc.sine(540)
        self.assertEqual(0, result)
        result = self.calc.sine(90)
        self.assertEqual(1, result)
        result = self.calc.sine(270)
        self.assertEqual(-1, result)        
        result = self.calc.sine(-6)
        self.assertEqual(-0.1045285, result)
        result = self.calc.sine(5.5)
        self.assertEqual(0.0958458, result)        
        result = self.calc.sine(360)
        self.assertEqual(0, result)         

    def test_cosine(self):
        result = self.calc.cosine(45)
        self.assertEqual(0.7071068, result)
        result = self.calc.cosine(90)
        self.assertEqual(0, result)
        result = self.calc.cosine(180)
        self.assertEqual(-1, result)
        result = self.calc.cosine(270)
        self.assertEqual(0, result)
        result = self.calc.cosine(540)             
        self.assertEqual(-1, result)
        result = self.calc.cosine(360)             
        self.assertEqual(1, result)
        result = self.calc.cosine(-4.5)             
        self.assertEqual(0.9969173, result)        
        
    def test_tangent(self):
        result = self.calc.tangent(90)
        self.assertEqual("Undefined", result)
        result = self.calc.tangent(180)
        self.assertEqual(0, result)
        result = self.calc.tangent(270)
        self.assertEqual("Undefined", result)
        result = self.calc.tangent(360)
        self.assertEqual(0, result)
        result = self.calc.tangent(-60.6)
        self.assertEqual(-1.7747141, result)         

if __name__ == '__main__':
    unittest.main()
