:- use_module(library(csv)).
% Predicate to read data from a CSV file and store it as rules
read_csv_and_store(Filename) :-
csv_read_file(Filename, Rows, []),
process_rows(Rows).

% Process each row in the CSV file and store data as rules
process_rows([]).
process_rows([Row|Rows]) :-
process_row(Row),
process_rows(Rows).

% Store data from a row as a rule
process_row(row(EEID,Name,Job_Title,Department,Business_Unit,Gender,Ethnicity,Age,Hire_Date,Annual_Salary,Bonus_percentage,Country,City,Exit_Date)) :-
assert(employee(EEID,Name,Job_Title,Department,Business_Unit,Gender,Ethnicity,Age,Hire_Date,Annual_Salary,Bonus_percentage,Country,City,Exit_Date)).

%Question 1

is_seattle_employee3(Name) :-
        employee(_,Name, _, _, _, _, _, _, _, _, _, _, 'Seattle', _).

%Question 2

is_senior_manager_in_IT3(Name) :-
        employee(_, Name, 'Sr. Manger', 'IT', _, _, _, _, _, _, _, _, _, _).

%Question 3

is_director_finance_miami3(Name) :-
        employee(_, Name, 'Director', 'Finance', _, _, _, _, _, _, _, _, 'Miami', _).

%Question 4

is_asian_US_manufacturing_40M3(Name, Bussiness_Unit, Gender, Ethinicity, Age) :-
        employee(_, Name, _, _, Business_Unit, Gender, Ethnicity, Age, _, _, _, 'United States', _, _),
        Age>40,
        Business_Unit = 'Manufacturing',
        Gender = 'Male',
        Ethnicity = 'Asian'.

%Question 5

greet3(EEID) :-
        employee(EEID, Name, JobTitle, Department, BusinessUnit, _, _, _, _, _, _, _, _, _),
        format('Hello, ~w, ~w of ~w, ~w!', [Name, JobTitle, Department, BusinessUnit]).

%Question 6
years_until_retirement3(Name, Age, Years_to_retire) :-
        employee(_, Name, _, _, _, _, _, Age, _, _, _, _, _, _),
        Years_to_retire is 65 - Age.

%Question 7

is_rd_black_midAge3(Name, Business_unit, Ethnicity, Age) :-
        employee(_, Name, _, _, Business_unit, _, Ethnicity, Age, _, _, _, _, _, _),
        Age >= 25,
        Age =< 50,
        Business_unit = 'Research & Development',
        Ethnicity = 'Black'.

%Question 8

is_ITorFin_PHXorMIAorAUS3(Name, Department,City) :-
        employee(_, Name, _, Department, _, _, _, _, _, _, _, _, City, _),
        (Department = 'IT' ; Department = 'Finance'),
        (City = 'Phoenix' ; City = 'Miami' ; City = 'Austin').

%Question 9

is_female_senior_role3(Name, JobTitle) :-
        employee(_, Name, JobTitle, _, _, 'Female', _, _, _, _, _, _, _, _),
        atom_concat('Sr.', _, JobTitle).

%Question 10

is_highly_paid_senior_manager3(Name, Salary) :-
        employee(_, Name, 'Sr. Manger', _, _, _, _, _, _, Salary, _, _, _, _).
        remove_dollar_sign_comma_10(Salary, New_Salary), %function call to function that removes the symbol
        atom_number(New_Salary, NumSalary) %converts to number
        NumSalary > 120000.

remove_dollar_sign_comma_10(Salary_Original, New_Salary) :- %function to remove the unwanted symbols 

        atom_codes(Salary_Original, AsciiCode), %concerts to ascii
        exclude(=(36), AsciiCode, NoSign), %excludes ascii code for $ which is 36
        exclude(=(44), NoSign, NoComma), %excludes ascii code for , which is 44
        atom_codes(New_Salary, NoComma). %converts back 
%Question 11

is_prime_age3(Name, Age) :-
        employee(_, Name, _, _, _, _, _, Age, _, _, _, _, _, _), not((Maximum is Age-1, between(2,Maximum,Value), 0 is mod(Age,Value))). %calculates max possible divisor, then iterates over all possible divisors from 2 to max, lastly it checks if the age is divisible by the current value
%Question 12


average_salary3(Job_Title, Salary) :-
    bagof(SalaryOG, (employee(_, _, Job_Title, _, _, _, _, _, _, SalaryOG, _, _, _, _)), SalariesSign),
    maplist(remove_dollar_sign_comma_12, SalariesSign, SalariesNum),
    length(SalariesNum, NumTotalSalaries),
    NumTotalSalaries > 0, % Ensure there are salaries to calculate an average
    sum_list(SalariesNum, Sum),
    Salary is Sum / NumTotalSalaries.

remove_dollar_sign_comma_12(Salary_Original, New_Salary) :-
    atom_codes(Salary_Original, AsciiCode),
    exclude(=(36), AsciiCode, NoSign),
    exclude(=(44), NoSign, NoComma),
    deleteWhiteSpace_12(NoComma, NoWhiteSpace),
    atom_codes(Atom, NoWhiteSpace),
    atom_number(Atom, New_Salary).

deleteWhiteSpace_12([], []).
deleteWhiteSpace_12([32 | Tail], Deleted) :-
    deleteWhiteSpace_12(Tail, Deleted).
deleteWhiteSpace_12([Head | Tail], [Head | Deleted]) :-
    dif(Head, 32),
    deleteWhiteSpace_12(Tail, Deleted).

%Question 13

total_salary3(Name,Salary) :-
        employee(_, Name, _, _, _, _, _, _, _, SalaryOG, Bonus, _, _, _),
        remove_dollar_sign_comma_13(SalaryOG, SalaryNoSign),
        remove_percent_13(Bonus, NewBonus),
        Salary is SalaryNoSign + (SalaryNoSign * (NewBonus/100)).


