class Movie < ActiveRecord::Base
  def self.get_movie_rating_collection
    distinct.pluck(:ratings)
  end
end
