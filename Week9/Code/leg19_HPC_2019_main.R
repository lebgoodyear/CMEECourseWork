# CMEE 2019 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything 
# yourself from scratch please ensure you use EXACTLY the same function and parameter names and 
# beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Lucy Goodyear"
preferred_name <- "Lucy"
email <- "leg19@imperial.ac.uk"
username <- "leg19"
personal_speciation_rate <- 0.002216 # will be assigned to each person individually in class and 
# should be between 0.002 and 0.007

# Question 1
# calculates species richness (number of unique species) in a system (community)
species_richness <- function(community){
  return(length(unique(community)))
}

# Question 2
# returns a sequence of 1 : max_size of community, representing an initial state 
# of the community with the maximum possible number of species, with each species
# referenced by an index number between 1 and max_size
init_community_max <- function(size){
  return(seq(1, size))
}

# Question 3
# returns a sequence of length max_size, containing all 1s.
# an alternative initial state of the community with the minimum possible
# number of species (monodominance of one species, with index 1)
init_community_min <- function(size){
  return(rep(1, size))
}

# Question 4
# returns two randomly chosen values between 1 and a max value
choose_two <- function(max_value){
  return(sample(1:max_value, 2, replace = FALSE))
}

# Question 5
# returns the state of a community after an individual of one species has died 
# and been replaced by an individual of one of the other species
neutral_step <- function(community){
  replace <- choose_two(length(community)) # picks two individuals at random
  # one individual is replaced by the species of the other
  community[replace[1]] <- community[replace[2]]
  return(community)
}

# Question 6
# calculate state of community after ONE generation has passed,
# where one generation is number of individuals divided by 2
neutral_generation <- function(community){
  # if statements to ensure rounding of odd community numbers averages to
  # correct half value over time
  x <- runif(1)
  if (x < 0.5){ 
    steps <- floor((length(community) / 2))
  }
  else{
    steps <- ceiling((length(community) / 2))
  }
  # calculate state of community at each step
  for (i in 1:steps){
    community <- neutral_step(community)
  }
  return(community) # return final state of community
}

# Question 7
# calculate species richness in community at each generation in "duration" number of generations
neutral_time_series <- function(community, duration){
  species_rich_gens <- c(species_richness(community)) # set initial species richness as first value
  for (t in 1:duration){ # for loop over the generations
    community <- neutral_generation(community) # state of community after t generations
    # calculate species richness after t generations and append to vector
    species_rich_gens <- c(species_rich_gens, species_richness(community))
  }
  # return vector of species richnesses at each generation
  return(species_rich_gens)
}

# Question 8
# plot species richness after "duration" number of generations has passed
question_8 <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  plot(x = 0:200,
       y = neutral_time_series(community = init_community_max(100), duration = 200),
       type = "l",
       ylab = "Species Richness (by generation)",
       xlab = "Time (in generations)")
  return("The system will always converge to a species richness of 1 because you are always 
         replacing the individual that died with an individual from one of the other species, 
         with no new species ever being added. This decreases the species richness because we
         are starting with a community of maximum diversity (one of each species). 
         Over time the species richness will continue decreasing as more species are lost and 
         replaced by existing species, with the probability of the most common species replacing
         a lost individual of another species gradually increasing, eventually converging to a 
         species richness of 1.")
}

# Question 9
# returns the state of a community after an individual of one species has died 
# and either been replaced by an individual of one of the other species or been
# replaced by an entirely new species, the outcome being based on the probability
# of speciation
neutral_step_speciation <- function(community, speciation_rate)  {
  replace <- choose_two(length(community)) # randomly choose two individuals
  # generate random uniform number (runif) and check if larger than speciation rate
  if (runif(1) < speciation_rate) { # if runif smaller, speciation occurs
    new_species <- max(community) + 1 # allocate new species an unused index
    community[replace[1]] <- new_species # replace dead individual with new species
    return(community)
  }
  else { # if runif larger, replacement from existing species occurs
    community[replace[1]] <- community[replace[2]]
    return(community)
  }
}

# Question 10
# calculate state of community after ONE generation has passed, including the 
# possibility of speciation
neutral_generation_speciation <- function(community,speciation_rate)  {
  # if statements to ensure rounding of odd community numbers averages to
  # correct half value over time
  x <- runif(1)
  if (x < 0.5){ 
    steps <- floor((length(community) / 2))
  }
  else{
    steps <- ceiling((length(community) / 2))
  }
  # calculate state of community at each step
  for (i in 1:steps){
    community <- neutral_step_speciation(community, speciation_rate)
  }
  return(community)
}

# Question 11
# calculate species richness in community during "duration" number of generations,
# including the possibility of speciation
neutral_time_series_speciation <- function(community, speciation_rate, duration)  {
  species_rich_gens <- c(species_richness(community)) # set initial species richness as first value
  for (t in 1:duration){ # for loop over the generations
    community <- neutral_generation_speciation(community, speciation_rate) # state of community after t generations
    # calculate species richness after t generations and append to vector
    species_rich_gens <- c(species_rich_gens, species_richness(community))
  }
  # return vector of species richnesses at each generation
  return(species_rich_gens)
}

