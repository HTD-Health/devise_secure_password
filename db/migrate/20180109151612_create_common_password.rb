class CreateCommonPassword < ActiveRecord::Migration[5.1]
  def change
    create_table :common_passwords do |t|
      t.string :password

      t.timestamps
    end
  end
end
