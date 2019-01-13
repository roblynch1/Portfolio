for input in range(1,51):
	if (input %5) == 0 and (input %3) == 0:
		print 'fizzbuzz'
	elif input %3 == 0:
		print 'Fizz'
	elif input %5 == 0:
		print 'Buzz'
	else:
		print input