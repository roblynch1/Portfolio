rm(list=ls())                     #Cleans the values in the Environment, ready for the next user input
options(warn=-1)                  #Used to surpress warning error message

#CALCULATION FUNCTIONS AS FOLLOWS: 
add <- function(x, y) {
  return(x + y)
}

subtract <- function(x, y) {
  return(x - y)
}

multiply <- function(x, y) {
  return(x * y)
}

divide <- function(x,y) {
  if(y == 0){
    return ("Error, can't divide by zero")        #ERROR HANDLING FOR DIVIDING BY ZERO
  } else {
    return(x/y)
  }
}

exponent <- function(x, y){
  return(x^y)
}

squareroot <-function(x) {
  if (x < 0) {
    print("Error, can't square root negative numbers")  #ERROR HANDLING FOR NEGATIVE NUMBERS
  } else {
    return(sqrt(x))
  }
}   

square <- function(x){
  return(x^2)
}

sine <- function(x) {
  return(sin(x*pi/180))
}

cosine <- function(x) {
  return(cos(x*pi/180))
}

tangent <- function(x) {
  if(x %% 180 ==0){                     #ERROR HANDLING FOR AN INPUT OF 180
    return (0)
  } else if(x%% 90 ==0){                #ERORR HANDLING FOR INPUTS DIVISIBLE BY 90
    return ("Undefined")
  } else {
    return (tan(x*pi/180))
  }
}

fact <- function(x) {
  if(x < 0) {
    print("Error, can't factor negative numbers")     #ERROR HANDLING FOR NEGATIVE NUMBERS
  } else if(x == 0) {
    print("The factorial of 0 is 1")                  #MESSAGE IF X = 0
  } else {
    factorial = 1
    for(i in 1:x) {
      factorial = factorial * i
    }
    print("######### ANSWER #########")
    print(paste(x,"! =",factorial))
  }
}

show_menu <- function() {                               #menu function
  print ("############################")
  print ("SCIENTIFIC CALCULATOR 2.0")
  print ("Press 1  for Addition")
  print ("Press 2  for Subtraction")
  print ("Press 3  for Multiplication")
  print ("Press 4  for Division")
  print ("Press 5  for the Exponent")
  print ("Press 6  for the Square Root")
  print ("Press 7  for the Square")
  print ("Press 8  for Sine")
  print ("Press 9  for Cosine")
  print ("Press 10 for Tangent")
  print ("Press 11 for Factorial")  
  print ("############################")
}

loop <- TRUE

while (loop) {                                  #CREATE LOOP FOR USER TO CONTINUE USING PROGRAM

show_menu()                                     #DISPLAYS THE MENU OPTIONS
  
choice = as.integer(readline(prompt="Enter choice[1/2/3/4/5/6/7/8/9/10/11]: "))         #TAKES USERS MENU CHOICE

num1 = as.numeric(readline(prompt="Enter first number: "))                              #TAKES USERS FIRST NUMBER

if (choice <=5) {                                                                       #FIRST 5 OPTIONS NEED 2 NUMBER INPUTS
  num2 = as.numeric(readline(prompt="Enter second number: "))
}

#TRIED TO HANDLE IF USER INPUTS NUMBER CHOICE OUT OF RANGE OR WHAT THEY ENTER IS NOT AN NUMBER - WON'T WORK FOR ME
# if ((!in_range(choice)) | (!is.integer(choice)))  {
# print("Error, please run the program again and enter a numbered choice from the menu")
# break
# }

#USE SWITCH TO HERE TO OUTPUT THE CORRECT OPERATOR AND RESULT FOR THE ANSWER
operator <- switch(choice,"+","-","*","/","to the power of", "Squareroot of","Square of","Sine of ","Cosine of","Tangent of","Factorial")
result <- switch(choice, add(num1, num2), subtract(num1, num2), multiply(num1, num2), divide(num1, num2),exponent(num1, num2), squareroot(num1), square(num1), sine(num1), cosine(num1), tangent(num1), fact(num1))

if (choice == 1 | choice == 2 | choice == 3 | choice == 4 | choice ==5) {               #IF STATEMENTS FOR OUTPUTTING THE CORRECT OPERATOR AND RESULTS
  print("######### ANSWER #########")
  print(paste(num1, operator, num2, "=", result))
} else if (choice ==6 | choice == 7 | choice == 8 | choice == 9 | choice == 10) {
  print("######### ANSWER #########")
  print(paste(operator, num1, "=", result))
} else if ((choice == 11)) {                                                            #FACTORIAL FUNCTION OUTPUTS ITS OWN PRINT STATEMENT
} else {
  #ERROR HANDLING - Tried various different options to improve the error handling like grepl and !as.numeric but couldn't get any of them to 100% work.
  print("Invlaid input")         
  
}
continue = readline(prompt="Do you wish to continue? Type 'y' or any key to quit: ")    #ASK USER DO THEY WANT TO CONTINUE AND IF NOT LOOP BECOMES FALSE AND PROGRAM BREAKS
if(continue != "y") {
  loop <- FALSE
  print("THANK YOU!")

}
}
options(warn=-0)