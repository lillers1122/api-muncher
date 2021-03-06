require 'httparty'

class EdamamApiWrapper
  URL = "https://api.edamam.com/search?"
  URL2 = "http://www.edamam.com/ontologies/edamam.owl#recipe_"
  ID = ENV["EDAMAM_ID"]
  KEY = ENV["EDAMAM_KEYS"]

  def self.get_recipes(search)
    @recipe_list = []
    if search[:sugar] == true
      encoded_uri = URI.encode("#{URL}q=#{search[:search]}&app_id=#{ID}&app_key=#{KEY}&from=0&to=50&health=sugar-conscious")
    else
      encoded_uri = URI.encode("#{URL}q=#{search[:search]}&app_id=#{ID}&app_key=#{KEY}&from=0&to=50")  
    end

    response = HTTParty.get(encoded_uri)
    if response["hits"]
      response["hits"].each do |item|
        @recipe_list << Recipe.new(
          item["recipe"]["source"],
          item["recipe"]["label"],
          item["recipe"]["image"],
          item["recipe"]["uri"],
          item["recipe"]["ingredients"],
          item["recipe"]["yield"],
          item["recipe"]["url"],
          item["recipe"]["healthLabels"],
          item["recipe"]["dietLabels"])
      end
    end
    return @recipe_list
  end

  def self.show_recipe(id)
    encoded_uri = URI.encode("#{URL}r=#{URL2}#{id}&app_id=#{ID}&app_key=#{KEY}")
    response = HTTParty.get(encoded_uri)

    if response.empty?
      return nil
    else
      recipe = Recipe.new(
        response[0]["source"],
        response[0]["label"],
        response[0]["image"],
        response[0]["uri"],
        response[0]["ingredients"],
        response[0]["yield"],
        response[0]["url"],
        response[0]["healthLabels"],
        response[0]["dietLabels"]
    )
      return recipe
    end
  end
end
