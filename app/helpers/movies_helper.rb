module MoviesHelper

    def rotten_tomatoes_nokogiri
        @rotten_tomato_nokogiri
    end

    def rotten_tomatoes_nokogiri=(nokogiri_doc)
        @rotten_tomato_nokogiri = nokogiri_doc
    end

    def clear_rotten_tomatoes_nokogiri
        @rotten_tomato_nokogiri = nil
    end
end
