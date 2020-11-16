import sys


#======================================================================================================


#Checks formatting of the two files based on comma splitting.
def format_checker(file, comma_count):
    array = file.readlines()

    for line in array:
        count = line.count(",")
        if count != comma_count:
            print("File " + file.name + " did not pass format check!")
            sys.exit(0)
    return array


#Just splits the lines in the provided arrays by comma.
def format_array(array):
    array_result = []

    for line in array:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        array_result.append(parsed_line)
    return array_result


#Opening files and and parsed.
def file_handler():
    try:
        students_file = open("list.txt")
        teachers_file = open("teachers.txt")
    except:
        print("Cannot open files.")
        sys.exit(0)

    students_list = format_checker(students_file, 5)
    teachers_list = format_checker(teachers_file, 2)
    students = format_array(students_list)
    teachers = format_array(teachers_list)
    return [students, teachers]


#combine lists into one file, students.txt.
def combine_files(student_teacher_list):
    result = []
    for student in student_teacher_list[0]:
        for teacher in student_teacher_list[1]:
            if int(student[3]) == int(teacher[2]):
                result.append(
                    student[0] + ',' +
                    student[1] + ',' +
                    student[2] + ',' +
                    student[3] + ',' +
                    student[4] + ',' +
                    student[5] + ',' +
                    teacher[0] + ',' +
                    teacher[1] + ','
                )
    return result


#======================================================================================================


#NR1: Given a classroom number, list all students assigned to it.
def students_by_class_search(lines, class_number, attr="filler"):
    result = []

    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if class_number == parsed_line[3]:
            result.append(parsed_line[0] + ',' + parsed_line[1])

    return [result, 9]


#NR2: Given a classroom number, find the teacher (or teachers) teaching.
def teachers_by_class_search(lines, class_number, attr="filler"):
    result = []

    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if class_number == parsed_line[3]:
            result.append(parsed_line[6] + ',' + parsed_line[7])
    result = list(dict.fromkeys(result))

    return [result, 9]


#NR3: Given a grade, find all teachers who teach it.
def teachers_by_grade_search(lines, grade_number, attr="filler"):
    result = []

    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if grade_number == parsed_line[2]:
            result.append(parsed_line[6] + ',' + parsed_line[7])
    result = list(dict.fromkeys(result))

    return [result, 9]


#NR4: Report the enrollments broken down by classroom (i.e., output a
#list of classrooms ordered by classroom number, with a total number of students in each
#of the classrooms).
def enrollments_by_class_search(lines, attr="filler", attr2="filler"):
    result = []

    classrooms = []
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        classrooms.append(int(parsed_line[3]))
    classrooms = list(dict.fromkeys(classrooms))
    classrooms.sort()

    for class_ in classrooms:
        count = 0
        for line in lines:
            line = line.rstrip('\n')
            parsed_line = line.split(',')
            if int(class_) == int(parsed_line[3]):
                count += 1
        result.append(str(class_) + ": " + str(count))

    return [result, 9]


#======================================================================================================


#NR5: Add to your program the commands that allow a data analyst to extract
#appropriate data to be able to analyze whether student GPAs are affected by the student’s
#grades, student’s teachers or the bus routes the students are on.


#Average from specific Bus number.
def average_from_bus(lines, bus_number, attr="filler"):
    if bus_number == "DNE":
        return [[], 9]
    
    total = 0.0
    length = 0

    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if bus_number == parsed_line[4]:
            total += float(parsed_line[5])
            length += 1

    if total != 0:
        return [[str(bus_number) + ": " + str(total/length)], 9]
    return [[str(bus_number) + ": 0"], 9]


#Average from specific Class number.
def average_from_class(lines, class_number, attr="filler"):
    if class_number == "DNE":
        return [[], 9]

    total = 0.0
    length = 0

    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if class_number == parsed_line[3]:
            total += float(parsed_line[5])
            length += 1

    if total != 0:
        return [[str(class_number) + ": " + str(total/length)], 9]
    return [[str(class_number) + ": 0"], 9]


#Average from specific teacher.
def average_from_teacher(lines, teacher, attr="filler"):
    if teacher == "DNE":
        return [[], 9]

    total = 0.0
    length = 0

    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if teacher == parsed_line[6]:
            total += float(parsed_line[5])
            length += 1

    if total != 0:
        return [[str(teacher) + ": " + str(total/length)], 9]
    return [[str(teacher) + ": 0"], 9]


#======================================================================================================


#student search function.
def student_search(lines, search_value, attr="filler"):
    result = []

    #if student matches search value, add that line to list.
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if search_value == parsed_line[0]:
            result.append(line)

    return [result, 0]


#print for student.
def student_print(lines):
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        print(parsed_line[0] + ',' +
              parsed_line[1] + ',' +
              parsed_line[2] + ',' +
              parsed_line[3] + ',' +
              parsed_line[6] + ',' +
              parsed_line[7])


#teacher search function.
def teacher_search(lines, search_value, attr="filler"):
    result = []

    #if teacher matches search value, add that line to list.
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if search_value == parsed_line[6]:
            result.append(parsed_line[0] + ',' + parsed_line[1])
    
    return [result, 9]


#bus number search function.
def bus_search(lines, search_value, parsed_key):
    result = []

    if search_value == "DNE" and len(parsed_key) > 1:
        for line in lines:
            line = line.rstrip('\n')
            parsed_line = line.split(',')
            result.append(
                parsed_line[0] + ',' +
                parsed_line[1] + ',' +
                parsed_line[4]
            )
        return [result, 9]

    #if bus number matches search value, add that line to list.
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if search_value == parsed_line[4]:
            result.append(
                parsed_line[1] + ',' +
                parsed_line[0] + ',' +
                parsed_line[2] + ',' +
                parsed_line[3]
            )
    return [result, 9]


