m = 2
num_clusters = 3
num_iterations = 100

x = list()
x = iris[-5]

normalize <- function(x){
  (x-min(x))/(max(x)-min(x))
}

x = normalize(x)

mu = list()
for(i in seq(1,num_clusters)){
  mu[[i]] = runif(n = length(x[[i]]))
}

#normalize
for(i in seq(1,num_clusters)){
  mu[[i]] = mu[[i]] /  Reduce("+",mu[[i]])
}


for(i in seq(1,num_iterations)){
  #centroid
  centroid = list()
  for(i in seq(1,num_clusters)){
    centroid[[i]] = rep(1,length(x))  #dummy initialization
    for(j in seq(1,length(x))){
      centroid[[i]][j] = sum(mu[[i]]^m*x[[j]])/sum(mu[[i]]^m)
    }
  }
  
  #distance
  dist = list()
  for(i in seq(1,num_clusters)){
    dist[[i]] = rep(0,length(x[[1]]))  #dummy initialization
    for(j in seq(1,length(x))){
      dist[[i]] = dist[[i]] + (centroid[[i]][j]-x[[j]])^2
    }
    dist[[i]] = 1 / sqrt(dist[[i]]) #reciprocal also done
  }
  
  
  #membership
  for(i in seq(1,num_clusters)){
    mu[[i]] = (  dist[[i]]^(1/(m-1)) ) / ( Reduce("+",dist)^(1/(m-1)) )
  }
}



#print
df = data.frame(x,mu)

for(i in seq(1,length(x))){
  colnames(df)[i] = paste("x",i,sep="")
}
for(i in seq(1,num_clusters)){
  colnames(df)[i+length(x)] = paste("mu",i,sep="")
}

c = colnames(df[(length(x)+1):(length(x)+num_clusters)])[apply(df[(length(x)+1):(length(x)+num_clusters)],1,which.max)]
df = cbind(df,c)
print(df)


## Plot
library(ggplot2)
ggplot(data = iris, aes(x=Petal.Length, y=Petal.Width)) +
geom_point(aes(color=Species, shape=Species)) +
  xlab("Petal Length") + 
  ylab("Petal Width") +
  ggtitle("Source - Petal Length vs Width")


# Clusters
ggplot(data = cbind(iris[-5],df$c), aes(x=Petal.Length, y=Petal.Width)) +
geom_point(aes(color=c, shape=c)) +
  xlab("Petal Length") + 
  ylab("Petal Width") +
  ggtitle("Clusters - Petal Length vs Width")
########################################################################
# Replace values
df$c <- as.character(df$c)
df$c[df$c == "mu1"] <- "setosa"
df$c[df$c == "mu2"] <- "virginica"
df$c[df$c == "mu3"] <- "versicolor"


# Accuracy Measures
library(caret)
tbl = table(iris$Species,df$c)
confusionMatrix(tbl)

for( level in levels(iris$Species)){

  print("___________________________________________")
  print(level)
  print(paste("Precision: ",precision(tbl,relevant = level)))
  print(paste("Recall: ",recall(tbl,relevant = level)))
  print(paste("F1 Measure: ",F_meas(tbl,relevant = level)))
  
}
print("___________________________________________")

library(precrec)
#precrec_obj <- evalmod(scores = y, labels = x)
#autoplot(precrec_obj)
