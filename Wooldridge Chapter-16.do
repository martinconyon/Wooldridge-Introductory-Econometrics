// Author: Martin Conyon
// Data set: Wooldridge - Chapter 16
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 16: Simultaneous Equations Models

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 16
log using "output/Chapter16.smcl", replace

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

// Example 16.5: Labor Supply of Married, Working Women
use "./data/mroz.dta", clear
ivreg hours (lwage=exper*) educ age kidslt6 nwifeinc
ivreg lwage (hours=age kidslt6 nwifeinc) educ exper*  

// Example 16.6: Inflation and Openness
use "./data/openness.dta", clear
reg open lpcinc lland
ivreg inf (open=lland) lpcinc

// Example 16.7: Testing the Permanent Income Hypothesis
use "./data/consump.dta", clear
ivreg gc (gy r3 =gy_1 gc_1 r3_1) 
predict u, res
g u_1 = u[_n-1]
reg u u_1
ivreg gc (gy r3 =gy_1 gc_1 r3_1) u_1 

// Example 16.8: Effect of Prison Population on Violent Crime Rates
use "./data/prison.dta", clear
local z "gpolpc gincpc cunem cblack cmetro cag0_14 cag15_17 cag18_24 cag25_34"
ivreg gcriv (gpris = final1 final2) `z'
reg gcriv gpris `z'

// Close the log file
log close
