s_score = raw_input('Please enter a score between 0.0 and 1.0: ')
try:
	score = float(s_score)
	if score >0.0 and score < 1.0:
		if score >= 0.9:
			message = 'A'
		elif score >=0.8:
			message = 'B'
		elif score >=0.7:
			message = 'C'
		elif score >=0.6:
			message = 'D'
		elif score < 0.6:
			message ='F'
	else:
		message = 'Out of range. Please enter value between 0.0 and 1.0'
except:
	message = 'Please enter a numeric value'

print message