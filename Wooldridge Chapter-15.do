// Author: Martin Conyon
// Data set: Wooldridge - Chapter 15
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 15: Instrumental Variables and Two Stage Least Squares

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 15
log using "output/Chapter15.smcl", replace

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

// Example 15.1: Estimating the Return to Education for Married Women
use "./data/mroz.dta", clear
reg lwage educ
reg educ fathedu
ivreg lwage (educ=fathedu)

// Example 15.2: Estimating the Return to Education for Men
use "./data/wage2.dta", clear
reg educ sibs
ivreg lwage (educ=sibs)
reg lwage educ, nohead

// Example 15.3: Estimating the Effect of Smoking on Birth Weight
use "./data/bwght.dta", clear
reg packs cigprice
ivreg lbwght (packs=cigprice)

// Example 15.4: Using College Proximity as an IV for Education
use "./data/card.dta", clear
qui reg educ nearc4 exper expersq black smsa south smsa66 reg6*
display "Constant = " _b[_cons] ", b1 = " _b[nearc4] ", b2 = " _b[exper]
eststo OLS: qui reg lwage educ exper* black smsa south smsa66 reg6*
eststo IV: qui ivreg lwage (educ=nearc4) exper* black smsa south smsa66 reg6*
estout, cells(b(nostar fmt(3)) se(par fmt(3))) ///
    stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "Observations")) ///
    varlabels(_cons constant) varwidth(20) ///
    title("Table 15.1 LHS: (lwage)")
est clear

// Example 15.5: Return to Education for Working Women
use "./data/mroz.dta", clear
qui reg educ exper* fatheduc motheduc
test fatheduc motheduc
ivreg lwage (educ=fatheduc motheduc) exper*
qui reg lwage educ exper*
display "b1 = " _b[educ]

// Example 15.6: Using Two Test Scores as Indicators of Ability
use "./data/wage2.dta", clear
ivreg lwage educ exper tenure married south urban black (IQ=KWW)

// Example 15.7: Return to Education for Working Women
use "./data/mroz.dta", clear
qui reg educ exper* fatheduc motheduc if inlf==1
predict v2, res
ivreg lwage (educ=fatheduc motheduc) exper* v2
qui reg lwage educ exper*
display "The OLS estimate is " _b[educ] " (" _se[educ] ")"

// Example 15.8: Return to Education for Working Women
use "./data/mroz.dta", clear
qui ivreg lwage (educ=fatheduc motheduc) exper*
predict u1, res
reg u1 exper* fatheduc motheduc
display "N*Rsquared =" e(r2)*e(N)
qui ivreg lwage (educ=fatheduc motheduc huseduc) exper*
predict u1_h, res
qui reg u1_h exper* fatheduc motheduc huseduc
display "N*Rsquared =" e(r2)*e(N)
qui ivreg lwage (educ=fatheduc motheduc huseduc) exper*
display "The IV estimate using all three instruments is " _b[educ] " (" _se[educ] ")"
qui ivreg lwage (educ=fatheduc motheduc) exper*
display "The IV estimate using two instruments is " _b[educ] " (" _se[educ] ")"

// Example 15.9: Effect of Education on Fertility
use "./data/fertil1.dta", clear
ivreg kids (educ=meduc feduc) age agesq black-y84
qui reg kids educ age agesq black-y84
display "The OLS estimate is " _b[educ] " (" _se[educ] ")"

// Endogeneity
reg educ meduc feduc
predict v2, res
ivreg kids (educ=meduc feduc) age agesq black-y84 v2
display "The OLS estimate is " _b[v2] " (" _b[v2]/_se[v2] ")"

// Example 15.10: Job Training and Worker Productivity
use "./data/jtrain.dta", clear
reg chrsemp cgrant if year==1988
ivreg clscrap chrsemp if year==1988

// Close the log file
log close
