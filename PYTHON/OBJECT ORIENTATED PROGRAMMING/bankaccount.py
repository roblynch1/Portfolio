class Bank:
	'''Class for Bank Account'''
	
	def __init__(self, marque):
		self.marque_name = marque
		self.account_balance = 0.0
			
	def show_account_balance(self):
		print self.account_balance
		
	def add_account(self, amount):
		self.account_balance += amount
	
	def withdraw_account(self, amount):
		self.account_balance -= amount
	
	
account1 = Bank(raw_input('Please enter your name to open an account: '))
account1.add_account(20)
account1.show_account_balance()
s_choice = raw_input('Press L to lodge money to your account: \nPress W to withdraw money: ')

if s_choice == 'l':
	l_lodge = raw_input("Please enter the amount you'd like to lodge: ")
	lodge = float(l_lodge)
	account1.add_account(lodge)
		
elif s_choice == 'w':
	w_lodge = raw_input("Please enter the amount you'd like to withdraw:\n")
	lodge = float(w_lodge)
	account1.withdraw_account(lodge)
		
print account1.marque_name
account1.show_account_balance()