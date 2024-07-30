// Author: Martin Conyon
// Data set: Wooldridge - Chapter 07
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 07: Multiple Regression Analysis with Qualitative Information: Binary (or Dummy) Variables

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 07
log using "output/Chapter07.smcl", replace

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
capture erase output/Figure_07_*.gph

// Example 7.1: Effects of Gender on Wage
use "data/WAGE1.DTA", clear

regress wage female educ exper tenure

regress wage female

// Compare to:
ttest wage, by(female)

lincom female + _cons

// Example 7.2: Effects of Computer Ownership on College GPA
use "data/GPA1.dta", clear

regress colGPA PC hsGPA ACT

regress colGPA PC

// Example 7.3: Effects of Training Grants on Hours of Training in 1988
use "data/jtrain.dta", clear

regress hrsemp grant lsales lemploy if year == 1988

// Example 7.4: Housing Price Regression (log example)
use "data/hprice1.dta", clear

regress lprice llotsize lsqrft bdrms colonial

// Example 7.5: Log Hourly Wage Equation (log example)
use "data/WAGE1.dta", clear

regress lwage female educ exper expersq tenure tenursq

// Difference between female and male wage
display (exp(_b[female] * 1) - 1) * 100

// Difference between male and female wage
display (exp(-1 * _b[female] * 1) - 1) * 100

// Example 7.6: Log Hourly Wage Equation with Interaction Terms
use "data/WAGE1.dta", clear

gen male = !female
gen single = !married
gen marrmale = married & !female
gen marrfem = married & female
gen singfem = female & !married
gen singmale = !female & !married

regress lwage marrmale marrfem singfem educ exper expersq tenure tenursq

// Difference in lwage between married and single women
lincom singfem - marrfem

test singfem = marrfem

regress lwage marrmale singmale singfem educ exper expersq tenure tenursq

// Example 7.7: Effects of Beauty on Physical Attractiveness
use "data/beauty.dta", clear

describe

// Male (log) earnings
regress lwage belavg abvavg exper expersq union goodhlth married black south bigcity smllcity service educ if female == 0

// Female (log) earnings
regress lwage belavg abvavg exper expersq union goodhlth married black south bigcity smllcity service educ if female == 1

// Correct for heteroscedasticity
regress lwage belavg abvavg exper expersq union goodhlth married black south bigcity smllcity service educ if female == 0

regress lwage belavg abvavg exper expersq union goodhlth married black south bigcity smllcity service educ if female == 1

// Example 7.8: Effects of Law School Rankings on Starting Salaries
use "data/lawsch85.dta", clear

gen r61_100 = rank > 60 & rank < 101

regress lsalary top10 r11_25 r26_40 r41_60 r61_100 LSAT GPA llibvol lcost

// Difference in starting wage between top 10 below 100 school
display (exp(_b[top10] * 1) - 1) * 100

regress lsalary rank LSAT GPA llibvol lcost

// Example 7.10 Log Hourly Wages
use "data/wage1.dta", clear

gen femeduc = female * educ

regress lwage female educ femeduc exper expersq tenure tenursq

regress lwage female educ exper expersq tenure tenursq

// Example 7.11: Effects of Race on Baseball Player Salaries
use "data/MLB1.dta", clear

regress lsalary years gamesyr bavg hrunsyr rbisyr runsyr fldperc allstar black hispan blckpb hispph

// Difference in lwage between black and white in cities with 10% of blacks
lincom _b[black] + _b[blckpb] * 10

// Difference in lwage between black and white in cities with 20% of blacks
lincom _b[black] + _b[blckpb] * 20

// City percentage of hispanic people when wages of hispanic and whites are equal
display _b[hispan] * -1 / _b[hispph]

// Example 7.12: A Linear Probability Model of Arrests
use "data/crime1.dta", clear

gen arr86 = !narr86

regress arr86 pcnv avgsen tottime ptime86 qemp86

// Change in probability of arrest if pcnv increases by .5
lincom _b[pcnv] * .5

// Change in probability of arrest if ptime86 increases by 6
lincom _b[ptime86] * 6

// Change in probability of arrest if ptime86 decreases by 12
lincom _b[_cons] - _b[ptime86] * 12

// Change in probability of arrest if qemp86 increases by 4
lincom _b[qemp86] * 4

regress arr86 pcnv avgsen tottime ptime86 qemp86 black hispan

// Close the log file
log close
