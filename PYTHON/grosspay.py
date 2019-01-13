def computepay(h,r):
    if h>40:
        result = 40*r + ((h-40)*(r*1.5))
    else:
        result = h*r
    return result
    
def getnuminput(str):
    while True:
        str_input = raw_input(str)
        try:
            float_value = float(str_input) 
            break
        except:
            print 'Input must be numeric'
    return float_value
    
hours = getnuminput('Enter hours: ')
rate =  getnuminput('Enter rate: ')


pay = computepay(hours,rate)

print 'Grosspay is',pay
