class CreateTodosTable < ActiveRecord::Migration[6.0]
  def change 
    create_table :todos do |t|
    t.string :name  
    t.references :category, foreign_key: true
    end
  end
end
