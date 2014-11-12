class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.references :feedback
      t.string :explanation, null: false

      t.timestamps
    end

    add_index :flags, :feedback_id
  end
end