# Question 12
# plot species richness against time after "duration" number of generations has passed for two
# different initial conditions, including possibility of speciation
question_12 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  duration = 200 # set duration
  plot(x = 0:duration,
       y = neutral_time_series_speciation(community = init_community_max(100), speciation_rate = 0.1, duration),
       type = "l",
       ylab = "Species Richness",
       xlab = "Time (in generations)",
       main = "Neutral Time Series (with speciation)",
       ylim = c(0, 100),
       col = "#D55E00")
  lines(x = 0:duration,
       y = neutral_time_series_speciation(community = init_community_min(100), speciation_rate = 0.1, duration),
       col = "#56B4E9")
  legend("topright", 
         legend = c("Maximum Initial Conditions", "Minimum Initial Conditions"),
         col = c("#D55E00", "#56B4E9"),
         lty = 1, bty = "n")
  return("Regardless of initial conditions, the system will always converge to the same
         equilibrium because speciation rate and length of generation is the same. The system
         reaches a rough equilibrium rather than dropping to a species richness of 1 because of
         the introduction of the speciation rate.")
}

# Question 13
# calculate the species abundance distribution (how many there are of each species)
# in decreasing order of abundance
# note that, because in neutral theory the actual species is interchangable,
# it doesn't matter which abundance belongs to which species
species_abundance <- function(community){
  counts <- as.data.frame(table(community)) # save as dataframe to extract freqs
  return(sort(counts$Freq, decreasing = TRUE)) # return in decreasing order
}

# Question 14
# bin species abundances into octave classes of 2^(n-1) <= abundances < 2^n
octaves <- function(abundance_vector) {
  # use tabulate function where:
  # first argument is the vector to be binned 
  # (we log2 because that is the form of our bins and add one to account for log2(1)=0
  # otherwise all species with one individual would get discounted)
  # second argument (nbin) is the number of bins
  return(tabulate(log2(abundance_vector)+1, nbin = ceiling(log2(max(abundance_vector)))))
}

# Question 15
# sums two vectors after appending the shorter vector with zeros to make it the 
# same length as the longer vector
sum_vect <- function(x, y) {
  if (length(x) < length(y)) {
    x <- c(x, rep(0, length(y) - length(x))) # append zeros to x if shorter
  } 
    else (length(y) < length(x))
      y <- c(y, rep(0, length(x) - length(y))) # append zeros to y if shorter
  return(x+y)
}

