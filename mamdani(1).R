## This example shows how to use frbs without
## learning process.
## Note: some variables might be shared for other examples.

## Define shape and parameters of membership functions of input variables.
## Please see fuzzifier function to contruct the matrix.
# varinp.mf <- matrix(c(2, 0, 20, 40, NA, 4, 20, 40, 60, 80, 3, 60, 80, 100, NA,
# 2, 0, 35, 75, NA, 3, 35, 75, 100, NA,
# 2, 0, 20, 40, NA, 1, 20, 50, 80, NA, 3, 60, 80, 100, NA,
# 2, 0, 20, 40, NA, 4, 20, 40, 60, 80, 3, 60, 80, 100, NA),
# nrow = 5, byrow = FALSE)

library('frbs')

varinp.mf <- matrix(c(4, 0, 0, 31, 63, 
                      1, 31,63,95, NA,
                      1, 63,95,127, NA,
                      1, 95,127,159, NA,
                      1, 127,159,191, NA,
                      1, 159,191,227, NA,
                      4, 191,227,255,255,
                      4, 0, 0, 31, 63, 
                      1, 31,63,95, NA,
                      1, 63,95,127, NA,
                      1, 95,127,159, NA,
                      1, 127,159,191, NA,
                      1, 159,191,227, NA,
                      4, 191,227,255,255
                      ),
                    nrow = 5, byrow = FALSE)

## Define number of fuzzy terms of input variables.
## Suppose, we have 3, 2, 3, and 3 numbers of fuzzy terms
## for first, second, third and fourth variables, respectively.
num.fvalinput <- matrix(c(7,7), nrow=1)

## Give the names of the fuzzy terms of each input variable.
## It should be noted that the names of the fuzzy terms must be unique,
## so we put a number for making it unique.
varinput.1 <- c("a1", "a2", "a3","a4","a5","a6","a7")
varinput.2 <- c("b1", "b2", "b3","b4","b5","b6","b7")

names.varinput <- c(varinput.1, varinput.2)

## Set interval of data.
range.data <- matrix(c(0,255, 0,255, 0,255), nrow=2)

## Set weighted average method to be used as defuzzification method.
type.defuz <- "COG"
## We are using standard t-norm and s-norm.
type.tnorm <- "MIN"
type.snorm <- "MAX"
type.implication.func <- "ZADEH"

## Give the name of simulation.
name <- "Sim-0"

## Provide new data for testing.
newdata<- matrix(c(100, 70), nrow= 1, byrow = TRUE)
## the names of variables
colnames.var <- c("input1", "input2", "output1")

###################################################################
## 1. The following codes show how to generate a fuzzy model using the frbs.gen function
## 1a. Using Mamdani Model
####################################################################
## Define number of fuzzy terms of output variable.
## In this case, we set the number of fuzzy terms to 3.
num.fvaloutput <- matrix(c(7), nrow=1)

## Give the names of the fuzzy terms of the output variable.
## Note: the names of the fuzzy terms must be unique.
varoutput.1 <- c("e1", "e2", "e3","e4","e5","e6","e7")
names.varoutput <- c(varoutput.1)

## Define the shapes and parameters of the membership functions of the output variables.
varout.mf <- matrix(c(4, 0, 0, 31, 63, 
                      1, 31,63,95, NA,
                      1, 63,95,127, NA,
                      1, 95,127,159, NA,
                      1, 127,159,191, NA,
                      1, 159,191,227, NA,
                      4, 191,227,255,255),
                    nrow = 5, byrow = FALSE)

## Set type of model which is 1 or 2 for Mamdani or Takagi Sugeno Kang model, respectively.
## In this case, we choose Mamdani model.
type.model <- "MAMDANI"

## Define the fuzzy IF-THEN rules;
## there are two kinds of model: Mamdani and Takagi Sugeno Kang model
## if we use the Mamdani model then the consequent part is a linguistic term,
## but if we use Takagi Sugeno Kang then we build a matrix representing
## linear equations in the consequent part.
## In this example we are using the Mamdani model
## (see the type.model parameter).
## Note:
## "a1", "and", "b1, "->", "e1" means that "IF inputvar.1 is a1 and inputvar.2 is b1 THEN outputvar.1 is e1"
## Make sure that each rule has a "->" sign.
rule <- matrix(c("a1","and","b4","->","e7",
                 "a4","and","b1","->","e7",
                 "a2","and","b4","->","e6",
                 "a3","and","b5","->","e5",
                 "a5","and","b3","->","e3",
                 "a7","and","b4","->","e1",
                 "a4","and","b3","->","e5",
                 "a4","and","b2","->","e6"
                 ),
               nrow=8, byrow=TRUE)

## Generate a fuzzy model with frbs.gen.
object <- frbs.gen(range.data, num.fvalinput, names.varinput, num.fvaloutput, varout.mf,
                   names.varoutput, rule, varinp.mf, type.model, type.defuz, type.tnorm,
                   type.snorm, func.tsk = NULL, colnames.var, type.implication.func, name)

## We can plot the membership function
plotMF(object)

## Predicting using new data.
res <- predict(object, newdata)$predicted.val
print(res)