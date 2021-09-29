class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.get_movie_rating_collection
    @current = nil
    
    if params[:ratings]
      @output = params[:ratings].keys
    else
      @output = @all_ratings
    end
    @movies.where!(rating: @output)
    
    @current  = @movies.where!(rating: @output)
    
 
    if params[:sort] == "title"
      @movies=Movie.order(title: :asc)
      @temp = "bg-warning"
    elsif params[:sort] == "release_date"
      @movies=Movie.order(release_date: :asc)
      @rell = "bg-warning"
    else
      @temp ="bg-white" 
      @rell = "bg-white"
    end


  end 

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