# Question 16 
# plot a bar chart of species abundance by octave after 2000 generations at equilibrium
# for two communities with different initial states
question_16 <- function()  {
  # set number of burn generations and number generations at equilibrium to run for
  burn_duration = 200
  eq_duration = 2000
  # set two initial communities, with max and min species richness
  community_min = init_community_min(100)
  community_max = init_community_max(100)
  
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # generate species abundance octaves for community with maximum species richness
  sp_ab_octave_max <- c() # initialise empty vector to store octave results
  for (t in 1:eq_duration){ # loop over number generations at equilibrium
    community_max <- neutral_generation_speciation(community = community_max, speciation_rate = 0.1)
    # record octaves every 20 generations once at equilibrium
    if ((t %% 20 == 0) & (t >= burn_duration)) {
      current_state <- octaves(species_abundance(community_max))
      sp_ab_octave_max <- sum_vect(current_state, sp_ab_octave_max) # sum octaves cumulatively
    }
  }
  
  # generate species abundance octaves for community with minimum species richness
  sp_ab_octave_min <- c()
  for (t in 1:eq_duration){
    community_min <- neutral_generation_speciation(community = community_min, speciation_rate = 0.1)
    if ((t %% 20 == 0) & (t >= burn_duration)) {
      current_state <- octaves(species_abundance(community_min))
      sp_ab_octave_min <- sum_vect(current_state, sp_ab_octave_min)
    }
  }
  
  # calculate how many octaves have been found and stored
  # (will be the same for both simulations)
  counts <- ((eq_duration - burn_duration) / 20) + 1
  # plot bar chart of mean species abundance by octave for both initial communities 
  par(mfrow=c(2,1), oma=c(0,0,2.5,0), mar = c(3,3,2,2), mgp=c(1.5,0.5,0)) # edit margins for neater fit
  barplot(sp_ab_octave_max / counts, # divide sum of octaves by counts to get mean
          ylab = "Mean species abundance",
          xlab = "Species abundance octaves (log2)",
          main = "Initial species richness at maximum",
          names.arg = 1:length(sp_ab_octave_max), # print octaves on x-axis
          col = "#999999", # colour-blind friendly, neutral colour
          cex.main = 0.75, cex.lab = 0.75, cex.names = 0.75, cex.axis = 0.75)
  barplot(sp_ab_octave_min / counts,
          ylab = "Mean species abundance",
          xlab = "Species abundance octaves (log2)",
          main = "Initial species richness at minimum",
          names.arg = 1:length(sp_ab_octave_min),
          col = "#999999", # colour-blind friendly, neutral colour
          cex.main = 0.75, cex.lab = 0.75, cex.names = 0.75, cex.axis = 0.75)
  title(main = "Mean species abundances by octave after 2000 generations\n at equilibrium for two different initial species richnesses", cex.main = 0.95, outer=TRUE)     
  
  return("The initial conditions do not matter because speciation rate is constant so the system
         will always reach the same equilibrium point in terms of species richness.")
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  # set initial community with minimal species diversity
  community <- init_community_min(size)
  # initiliase vectors to store species richnesses and abundance octaves with
  # first values being the richness and abundance octaves of the initial state
  species_richness_vector <- c(species_richness(community))
  octaves_list <- list(octaves(species_abundance(community)))
  # start timer
  timer <- proc.time()
  # start counter
  t <- 1
  # while loop to apply neutral_generation_speciation function for wall_time amount of time
  while ((proc.time()[3] - timer[3]) < (wall_time)*60){
    community <- neutral_generation_speciation(community, speciation_rate)
    if ((t <= burn_in_generations) & (t %% interval_rich == 0)){ # only measure richness during burn in
      species_richness_vector <- c(species_richness_vector, species_richness(community))
    }
    if (t %% interval_oct == 0){ # record abundance octaves for whole simulation
      octaves_list[[length(octaves_list)+1]] = octaves(species_abundance(community))
    }
    # add to timer after every generation
    t <- t + 1
  }
  # calculate time taken for simulation
  time_taken = proc.time()[3] - timer[3]
  # save all neccessary data in output file
  save(species_richness_vector,
       octaves_list, 
       community, 
       time_taken, 
       speciation_rate, 
       size, 
       wall_time, 
       interval_rich, 
       interval_oct, 
       burn_in_generations,
       file = output_file_name)
}

# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function(){
  # initialise empty vectors to store sum totals of octave data for each size
  octaves_500 <- c()
  octaves_1000 <- c()
  octaves_2500 <- c()
  octaves_5000 <- c()
  # set counters to count each octave per size
  counter_500 <- 0
  counter_1000 <- 0
  counter_2500 <- 0
  counter_5000 <- 0
  
  # generate list of results files
  files <- list.files(path = "../Results/leg19_cluster_results/", pattern = "*.rda")
  
  # set for loop over files to extract octave information
  for (i in files){
    load(paste0("../Results/leg19_cluster_results/",i)) # load each file
    octaves_tot <- c() # initliase empty octave vector for i file octave sum
    counter <- 0 # reset counter to 0
    
    # loop over each octave in file i
    for (j in 1:length(octaves_list)){
      if (j > (burn_in_generations/interval_oct)){ # don't inlcude octaves from burn in period
        # sum all octaves in file i
        octaves_tot <- sum_vect(octaves_tot, octaves_list[[j]])
        # count all octaves in file i
        counter <- counter + 1
      }
    }
    
    # set if statements to sum octaves over each size
    if (size == 500){
      octaves_500 <- sum_vect(octaves_500, octaves_tot)
      # add file i count to total count for that size
      counter_500 <- counter_500 + counter
    }
    if (size == 1000){
      octaves_1000 <- sum_vect(octaves_1000, octaves_tot)
      counter_1000 <- counter_1000 + counter
    }
    if (size == 2500){
      octaves_2500 <- sum_vect(octaves_2500, octaves_tot)
      counter_2500 <- counter_2500 + counter
    }
    if (size == 5000){
      octaves_5000 <- sum_vect(octaves_5000, octaves_tot)
      counter_5000 <- counter_5000 + counter
    }
  }
  
  # calculate mean for each octave bin per size
  octaves_means_500 <- octaves_500 / counter_500
  octaves_means_1000 <- octaves_1000 / counter_1000
  octaves_means_2500 <- octaves_2500 / counter_2500
  octaves_means_5000 <- octaves_5000 / counter_5000
  
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  par(mfrow = c(2, 2), oma=c(0,0,2.5,0)) # edit outer margin property to make space for title
  barplot(octaves_means_500,
          ylab = "Mean species abundance",
          xlab = "Species abundance octaves (log2)",
          main = "Community of size 500",
          cex.main = 0.9,
          cex.names = 0.9,
          col = "#999999", # colour-blind friendly, neutral colour
          names.arg = 1:length(octaves_500)) # print octaves on x-axis
  barplot(octaves_means_1000,
          ylab = "Mean species abundance",
          xlab = "Species abundance octaves (log2)",
          main = "Community of size 1000",
          cex.main = 0.9,
          cex.names = 0.9,
          col = "#999999",
          names.arg = 1:length(octaves_1000))
  barplot(octaves_means_2500,
          ylab = "Mean species abundance",
          xlab = "Species abundance octaves (log2)",
          main = "Community of size 2500",
          cex.main = 0.9,
          cex.names = 0.9,
          col = "#999999",
          names.arg = 1:length(octaves_2500))
  barplot(octaves_means_5000,
          ylab = "Mean species abundance",
          xlab = "Species abundance octaves (log2)",
          main = "Community of size 5000",
          cex.main = 0.9,
          cex.names = 0.9,
          col = "#999999",
          names.arg = 1:length(octaves_5000))
  title(main = "Mean species abundance octaves for different community sizes", outer=TRUE) 
  
  # create list output to be returned and save as rda file
  combined_results <- list(octaves_means_500, octaves_means_1000, octaves_means_2500, octaves_means_5000)
  save(combined_results, file = "../Results/leg19_cluster_results.rda")
  # print list output in readable format
  return(cat("\nMean octave outputs for size 500:\n", octaves_means_500, "\n",
      "\nMean octave outputs for size 1000:\n", octaves_means_1000, "\n",
      "\nMean octave outputs for size 2500:\n", octaves_means_2500, "\n",
      "\nMean octave outputs for size 5000:\n", octaves_means_5000, "\n", "\n"))
}

