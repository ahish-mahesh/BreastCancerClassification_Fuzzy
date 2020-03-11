## This example shows how to use frbs without
## learning process.
## Note: some variables might be shared for other examples.

## Define shape and parameters of membership functions of input variables.
## Please see fuzzifier function to contruct the matrix.
#install.packages("frbs")
library("frbs")
varinp.mf <- matrix(c(1, 1000, 1200, 1400, NA, 1, 1200, 1600, 1800, NA, 1, 2.5, 5, 7.5, NA,
                      1, 6, 10, 14, NA),
                    nrow = 5, byrow = FALSE)

## Define number of fuzzy terms of input variables.
## Suppose, we have 3, 2, 3, and 3 numbers of fuzzy terms
## for first, second, third and fourth variables, respectively.
num.fvalinput <- matrix(c(2, 2), nrow=1)

## Give the names of the fuzzy terms of each input variable.
## It should be noted that the names of the fuzzy terms must be unique,
## so we put a number for making it unique.
varinput.1 <- c("asmall", "alarge")
varinput.2 <- c("bsmall", "blarge")

names.varinput <- c(varinput.1, varinput.2)

## Set interval of data.
range.data <- matrix(c(1000,1800, 0, 14, 0,6000), nrow=2)

## Set weighted average method to be used as defuzzification method.
type.defuz <- "WAM"
## We are using standard t-norm and s-norm.
type.tnorm <- "MIN"
type.snorm <- "MAX"
type.implication.func <- "ZADEH"

## Give the name of simulation.
name <- "Sim-0"

## Provide new data for testing.
newdata<- matrix(c(1300, 6.5), nrow= 1, byrow = TRUE)
## the names of variables
colnames.var <- c("input1", "input2", "output1")

#####################################################################
## 1b. Using Takagi Sugeno Kang (TSK) Model
#####################################################################

type.model <- "TSK"

## Define function of TSK
func.tsk<-matrix(c(4.692, -526.2, 2631, 3.4765, -210.5, 2103, 4.692, -526.2, 2631), nrow=3, byrow=TRUE)

## Define the fuzzy IF-THEN rules;
## For TSK model, it isn't necessary to put linguistic term in consequent parts.
## Make sure that each rule has a "->" sign.
rule <- matrix(c("alarge","and","bsmall","->",
                 "asmall","or","blarge", "->",  
                 "asmall","and","bsmall","->"),
               nrow=3, byrow=TRUE)

## Generate a fuzzy model with frbs.gen.
## It should be noted that for TSK model, we do not need to input:
## num.fvaloutput, varout.mf, names.varoutput, type.defuz.
##
object <- frbs.gen(range.data, num.fvalinput, names.varinput, num.fvaloutput = NULL,
                   varout.mf = NULL, names.varoutput = NULL, rule,
                   varinp.mf, type.model, type.defuz = NULL, type.tnorm, type.snorm, func.tsk, colnames.var,
                   type.implication.func, name)

## We can plot the membership function
plotMF(object)

## Predicting using new data.
res <- predict(object, newdata)$predicted.val