class CreateEmps < ActiveRecord::Migration
  def change
    create_table :emps do |t|
      t.string :name
      t.string :job
      t.string :age

      t.timestamps null: false
    end
  end
end
