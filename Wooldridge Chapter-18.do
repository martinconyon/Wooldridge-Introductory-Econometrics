// Author: Martin Conyon
// Data set: Wooldridge - Chapter 18
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 18: Time Series Econometrics

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 18
log using "output/Chapter18.smcl", replace

// Set the working directory (users should modify this to their specific path)
// Place this in a block comment to guide users
/*
    Set your working directory to the project root where the 'do-files' and 'data' folders are located.
    Example:
    cd "/path/to/project-root"
*/

// Check PWD
// cd "/path/to/project-root" if required
cd "."

// Example 18.1: Housing Investment and Residential Price Inflation
use "./data/hseinv.dta", clear
est clear
tsset year
reg linvpc t
predict y, res
gen y1 = y[_n-1]
gen gprice_1 = gprice[_n-1] 
eststo GeometricDL: quietly reg y gprice y1 
eststo RationalDL: quietly reg y gprice y1 gprice_1
estout, cells(b(nostar fmt(3)) se(par fmt(3))) stats(N r2_a, fmt(%5.0g) labels(Sample Size Adjusted-R-squared)) ///
    varlabels(_cons constant) varwidth(18) title("Table 18.1 Distributed Lag Models for Housing Investment: log(invpc)")
est clear

// Example 18.2: Unit Root Test for Three-Month T-Bill Rates
use "./data/intqrt.dta", clear
reg cr3 r3_1
display "rho = " 1 + _b[r3_1]
display "t statistics on r3_1 = " _b[r3_1] / _se[r3_1]
reg r3 r3_1

// Example 18.3: Unit Root Test for Annual U.S. Inflation
use "./data/phillips.dta", clear
gen cinf_1 = cinf[_n-1]
reg cinf inf_1 cinf_1
display "rho = " 1 + _b[inf_1]
reg cinf inf_1
display "rho2 = " 1 + _b[inf_1]

// Example 18.4: Unit Root in the Log of U.S. Real Gross Domestic Product
use "./data/inven.dta", clear
gen lgdp_1 = ln(gdp[_n-1])
gen ggdp_1 = ggdp[_n-1]
egen t = seq()
reg ggdp t lgdp_1 ggdp_1 
display "rho = " 1 + _b[lgdp_1]
reg ggdp lgdp_1 ggdp_1 
display "rho = " 1 + _b[lgdp_1]

// Example 18.5: Cointegration between Fertility and Personal Exemption
use "./data/fertil3.dta", clear
tsset t
reg gfr t pe 
predict u, res
reg cgfr cpe 

// Augmented DF test for gfr & pe
dfuller gfr, lags(1) trend
dfuller pe, lags(1) trend

// Regression in levels with a single lag & time trend, manually
gen u_1 = u[_n-1]
gen cu = u - u_1
gen cu_1 = cu[_n-1]
reg cu u_1 cu_1 t
// Test alternatively using the augmented DF command in Stata
dfuller u, lags(1) trend reg
// First difference regression, with two lags (equation 11.27)
reg cgfr cpe cpe_1 cpe_2

// Example 18.6: Cointegrating Parameter for Interest Rates
use "./data/intqrt.dta", clear
gen cr3_2 = cr3[_n-2]
gen cr3_a = cr3[_n+1]
gen cr3_b = cr3[_n+2]
reg r6 r3 cr3 cr3_1 cr3_2 cr3_a cr3_b
// test Ho: B=1
display (_b[r3] - 1) / _se[r3]
// test serial correlation
predict u, res
gen u_1 = u[_n-1]
reg r6 r3 cr3 cr3_1 cr3_2 cr3_a cr3_b u_1
reg u u_1
// Compare with Simple OLS
reg r6 r3

// Example 18.7: Error Correction Model for Holding Yields
use "./data/intqrt.dta", clear
gen hy3_2 = hy3[_n-2]
gen hy6_1hy3_2 = hy6_1 - hy3_2
reg chy6 chy3_1 hy6_1hy3_2

// Example 18.8: Forecasting the U.S. Unemployment Rate
use "./data/phillips.dta", clear
reg unem unem_1
display "Forecasts of unem for 1997 = " %6.3f (_b[_cons] + _b[unem_1] * 5.4)

// 95% forecast interval
gen unem_1f = unem_1 - 5.4
gen inf_1f = inf_1 - 3
reg unem unem_1f inf_1f
display "Forecast = " %5.3f _b[_cons] ", SE = " %5.3f _se[_cons] " & se(e+1) = " %5.3f sqrt(_se[_cons]^2 + e(rmse)^2)
display "The 95% forecast interval is [" %6.3f (_b[_cons] - 1.96 * sqrt(_se[_cons]^2 + e(rmse)^2)) ", " %6.3f (_b[_cons] + 1.96 * sqrt(_se[_cons]^2 + e(rmse)^2)) "]"

// Example 18.9: Out-of-Sample Comparisons of Unemployment Forecasts
use "./data/phillips.dta", clear
quietly reg unem unem_1 
display "RMSE = " %5.3f e(rmse)
predict u, res
gen ua = abs(u)
summarize ua
display "MSE = " %5.3f r(mean)
quietly reg unem unem_1 inf_1 
display "RMSE = " %5.3f e(rmse)
predict uinf, res
gen uinfa = abs(uinf)
summarize uinfa
display "MSE = " %5.3f r(mean)

// Close the log file
log close
