// Author: Martin Conyon
// Data set: Wooldridge - Chapter 08
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 08: Heteroskedasticity


// Dependency
// net install whitetst.pkg

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 08
log using "output/Chapter08.smcl", replace

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
capture erase output/Figure_08_*.gph

// Example 8.1: Log Wage Equation with Heteroscedasticity-Robust Standard Errors
use "data/wage1.dta", clear

gen single = !married
gen male = !female
gen marrmale = male * married
gen marrfem = female * married
gen singfem = single * female

regress lwage marrmale marrfem singfem educ exper expersq tenure tenursq, robust

regress lwage marrmale marrfem singfem educ exper expersq tenure tenursq

// Example 8.2: Heteroscedasticity-Robust F Statistics
use "data/gpa3.dta", clear

regress cumgpa sat hsperc tothrs female black white if term == 2, robust

regress cumgpa sat hsperc tothrs female black white if term == 2

// Example 8.3: Heteroskedasticity-Robust LM Statistic
use "data/crime1.dta", clear

gen avgsensq = avgsen * avgsen

regress narr86 pcnv avgsen avgsensq ptime86 qemp86 inc86 black hispan, robust

// f.o.c=0 for avgsen
display _b[avgsen] / (2 * _b[avgsensq])

regress narr86 pcnv ptime86 qemp86 inc86 black hispan
predict ubar1, resid
qui reg avgsen pcnv ptime86 qemp86 inc86 black hispan
predict r1, r
qui reg avgsensq pcnv ptime86 qemp86 inc86 black hispan
predict r2, r
qui gen ur1 = ubar1 * r1
qui gen ur2 = ubar1 * r2
gen iota = 1
regress iota ur1 ur2, noconstant

scalar hetlm = e(N) - e(rss)
scalar pval = chi2tail(2, hetlm)

display _n "Robust LM statistic: " %6.3f hetlm _n "Under H0, distrib Chi2(2), p-value: " %5.3f pval

regress narr86 pcnv ptime86 qemp86 inc86 black hispan
predict ubar2, resid
regress ubar2 pcnv avgsen avgsensq ptime86 qemp86 inc86 black hispan

scalar lm1 = e(N) * e(r2)
display _n "LM statistic: " %6.3f lm1

// Example 8.4: Heteroscedasticity in Housing Price Equation
use "data/hprice1.dta", clear

regress price lotsize sqrft bdrms
whitetst, fitted


// Perform the White test for heteroskedasticity
regress price lotsize sqrft bdrms
estat imtest, white

regress lprice llotsize lsqrft bdrms
whitetst, fitted

// Example 8.5: Special Form of the White Test in the Log Housing Price Equation
use "data/hprice1.dta", clear

regress lprice llotsize lsqrft bdrms
whitetst, fitted

regress lprice llotsize lsqrft bdrms
estat imtest, white

// Example 8.6: Family Saving Equation
use "data/saving.dta", clear

regress sav inc
regress sav inc [aw = 1 / inc]
regress sav inc size educ age black
regress sav inc size educ age black [aw = 1 / inc]

// Example 8.7: Demand for Cigarettes
use "data/smoke.dta", clear

regress cigs lincome lcigpric educ age agesq restaurn
estat imtest, white

// Change in cigs if income increases by 10%
display _b[lincome] * (10 / 100)

// f.o.c. for age
display _b[age] / (2 * _b[agesq])


// Example 8.8: Labor Force Participation of Married Women
use "data/mroz.dta", clear

regress inlf nwifeinc educ exper expersq age kidslt6 kidsge6
regress inlf nwifeinc educ exper expersq age kidslt6 kidsge6, robust

// Example 8.9: Determinants of Personal Computer Ownership
use "http://fmwww.bc.edu/ec-p/data/wooldridge/gpa1", clear

gen parcoll = mothcoll | fathcoll

regress PC hsGPA ACT parcoll
predict phat
gen h = phat * (1 - phat)
regress PC hsGPA ACT parcoll [aw = 1 / h]

// Close the log file
log close