#grade search function.
def grade_search(lines, search_value, attr="filler"):
    result = []

    #if grade matches search value, add that line to list.
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if search_value == parsed_line[2]:
            result.append(line)

    return [result, 4]


#print for grade.
def grade_print(lines):
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        print(parsed_line[0] + ',' + parsed_line[1])


#high option function.
def high_option(lines, attr="filler", attr2="filler"):
    if len(lines) == 0:
        return [[], 9]

    student = ''
    max_GPA = 0

    #Since this function gets called after Grade function.
    #I parse through a list of that specified grade already.
    #So just gotta do basic minimum finder function.
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if max_GPA < float(parsed_line[5]):
            max_GPA = float(parsed_line[5])
            student = line
    
    student = student.split(',')
    result = student[0] + ',' + student[1] + ',' + student[5] + ',' + student[6] + ',' + student[7] + ',' + student[4]

    return [[result], 9]


#low option function.
def low_option(lines, attr="filler", attr2="filler"):
    if len(lines) == 0:
        return [[], 9]

    student = ''
    min_GPA = float(lines[0].split(',')[5])

    #Since this function gets called after Grade function.
    #I parse through a list of that specified grade already.
    #So just gotta do basic minimum finder function.
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if min_GPA > float(parsed_line[5]):
            min_GPA = float(parsed_line[5])
            student = line
    
    student = student.split(',')
    result = student[0] + ',' + student[1] + ',' + student[5] + ',' + student[6] + ',' + student[7] + ',' + student[4]

    return [[result], 9]


#Average search function.
def average_search(lines, search_value, attr="filler"):
    if search_value == "DNE":
        return [[], 9]

    #return me list of students in that grade only.
    students = grade_search(lines, search_value)

    total = 0.0
    #add up the GPA's for that students list.
    for student in students[0]:
        student = student.rstrip('\n')
        parsed_student = student.split(',')
        total += float(parsed_student[5])
    
    #checker for divide-by-zero case.
    if total != 0:
        return [[str(search_value) + ": " + str(total/len(students[0]))], 9]
    return [[str(search_value) + ": 0"], 9]


#Info section / INCOMPLETE.
def info_option(lines, attr="filler", attr2="filler"):
    #Grades 0->6.
    total = [0] * 7
    #just incrementing value in array if student in that grade found.
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        total[int(parsed_line[2])] += 1

    #converting to string and proper formating before sending off.
    total = list(map(str, total))
    for i in range(0,len(total)):
        total[i] = str(i) +": " + total[i]

    return [total, 9]


#default print.
def default_print(lines):
    print('\n'.join(lines))


#Quits / Exits out of program.
def quit_option(lines, attr="filler", attr2="filler"):
    sys.exit(0)


#Basic control menu that returns user input.
def user_prompt():
    print("Lab 1A:")
    print("S[tudent]:")
    print("T[eacher]:")
    print("B[us]:")
    print("G[rade]:")
    print("A[verage]:")
    print("I[nfo]")
    print("Q[uit]")
    print()
    print("Lab 1B:")
    print("SC: <number>     student(s) by class number      [NR1]")
    print("TC: <number>     teacher(s) by class number      [NR2]")
    print("TG: <number>     teacher(s) by grade number      [NR3]")
    print("EC:              enrollment by class number      [NR4]")
    print()
    print("Analytics:")
    print("BA: <number>     average from bus number         [NR5]")
    print("CA: <number>     average from class number       [NR5]")
    print("TA: <string>     average from teacher            [NR5]")
    return input("\n>> ")


#======================================================================================================


def main():
    #dictionary to function calls / search functions.
    options = {
        "S:" : student_search,
        "T:" : teacher_search,
        "B:" : bus_search,
        "G:" : grade_search,
        "H:" : high_option,
        "L:" : low_option,
        "A:" : average_search,
        "I:" : info_option,
        "Q:" : quit_option,
        "SC:": students_by_class_search,
        "TC:": teachers_by_class_search,
        "TG:": teachers_by_grade_search,
        "EC:": enrollments_by_class_search,
        "BA:": average_from_bus,
        "CA:": average_from_class,
        "TA:": average_from_teacher
    }

    prints = {
        0 : student_print,
        4 : grade_print,
        9 : default_print
    }

    print()
    while(1):
        #opening file and turning into array split by newline.
        student_teacher_list = file_handler()
        lines = [combine_files(student_teacher_list), -1]

        #grabbing user input and splitting by spaces.
        key = user_prompt()
        parsed_key = key.split(' ')

        #iterating through user input.
        for item in parsed_key:
            if item in options:
                index = parsed_key.index(item)
                #cover options 'Q:', 'I:', 'H:', 'L:' which have no follow-up data.
                if(len(parsed_key)-1 == index):
                    lines = options[item](lines[0], "DNE", parsed_key)
                #get information infront of key and do search function.
                #search function as well mutates list.
                else:
                    lines = options[item](lines[0], parsed_key[index+1], parsed_key)
        #printing out results (everything gets outputted as a list).
        print()
        if lines[1] == -1:
            continue
        if len(lines[0]) != 0:
            prints[lines[1]](lines[0])
            print()


if __name__ == "__main__":
    main()