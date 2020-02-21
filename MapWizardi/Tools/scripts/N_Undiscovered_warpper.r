
# Use function NDepositsPmf to generate probability distributions for the number of undiscovered deposits.
# Function NDepositsPmf is a combination of the corresponding Mark3 and Mark4 functions to include
# all the three approaches present in Mark3 and Mark4.

source("NDepositsPmf_JT.R")

# Fit input data (90,50 and 10 percentiles from several experts) to the negative binomial function
# Input data
indat<-("C:/Temp/mapWizard/undiscovered_deposits/nDepEst.csv")
N_data<-read.csv(indat,header=TRUE)
# Output pdf file for the plot
pdf("C:/Temp/NegBinPlot.pdf")
# Call NDepositsPmf function
NUnDisc<-NDepositsPmf("NegBinomial",list(nDepEst=N_data))
# Create the plot and statistics summary
plot(NUnDisc)
summary(NUnDisc)
graphics.off()

# Normalize and plot given number-probability pairs
nlist<-c(0,1,2,3,4,5,6,8,10,15,20)
rel6<-c(0,10,30,60,80,100,70,40,10,5,1)
pdf("C:/Temp/Mark4Plot.pdf")
NUnDisc<-NDepositsPmf("CustomMark4",list(nDeposits=nlist, relProbabilities=rel6))
print(NUnDisc)
plot(NUnDisc)
summary(NUnDisc)
graphics.off()

# Use the approach by Singer, D., and Menzie, W.D., 2010,
# Quantitative Mineral Resource Assessments: An Integrated Approach: Oxford University Press.
#N_data<-c(1,5,13,16,21)
N_data <- read.csv("C:/Temp/mapWizard/undiscovered_deposits/nDepEstMiddle.csv")

pdf("C:/Temp/Mark3Plot_FromNegBinDistr.pdf")
NUnDisc<-NDepositsPmf("CustomMark3",list(nDepEst=N_data))
print(NUnDisc)
plot(NUnDisc)
summary(NUnDisc)
graphics.off()

