module MoviesHelper

    def seen?(user, movie)

        !user.votes.select{|s| s.movie_id == movie.id}.empty?

    end

end
