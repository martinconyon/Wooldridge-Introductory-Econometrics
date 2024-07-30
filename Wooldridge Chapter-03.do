// Author: Martin Conyon
// Data set: Wooldridge - Chapter 03
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 03: Multiple Regression Analysis: Estimation

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 03
log using "output/Chapter03.smcl", replace

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
capture erase output/Figure_03_*.gph

// Example 3.1: Determinants of College GPA
use "data/GPA1.dta", clear
summarize ACT
regress colGPA hsGPA ACT
regress colGPA ACT

// Example 3.2: Hourly Wage Equation
use "data/WAGE1.dta", clear

// Example 3.3: Participation in 401(K) Pension Plan 
use "data/401k.dta", clear
summarize prate mrate age
regress prate mrate age
regress prate mrate

// Example 3.4: Determinants of College GPA
use "data/GPA1.dta", clear
regress colGPA hsGPA ACT

// Example 3.5: Explaining Arrest Records
use "data/crime1.dta", clear
regress narr86 pcnv ptime86 qemp86

// Change in the predicted number of arrests when proportion of convictions increases by .5 for 1 man
display _b[pcnv]*.5

// Change in the predicted number of arrests when proportion of convictions increases by .5 for 100 men 
display 100*_b[pcnv]*.5

// Change in the predicted number of arrests when prison term increases by 12 
display _b[ptime86]*12

// Change in the predicted number of arrests when legal employment increases by a quarter for 100 men 
display _b[qemp86]*100

regress narr86 pcnv avgsen ptime86 qemp86

// Example 3.6: Hourly Wage Equation
use "data/WAGE1.dta", clear
regress lwage educ

// Close the log file
log close

// Erase any created data files
capture erase "data/regression_results.dta"
