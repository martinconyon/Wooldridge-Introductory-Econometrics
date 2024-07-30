// Author: Martin Conyon
// Data set: Wooldridge - Chapter 14
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 14: Advanced Panel Data Methods

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 14
log using "output/Chapter14.smcl", replace

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

// Example 14.1: Effect of Job Training on Firm Scrap Rates
use "./data/jtrain.dta", clear
xtset fcode year
xtreg lscrap d88 d89 grant grant_1, fe
display exp(_b[grant_1])-1
xtreg lscrap d88 d89 grant, fe

// Example 14.2: Has the Return to Education Changed over Time?
use "./data/wagepan.dta", clear
xtset nr year
xtreg lwage c.educ##i.year union mar, fe
testparm c.educ#i.year

// Example 14.3: Effect of Job Training on Firm Scrap Rates
use "./data/jtrain.dta", clear
xtset fcode year
xtreg lscrap d88 d89 grant grant_1 lsales lempl, fe

// Example 14.4: A Wage Equation Using Panel Data
use "./data/wagepan.dta", clear
xtset nr year
eststo POLS: qui reg lwage educ black hisp exper expersq mar union i.year
eststo RE: qui xtreg lwage educ black hisp exper expersq mar union i.year, re
eststo FE: qui xtreg lwage expersq mar union i.year, fe
estout, cells(b(nostar fmt(3)) se(par fmt(3))) ///
    stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "Observations")) ///
    varlabels(_cons constant) varwidth(20) ///
    title("Table 14.2 Three Different Estimators of a Wage Equation (lwage)")
est clear

// Close the log file
log close
