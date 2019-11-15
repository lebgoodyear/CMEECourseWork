############## Practical on Allele and Genotype frequencies ################

# clear workspace
rm(ls=(list))

# load packages
library(plyr)
library(stringr)
library(ggplot2)

# load bear csv data
bears <- read.csv("../Data/bears.csv", 
                  stringsAsFactors = F, 
                  header = F, 
                  colClasses = c("character"))

nos <- c()
for (i in 1:200){
  if (i %% 2 == 0) {
    i <- i-1
    nos <- c(nos, i)
  }
  else{
    i <- i
    nos <- c(nos, i)
  }
}

SNPs <- data.frame()
for (i in 1:10000) {
  if (length(unique(bears[,i])) > 1) {
    if (length(SNPs) < 1) {
      SNPs <- bears[,i] }
    else {
      SNPs <- cbind(SNPs, bears[,i])
    }  
  }
}

colnames(SNPs)[1:100] <- paste("SNP", 1:100)
colnames(SNPs) <- str_replace_all(colnames(SNPs), c(" " = "."))

F_allele <- data.frame(matrix(ncol = 3, nrow = 200))   
colnames(F_allele) <- c("SNP", "Alleles", "Frequencies")

v <- c()
b <- c()
for (i in 1:100) {
    v <- c(v, unique(SNPs[,i]))
    b <- c(b, table(SNPs[,i]))
}

F_allele$Alleles <- v
F_allele$Counts <- b
F_allele$Frequencies <- as.numeric(F_allele$Counts)/40

F_allele$SNP <- as.factor(c(nos))

#ggplot(F_allele, aes(x = SNPs, y = Frequencies, colour = Alleles)) +
#      geom_bar(stat = "identity")




#p <- c()
#for (i in 1:199) {
#  if (F_allele$SNP[i] == F_allele$SNP[i+1]) {
#    p[i] <- c(paste(F_allele$Alleles[i], F_allele$Alleles[i+1]))
#    p[i+1] <- c(paste(F_allele$Alleles[i], F_allele$Alleles[i+1]))
#  }
#}

#F_allele$Genotype <- p






                       
                       
                       
