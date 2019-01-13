def computegrade() :
    s_score = raw_input('Please enter a score between 0.0 and 1.0: ')
    try:
        score = float(s_score)
        if score >0.0 and score < 1.0:
            if score >= 0.9:
                print 'A'
            elif score >=0.8:
                print 'B'
            elif score >=0.7:
                print 'C'
            elif score >=0.6:
                print 'D'
            elif score < 0.6:
                print 'F'
        else:
            print 'Out of range. Please enter value between 0.0 and 1.0'
    except:
        print 'Please enter a numeric value'
        
computegrade()