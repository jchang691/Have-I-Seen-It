require 'nokogiri'
require 'open-uri'
class MoviesController < ApplicationController
  # GET /movies 
  # GET /movies.json
  def index
    session[:movie_step] = session[:movie_params] = session[:movie_doc] = nil
    @user = current_user
    @all_movies = Movie.paginate(:order=> "name", page: params[:page])
    @movies = @user.movies.paginate(:order=> "name", page: params[:page]) unless @user.nil?
    @movies = @all_movies if @movies.nil?
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
    @movie_has_been_seen = nil
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
        @existing_movie = Movie.where(:name => movie_title)
        if @user.movies.select{|s| s.name == movie_title}.empty?
          if @existing_movie.empty?

            @movie.rating = rt_link.at_css("a.tomato_numbers span").text
            @movie.name = movie_title
            @movie.year = @movie.name.match(/\((\d+)\)/)[1]
            movie_text =  rt_link.at_css("p.movie_synopsis").text.force_encoding('ISO-8859-1').encode('UTF-8')
            @movie.description = movie_text.slice(0..movie_text.index("~")-1)
            @movie.save if @movie.all_valid?
            actor_arr = rt_link.css("div#cast-info li span[itemprop=name]")
            actor_arr[0..7].each do |act|
              @actor = Actor.new(:name => act.text)
              if @actor.save
                @movie.actors << @actor
              else
                @movie.actors << Actor.find_by_name(act.text)
              end
            end
            @user.movies << @movie
          else
            @movie_has_been_seen = true
            @user.movies << @existing_movie
          end
        else
          flash[:notice] = "Movie is already in library"
        end
      else
        @movie.next_step
      end
      session[:movie_step] = @movie.current_step
    end
    if @movie.new_record?
      if @movie_has_been_seen
        flash[:notice] = "Movie has been added"
        @movie_has_been_seen = nil
        redirect_to @existing_movie[0]
      else
        if @movie.current_step == "rottentomatoes"
          @rotten_tomatoes_link = @movie.rotten_tomatoes_link
        end
        render "new"
        session[:movie_doc] = @movie.rotten_tomatoes_link.to_html
      end

    else
      session[:movie_step] = session[:movie_params] = session[:movie_doc] = nil
      flash[:notice] = "Movie saved!"
      redirect_to @movie
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
    @user = current_user
    @user.movies.delete(@movie)
    @vote = Vote.where(:movie_id => params[:id], :user_id => @user.id)[0]
    if !@vote.nil?
      @vote.delete
      @vote.save
    end

    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :no_content }
    end
  end

  def seen
    @user = current_user
    @user.votes.create({:movie_id => params[:movie_id]})
    redirect_to :back
  end

  def unseen
    @user = current_user
    @vote = Vote.where(:movie_id => params[:movie_id], :user_id => @user.id)[0]
    @vote.delete
    @vote.save
    redirect_to :back
  end

  def add_to_library
    @user = current_user
    @movie = Movie.find(params[:movie_id])
    if @user.movies.select{|s| s.id == @movie.id}.empty?
      @user.movies << @movie
      flash[:notice] = "Movie has been added to Library"
    else
      flash[:notice] = "Movie is already in Library"
    end
    redirect_to :back
  end

  def imdb_link search_query
    doc = Nokogiri::HTML(open("http://www.imdb.com/find?q=#{search_query.gsub(" ", "+")}"))
    doc.css('table.findList a')[0]["href"]
  end 

  def rotten_tomatoes_link search_query
    Nokogiri::HTML(open("http://www.rottentomatoes.com/search/?search=#{search_query.gsub(" ", "+")}"))
  end

  
end
