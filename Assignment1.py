import datetime

# Exercise 1: Working with Date & Times
print("Exercise 1-------------------------------------------------")
# getting current date and time
now = datetime.datetime.now()
print("current time: " + str(now))

# formatting date as YYYY-MM-DD
print("formatted time: " + str(now.strftime('%Y-%m-%d')))

# calculating number of days until next birthday
birthday = datetime.datetime.strptime("2024-10-18", '%Y-%m-%d')
time_til_bday = birthday - now

print("Days until birthday: " + str(time_til_bday.days))

# Exercise 2: Dictionaries and Sets
print("Exercise 2-------------------------------------------------")

grades_dict = {
    "George" : [85,75,82,91],
    "Jerry" : [92,89,93,87],
    "Katherine" : [96,88,94,95]
}
print(grades_dict)

# adding fourth student
grades_dict["Kyle"] = [93,94,97,95]
print("after adding Kyle: " + str(grades_dict))

# changing value of each student to another dictionary of their classes
for k,v in grades_dict.items():
    grades_list = v
    grades_dict[k] = {
        "Math" : grades_list[0],
        "History" : grades_list[1],
        "Science" : grades_list[2],
        "English" : grades_list[3]
    }
print(grades_dict)

# Exercise 3: Advanced String Operations
print("Exercise 3-------------------------------------------------")

ex_str = "I Like Pizza"

# splitting string into a list of words
str_list = ex_str.split()
print(str_list)

# joining list of words into a single string with pipes seperating
full_str = '|'.join(str_list)
print(full_str)

# counting occurences of a character in a string (case_sensitive)
char_occurences = {}
for char in ex_str:
    if char in char_occurences:
        char_occurences[char] = char_occurences[char] + 1
    else:
        char_occurences[char] = 1

print(char_occurences)

# Exercise 4: Lists and Basic Operations
print("Exercise 4-------------------------------------------------")

int_list = [1,5,26,2743,35,3543]
print(int_list)
int_list.append(25)
print(int_list)
int_list.remove(26)
print(int_list)
int_list.sort()
print(int_list)