# Question 21
question_21 <- function()  {
  D <- log(8)/log(3)
  return(list(D, paste0("By eye, we can see that scaling one side of the object by 3 scales the area by 8, which is 3 to the power of ", round(D, 6), 
                       ". To calculate this, use the equation N(delta) = K * delta^(-D) and set K = 1. ",
                       "Then by logging both sides and substituting our values, we have log(8) = -D*log(3), ",
                       "where fractional dimension = -1 * gradient. So D = log(8)/log(3)")))
}

# Question 22
question_22 <- function()  {
  D <- log(20)/log(3)
  return(list(D, paste0("By eye, we can see that scaling one side of the object by 3 scales the volume by 20, which is 3 to the power of ", round(D, 6), 
                        ". To calculate this, use the equation N(delta) = K * delta^(-D) and set K = 1. ",
                        "Then by logging both sides and substituting our values, we have log(20) = -D*log(3), ",
                        "where fractional dimension = -1 * gradient. So D = log(20)/log(3)")))
}

# Question 23
chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  # create a new plot
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 5), ylim=c(0, 5))
  # store the stationary points as a list
  store <- list(A = c(0,0), B = c(3,4), C = c(4,1))
  # set starting point
  x <- c(0,0)
  for (i in 1:15000){
    # choose one of A, B, C at random
    chosen_point <- sample(store, 1)
    # assign new point half the distance between start point and chosen point
    x[1] <- x[1] + (unlist(chosen_point)[1] - x[1])/2
    x[2] <- x[2] + (unlist(chosen_point)[2] - x[2])/2
    # plot new point, which becomes the new start point
    points(x[1],
           x[2],
           cex = 0.05)
  }
  return("A Sierpinski Gasket emerges but of a scalene triangle rather than an equiliateral triangle. 
         This is a fractal object that is created with three stationary points and an initial start point, which
         was the origin in this case. The initial start point is moved half way towards one of the stationary points,
         which then becomes the new start point for the next iterations. This fractal was created with 15,000 iterations.")
}

# open plot to test turtle function
#graphics.off()
#plot(1, type="n", xlab="", ylab="", xlim=c(0, 4), ylim=c(0, 4))

# Question 24
turtle <- function(start_position, direction, length)  {
  # extract x and y coordinates of starting position
  x0 <- start_position[1]
  y0 <- start_position[2]
  # calculate new point given the input parameters
  x <- length * cos(direction) + x0
  y <- length * sin(direction) + y0
  # draw a line segment between starting position and new point
  segments(x0, y0, x1 = x, y1 = y)
  # extract the endpoint to be returned
  endpoint <- c(x,y)
  return(endpoint) # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  # call turtle function to draw segment first segment
  new_points <- turtle(start_position, direction, length)
  # call turtle function again on new_points with the below input parameters
  second_call <- turtle(c(new_points[1],new_points[2]), direction - pi/4, length*0.95)
  return(second_call)
}

# Question 26
spiral <- function(start_position, direction, length)  {
  # call turtle function to draw segment first segment
  new_points <- turtle(start_position, direction, length)
  if (length > 0.005) { # if statement otherwise recursive function will never end
    # call spiral recursively to draw subsequent segments
    spiral(c(new_points[1], new_points[2]), direction - pi/4, length*0.95)
  }
  return("An error message occurs: 'Error: C stack usage  7970112 is too close to the limit.'
         This happens because there is no end point to the recursive function so it will keep calling
         itself infinitely many times, which the computer cannot handle becuase it cannot allocate memory
         for inifinitely many lines. To solve this include an if statement to set a limit, e.g. stop 
         when the length reaches a certain threshold.")
}

# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  # create a new plot window
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 5), ylim=c(0, 5))
  # call spiral function, which prints to plot
  return(spiral(c(0.5,3), pi/4, 1.5))
}

# Question 28
tree <- function(start_position, direction, length)  {
  # assign first point using turtle
  new_point <- turtle(start_position, direction, length)
  # start points for both left and right branches are the same
  if (length > 0.007) { # if statement otherwise recursive function will never end
    # call tree recursively to draw subsequent segments  
    tree(new_point, direction - pi/4, length*0.65)
    tree(new_point, direction + pi/4, length*0.65)
  }
  return(0)
  
}
draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  # create a new plot window
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 3.5), ylim=c(0,3.5))
  # call tree function, which prints to plot
  return(tree(c(1.75,0.25), pi/2, 1))
}

# Question 29
fern <- function(start_position, direction, length)  {
  # assign first point using turtle function
  new_point <- turtle(start_position, direction, length)
  # start points for both left and straight branches are the same
  if (length > 0.005) { # if statement otherwise recursive function will never end
    # call fern recursively to draw subsequent segments
    fern(new_point, direction, length*0.87) # straight branches
    fern(new_point, direction + pi/4, length*0.38) # left branches
  }
  return(0)
  
}
draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  # create a new plot window
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 4), ylim=c(0,4))
  # call fern function, which prints to plot
  return(fern(c(2,0.2), pi/2, 0.5))
}

