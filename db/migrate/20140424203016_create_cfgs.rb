class CreateCfgs < ActiveRecord::Migration
  def change
    create_table :cfgs do |t|
      t.string :host
      t.integer :port
      t.integer :slave
      t.integer :reg_type
      t.integer :var_type

      t.timestamps
    end
  end
end
