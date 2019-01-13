from __future__ import division         #imports division functionality from python version 3

import math

#creation of class Calculator
class Calculator(object):
 
    def add(self, x, y):                                                #creation of calculator operation functions
        number_types = (int, long, float, complex)
 
        if isinstance(x, number_types) and isinstance(y, number_types):
            return x + y
        else:
            raise ValueError

    def subtract(self, x, y):
        number_types = (int, long, float, complex)
 
        if isinstance(x, number_types) and isinstance(y, number_types):
            return x - y
        else:
            raise ValueError

    def multiply(self, x, y):
        number_types = (int, long, float, complex)
 
        if isinstance(x, number_types) and isinstance(y, number_types):
            return x * y
        else:
            raise ValueError            

    def divide(self, x, y):
        number_types = (int, long, float, complex)
 
        if isinstance(x, number_types) and isinstance(y, number_types):
            try:
                if y == 0:
                    return "Error, can't divide by zero"                #return error as can't divide by zero
                else:
                    over = x / y
                    return round(over, 7)
            except:
                raise ValueError
        else:
            raise ValueError            

    def exponent(self, x, y): 
        number_types = (int, long, float, complex)
 
        if isinstance(x, number_types) and isinstance(y, number_types):
            return x ** y
        else:
            raise ValueError    

    def square_root(self, x):
        number_types = (int, long, float, complex)
 
        if isinstance(x, number_types):
            try:
                if x < 0:
                    return "Error, can't square root negative numbers"       #return error if user enters negative number
                else:
                    root = math.sqrt(x)
                    return root
            except:
                raise ValueError
        else:
            raise ValueError                
            
    def square(self, x):
        number_types = (int, long, float, complex)
 
        if isinstance(x, number_types):
            return x ** 2
        else:
            raise ValueError

    def factorial(self, x):
        number_types = (int, long, float, complex)
 
        if isinstance(x, number_types):
            try:
                if x == 0:                                            #if x is zero or x is negative
                    return 1
                if x < 0:
                    return "Error, can't factor negative numbers"
                else:
                    return math.gamma(x + 1)
            except:
                raise ValueError
        else:
            raise ValueError                
            
    def sine(self, x):
        number_types = (int, long, float, complex)
 
        if isinstance(x, number_types):
            return round(math.sin(math.radians(x)), 7)                 #round answer to 7 decimel places
        else:
            raise ValueError                           
            
    def cosine(self, x):
        number_types = (int, long, float, complex)
 
        if isinstance(x, number_types):
            return round(math.cos(math.radians(x)), 7)
        else:
            raise ValueError                    

    def tangent(self, x):
        number_types = (int, long, float, complex)
 
        if isinstance(x, number_types):
            try:
                if x % 180 == 0:
                    tancalc = 0.0
                    return tancalc
                elif x % 90 == 0:
                    tancalc = "Undefined"
                    return tancalc
                else:
                    tancalc = round(math.tan(math.radians(x)), 7)
                    return tancalc
            except:
                raise ValueError
        else:
            raise ValueError