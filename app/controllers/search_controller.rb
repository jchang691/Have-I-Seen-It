require 'will_paginate/array'
class SearchController < ApplicationController

    def search
        @user = current_user
        movies_per_page = @user.nil? ? 10 : @user.movies_per_page
        @search_query = params[:search]
        @movies = Movie.find(:all, :conditions => ['lower(name) LIKE ?', "%#{@search_query.downcase}%"])
        @movies = @movies.paginate(:order=> "name", page: params[:movie_page], :per_page => movies_per_page) unless @movies.empty?
        @actors = Actor.find(:all, :conditions => ['lower(name) LIKE ?', "%#{@search_query.downcase}%"])
        @actors = @actors.paginate(:order=> "name", page: params[:actor_page], :per_page => movies_per_page) unless @actors.empty?

        respond_to do |format|
        	format.html
        	format.js
        end
    end
end
