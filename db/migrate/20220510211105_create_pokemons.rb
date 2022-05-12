class CreatePokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemons do |t|
      t.string :scraped_element
      t.string :cardName
      t.integer :set_num
    end
  end
end