# Question 30
fern2 <- function(start_position, direction, length, dir)  {
  # assign first point using turtle function
  new_point <- turtle(start_position, direction, length)
  # start points for left, right and straight bracnhes are the same
  if (length > 0.005) { # if statement otherwise recursive function will never end
    fern2(new_point, direction + (dir * (pi/4)), length*0.38, dir) 
    fern2(new_point, direction, length*0.87, -(dir)) 
  }
  return(0)
}

draw_fern2 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  # create a new plot window
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 6), ylim=c(0,5))
  # call fern2 function, which prints to plot
  return(fern2(c(3,0.5), pi/2, 0.5, 1))
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
# plot mean species richness against time after "duration" number of generations has passed for two systems with
# different initial conditions, including possibility of speciation, across a large number of 
# repeat simulations
Challenge_A <- function() {
  
  # define number of generations and number of repeat simulations to perform
  duration = 100
  repeats = 75 # could be increased at expense of increased runtime
 
  # create matrix of repeated simulations
  max_mat <- replicate(repeats, neutral_time_series_speciation(community = init_community_max(100), speciation_rate = 0.1, duration))
  min_mat <- replicate(repeats, neutral_time_series_speciation(community = init_community_min(100), speciation_rate = 0.1, duration))
  
  # calculate confidence intervals and store as matrix
  z <- qnorm((1-0.972)/2) # calculate z-score
  max_ci <- apply(max_mat, 1, function(x) {mean(x)+c(z, -z)*sd(x)/sqrt(length(x))})
  min_ci <- apply(min_mat, 1, function(x) {mean(x)+c(z, -z)*sd(x)/sqrt(length(x))})
  
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # plot bar chart of mean species richness as a function of time for both initial communities 
  
  # plot for community with maximum initial diversity
  plot(x = 0:duration,
       y = rowSums(max_mat,na.rm=T)/repeats, # get mean at each time point
       type = "l",
       ylab = "Species Richness",
       xlab = "Time (in generations)",
       main = paste("Neutral Time Series (with 97.2% confidence interval),\naveraged after", repeats, "simulations"),
       xlim = c(0, duration),
       ylim = c(0, 100),
       col = "#D55E00")
  # plot upper and lower CI
  lines(x = 0:duration,
        y = max_ci[1,],
        lwd = 0.1)
  lines(x = 0:duration,
        y = max_ci[2,],
        lwd = 0.1)
  # fill confidence intervals transparent grey for easy viewing
  polygon(c(0:duration, rev(0:duration)), c(max_ci[2,], rev(max_ci[1,])),
          col = rgb(128,128,128, 100, max = 255), # alpha = 100 indicates transparancy
          border = NA)
  
  # plot for community with minimum initial diversity
  lines(x = 0:duration,
        y = rowSums(min_mat,na.rm=T)/repeats,
        col = "#56B4E9")
  # plot upper and lower CI
  lines(x = 0:duration,
        y = min_ci[1,],
        lwd = 0.1)
  lines(x = 0:duration,
        y = min_ci[2,],
        lwd = 0.1) 
  # fill confidence intervals transparent grey for easy viewing
  polygon(c(0:duration, rev(0:duration)), c(min_ci[2,], rev(min_ci[1,])),
          col = rgb(128,128,128, 70, max = 255),
          border = NA)
  
  # add to graph the estimated number of generations needed for system to reach dynamic equilibrium
  abline(v = 30, col = "#E79F00", lwd = 1, lty = 2)
  text(40, 60, "Estimated number of generations needed for\nsystem to reach dynamic equilibrium = 30", cex = 0.75)
  
  # add legend to plot
  legend("topright", 
         legend = c("Maximum Initial Conditions", "Minimum Initial Conditions"),
         col = c("#D55E00", "#56B4E9"),
         lty = 1,
         cex = 0.75,
         bty = "n")
}

# Challenge question B
# plot a graph showing many averaged time series for a whole range of different 
# initial species richnesses
Challenge_B <- function() {
  # choose initial parameters so plot finishes in 30 seconds
  duration <- 50 # number of generations
  repeats <- 40 # number of repeat simulations (for each initial community state)
  no_individuals <- 50 # community size
  
  # create empty plot
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  plot(1, type="n", 
       xlab="Time (in generations)", 
       ylab="Species Richness",   
       main = paste("Neutral Time Series for", no_individuals, "different initial species richnesses,\naveraged on", repeats, "simulations per initial richness"), 
       xlim=c(0, duration), 
       ylim=c(0, no_individuals))
  
  # for loop and if statements to create a wide range of different initial species richnesses
  for (i in (1:no_individuals)){
      community <- rep(1,i) # ensure max and min diversities are included
      # to get higher diversities, don't sample with replacement
      if (i < (no_individuals * 0.3) && (i %% 2)) { # use modulo 2 to limit number of plots (for easy viewing and for faster code)
        community <- c(community, (2:(no_individuals-i)))
        rep_mat <- replicate(repeats, neutral_time_series_speciation(community, speciation_rate = 0.1, duration))
        lines(x = 0:duration,
              y = rowSums(rep_mat,na.rm=T)/repeats, # get mean at each time point
              col = "#D55E00")
      }
      # for lower diversities and for a greater spread of species richnesses, use sample with replacement
      else if (((i+1) %% 2) && (i != no_individuals)) {
        community <- c(community, sample(2:(no_individuals-i), replace = T))
        rep_mat <- replicate(repeats, neutral_time_series_speciation(community, speciation_rate = 0.1, duration))
        lines(x = 0:duration,
              y = rowSums(rep_mat,na.rm=T)/repeats, # get mean at each time point
              col = "#D55E00")
      }
      else if (i == no_individuals) { # ensure min diversity is included
        rep_mat <- replicate(repeats, neutral_time_series_speciation(community, speciation_rate = 0.1, duration))
        lines(x = 0:duration,
              y = rowSums(rep_mat,na.rm=T)/repeats, # get mean at each time point
              col = "#D55E00")
      }
  }
}

