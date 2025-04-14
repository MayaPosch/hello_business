IDENTIFICATION DIVISION.
program-id. hello_business. *> Simple 'Hello World' style example.
author. Maya Posch.
date-written. April 7 2025

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
	select employee-file assign to 'employees.dat'
	organization is sequential.
	select report-file assign to 'report-file.txt'
	line sequential.
	
DATA DIVISION.
FILE SECTION.
fd employee-file
	block contains 19 characters
	record contains 19 characters.
01 employee-record.
	05 employee-id		PIC 9(3).
	05 employee-name	PIC X(10).
	05 employee-salary	PIC S9(4)V99.

fd report-file
	report is employee-report.

WORKING-STORAGE SECTION.
01 end-of-file			PIC X(1) value 'N'.
	
REPORT SECTION.
RD employee-report
	page limits 60 lines
	first detail 3.
	
01 TYPE PAGE HEADING.
	03 LINE 1.
		05 COL 	12	VALUE 'Employee List'.
		05 COL 	47	VALUE 'Page'.
		05 COL 	52	PIC Z9	SOURCE PAGE-COUNTER.
	03 LINE 3.
		05 COL	4	VALUE "ID	Name	Salary".
	
01 employee-line TYPE DETAIL.
	03 LINE + 2.
		05 COL 	4	PIC 9(3)	SOURCE employee-id.
		05 COL 	12	PIC X(10)	SOURCE employee-name.
		05 EMP-SAL-VAL COL	20	PIC $(5)9.99	SOURCE employee-salary.
		
01 TYPE RF.
	03 LINE + 3.
		05 COL 16	VALUE 'TOTAL SALARY:'.
		05 COL 41	PIC $(5)9.99	SUM OF EMP-SAL-VAL.
	03 LINE.
		05 COL 41	VALUE '========='.

PROCEDURE DIVISION.
	perform welcome
	perform read-file
	perform farewell
	stop run.
	
welcome.
	display 'Welcome to business.'.
	
farewell.
	display 'Report has been generated.'.
	display 'Thank you for your time.'.
	
read-file.
	open input employee-file.
	open output report-file.
	INITIATE employee-report.
	
	read employee-file
		at end move 'Y' to end-of-file
	end-read.
	
	perform until end-of-file = 'Y'
	*> perform until 1 <> 1
		*> READ employee-file
			*> AT END
				*> EXIT PERFORM
		*> END-READ
		
		GENERATE employee-line
	
		display 'Employee ID: ' employee-id
		display 'Employee name: ' employee-name
		display 'Employee salary: $' employee-salary
		display '------------------------------'
		
		read employee-file
			at end move 'Y' to end-of-file
		end-read
	end-perform.
	
	TERMINATE employee-report
	close employee-file, report-file
	.

