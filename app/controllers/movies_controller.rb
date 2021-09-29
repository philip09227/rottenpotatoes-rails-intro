class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_movie_rating_collection

    if params[:ratings]
      @ratings =  params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
    else
      query = Hash.new
      @all_ratings.each do |rating|
        query[ rating] =1
      @ratings = query
      end
    end
    
    if  params[:sort]
        @sort = params[:sort]
    elsif session[:sort]
        @sort = session[:sort]
    end
    @movies = Movie.where(rating:@ratings.keys)
    
    if params[:sort]!=session[:sort] or params[:ratings]!=session[:ratings]
      session[:sort] = @sort
      session[:ratings] = @ratings
      flash.keep
      redirect_to movies_path(sort: session[:sort],ratings: session[:ratings])
    end 
    
    if params[:sort] == "title"
      @movies = @movies.order(title: :asc)
      @temp = "bg-warning"
    elsif params[:sort] == "release_date"
      @movies =  @movies.order(release_date: :asc)
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
