class AddSlugToFixtures < ActiveRecord::Migration[7.1]
  def change
    add_column :fixtures, :slug, :string
  end
end
