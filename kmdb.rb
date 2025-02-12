# In this assignment, you'll be using the domain model from hw1 (found in the hw1-solution.sql file)
# to create the database structure for "KMDB" (the Kellogg Movie Database).
# The end product will be a report that prints the movies and the top-billed
# cast for each movie in the database.

# To run this file, run the following command at your terminal prompt:
# `rails runner kmdb.rb`

# Requirements/assumptions
#
# - There will only be three movies in the database – the three films
#   that make up Christopher Nolan's Batman trilogy.
# - Movie data includes the movie title, year released, MPAA rating,
#   and studio.
# - There are many studios, and each studio produces many movies, but
#   a movie belongs to a single studio.
# - An actor can be in multiple movies.
# - Everything you need to do in this assignment is marked with TODO!
# - Note rubric explanation for appropriate use of external resources.

# Rubric
# 
# There are three deliverables for this assignment, all delivered within
# this repository and submitted via GitHub and Canvas:
# - Generate the models and migration files to match the domain model from hw1.
#   Table and columns should match the domain model. Execute the migration
#   files to create the tables in the database. (5 points)
# - Insert the "Batman" sample data using ruby code. Do not use hard-coded ids.
#   Delete any existing data beforehand so that each run of this script does not
#   create duplicate data. (5 points)
# - Query the data and loop through the results to display output similar to the
#   sample "report" below. (10 points)
# - You are welcome to use external resources for help with the assignment (including
#   colleagues, AI, internet search, etc). However, the solution you submit must
#   utilize the skills and strategies covered in class. Alternate solutions which
#   do not demonstrate an understanding of the approaches used in class will receive
#   significant deductions. Any concern should be raised with faculty prior to the due date.

# Submission
# 
# - "Use this template" to create a brand-new "hw2" repository in your
#   personal GitHub account, e.g. https://github.com/<USERNAME>/hw2
# - Do the assignment, committing and syncing often
# - When done, commit and sync a final time before submitting the GitHub
#   URL for the finished "hw2" repository as the "Website URL" for the 
#   Homework 2 assignment in Canvas

# Successful sample output is as shown:

# Movies
# ======

# Batman Begins          2005           PG-13  Warner Bros.
# The Dark Knight        2008           PG-13  Warner Bros.
# The Dark Knight Rises  2012           PG-13  Warner Bros.

# Top Cast
# ========

# Batman Begins          Christian Bale        Bruce Wayne
# Batman Begins          Michael Caine         Alfred
# Batman Begins          Liam Neeson           Ra's Al Ghul
# Batman Begins          Katie Holmes          Rachel Dawes
# Batman Begins          Gary Oldman           Commissioner Gordon
# The Dark Knight        Christian Bale        Bruce Wayne
# The Dark Knight        Heath Ledger          Joker
# The Dark Knight        Aaron Eckhart         Harvey Dent
# The Dark Knight        Michael Caine         Alfred
# The Dark Knight        Maggie Gyllenhaal     Rachel Dawes
# The Dark Knight Rises  Christian Bale        Bruce Wayne
# The Dark Knight Rises  Gary Oldman           Commissioner Gordon
# The Dark Knight Rises  Tom Hardy             Bane
# The Dark Knight Rises  Joseph Gordon-Levitt  John Blake
# The Dark Knight Rises  Anne Hathaway         Selina Kyle

# Delete existing data, so you'll start fresh each time this script is run.
# Use `Model.destroy_all` code.
# TODO!

Role.destroy_all   
Movie.destroy_all  
Actor.destroy_all  
Studio.destroy_all

# Generate models and tables, according to the domain model.
# TODO!


# executed in terminal, commented out below
# rails generate model Studio name:string
# rails generate model Movie title:string year_released:integer rated:string studio:references
# rails generate model Actor name:string
# rails generate model Role movie:references actor:references character_name:string
# rails db:migrate


# Insert data into the database that reflects the sample data shown above.
# Do not use hard-coded foreign key IDs.
# TODO!

warner_bros = Studio.new
warner_bros["name"] = "Warner Bros"
warner_bros.save

batman_begins = Movie.new
batman_begins["title"] = "Batman Begins"
batman_begins["year_released"] = 2005
batman_begins["rated"] = "PG-13"
batman_begins["studio_id"] = warner_bros.id
batman_begins.save

dark_knight = Movie.new
dark_knight["title"] = "The Dark Knight"
dark_knight["year_released"] = 2008
dark_knight["rated"] = "PG-13"
dark_knight["studio_id"] = warner_bros.id
dark_knight.save

dark_knight_rises = Movie.new
dark_knight_rises["title"] = "The Dark Knight Rises"
dark_knight_rises["year_released"] = 2012
dark_knight_rises["rated"] = "PG-13"
dark_knight_rises["studio_id"] = warner_bros.id
dark_knight_rises.save

actors = {
  "Christian Bale" => Actor.new,
  "Michael Caine" => Actor.new,
  "Liam Neeson" => Actor.new,
  "Katie Holmes" => Actor.new,
  "Gary Oldman" => Actor.new,
  "Heath Ledger" => Actor.new,
  "Aaron Eckhart" => Actor.new,
  "Maggie Gyllenhaal" => Actor.new,
  "Tom Hardy" => Actor.new,
  "Joseph Gordon-Levitt" => Actor.new,
  "Anne Hathaway" => Actor.new
}

actors.each do |name, actor|
  actor["name"] = name
  actor.save
end

roles_data = [
  [batman_begins, "Christian Bale", "Bruce Wayne"],
  [batman_begins, "Michael Caine", "Alfred"],
  [batman_begins, "Liam Neeson", "Ra's Al Ghul"],
  [batman_begins, "Katie Holmes", "Rachel Dawes"],
  [batman_begins, "Gary Oldman", "Commissioner Gordon"],

  [dark_knight, "Christian Bale", "Bruce Wayne"],
  [dark_knight, "Heath Ledger", "Joker"],
  [dark_knight, "Aaron Eckhart", "Harvey Dent"],
  [dark_knight, "Michael Caine", "Alfred"],
  [dark_knight, "Maggie Gyllenhaal", "Rachel Dawes"],

  [dark_knight_rises, "Christian Bale", "Bruce Wayne"],
  [dark_knight_rises, "Gary Oldman", "Commissioner Gordon"],
  [dark_knight_rises, "Tom Hardy", "Bane"],
  [dark_knight_rises, "Joseph Gordon-Levitt", "John Blake"],
  [dark_knight_rises, "Anne Hathaway", "Selina Kyle"]
]

roles_data.each do |movie, actor_name, character_name|
  role = Role.new
  role["movie_id"] = movie.id
  role["actor_id"] = actors[actor_name].id
  role["character_name"] = character_name
  role.save
end

# Prints a header for the movies output
puts "Movies"
puts "======"
puts ""

# Query the movies data and loop through the results to display the movies output.
# TODO!
Movie.includes(:studio).order(:year_released).each do |movie|
  puts "#{movie.title.ljust(25)} #{movie.year_released}  #{movie.rated.ljust(6)} #{movie.studio.name}"
end

# Prints a header for the cast output
puts ""
puts "Top Cast"
puts "========"
puts ""

# Query the cast data and loop through the results to display the cast output for each movie.
# TODO!
Role.includes(:movie, :actor).order("movies.year_released").group_by { |role| role.movie.title }.each do |movie_title, movie_roles|
  movie_roles.each do |role|
    puts "#{movie_title.ljust(25)} #{role.actor.name.ljust(20)} #{role.character_name}"
  end
end
