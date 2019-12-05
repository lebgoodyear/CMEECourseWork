# CMEE 2019 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything 
# yourself from scratch please ensure you use EXACTLY the same function and parameter names and 
# beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Lucy Goodyear"
preferred_name <- "Lucy"
email <- "leg19@imperial.ac.uk"
username <- "leg19"
personal_speciation_rate <- 0.002216 # will be assigned to each person individually in class and should be between 0.002 and 0.007

# Question 1
# calculates speices richness (number of unique species) in a system
species_richness <- function(community){
  return(length(unique(community)))
}

# Question 2
# returns a sequnce of 1:max_size of community, representing an initial state 
# of the community with the maximum possible numer of species, indexed 1:max_size
init_community_max <- function(size){
  return(seq(1, size))
}

# Question 3
# returns a sequence of length max_size, containing all 1s.
# an alternative initial state of the community with the minimum possible
# number of species (monodominance of one species)
init_community_min <- function(size){
  return(rep(1, size))
}

# Question 4
# returns two randomly chosen values from between 1 and a max value
choose_two <- function(max_value){
  return(sample(1:max_value, 2, replace = FALSE))
}

# Question 5
# returns the state of a community after an individual of one species has died 
# and been replaced by an individual of one of the other species
neutral_step <- function(community){
  replace <- choose_two(length(community))
  community[replace[1]] <- community[replace[2]]
  return(community)
}

# Question 6
# calculate state of community after ONE generation has passed
neutral_generation <- function(community){
  x <- runif(1)
  if (x < 0.5){
    steps <- floor((length(community) / 2))
  }
  else{
  steps <- ceiling((length(community) / 2))
  }
  for (i in 1:steps){
    community <- neutral_step(community)
  }
  return(community)
}

# Question 7
# calculate species richness in community during "duration" number of generations
neutral_time_series <- function(community, duration){
  sp_ri_gens <- c(length(unique(community)))
  for (t in 1:duration){
    community <- neutral_generation(community)
    sp_ri_gens <- c(sp_ri_gens, species_richness(community))
  }
  return(sp_ri_gens)
}

