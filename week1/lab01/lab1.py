import sys
import math

students = list()
# Indices:
# 0 -> Student Last name
# 1 -> Student First name
# 2 -> Grade
# 3 -> Classroom
# 4 -> Bus
# 5 -> GPA
# 6 -> Teacher's last name
# 7 -> Teacher First name

# get content from file
def get_content():
    with open('./students.txt', 'r') as f:
        content = f.readlines()
        global students 
        students = [c.strip() for c in content] # get rid of '\n'
        students = [s.split(',') for s in students]

# search by student's last name
def search_student_last_name(args: list):
    # only last name was specified, no bus route
    if len(args) == 1:
        last_name = args[0]
        for student in students: 
            if student[0] == last_name:
                print({
                    'last_name': student[0],
                    'first_name': student[1],
                    'grade': student[2],
                    'class_room': student[3],
                    'teacher': f'{student[7]} {student[6]}'
                })
    elif len(args) == 2:
        search_student_last_name_and_bus(args)

# search by student's name and bus
def search_student_last_name_and_bus(args:list):
    last_name = args[0]
    bus_route = args[1]
    for student in students:
        if student[0] == last_name and student[4] == bus_route:
            print({
                'last_name': student[0],
                'first_name': student[1],
                'bus': student[4]
            })


# search by teacher's last name
def search_teacher_last_name(args: list):
    last_name = args[0]
    for student in students:
        if student[6] == last_name:
            print({
                'last_name': student[0],
                'first_name': student[1]
            })

# search by grade
def search_bus(args: list):
    bus_route = args[0]
    for student in students:
        if student[4] == bus_route:
            print({
                'last_name': student[0],
                'first_name': student[1],
                'grade': student[2],
                'class_room': student[3],
            })

# search by grade
def search_grade(args: list):
    grade = args[0]
    if len(args) == 1:
        # high & low not specified
        for student in students:
            if student[2] == grade:
                print({
                    'last_name': student[0],
                    'first_name': student[1]
                })
    elif len(args) == 2:
        # high and low specified
        max_score = - math.inf
        max_score_student = None
        min_score = math.inf
        min_score_student = None
        # get highest / lowerst score
        for student in students:
            if student[2] == grade:
                if student[5] > max_score:
                    max_score = student[5]
                    max_score_student = student
                elif student[5] < min_score:
                    min_score = student[5]
                    min_score_student = student
        
        if args[1] == 'H':
            # print student with higher score
            print({
                    'last_name': max_score_student[0],
                    'first_name': max_score_student[1],
                    'grade': max_score_student[2],
                    'class_room': max_score_student[3],
                    'bus': max_score_student[4],
                    'teacher': f'{max_score_student[7]} {max_score_student[6]}'
                })
        elif args[1] == 'L':
            # print student with lowest score
            print({
                    'last_name': min_score_student[0],
                    'first_name': min_score_student[1],
                    'grade': min_score_student[2],
                    'class_room': min_score_student[3],
                    'bus': min_score_student[4],
                    'teacher': f'{min_score_student[7]} {min_score_student[6]}'
                })

# search for average
def search_average(args: list):
    grade = args[0]
    total = 0
    count = 0
    for student in students:
        if student[2] == grade:
            total += float(student[5])
            count += 1
    print(
        f'Grade {grade}: {total / count}'
    )


# print all grades and average
def search_info():
    student_counter = [0 for i in range(6)]
    for student in students:
        student_counter[int(student[2]) - 1] += 1
    for i in range(len(student_counter)):
        print(f'Grade {i + 1}: {student_counter[i]}')


'''
Main
'''
get_content()
while True:
    print('Input \'S\' to search by student\'s last name')
    print('Input \'T\' to search for students by teacher\'s last name')
    print('Input \'G\' to search for students by grade')
    print('Input \'B\' to search for students by bus route')
    print('Input \'A\' to search by student by average grade')
    print('Input \'I\' to compute the total number of students in each grade')
    print('Input \'Q\' to quit program')
    user_input = input('Your input: ')
    
    # S[tudent]:  <lastname> [B[us]]
    if user_input == 'S':
        print('This command prints students information given their last name')
        print('You can also specity their bus route')
        print('[Example input: Smith]')
        print('[Example input: Smith 16]')
        input_student_name = input('Your input: ')
        input_student_name = input_student_name.split()
        search_student_last_name(input_student_name)
    # T[eacher]:  <lastname>
    elif user_input == 'T':
        print('This command prints students information given teacher\'s last name')
        print('[Example input: Smith]')
        input_teacher_name = input('Your input: ')
        input_teacher_name = input_teacher_name.split()
        search_teacher_last_name(input_teacher_name)
    # B[us]:  <Number>
    elif user_input == 'B':
        print('This command prints students information given their bus route')
        print('[Example input: 911]')
        input_bus_route = input('Your input: ')
        search_bus(input_bus_route)
    # G[rade]:  <Number>
    elif user_input == 'G':
        print('This command prints students information given their last name')
        print('You can also specify the upper range (H[igh]) or lower range (L[ow)')
        print('[Example input: 3]')
        print('[Example input: 3 H] prints students highest score in that grade')
        print('[Example input: 3 L] prints students lowest score in that grade')
        input_grades = input('Your input: ')
        input_grades = input_grades.split()
        search_grade(input_grades)
    # A[verage]:  <Number>
    elif user_input == 'A':
        print('This command prints students information given the average GPA given grade level')
        print('[Example input: 2]')
        input_average = input('Your input: ')
        search_average(input_average)
    # I[nfo]
    elif user_input == 'I':
        print('This command prints students information given the average GPA for each grade level')
        search_info()
    elif user_input == 'Q':
        break
