// Author: Martin Conyon
// Data set: Wooldridge - Chapter 11
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 11: Further Issues in Using OLS with Time Series Data

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 11
log using "output/Chapter11.smcl", replace

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

// Example 11.4: Efficient Markets Hypothesis
use "./data/nyse.dta", clear
describe
reg return return_1

// Equation 11.18
list return return_1 in 1/10
gen return_2 = return[_n-2]
reg return return_1 return_2
test return_1 return_2

// Example 11.5: Expectations Augmented Phillips Curve
use "./data/phillips.dta", clear
describe
reg cinf unem
display as text "u_0 = " _b[_cons] / -_b[unem]

// Example 11.6: Fertility Equation
use "./data/fertil3.dta", clear
describe
reg cgfr cpe cpe_1 cpe_2
test cpe cpe_1

// Example 11.7: Wages and Productivity
use "./data/earns.dta", clear
describe
reg lhrwage loutphr t
reg ghrwage goutphr

// Example 11.8: Fertility Equation
use "./data/fertil3.dta", clear
describe
reg cgfr cgfr_1 cpe cpe_1 cpe_2
test cpe cpe_1

// Close the log file
log close
