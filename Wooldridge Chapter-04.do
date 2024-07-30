// Author: Martin Conyon
// Data set: Wooldridge - Chapter 04
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 04: Multiple Regression Analysis: Inference

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 04
log using "output/Chapter04.smcl", replace

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
capture erase output/Figure_04_*.gph

// Example 4.1: Hourly Wage Equation
use "data/WAGE1.dta", clear
regress lwage educ exper tenure

// Increase in log(wage) if experience increases by 3 years
display _b[exper]*3

// Example 4.2: Student Performance and School Size
use "data/meap93.dta", clear
regress math10 totcomp staff enroll
regress math10 ltotcomp lstaff lenroll

// Change in math10 if enrollment increases by 1 percent
display _b[lenroll]/100

// Example 4.3: Determinants of College GPA
use "data/GPA1.dta", clear
regress colGPA hsGPA ACT skipped

// Example 4.4: Campus Crime and Enrollment
use "data/CAMPUS.dta", clear
regress lcrime lenroll

// T-statistics for testing the coefficient on lenroll equal to 1
scalar tvalue = (_b[lenroll] - 1) / _se[lenroll]
scalar pvalue = ttail(120, tvalue)
display "T-value: " tvalue ", P=value: " pvalue
test lenroll = 1

di 6.04^0.5

// Find critical value
di invttail(95, 0.05)   // One sided test t-value, critical value at 5%
di invttail(95, 0.025)  // Two sided t-value, critical value at 5%
di ttail(95, 1.66)

// More directly
regress lcrime lenroll
test _b[lenroll] = 1

// Example 4.5: Housing Prices and Air Pollution
use "data/hprice2.dta", clear
gen ldist = log(dist)
regress lprice lnox ldist rooms stratio

// Example 4.6: Participation Rates in 401K Plans
use "data/401k.dta", clear
regress prate mrate age totemp

// Change in participation rate if total employment increases by 10,000
display _b[totemp]*10000

// Example 4.7: Effect of Job Training Grants on Firm Scrap Rates
use "data/JTRAIN.dta", clear
summarize hrsemp sales employ
regress lscrap hrsemp lsales lemploy

// Change in Firm Scrap Rates if training per employee increases by 1 hour
display _b[hrsemp]*1

// Change in Firm Scrap Rates if training per employee increases by 5 hours
display _b[hrsemp]*5

// Example 4.8: Hedonic Price Model for Houses
// Dataset is not available

// Example 4.9: Parents Education in a Birth Weight Equation
use "data/BWGHT.dta", clear
regress bwght cigs parity faminc motheduc fatheduc

// Test for joint significance of motheduc and fatheduc
test motheduc fatheduc
test motheduc fatheduc, accumulate

regress bwght cigs parity faminc if e(sample)

// Example 4.10: Salary-Pension Tradeoff for Teachers
use "data/meap93.dta", clear
regress lsalary bensal lenrol lstaff droprate gradrate
regress lsalary bensal lenrol lstaff
regress lsalary bensal

// Close the log file
log close
