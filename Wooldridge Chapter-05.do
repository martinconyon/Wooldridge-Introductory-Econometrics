// Author: Martin Conyon
// Data set: Wooldridge - Chapter 05
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 05: Multiple Regression Analysis: OLS Asymptotics

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 05
log using "output/Chapter05.smcl", replace

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
capture erase output/Figure_05_*.gph

// Example 5.2: Standard Errors in a Birth Weight Equation
use "data/BWGHT.dta", clear

// Regression with 694 observations
regress lbwght cigs lfaminc in 1/694

// Regression with 1388 observations
regress lbwght cigs lfaminc

// Example 5.3: Economic Model of Crime
use "data/CRIME1.dta", clear

regress narr86 pcnv ptime86 qemp86

predict ubar, resid

regress ubar pcnv ptime86 qemp86 avgsen tottime

// Close the log file
log close
