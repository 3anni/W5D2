# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
    select title
    from movies 
    join
      castings on movies.id = castings.movie_id
    join 
    actors on castings.actor_id = actors.id
    where
      actors.name = 'Harrison Ford'
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
  select title
  from movies 
  join
    castings on movies.id = castings.movie_id
  join 
    actors on castings.actor_id = actors.id
  where
    actors.name = 'Harrison Ford'
    AND
      castings.ord != 1
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
    select title, name
    from movies
    join castings on movies.id = castings.movie_id
    join actors on castings.actor_id = actors.id
    where 
      movies.yr = 1962
      AND
      castings.ord = 1
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
    select yr, count(movies.title)
    from movies
    join castings on movies.id = castings.movie_id
    join actors on castings.actor_id = actors.id 
    where actors.name = 'John Travolta'
    group by yr
      having count(movies.title) > 1 

  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
    select movies.title, actors.name
    from castings
    join movies on castings.movie_id = movies.id
    join actors on castings.actor_id = actors.id
    where 
      ord = 1 
      AND 
      movies.title in
        (
        select title 
        from castings c
        join movies m on c.movie_id = m.id
        join actors a on a.id = c.actor_id
        where a.name = 'Julie Andrews'
      )
  SQL
end

# select m.title from movies m
#     join castings c on c.movie_id = m.id
#     join actors a on a.id = c.actor_id
#     where a.name = 'Jule Andrews'


def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
    SELECT a.name
    FROM castings
    join actors a on castings.actor_id = a.id
    where ord=1
    group by a.name
    having count(*) >= 15
    order by a.name
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
    select title, count(*) from castings c
    join movies m on m.id = c.movie_id
    join actors a on c.actor_id = a.id
    where m.yr=1978
    group by title
    order by count(*) desc, title
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
  select distinct a.name 
  from castings c
  join actors a on a.id = c.actor_id
  where movie_id in
  (
    select m.id
    from movies m
    join castings c on c.movie_id = m.id
    join actors a on c.actor_id = a.id
    where a.name = 'Art Garfunkel'
  
   )
   
   and a.name != 'Art Garfunkel'
  SQL
end
