import random, math
random.seed()

secret = math.floor(random.random()*10)+1
guess = 0
attempts = 0
while secret != guess:
   attempts=attempts+1
   guess = input("Guess My Number between 1 and 10: ")
   if guess < secret: print("Higher!")
   if guess > secret: print("Lower!")
print("Correct! " + str(attempts) + " tries.")
