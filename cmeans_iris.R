m = 2
num_clusters = 3
num_iterations = 10

x = list()
x = iris[-5]

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

