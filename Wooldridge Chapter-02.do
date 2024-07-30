// Author: Martin Conyon
// Data set: Wooldridge - Chapter 02
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 02: The Simple Regression Model

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 02
log using "output/Chapter02_Log.smcl", replace

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
capture erase output/Figure_02_*.gph

// Load the data
use "data/wage1.dta", clear

// Descriptive statistics
summarize

// Regression analysis
regress wage educ

// Save regression results
estimates save "output/regression_results", replace

// Create scatter plot with fitted regression line
twoway (scatter wage educ) (lfit wage educ), ///
    title("Scatter plot of Wage vs. Education") ///
    xtitle("Years of Education") ///
    ytitle("Wage") ///
    legend(off)

// Save graph
graph export "output/Figure_02_Scatterplot.png", replace
graph save "output/Figure_02_Scatterplot.gph", replace

// Regression diagnostics
predict residuals, residuals
predict fitted, xb

// Plot residuals
twoway (scatter residuals educ), ///
    title("Residuals vs. Education") ///
    xtitle("Years of Education") ///
    ytitle("Residuals") ///
    legend(off)

// Save graph
graph export "output/Figure_02_Residuals.png", replace
graph save "output/Figure_02_Residuals.gph", replace

// Close the log file
log close

// Erase any created data files
capture erase "data/regression_results.dta"
