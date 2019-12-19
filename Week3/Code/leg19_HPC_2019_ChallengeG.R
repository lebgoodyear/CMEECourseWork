# CMEE 2019 HPC excercises R code challenge G proforma

rm(list=ls()) # nothing written elsewhere should be needed to make this work

name <- "Lucy Goodyear"
preferred_name <- "Lucy"
email <- "leg19@imperial.ac.uk"
username <- "leg19"

# don't worry about comments for this challenge - the number of characters used will be counted starting from here
frame();f=function(s,d,l,o){x=l*cos(d)+s[1];y=l*sin(d)+s[2];segments(s[1],s[2],x,y);p=c(x,y);if(l>.001){f(p,d+o*(pi/4),l*.38,o);f(p,d,l*.87,-o)}};f(c(.5,0),pi/2,.1,1)

