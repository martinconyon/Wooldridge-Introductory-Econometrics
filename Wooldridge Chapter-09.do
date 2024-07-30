// Author: Martin Conyon
// Data set: Wooldridge - Chapter 09
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 09:  More on Specification and Data Problems

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 09
log using "output/Chapter09.smcl", replace


// Install dependencises

// net install estout.pkg
// sse install estout

// net install estwrite.pkg


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


* Example 9.1: Economic Model of Crime
use "./data/CRIME1.dta", clear

reg narr86 pcnv avgsen tottime ptime86 qemp86 inc86 black hispan
reg narr86 pcnv pcnvsq avgsen tottime ptime86 pt86sq qemp86 inc86 inc86sq black hispan

* or ..
eststo clear
local x1 "pcnv avgsen tottime ptime86 qemp86 inc86 black hispan"
local x2 "pcnvsq pt86sq inc86sq"
qui reg narr86 `x1'
eststo model1
qui reg narr86 `x1' `x2', r
eststo model2
estout , cells(b(nostar fmt(4)) se(par fmt(4))) stats(r2 N, fmt(%9.3f %9.0g) labels(R-squared)) varlabels(_cons intercept) varwidth(20) ti(Dependent Variables: narr86)

* or ...

eststo model1: qui reg narr86 `x1'
eststo model2: qui reg narr86 `x1' `x2', r  
estout , cells(b(nostar fmt(4)) se(par fmt(4))) stats(r2 N, fmt(%9.3f %9.0g) labels(R-squared)) varlabels(_cons intercept) varwidth(20) ti(Dependent Variables: narr86)


// Example 9.2: Housing Price Equation
use "./data/hprice1.dta", clear

reg price lotsize sqrft bdrms

// Ramsey RESET test
predict yhat, xb
gen yhat2 = yhat^2
gen yhat3 = yhat^3
reg price lotsize sqrft bdrms yhat2 yhat3
test yhat2 yhat3

reg lprice llotsize lsqrft bdrms
// Ramsey RESET test
capture drop yhat*
predict yhat
gen yhat2 = yhat^2
gen yhat3 = yhat^3
reg lprice llotsize lsqrft bdrms yhat2 yhat3
test yhat2 yhat3

// can also use
reg price lotsize sqrft bdrms
estat ovtest 
reg lprice llotsize lsqrft bdrms
estat ovtest 

// Example 9.3: IQ as a Price for Ability
use "./data/wage2.dta", clear
gen educIQ = educ * IQ
reg lwage educ exper tenure married south urban black
reg lwage educ exper tenure married south urban black IQ 
reg lwage educ exper tenure married south urban black IQ educIQ

// Example 9.4: City Crime Rates
use "./data/crime2.dta", clear
reg lcrmrte unem llawexpc if d87 == 1
reg lcrmrte unem llawexpc lcrmrt_1

// Example 9.8: R&D Intensity and Firm Size
use "./Data/rdchem.dta", clear
reg rdintens sales profmarg
reg rdintens sales profmarg if sales < 30000

// Example 9.9: R&D Intensity
use "./Data/rdchem.dta", clear
reg lrd lsales profmarg
reg lrd lsales profmarg if sales < 30000

// Example 9.10: State Infant Mortality Rates
use "./Data/infmrt.dta", clear
reg infmort lpcinc lphysic lpopul if year == 1990
reg infmort lpcinc lphysic lpopul if year == 1990 & DC == 0

// Close the log file
log close