# Challenge question C
# plot a graph of mean species richness against simulation generation and use it to estimate
# a more accuarate number of burn-in generations for each community size
Challenge_C <- function() {
  # initialise empty matrices to store the species richness vectors of each iter per size
  species_richness500 <- matrix(nrow = 0, ncol = 4001)
  species_richness1000 <- matrix(nrow = 0, ncol = 8001)
  species_richness2500 <- matrix(nrow = 0, ncol = 20001)
  species_richness5000 <- matrix(nrow = 0, ncol = 40001)
  # initialise empty vectors to store the mean species richnesses
  mean_species_richness500 <- c()
  mean_species_richness1000 <- c()
  mean_species_richness2500 <- c()
  mean_species_richness5000 <- c()
  
  # generate list of results files
  files <- list.files(path = "../Results/leg19_cluster_results/", pattern = "*.rda")
  
  # loop over each file i and store the species richness vectors
  for (i in files){
    load(paste0("../Results/leg19_cluster_results/",i)) # load each file
    if (size == 500) { # store all species richness vectors of the same size together
      species_richness500 <- rbind(species_richness500, species_richness_vector)
    }
    if (size == 1000) {
      species_richness1000 <- rbind(species_richness1000, species_richness_vector)
    }
    if (size == 2500) {
      species_richness2500 <- rbind(species_richness2500, species_richness_vector)
    }
    if (size == 5000) {
      species_richness5000 <- rbind(species_richness5000, species_richness_vector)
    }
  }
  # calculate mean species richnesses for each size
  mean_species_richness500 <- colMeans(species_richness500)
  mean_species_richness1000 <- colMeans(species_richness1000)
  mean_species_richness2500 <- colMeans(species_richness2500)
  mean_species_richness5000 <- colMeans(species_richness5000)
  
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  # plot mean species richness vectors for each size as a time series
  par(mar = c(8,5,3,2), oma=c(2.5,0,0.5,0), mgp=c(1.5,0.5,0), xpd=TRUE) # edit margins for neater fit
  plot(x = 0:700, # only show first 700 generations as this is enough to find start of equilibrium period
       y = mean_species_richness5000[1:701],
       type = "l",
       ylab = "Species Richness",
       xlab = "Time (in generations)",
       main = "Species richness per generation for\n different community sizes",
       xlim = c(0, 700),
       ylim = c(0, 70),
       col = "#D55E00", # use colour-blind friendly palette
       cex.lab = 0.8,
       cex.axis = 0.8,
       cex.main = 0.9)
  lines(x = 0:700,
        y = mean_species_richness2500[1:701],
        col = "#56B4E9")
  lines(x = 0:700,
        y = mean_species_richness1000[1:701], 
        col = "#000000")
  lines(x = 0:700,
        y = mean_species_richness500[1:701], 
        col = "#009E73")
  # add dotted lines to show estimated end of burn-in period for each size
  segments(80, -2, x1 = 80, y1 = 8, col = "#009E73", lwd = 1, lty = 2) 
  segments(150, -2, x1 = 150, y1 = 18, col = "#000000", lwd = 1, lty = 2)
  segments(300, -2, x1 = 300, y1 = 40, col = "#56B4E9", lwd = 1, lty = 2)
  segments(650, -2, x1 = 650, y1 = 70, col = "#D55E00", lwd = 1, lty = 2)
  # add legend, including dotted lines
  legend("bottom", inset=c(0.5,-0.5),
         legend = c("Community size = 500", "Community size = 1000", "Community size = 2500", "Community size = 5000", "",
                    "Estimated number of generations \nneeded for system to reach \ndynamic equilibrium for each size"),
         col = c("#009E73", "#000000", "#56B4E9", "#D55E00", "", "#000000"),
         lty = c(1,1,1,1,0,2),
         bty = "n",
         cex = 0.7,
         # edit spacing for neater viewing
         x.intersp = 1,
         y.intersp = 0.001,
         ncol = 2,
         text.width = 250)
}

