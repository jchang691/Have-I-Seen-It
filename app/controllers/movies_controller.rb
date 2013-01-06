require 'nokogiri'
require 'open-uri'
class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.paginate(page: params[:page])
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
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(params[:movie])

    link = imdb_link @movie.name
    doc = Nokogiri::HTML(open("http://www.imdb.com#{link}"))
    rt_link = rotten_tomatoes_link @movie.name
    movie_header = doc.css('h1.header')[0]
    @movie.name = movie_header.children[0].text.strip
    @movie.year = movie_header.children[1].text.strip.gsub(/[()]/, "")
    @movie.description = doc.css('p')[1].text.strip
    @movie.rating = rt_link.at_css("a.tomato_numbers span").text
    @movie.save

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render json: @movie, status: :created, location: @movie }
      else
        format.html { render action: "new" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
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
