# CMEE 2019 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything 
# yourself from scratch please ensure you use EXACTLY the same function and parameter names and 
# beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Lucy Goodyear"
preferred_name <- "Lucy"
email <- "leg19@imperial.ac.uk"
username <- "leg19"
personal_speciation_rate <- 0.002 # will be assigned to each person individually in class and should be between 0.002 and 0.007

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
  return("The system will always converge to species richness of 1")
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
  return("type your written answer here")
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
          ylab = "Species abundance",
          xlab = "Octave (log2)",
          main = "Maximum Initial Community",
          names.arg = 1:length(sp_ab_octave_c1))
  barplot(sp_ab_octave_c2 / counts,
          ylab = "Species abundance",
          xlab = "Octave (log2)",
          main = "Maximum Initial Community",
          names.arg = 1:length(sp_ab_octave_c2))
      
  return("type your written answer here")
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  
}

# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function()  {
  # clear any existing graphs and plot your graph within the R window
  combined_results <- list() #create your list output here to return
  return(combined_results)
}

# Question 21
question_21 <- function()  {
  return("type your written answer here")
}

# Question 22
question_22 <- function()  {
  return("type your written answer here")
}

# Question 23
chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Question 24
turtle <- function(start_position, direction, length)  {

  return() # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  
}

# Question 26
spiral <- function(start_position, direction, length)  {
  return("type your written answer here")
}

# Question 27
draw_spiral <- function()  {
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


