module MoviesHelper

    def seen?(user, movie)

        !user.votes.select{|s| s.movie_id == movie.id}.empty?

    end

    def create_alphabet_filter
      list = "# "
      list << "<a href='/' data-remote='true'>All Movies</a> - "
      ('A'..'Z').each do |x|
        list << "<a href='?alpha=#{x.downcase}' data-remote='true'>#{x}</a> - "
      end
      list[0..list.size-3].html_safe
    end

end
