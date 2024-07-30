// Author: Martin Conyon
// Data set: Wooldridge - Chapter 06
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 06: Multiple Regression Analysis: OLS Asymptotics

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 06
log using "output/Chapter06.smcl", replace

// Set the working directory (users should modify this to their specific path)
// Place this in a block comment to guide users
/*
    Set your working directory to the project root where the 'do-files' and 'data' folders are located.
    Example:
    cd "/path/to/project-root"
*/

// Check PWD
// cd "/path/to/project-root" if required
// cd "."

// Erase any previously created .gph files
capture erase output/Figure_06_*.gph

// Example 5.2: Standard Errors in a Birth Weight Equation
use "data/HPRICE2.dta", clear

describe

regress price nox crime rooms dist stratio

regress price nox crime rooms dist stratio, beta

// Example 6.2: Effect of Pollution on Housing Prices
use "data/HPRICE2.dta", clear

gen rooms2 = rooms * rooms

gen ldist = log(dist)

regress lprice lnox rooms

regress lprice lnox ldist rooms rooms2 stratio

// Display optimal f.o.c value of rooms
display -1 * _b[rooms] / (2 * _b[rooms2])

// Change in price if rooms increases from 5 to 6
display 100 * (_b[rooms] + 2 * _b[rooms2] * 5)

// Change in price if rooms increases from 6 to 7
display 100 * (_b[rooms] + 2 * _b[rooms2] * 6)

// Example 6.3: Effect of Attendance on Final Exam Performance
use "data/ATTEND.dta", clear

summarize priGPA

gen priGPA2 = priGPA * priGPA

gen ACT2 = ACT * ACT

gen priatn = priGPA * atndrte

regress stndfnl atndrte priGPA ACT priGPA2 ACT2 priatn

// Partial effect of atndrte on stndfnl
display _b[atndrte] + _b[priatn] * 2.59

// Example 6.4: CEO Compensation and Firm Performance
use "data/CEOSAL1.dta", clear

// levels-levels model
regress salary sales roe

// log-log model
regress lsalary lsales roe

// Example 6.5: Confidence Interval for Predicted College GPA (Approach in Book)
use "data/GPA2.dta", clear

gen hsize2 = hsize * hsize

regress colgpa sat hsperc hsize hsize2

// Predicted GPA at given design matrix values
display _b[_cons] + _b[sat] * 1200 + _b[hsperc] * 30 + _b[hsize] * 5 + _b[hsize2] * 25

gen sat0 = sat - 1200

gen hsperc0 = hsperc - 30

gen hsize0 = hsize - 5

gen hsize20 = hsize2 - 25

regress colgpa sat0 hsperc0 hsize0 hsize2

// Example 6.5: Confidence Interval for Predicted College GPA (Another Approach)
use "data/GPA2.dta", clear

gen hsize2 = hsize * hsize

regress colgpa sat hsperc hsize hsize2

set obs 4138

replace sat = 1200 in 4138/4138

replace hsperc = 30 in 4138/4138

replace hsize = 5 in 4138/4138

replace hsize2 = 25 in 4138/4138

predict colgpahat in 4138/4138, stdp 

predict colgpahatt in 4138/4138, xb

gen lb = colgpahatt - 1.96 * colgpahat in 4138/4138

gen ub = colgpahatt + 1.96 * colgpahat in 4138/4138

list colgpahat lb colgpahatt ub in 4138/4138

// Example 6.7: Predicting CEO Salaries
use "data/CEOSAL2.dta", clear

regress lsalary lsales lmktval ceoten

predict lsal, xb

gen mhat = exp(lsal)

// Predicted salary
display _b[_cons] + _b[lsales] * log(5000) + _b[lmktval] * log(10000) + _b[ceoten] * 10

regress salary mhat, noconstant

// Predicted salary
display _b[mhat] * exp(7.013)

// Example 6.8: Predicting CEO Salaries
use "data/CEOSAL2.dta", clear

regress salary sales mktval ceoten

// Close the log file
log close