# Challenge question D
# first, create a function to calculate species abundances using coalescence theory
coalescence <- function(J,v) {
  # vector of initial community
  lineages <- rep(1, J)
  # initialise empty vector to store abundances
  abundances <- c()
  # set N = J, where J is size of community
  N <- J
  # calculate theta where v is speciation rate
  theta <- v*((N-1)/(1-v))
  # while loop to run until final coalescence occurs on common ancestor
  while (N > 1) {
    randnum <- runif(1) # generate random number
    # if statements based on random number dictate whether speciation occurred
    if (randnum < ((theta)/(theta+N-1))) { # speciation occurred
      j <- sample(1:N, 1) # randomly choose an individual
      abundances <- c(abundances, lineages[j]) # add abundance of that species to vector
      lineages <- lineages[-j] # remove individual from initial community
    }
    else if (randnum >= ((theta)/(theta+N-1))) { # speciation did not occur
      s <- sample(1:N, 2, replace = FALSE) # randomly choose 2 individuals
      lineages[s[1]] <- lineages[s[1]] + lineages[s[2]] # add numbers together to symbolise convergence in place of one inidividual
      lineages <- lineages[-s[2]] # remove the other individual from initial community
    }
    N <- N-1 # decrease initial community length by one
  }
  abundances <- c(abundances, lineages[1]) # add remaining element to abundances vector
  return(sort(abundances, decreasing = TRUE)) # return abundances in descending order (so octaves function can be called)
}

# now run coalescence function 25 times on the 4 different community sizes, calculate octaves and plot the
# corresponding barcharts
Challenge_D <- function() {
  # set number of iterations
  iters <- 25
  # initialise empty vectors to store sums of octaves for each size
  total_octaves500 <- c()
  total_octaves1000 <- c()
  total_octaves2500 <- c()
  total_octaves5000 <- c()
  # call coalescence function 25 times on each community size, summing them cumulatively
  for (i in 1:iters){
    total_octaves500 <- sum_vect(total_octaves500, octaves(coalescence(500, 0.002216)))
    total_octaves1000 <- sum_vect(total_octaves1000, octaves(coalescence(1000, 0.002216)))
    total_octaves2500 <- sum_vect(total_octaves2500, octaves(coalescence(2500, 0.002216)))
    total_octaves5000 <- sum_vect(total_octaves5000, octaves(coalescence(5000, 0.002216)))
  }
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  par(mfrow = c(2, 2), oma=c(0,0,2.5,0)) # edit outer margin property to make space for title
  # plot barplots for mean octaves for each community size
  barplot(total_octaves500 / iters, # calculate mean by dividing by number of iterations
          ylab = "Mean species abundance",
          xlab = "Species abundance octaves (log2)",
          main = "Initial community of size 500",
          cex.main = 0.9,
          cex.names = 0.9,
          col = "#999999", # colour-blind friendly, neutral colour
          names.arg = 1:length(total_octaves500 / iters)) # print octaves on x-axis
  barplot(total_octaves1000 / iters,
          ylab = "Mean species abundance",
          xlab = "Species abundance octaves (log2)",
          main = "Initial community of size 1000",
          cex.main = 0.9,
          cex.names = 0.9,
          col = "#999999",
          names.arg = 1:length(total_octaves1000 / iters))
  barplot(total_octaves2500 / iters,
          ylab = "Mean species abundance",
          xlab = "Species abundance octaves (log2)",
          main = "Initial community of size 2500",
          cex.main = 0.9,
          cex.names = 0.9,
          col = "#999999",
          names.arg = 1:length(total_octaves2500 / iters))
  barplot(total_octaves5000 / iters,
          ylab = "Mean species abundance",
          xlab = "Species abundance octaves (log2)",
          main = "Initial community of size 5000",
          cex.main = 0.9,
          cex.names = 0.9,
          col = "#999999",
          names.arg = 1:length(total_octaves5000 / iters))
  title(main = "Mean species abundance octaves for different community sizes, \nusing coalescence theory", outer=TRUE)
  return(paste("Using coalescence theory, the time taken for one run of a community size of 500 is:", system.time(octaves(coalescence(500, 0.002216)))[3],
               "compared to 12 hours using the cluster. Coalescence theory is much faster because we are only simulating the system at equilibrium",
               "and we are only calculating and storing the final species abundances, rather than at each generation."))
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  # create empty multiplot
  par(mfrow = c(2,2), mar=c(3,3,3,3), oma = c(0,0,2,0)) # edit margins for neater fit
  # create first plot
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 5), ylim=c(0, 5),
       main = "Starting point outside fractal area", cex.main = 0.8)
  # store the stationary points as a list
  store <- list(A = c(0,0), B = c(3,4), C = c(4,1))
  # set starting point outside area framed by stationary points
  x <- c(1,4)
  for (i in 1:30){ # plot just the first 30 points
    # choose one of A, B, C at random
    chosen_point <- sample(store, 1)
    # assign new point half the distance between start point and chosen point
    x[1] <- x[1] + (unlist(chosen_point)[1] - x[1])/2
    x[2] <- x[2] + (unlist(chosen_point)[2] - x[2])/2
    # plot new point, which becomes the new start point
    points(x[1],
           x[2],
           cex = 0.5,
           pch = 19, # plot points bigger and in red so more noticeable
           col = "#D55E00") # colour blind friendly red
  }
  # set starting point as the last point from the above loop so simulation can be carried straight on as before
  x <- c(x[1], x[2])
  for (i in 1:10000){
    # choose one of A, B, C at random
    chosen_point <- sample(store, 1)
    # assign new point half the distance between start point and chosen point
    x[1] <- x[1] + (unlist(chosen_point)[1] - x[1])/2
    x[2] <- x[2] + (unlist(chosen_point)[2] - x[2])/2
    # plot new point, which becomes the new start point
    points(x[1],
           x[2],
           cex = 0.05)
  }

  # create second plot
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 4), ylim=c(0, 4),
       main = "Classical Sierpinski Gasket", cex.main = 0.8)
  # store the stationary points as a list of vertices of an equilateral triangle
  store <- list(A = c(0,0), B = c(3,0), C = c(3*sin(pi/6), 3*tan(pi/3)/2))
  # set starting point
  x <- c(0,0)
  for (i in 1:10000){
    # choose one of A, B, C at random
    chosen_point <- sample(store, 1)
    # assign new point half the distance between start point and chosen point
    x[1] <- x[1] + (unlist(chosen_point)[1] - x[1])/2
    x[2] <- x[2] + (unlist(chosen_point)[2] - x[2])/2
    # plot new point, which becomes the new start point
    points(x[1],
           x[2],
           cex = 0.05)
  }
  
  # create third plot
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 5), ylim=c(0, 5),
       main = "Four stationary points", cex.main = 0.8)
  # store the stationary points as a list, this time 4 forming a square
  store <- list(A = c(0,0), B = c(4,0), C = c(0,4), D = c(4,4))
  # set starting point
  x <- c(0,0)
  for (i in 1:5000){
    # choose one of A, B, C, D at random
    chosen_point <- sample(store, 1)
    # assign new point half the distance between start point and chosen point
    x[1] <- x[1] + (unlist(chosen_point)[1] - x[1])/2
    x[2] <- x[2] + (unlist(chosen_point)[2] - x[2])/2
    # plot new point, which becomes the new start point
    points(x[1],
           x[2],
           cex = 0.05)
  }
  
  # create fourth plot
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 5), ylim=c(0, 5),
       main = "Move 1/3 distance", cex.main = 0.8)
  # store the stationary points as a list
  store <- list(A = c(0,0), B = c(3,4), C = c(4,1))
  # create starting point
  x <- c(0,0)
  for (i in 1:5000){
    # choose one of A, B, C at random
    chosen_point <- sample(store, 1)
    # assign new point one third of the distance between start point and chosen point
    x[1] <- x[1] + (unlist(chosen_point)[1] - x[1])/3
    x[2] <- x[2] + (unlist(chosen_point)[2] - x[2])/3
    # plot new point, which becomes the new start point
    points(x[1],
           x[2],
           cex = 0.05)
  }
  title(main = "Chaos game simulations with different parameters/initial conditions", outer=TRUE)
  return("1) Starting with an initial position outside the stationary points still ends up with a
         scalene Sierpinski triangle but the first few points (coloured in red) are located outside of the fractal pattern.
         2) The classical Sierpinski gasket made from 3 points corresponding to the vertices of an
         equilateral triangle.
         3) The same algorithm but with 4 stationary points rather than 3 does not create a fractal.
         4) The save algorithm but moving 1/3 of the distance towards the stationary points rather
         than 1/2 does not create a fractal.")
}