remove_percent_13(BonusOG, NewBonus) :-
        atom_codes(BonusOG, AsciiCode), %converts to ascii code
        exclude(=(37), AsciiCode, NoPercent), %excludes percent sign
        deleteWhiteSpace_13(NoPercent, NoWhiteSpace), %exlcudes white spaces in number
        atom_codes(Atom, NoWhiteSpace), %converts back
        atom_number(Atom, NewBonus). %converts to number in order to manipulate

remove_dollar_sign_comma_13(Salary_Original, New_Salary) :- %function to remove the unwanted symbols 
        atom_codes(Salary_Original, AsciiCode), %concerts to ascii

        exclude(=(36), AsciiCode, NoSign), %excludes ascii code for $ which is 36
        exclude(=(44), NoSign, NoComma), %excludes ascii code for , which is 44

        deleteWhiteSpace_13(NoComma, NoWhiteSpace),

        atom_codes(Atom, NoWhiteSpace), %converts back
        atom_number(Atom, New_Salary). %converts to number 

deleteWhiteSpace_13([], []).
deleteWhiteSpace_13([32 | Tail], Deleted) :- %32 is the ascii code for white space
        deleteWhiteSpace_13(Tail, Deleted).
deleteWhiteSpace_13([Head | Tail], [Head | Deleted]) :-
        dif(Head, 32), %skips the chars that aren't white spaces
        deleteWhiteSpace_13(Tail, Deleted).

%Question 14
 takehome_salary3(Name, Job_Title, Take_home_salary) :-

        employee(_, Name, Job_Title, _, _, _, _, _, _, Salary, _, _, _, _), %find salary
        remove_dollar_sign_comma_14(Salary, Salary_Corrected),
        calculate_tax(Salary_Corrected, Tax), %use salary to calculate the tax level on it

        total_salary3(Name, New_Salary), %use salary found to calculate total salary

        Take_home_salary is New_Salary - (New_Salary * Tax). %do the formula given 

 calculate_tax(Salary, Tax) :-
         Salary < 50000,
         !, Tax is 0.2.
        calculate_tax(Salary, Tax) :-
        Salary >= 50000, Salary < 100000,
         !, Tax is 0.25.
        calculate_tax(Salary, Tax) :-
        Salary >= 100000, Salary < 200000,
        !, Tax is 0.3.
        calculate_tax(Salary, Tax) :-
        Salary >= 200000,
        !, Tax is 0.35.

remove_dollar_sign_comma_14(Salary_Original, New_Salary) :- %function to remove the unwanted symbols 
        atom_codes(Salary_Original, AsciiCode), %concerts to ascii

        exclude(=(36), AsciiCode, NoSign), %excludes ascii code for $ which is 36
        exclude(=(44), NoSign, NoComma), %excludes ascii code for , which is 44

        deleteWhiteSpace_14(NoComma, NoWhiteSpace),

        atom_codes(Atom, NoWhiteSpace), %converts back
        atom_number(Atom, New_Salary). %converts to number 

 total_salary(Name,Salary) :-
        employee(_, Name, _, _, _, _, _, _, _, SalaryOG, Bonus, _, _, _),
        remove_dollar_sign_comma_14(SalaryOG, SalaryNoSign),
        remove_percent_14(Bonus, NewBonus),
        Salary is SalaryNoSign + (SalaryNoSign * (NewBonus/100)).

deleteWhiteSpace_14([], []).
deleteWhiteSpace_14([32 | Tail], Deleted) :- %32 is the ascii code for white space
        deleteWhiteSpace_14(Tail, Deleted).
deleteWhiteSpace_14([Head | Tail], [Head | Deleted]) :-
        dif(Head, 32), %skips the chars that aren't white spaces
        deleteWhiteSpace_14(Tail, Deleted).

remove_percent_14(BonusOG, NewBonus) :-
        atom_codes(BonusOG, AsciiCode), %converts to ascii code
        exclude(=(37), AsciiCode, NoPercent), %excludes percent sign
        deleteWhiteSpace_14(NoPercent, NoWhiteSpace), %exlcudes white spaces in number
        atom_codes(Atom, NoWhiteSpace), %converts back
        atom_number(Atom, NewBonus). %converts to number in order to manipulate
%Question 15


total_years3(Name, Years) :-
    employee(_, Name, _, _, _, _, _, _, Hire_Date_OG, _, _, _, _, Exit_Date_OG), % find hire date, exit date, and name
    parse_date(Hire_Date_OG, New_Hire_Date),
    (nonvar(Exit_Date_OG) -> %if no exit date, hard code to 23
        New_Exit_Date is 23
    ;
        parse_date(Exit_Date_OG, New_Exit_Date)
    ),
    calculate_years(New_Hire_Date, New_Exit_Date, Years).

parse_date(DateString, Year) :-
    sub_string(DateString, _, 2, 0, YearString),
    atom_number(YearString, Year).

calculate_years(New_Hire_Date, New_Exit_Date, Years) :-
    (New_Hire_Date > 23, nonvar(New_Exit_Date) -> %if hire date is in 90s and no exit date
        Hire_Difference is 100 - New_Hire_Date,
        Years is Hire_Difference + 23
    ;
    
    New_Hire_Date =< 23, nonvar(New_Exit_Date) -> %if hire date is in 2000s and no exit date 
        Years is 23 - New_Hire_Date
    ;
    New_Hire_Date > 23, New_Exit_Date =< 23 -> %if hire date is in 90s and exit date is in 2000s (specified)
        Years is 23 - New_Hire_Date
    ;
        Years is New_Exit_Date - New_Hire_Date %final case where hire date and exit are in the 2000s
    ).

