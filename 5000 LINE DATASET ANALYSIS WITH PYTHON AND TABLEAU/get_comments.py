import csv
# open the file - and read all of the lines.
changes_file = 'changes_python.log'

# use strip to strip out spaces and trim the line.
data = [line.strip() for line in open(changes_file, 'r')]

#print the number of lines read
#print(len(data))

sep = 72*'-'

# create the commit class to hold each of the elements

class Commit:
    'class for commits'
   
    def __init__(self, revision = None, author = None, date = None, comment_line_count = None, changes = None, comment = None): #here we creat an object with basically empty variables, '=None' 
        self.revision = revision
        self.author = author
        self.date = date
        self.comment_line_count = comment_line_count
        self.changes = changes
        self.comment = comment
  
    def get_comment(self):
        return self.comment
    
commits = []
current_commit = None
index = 0

author = {}
while True:
    try:
        # parse each of the commits and put them into a list of commits
        current_commit = Commit()
        details = data[index + 1].split('|')						#[index+1] represents the 1st line of the file
        current_commit.revision = int(details[0].strip().strip('r'))	#.strip takes out empty spaces before and after the | symbol in the file
        current_commit.author = details[1].strip()						
        current_commit.date = details[2].strip()
        current_commit.comment_line_count = int(details[3].strip().split(' ')[0])	#strip to remove all spaces - then changes to int 
        current_commit.changes = data[index+2:data.index('',index+1)]
        #print(current_commit.changes)
        index = data.index(sep, index + 1)	#its looking for 72 '-' in the file (ie the 72 seperators), look for line 1 and get me the next line with 72  -'s						
        current_commit.comment = data[index-current_commit.comment_line_count:index]
        commits.append(current_commit)
    except IndexError:
        break

#print(len(commits))

commits.reverse() #to reverse the order by date

output = open ("comments_output.csv", 'w')       #OUTPUTS COMMENTS TO CSV
index = 0
for index, commit in enumerate(commits):
    output.write(str(commit.get_comment()))
    output.write(';')
    output.write('\n')    
    index = index + 1
output.close()