# Challenge question F
# create a new turtle function to add colour and chnage thickness of segment with each iteration
turtle2 <- function(start_position, direction, length, thickness)  {
  # extract x and y coordinates of starting position
  x0 <- start_position[1]
  y0 <- start_position[2]
  # calculate new point given the input parameters
  x <- length * cos(direction) + x0
  y <- length * sin(direction) + y0
  # draw a line segment between starting position and new point
  segments(x0, y0, x1 = x, y1 = y, col="springgreen4", lwd = thickness)
  # extract the endpoint to be returned
  endpoint <- c(x,y)
  return(endpoint)
}

# create a function to draw a fir tree
fir <- function(start_position, direction, length, thickness)  {
  # assign first point using turtle function
  new_point <- turtle2(start_position, direction, length, thickness)
  # start points for left, right and straight bracnhes are the same
  if (length > 0.01) { # if statement otherwise recursive function will never end
    fir(new_point, direction, length*0.87, thickness*.85) 
    fir(new_point, direction + (-5*pi/6), length*0.38, thickness)
    fir(new_point, direction + (5*pi/6), length*0.38, thickness)
  }
  return(0)
}

# function to plot Christmas tree
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  # create a new plot window
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 6), ylim=c(0,10))
  
  # draw main tree trunk segment
  x <- 3 * cos(pi/2) + 3
  y <- 3 * sin(pi/2) + 1
  segments(3, 1, x1 = x, y1 = y, col="burlywood4", lwd = 4)
  
  # call fir function, which prints to plot
  fir(c(3,3), pi/2, 0.8, 4)
  # add baubles and star at the top of tree using points()
  points(c(2.5,2.75,3.5,3.5,2.7,3.9,3.2,3.3,2.9), c(2.7,6,5,4,4.2,2.1,4.5,7,7.9), pch = 19, col = rainbow(9), cex = 1)
  points(3,9, pch = 8, cex = 2, col = "#CFB53B", lwd = 2)
  return(0)
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


