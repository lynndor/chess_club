class ChangeResultTypeInMatches < ActiveRecord::Migration[7.1]
  def up
    change_column :matches, :result, 'integer USING CAST(result AS integer)'
  end

  def down
    change_column :matches, :result, :string
  end
end