# Question 8
# plot species richness after "duration" number of generations has passed
question_8 <- function(community, duration) {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  plot(x = 0:duration,
       y = neutral_time_series(community, duration),
       type = "l",
       ylab = "Species Richness (by generation)",
       xlab = "Time (in generations)")
  return("The system will always converge to species richness of 1 because you are always 
         replacing the individual that died with an inidividual from one of the other species, 
         with no new species ever being added.")
}

# Question 9
# returns the state of a community after an individual of one species has died 
# and either been replaced by an individual of one of the other species or been
# replaced by an entirely new spsecies, the outcome being based on the probability
# of speciation
neutral_step_speciation <- function(community, speciation_rate)  {
  replace <- choose_two(length(community))
  if (runif(1) < speciation_rate) {
    # speciation occurs
    new_species <- max(community) + 1
    community[replace[1]] <- new_species
    return(community)
  }
  else {
    community[replace[1]] <- community[replace[2]]
    return(community)
  }
}

# Question 10
# calculate state of community after ONE generation has passedm including the 
# possibility of speciation
neutral_generation_speciation <- function(community,speciation_rate)  {
  steps <- round((length(community) / 2))
  for (i in 1:steps){
    community <- neutral_step_speciation(community, speciation_rate)
  }
  return(community)
}

# Question 11
# calculate species richness in community during "duration" number of generations,
# including the possibility of speciation
neutral_time_series_speciation <- function(community, speciation_rate, duration)  {
  sp_ri_gens <- c(length(unique(community)))
  for (t in 1:duration){
    community <- neutral_generation_speciation(community, speciation_rate)
    sp_ri_gens <- c(sp_ri_gens, species_richness(community))
  }
  return(sp_ri_gens)
}

# Question 12
# plot species richness after "duration" number of generations has passed, inlcuding
# possibility of speciation
question_12 <- function(community_1, community_2, speciation_rate, duration)  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  plot(x = 0:duration,
       y = neutral_time_series_speciation(community_1, speciation_rate, duration),
       type = "l",
       ylab = "Species Richness (by generation)",
       xlab = "Time (in generations)",
       main = "Neutral Time Series (Speciation)",
       ylim = c(0, 100),
       col = "Red")
  lines(x = 0:duration,
       y = neutral_time_series_speciation(community_2, speciation_rate, duration),
       col = "Blue")
  legend("topright", 
         c("Maximum Initial Conditions", "Minimum Initial Conidtions"),
         fill = c("Red", "Blue"))
  return("Regardless of initial conditions, the system will always converge to the same
         equilibrium because speciation rate and time step is the same.")
}

# Question 13
species_abundance <- function(community){
  counts <- as.data.frame(table(community))
  return(sort(counts$Freq, decreasing = TRUE))
}

# Question 14
octaves <- function(abundance_vector) {
  return(tabulate(log2(abundance_vector)+1, nbin = ceiling(log2(max(abundance_vector)))))
}

# Question 15
sum_vect <- function(x, y) {
  if (length(x) < length(y)) {
    x <- c(x, rep(0, length(y) - length(x)))
  } 
    else (length(y) < length(x))
      y <- c(y, rep(0, length(x) - length(y)))
  return(x+y)
}

# Question 16 
question_16 <- function(community_1, community_2, speciation_rate, burn_duration, eq_duration)  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  # generate species abundance octaves for community 1
  sp_ab_octave_c1 <- c()
  for (t in 1:eq_duration){
    community_1 <- neutral_generation_speciation(community_1, speciation_rate)
    if ((t %% 20 == 0) & (t >= burn_duration)) {
      current_state <- octaves(species_abundance(community_1))
      sp_ab_octave_c1 <- sum_vect(current_state, sp_ab_octave_c1)
    }
  }
    # generate species abundance octaves for community 2
  sp_ab_octave_c2 <- c()
  for (t in 1:eq_duration){
    community_2 <- neutral_generation_speciation(community_2, speciation_rate)
    if ((t %% 20 == 0) & (t >= burn_duration)) {
      current_state <- octaves(species_abundance(community_2))
      sp_ab_octave_c2 <- sum_vect(current_state, sp_ab_octave_c2)
    }
  }
  # to know how many times this has occured to use to divide by later
  counts <- (eq_duration - burn_duration) / 20 + 1
  # calculate the mean of each bin and plot bar chart  
  par(mfrow=c(2,1))
  barplot(sp_ab_octave_c1 / counts,
          ylab = "Mean species abundance",
          xlab = "Octave (log2)",
          main = "Maximum Initial Community",
          names.arg = 1:length(sp_ab_octave_c1))
  barplot(sp_ab_octave_c2 / counts,
          ylab = "Mean species abundance",
          xlab = "Octave (log2)",
          main = "Maximum Initial Community",
          names.arg = 1:length(sp_ab_octave_c2))
      
  return("The initial conditions do not matter because speciation rate is constant.")
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  community <- init_community_min(size)
  species_richness_vector <- c(species_richness(community))
  octaves_list <- list(octaves(species_abundance(community)))
  # start timer
  timer <- proc.time()
  t <- 1
  while ((proc.time()[3] - timer[3]) < (wall_time)*60){
    community <- neutral_generation_speciation(community, speciation_rate)
    if ((t <= burn_in_generations) & (t %% interval_rich == 0)){
      species_richness_vector <- c(species_richness_vector, species_richness(community))
    }
    if (t %% interval_oct == 0){
      octaves_list[[length(octaves_list)+1]] = octaves(species_abundance(community))
    }
    t <- t + 1
  }
  time_taken = proc.time()[3] - timer[3]
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
  # initialise empty vectors to store total octave data for each size
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
  files <- list.files(path = "../Results/", pattern = "*.rda")
  # set for loop over files to extract octave information
  for (i in files){
    load(paste0("..//Results/",i)) # load each file
    octaves_tot <- c() # initliase empty octave vector for i file ocatve sum
    counter <- 0 # reset counter to 0
    # loop over each octave in file i
    for (j in length(octaves_list)){
      # sum all octaves in file i
      octaves_tot <- sum_vect(octaves_tot, octaves_list[[j]])
      # count all octaves in file i
      counter <- counter + 1
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
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  par(mfrow = c(2, 2))
  barplot(octaves_500 / counter_500,
          ylab = "Mean species abundance",
          xlab = "Species abundance octaves (log2)",
          main = "Initial community of size 500",
          names.arg = 1:length(octaves_500))
  barplot(octaves_1000)
  barplot(octaves_2500)
  barplot(octaves_5000)

  combined_results <- list(octaves_500, octaves_1000, octaves_2500, octaves_5000) #create your list output here to return
  return(combined_results)
}

# Question 21
question_21 <- function()  {
  # by eye we can see that to triple the object's area, we need 8 of them.
  # use the equation N(delta) = K * delta^(-D)
  # set K = 1
  # log(8) = -D*log(3)
  # where fractional dimension = -1 * gradient
  D <- log(8)/log(3)
  return(list("Scaling one side of the object by 3 scales the area by 8, which is 3 to the power of", D))
}

# Question 22
question_22 <- function()  {
  D <- log(20)/log(3)
  return(list("Scaling one side of the object by 3 scales the volume by 20, which is 3 to the power of", D))
}

# Question 23
chaos_game <- function()  {
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 5), ylim=c(0, 5))
  store <- list(A = c(0,0), B = c(3,4), C = c(4,1))
  x <- c(0,0)
  for (i in 1:5000){
    # choose one of A, B, C at random
    chosen_point <- sample(store, 1)
    # assign new point
    x[1] <- x[1] + (unlist(chosen_point)[1] - x[1])/2
    x[2] <- x[2] + (unlist(chosen_point)[2] - x[2])/2
    # plot new point
    points(x[1],
           x[2],
           cex = 0.05)
  }
  # clear any existing graphs and plot your graph within the R window
  return("A fractal emerges")
}

# open plot to test turtle function
plot(1, type="n", xlab="", ylab="", xlim=c(0, 5), ylim=c(0, 5))

# Question 24
turtle <- function(start_position, direction, length)  {
  x0 <- start_position[1]
  y0 <- start_position[2]
  x <- length * cos(direction) + x0
  y <- length * sin(direction) + y0
  segments(x0, y0, x1 = x, y1 = y)
  endpoint <- c(x,y)
  return(endpoint) # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  new_points <- turtle(start_position, direction, length)
  turtle(c(new_points[1],new_points[2]), direction - pi/4, length*0.95)
}

# Question 26
spiral <- function(start_position, direction, length)  {
  new_points <- turtle(start_position, direction, length)
  while ((length*0.95)  > 0.1) {
    spiral(c(new_points[1], new_points[2]), direction - pi/4, length*0.95)
  }
  return("type your written answer here")
}

# Question 27
draw_spiral <- function()  {
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 5), ylim=c(0, 5))
  return(spiral(c(1,2), pi/4, 0.5))
  # clear any existing graphs and plot your graph within the R window
  
}

# Question 28
tree <- function(start_position, direction, length)  {
  
}
draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Question 29
fern <- function(start_position, direction, length)  {
  
}
draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Question 30
fern2 <- function(start_position, direction, length)  {
  
}
draw_fern2 <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


