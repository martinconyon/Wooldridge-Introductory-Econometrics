// Author: Martin Conyon
// Data set: Wooldridge - Chapter 13
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 13: Panel Data Methods

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 13
log using "output/Chapter13.smcl", replace

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

// Example 13.1: Women's Fertility over Time
use "./data/fertil1.dta", clear
reg kids educ age agesq black-y84
test y74 y76 y78 y80 y82 y84
predict u, res
gen u2 = u^2
qui reg u2 educ age agesq black-y84
display e(N) * e(r2)

// Example 13.2: Changes in the Return to Education and the Gender Wage Gap
use "./data/cps78_85.dta", clear
reg lwage y85 educ y85educ exper expersq union female y85fem
display "Return to Education in 1978 is " _b[educ]*100 "%"
display "Return to Education in 1985 is " (_b[educ] + _b[y85educ])*100 "%"

// Example 13.3: Effect of a Garbage Incinerator's Location on Housing Prices
use "./data/KIELMC.dta", clear
reg rprice nearinc if year==1981
reg rprice nearinc if year==1978
eststo Two: qui reg rprice y81 nearinc y81nrinc age agesq
eststo Three: qui reg rprice y81 nearinc y81nrinc age agesq intst land area rooms baths
estout, cells(b(nostar fmt(2)) se(par fmt(2))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels("R-squared" "Adj-R-squared" "Observations")) ///
    varlabels(_cons constant) varwidth(20) ///
    title("Table 13.2 Effects of Incinerator Location on Housing Prices (rprice)")
eststo clear

reg lprice y81 nearinc y81nrinc
reg lprice y81 nearinc y81nrinc age agesq lintst lland larea rooms baths

// Example 13.4: Effect of Worker Compensation Laws on Weeks out of Work
use "./data/injury.dta", clear
reg ldurat afchnge highearn afhigh if ky==1

// Example 13.5: Sleeping versus Working
use "./data/slp75_81.dta", clear
reg cslpnap ctotwrk ceduc cmarr cyngkid cgdhlth

// Example 13.6: Distributed Lag of Crime Rate on Clear-Up Rate
use "./data/crime3.dta", clear
reg clcrime cclrprc1 cclrprc2

// Example 13.7: Effect of Drunk Driving Laws on Traffic Fatalities
use "./data/traffic1.dta", clear
reg cdthrte copen cadmn

// Example 13.8: Effect of Enterprise Zones on Unemployment Claims
use "./data/ezunem.dta", clear
reg guclms d82-d88 cez
display exp(_b[cez])-1
predict u, res
gen u2 = u^2
gen u_1 = u[_n-1]
reg u2 d82-d88 cez
reg u d83-d88 cez u_1

// Example 13.9: County Crime Rates in North Carolina
use "./data/crime4.dta", clear
eststo hetrosk: qui reg clcrmrte i.year clprbarr clprbcon clprbpri clavgsen clpolpc
predict u, res
eststo robust: qui reg clcrmrte i.year clprbarr clprbcon clprbpri clavgsen clpolpc, robust
estout, cells(b(nostar fmt(2)) se(par fmt(2))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels("R-squared" "Adj-R-squared" "Observations")) ///
    varlabels(_cons constant) varwidth(20) ///
    title("Dependent Variable is clcrmrte")
eststo clear

gen usq = u^2
gen u_1 = u[_n-1]

reg usq i.year clprbarr clprbcon clprbpri clavgsen clpolpc
reg u i.year clprbarr clprbcon clprbpri clavgsen clpolpc u_1

// Close the log file
log close
