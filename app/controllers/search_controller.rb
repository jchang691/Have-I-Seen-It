require 'will_paginate/array'
class SearchController < ApplicationController

    def search
        @user = current_user
        @search_query = params[:search]
        @movies = Movie.find(:all, :conditions => ['lower(name) LIKE ?', "%#{@search_query.downcase}%"])
        @movies = @movies.paginate(:order=> "name", page: params[:page]) unless @movies.empty?
        @actors = Actor.find(:all, :conditions => ['lower(name) LIKE ?', "%#{@search_query.downcase}%"])
        @actors = @actors.paginate(:order=> "name", page: params[:page]) unless @actors.empty?
    end
end
