require(mclust)
require(ggfortify)
require(party)
require(rpart)
library(rpart)				        
library(rattle)					
library(rpart.plot)				
library(RColorBrewer)				
library(party)					
library(partykit)				
library(caret)					
library("data.tree")
library("visNetwork")


wdbcOriginal <- wdbc

originalClasses <- wdbcOriginal$V2
drops <- c("V1", "V2")
wdbcData <- wdbcOriginal[, !(names(wdbcOriginal) %in% drops)]

# Clustering using EM algorithm
#=========================================================================
fit <- Mclust(wdbcData)

summary(fit, parameters = TRUE)

plot(fit, what = "BIC")
table(originalClasses, fit$classification)

wdbcDataNew <- wdbcData
wdbcDataNew["Clusters"] <- fit$classification
wdbcDataWithClasses <- wdbcDataNew
wdbcDataWithClasses['Severity'] <- originalClasses
wdbcDataNew <- split(wdbcDataNew, wdbcDataNew$Clusters) # splitting the data according to clusters
wdbcDataWithClasses <- split(wdbcDataWithClasses, wdbcDataWithClasses$Clusters)
wdbcDataClusters <- wdbcDataNew

for(i in 1:length(wdbcDataNew)) {
  drops <- c("Clusters")
  wdbcDataNew[[i]] <- wdbcDataNew[[i]][, !(names(wdbcDataNew[[i]]) %in% drops)]
  wdbcDataWithClasses[[i]] <- wdbcDataWithClasses[[i]][, !(names(wdbcDataWithClasses[[i]]) %in% drops)]
}


# ========================================================================
#PCA

pcaResult <- c()

for(i in 1:length(wdbcDataNew)) {
  for(eachData in wdbcDataNew[[i]]) {
    eachData = as.numeric(as.factor(eachData))
  }
  # wdbcDataNew[[i]]$BIRADS = as.numeric(as.factor(wdbcDataNew[[i]]$BIRADS))
  # wdbcDataNew[[i]]$Age = as.numeric(as.factor(wdbcDataNew[[i]]$Age))
  # wdbcDataNew[[i]]$Shape = as.numeric(as.factor(wdbcDataNew[[i]]$Shape))
  # wdbcDataNew[[i]]$Margin = as.numeric(as.factor(wdbcDataNew[[i]]$Margin))
  # wdbcDataNew[[i]]$Density = as.numeric(as.factor(wdbcDataNew[[i]]$Density))
  # 
  pcaResult <- prcomp(wdbcDataNew[[i]])
  cat("\n========================================================================\n\n")
  print(paste('Cluster',i))
  print(pcaResult)
  cat("\n========================================================================\n")
  print(autoplot(pcaResult, data = wdbcDataClusters[[i]], colour = "Clusters"))
}

#==========================================================================

#CART
for(i in 1:length(wdbcDataNew)) {
  wdbcDataWithClasses[[i]]$BIRADS = as.numeric(as.factor(wdbcDataWithClasses[[i]]$BIRADS))
  wdbcDataWithClasses[[i]]$Age = as.numeric(as.factor(wdbcDataWithClasses[[i]]$Age))
  wdbcDataWithClasses[[i]]$Shape = as.numeric(as.factor(wdbcDataWithClasses[[i]]$Shape))
  wdbcDataWithClasses[[i]]$Margin = as.numeric(as.factor(wdbcDataWithClasses[[i]]$Margin))
  wdbcDataWithClasses[[i]]$Density = as.numeric(as.factor(wdbcDataWithClasses[[i]]$Density))
}

tree <- rpart(Severity ~ ., data = wdbcDataWithClasses[[1]], control = rpart.control(cp = 0.0001))
printcp(tree)

bestcp <- tree$cptable[which.min(tree$cptable[,"xerror"]),"CP"]

# Step3: Prune the tree using the best cp.
tree.pruned <- prune(tree, cp = bestcp)

prp(tree)
prp(tree.pruned, faclen = 0, cex = 0.8, extra = 1)
text(tree, cex = 0.8, use.n = TRUE, xpd = TRUE)
#======================================================================
