library(reshape2)

# create a matrix
GenerateMatrix <- function(N){
    M <- matrix(runif(N * N), N , N)
    return(M)
}

M <- GenerateMatrix(10)

# turn matrix into dataframe
Melt <- melt(M)

p <- ggplot(Melt, aes(Var1, Var2, fill=value)) + geom_tile() + theme(aspect.ratio = 1)

# add a black line diving each cell
p + geom_tile(colour = "black")

# remove all axes, titles, labels, legends etc.
p + theme(legend.position = "none",
          panel.background = element_blank(),
          axis.ticks = element_blank(), 
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.text.x = element_blank(),
          axis.title.x = element_blank(),
          axis.text.y = element_blank(),
          axis.title.y = element_blank())

# a more compact way to remove everything
p + theme(legend.position = "none",
          panel.background = element_blank(),
          axis.ticks = element_blank(), 
          panel.grid = element_blank(),
          axis.text = element_blank(),
          axis.title = element_blank())

# explore some colours
p + scale_fill_continuous(low = "yellow", high = "darkgreen")
p + scale_fill_gradient2()
p + scale_fill_gradientn(colours = grey.colors(10))
p + scale_fill_gradientn(colours = rainbow(10))
p + scale_fill_gradientn(colours = c("red", "white", "blue"))

