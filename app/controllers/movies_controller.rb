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
      session[:ratings].each do |rating|
        query['rating[' + rating + ']'] =1
      @ratings = query
      end
    end
    
    if  params[:sort]
        @sort = params[:sort]
    elsif session[:sort]
        @sort = session[:sort]
    end
    @movies = Movie.where(rating:@ratings.keys).order(@sort)
    
    if params[:sort]!=session[:sort] or params[:ratings]!=session[:ratings]
      session[:sort] = @sort
      session[:ratings] = @ratings
      flash.keep
      redirect_to movies_path(sort: session[:sort],ratings:session[:ratings])
    end 
    
    if params[:sort] == "title"
      @movies.order(title: :asc)
      @temp = "bg-warning"
    elsif params[:sort] == "release_date"
      @movies.order(release_date: :asc)
      @rell = "bg-warning"
    else
      @movies = Movie.all
      @temp ="bg-white" 
      @rell = "bg-white"
    end
    
=begin     
    if params[:ratings]
      @output = params[:ratings].keys
      session[:filter_rating] =  @output
    elsif session[:filter_rating]
      query = Hash.new
      session[:filter_rating].each do |rating|
        query['rating[' + rating + ']'] =1
      end
      if params[:sort]
        query[:sort] = params[:sort]
      end
      flash.keep
      redirect_to movies_path(query)
    else
      @output = @all_ratings
    end
    @movies.where!(rating: @output)
    

      

    case params[:sort]
    when 'title'
      @movies.order!('title asc')
      @temp = "hilite"
    when 'release_date'
      @movies.order!('release_date asc')
      @rell = "hilite"
    end
    
     @sort = params[:sort]||session[:sort]
    @all_ratings = Movie.ratings
    @ratings =  params[:ratings] || session[:ratings] || Hash[@all_ratings.map {|rating| [rating, rating]}]
    @movies = Movie.where(rating:@ratings.keys).order(@sort)
     if params[:sort]!=session[:sort] or params[:ratings]!=session[:ratings]
      session[:sort] = @sort
      session[:ratings] = @ratings
      flash.keep
      redirect_to movies_path(sort: session[:sort],ratings:session[:ratings])

    if params[:sort] == "title"
      @movies.order!("title asc")
      @temp = "bg-warning"
    elsif params[:sort] == "release_date"
      @movies.order!(release_date: :asc)
      @rell = "bg-warning"
    else
      @temp ="bg-white" 
      @rell = "bg-white"
    end

  

    if params[:ratings]
      @ratings_to_show = params[:ratings].keys
      session[:filtered_rating] = @ratings_to_show
    elsif session[:filtered_rating]
      query = Hash.new
      session[:filtered_rating].each do |rating|
        query['ratings['+ rating + ']'] = 1
      end
      query['sort'] = params[:sort] if params[:sort]
      session[:filtered_rating] = nil
      flash.keep
      redirect_to movies_path(query)
      #@ratings_to_show = session[:filtered_rating]
    else
      @ratings_to_show = @all_ratings
    end

    @movies.where!(rating: @ratings_to_show)
    
    case params[:sort]
    when 'title'
      @movies.order!('title asc')
      @title_class = "hilite"
    when 'release_date'
      @movies.order!('release_date asc')
      @release_date_class = "hilite"
    end
    
 
    #end 
=end
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
