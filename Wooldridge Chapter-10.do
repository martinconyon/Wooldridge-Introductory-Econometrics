// Author: Martin Conyon
// Data set: Wooldridge - Chapter 10
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 10: Basic Regression Analysis with Time Series Data

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 10
log using "output/Chapter10.smcl", replace

// Install dependencies
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

// Example 10.1: Static Phillips Curve
use "./data/phillips.dta", clear
reg inf unem

// Example 10.2: Effects of Inflation and Deficits on Interest Rates
use "./data/intdef.dta", clear
describe
reg i3 inf def
display _b[inf]

// Example 10.3: Puerto Rican Employment and the Minimum Wage
use "./data/prminwge.dta", clear
reg lprepop lmincov lusgnp

// Example 10.4: Effects of Personal Exemption on Fertility Rates
use "./data/fertil3.dta", clear
reg gfr pe ww2 pill

reg gfr pe pe_1 pe_2 ww2 pill
display _b[pe] + _b[pe_1] + _b[pe_2]

// Example 10.5: Antidumping Filings and Chemical Imports
use "./data/barium.dta", clear
reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6

// Example 10.6: Election Outcomes and Economic Performance
use "./data/fair.dta", clear
reg demvote partyWH incum c.partyWH#c.gnew c.partyWH#c.inf if year < 1996
display _b[_cons] + _b[partyWH] + _b[incum] + _b[c.partyWH#c.gnew]*3 + _b[c.partyWH#c.inf]*3.019

// Example 10.7: Housing Investment and Prices
use "./data/hseinv.dta", clear
reg linvpc lprice
reg linvpc lprice t

// Example 10.8: Fertility Equation
use "./data/fertil3.dta", clear
reg gfr pe ww2 pill t
reg gfr pe ww2 pill t tsq

// Example 10.9: Puerto Rican Employment
use "./data/prminwge.dta", clear
reg lprepop lmincov lusgnp t

// Example 10.10: Housing Investment
use "./data/hseinv.dta", clear
reg linvpc lprice t

qui reg linvpc t
predict uh, res
eststo Model1: qui reg uh lprice t
eststo Model2: qui reg linvpc lprice t
estout , cells(b(nostar fmt(4)) se(par fmt(4))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels(R-squared Adj-R-squared N)) varlabels(_cons intercept) varwidth(20) ti(Dependent Variables: log(invpc))
est clear

// Example 10.11: Effects of Antidumping Filings
use "./data/barium.dta", clear
reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6 feb - dec
test feb mar apr may jun jul aug sep oct nov dec

reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6 spr sum fall
test spr sum fall

// Close the log file
log close
