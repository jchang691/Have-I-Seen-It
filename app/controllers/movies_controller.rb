require 'nokogiri'
require 'open-uri'
class MoviesController < ApplicationController
  # GET /movies 
  # GET /movies.json
  def index
    session[:movie_step] = session[:movie_params] = session[:movie_doc] = nil
    @user = current_user
    if @user.nil?
      @movies = Movie.paginate(:order=> "name", page: params[:page])
    else 
      @movies = @user.movies.paginate(:order=> "name", page: params[:page])
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Movie.find(params[:id])
    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.json
  def new
    session[:movie_params] ||= {}
    @movie = Movie.new(session[:movie_params])
    @movie.current_step = session[:movie_step]
    @user = current_user
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.json
  def create
    @user = current_user
    session[:movie_params].deep_merge!(params[:movie]) if params[:movie]
    @movie = Movie.new(session[:movie_params])
    @movie.current_step = session[:movie_step]
    if @movie.valid?
      if params[:back_button]
        @movie.previous_step
      elsif @movie.last_step?
        if @movie.rotten_tomatoes_url.nil?
          rt_link = Nokogiri::HTML(session[:movie_doc])
        else
          rt_link = Nokogiri::HTML(open(@movie.rotten_tomatoes_url))
        end
        movie_title = rt_link.at_css("h1.movie_title span").text.strip
        existing_movie = Movie.where(:name => movie_title)
        if existing_movie.empty?
          @movie.rating = rt_link.at_css("a.tomato_numbers span").text
          @movie.name = movie_title
          @movie.year = @movie.name.match(/\((\d+)\)/)[1]
          @movie.description = rt_link.at_css("p.movie_synopsis").text
          @movie.save if @movie.all_valid?
          @user.movies << @movie
        else
          @user.movies << existing_movie
        end
      else
        @movie.next_step
      end
      session[:movie_step] = @movie.current_step
    end
    if @movie.new_record?
      if @movie.current_step == "rottentomatoes"
        @rotten_tomatoes_link = @movie.rotten_tomatoes_link
      end
      render "new"
      session[:movie_doc] = @movie.rotten_tomatoes_link.to_html
    else
      session[:movie_step] = session[:movie_params] = session[:movie_doc] = nil
      flash[:notice] = "Movie saved!"
      redirect_to @movie
    end
    
    # @movie.rating = rt_link.at_css("a.tomato_numbers span").text
    # @movie.save

  end

  # PUT /movies/1
  # PUT /movies/1.json
  def update
    @movie = Movie.find(params[:id])

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :no_content }
    end
  end

  def imdb_link search_query
    doc = Nokogiri::HTML(open("http://www.imdb.com/find?q=#{search_query.gsub(" ", "+")}"))
    doc.css('table.findList a')[0]["href"]
  end 

  def rotten_tomatoes_link search_query
    Nokogiri::HTML(open("http://www.rottentomatoes.com/search/?search=#{search_query.gsub(" ", "+")}"))
  end

  
end
