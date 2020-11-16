import sys


#How to Use (usage examples):
#    S: COOKUS
#    S: COOKUS B: 55
#    T: KERBS
#    B: 55
#    A: 2
#    G: 4
#    G: 4 H:
#    I:
#    Q:


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
            result.append(line)
    
    return [result, 1]


#print for teacher.
def teacher_print(lines):
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        print(parsed_line[0] + ',' + parsed_line[1])


#bus number search function.
def bus_search(lines, search_value, parsed_key):
    result = []

    if search_value == "DNE" and len(parsed_key) > 1:
        return [lines, 2]

    #if bus number matches search value, add that line to list.
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        if search_value == parsed_line[4]:
            result.append(line)

    return [result, 3]


#print for bus-2.
def bus_print_mode_2(lines):
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        print(parsed_line[0] + ',' +
              parsed_line[1] + ',' +
              parsed_line[4])

#print for bus-3.
def bus_print_mode_3(lines):
    for line in lines:
        line = line.rstrip('\n')
        parsed_line = line.split(',')
        print(parsed_line[1] + ',' +
              parsed_line[0] + ',' +
              parsed_line[2] + ',' +
              parsed_line[3])


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

    return [[result], 5]


#print for high.
def high_print(lines):
    print('\n'.join(lines))
    

#low option function.
def low_option(lines, attr="filler", attr2="filler"):
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

    return [[result], 6]


#print for low.
def low_print(lines):
    print('\n'.join(lines))


#Average search function.
def average_search(lines, search_value, attr="filler"):
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
        return [[str(search_value) + ": " + str(total/len(students[0]))], 7]
    return [[str(search_value) + ": 0"], 7]


#print for average.
def average_print(lines):
    print('\n'.join(lines))


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

    return [total, 8]


#print for info.
def info_print(lines):
    print('\n'.join(lines))


#Quits / Exits out of program.
def quit_option(lines, attr="filler", attr2="filler"):
    sys.exit(0)


#Basic control menu that returns user input.
def user_prompt():
    print("S[tudent]:")
    print("T[eacher]:")
    print("B[us]:")
    print("G[rade]:")
    print("A[verage]:")
    print("I[nfo]")
    print("Q[uit]")
    return input("\n>> ")


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
        "Q:" : quit_option
    }

    prints = {
        0 : student_print,
        1 : teacher_print,
        2 : bus_print_mode_2,
        3 : bus_print_mode_3,
        4 : grade_print,
        5 : high_print,
        6 : low_print,
        7 : average_print,
        8 : info_print
    }
    
    while(1):
        #opening file and turning into array split by newline.
        try:
            file = open("students.txt")
            lines = [file.readlines(), -1]
        except:
            sys.exit(0)

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