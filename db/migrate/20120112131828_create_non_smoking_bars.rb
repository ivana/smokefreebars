class CreateNonSmokingBars < ActiveRecord::Migration
  def change
    create_table :non_smoking_bars do |t|
      t.string :name,     :null => false
      t.string :address,  :null => false
      t.string :city,     :default => 'Zagreb'
      t.string :neighbourhood

      # by default, a bar is entirely non-smoking; this attribute indicates it has a non-smoking area when true
      t.boolean :partly,  :default => false

      t.timestamps
    end
  end
end
