birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

latin_lc = [species[0] for species in birds]
print(latin_lc)

common_name_lc = [species[1] for species in birds]
print(common_name_lc)

mass_lc = [species[2] for species in birds]
print(mass_lc)

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

latin_loop = []
for species in birds:
    latin_loop.append(species[0])
print(latin_loop)

common_name_loop = []
for species in birds:
   common_name_loop.append(species[1])
print(common_name_loop)

mass_loop = []
for species in birds:
    mass_loop.append(species[2])
print(mass_loop)
