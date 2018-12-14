# Analyse spatial patterns with spatstat
# lam94@cam.ac.uk
# input: Sel_____ csv file with x-y localisation, mask with the same name except the beginnin: Win_____ 
# as returned by SelectLocalisations.m  in the datafolder
#!!! Window: in anti-clockwise order, no repeats!

library(scatterplot3d)
library(spatstat)


datafolder <- "D:/Projects/WaveSM/Test/"

files <- list.files(datafolder, pattern = "^Sel.*\\.csv$")


for (k in 1:length(files)){
  pb = read.csv(paste(datafolder,files[k], sep =''),  header = FALSE, col.names = c( "x","y"), skip = 0)

  win = read.csv(paste(datafolder,sub("Sel", "Win", files[[k]]) , sep =''), header = FALSE, col.names = c( "x","y"), skip = 0)  
  P<- ppp(pb$y, pb$x, poly = list(x=win$y,y=win$x))
  
  Th<-thomas.estK(P, startpar=c(kappa = 1, sigma2 = 2), lambda=NULL, q=1/4, p=2) #,rmin = NULL, rmax = NULL)
  kk<-Th$modelpar[1]
  ss<-Th$modelpar[2]
  mm<-Th$modelpar[3]
  Th2<-thomas.estpcf(P, startpar=c(kappa = 0.04, sigma2 = 0.6), lambda=NULL, q=1/4, p=2,rmin = NULL, rmax = NULL)	
  k2<-Th2$modelpar[1]
  s2<-Th2$modelpar[2]
  m2<-Th2$modelpar[3]

  res<-cbind(kk,mm, ss, k2, s2,m2,P$n)
  write.csv(res, file = paste(datafolder,sub( ".csv", "Params.csv", files[[k]]) , sep =''))
  
  
  dev.off()   
  png(paste(datafolder,sub( ".csv", "PP.png", files[[k]]) , sep =''))
  plot(P, cols = "dark red", pch = ".")
  dev.off()
  
  pc<-pcf(P)
  png(paste(datafolder,sub( ".csv", "PCF.png", files[[k]]) , sep =''))
  plot(pc, main = "pcf")
  dev.off()

  esig<-envelope(P, fun=pcf, nsim=19)
  png(paste(datafolder,sub( ".csv", "PCFenv.png", files[[k]]) , sep =''))
  plot(esig, main = "pcf, 19 simulations")
  dev.off()
  
  kT<-  kppm(P, ~1, "Thomas")
  #kppm(P ~ 1, "Thomas", improve.type = "quasi")
  
  
}



