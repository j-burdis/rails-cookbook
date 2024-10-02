# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Recipe.create(name: "American pancakes", description: "Easy, American-style, fluffy pancakes are great for feeding a crowd at breakfast or brunch.", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/american-style-pancakes-87119e3.jpg?quality=90&webp=true&resize=440,400", rating: 8.9)
# Recipe.create(name: "Peanut butter-stuffed French toast", description: "Inspired by deep-fried French toast (made famous in Hong Kong), our version is pan-fried for ease.", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2024/03/Peanut-butter-stuffed-French-toast-e119754.jpg?quality=90&webp=true&resize=900,817", rating: 7.1)
# Recipe.create(name: "Panuozzo sandwich", description: "Make your own baguettes and pesto to make these pizza-inspired sandwiches for the whole family.", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2022/03/Panuozzo-sandwich-4b19929.jpg?quality=90&webp=true&resize=900,817", rating: 8.3)
# Recipe.create(name: "Sweet potato & peanut curry", description: "Cook this tasty, budget-friendly vegan curry with spinach and sweet potato, it boasts two of your five-a-day and it's under 400 calories", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/satay-sweet-potato-curry-17cc62d.jpg?quality=90&webp=true&resize=440,400", rating: 9.4)

require 'open-uri'
require 'json'
require 'uri'

puts ""

Recipe.destroy_all
puts "Database cleaned"

puts "Creating recipes"

recipe_ids = []
[ "Pasta", "Seafood", "Dessert", "Vegetarian" ].each do |cat_name|
  cat_url = URI.parse("https://www.themealdb.com/api/json/v1/1/filter.php?c=#{cat_name}")
  recipes_serialised = cat_url.open.read
  recipes = JSON.parse(recipes_serialised)['meals']
  recipes.each do |recipe|
    recipe_id = recipe['idMeal']
    recipe_ids << recipe_id
  end
end

def recipe_builder(meal_id)
  id_url = URI.parse("https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{meal_id}")
  meal_serialised = id_url.open.read
  meal = JSON.parse(meal_serialised)['meals']
  meal.each do |meal_data|
    info = Recipe.create!(
    name: meal_data['strMeal'],
    description: meal_data['strInstructions'],
    image_url: meal_data['strMealThumb'],
    category_name: meal_data['strCategory']
    )
  end
end

recipe_ids.each do |recipe_id|
  recipe_builder(recipe_id)
end

puts "Finished!"
