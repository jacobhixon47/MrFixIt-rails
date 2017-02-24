class AddActiveToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :active, :boolean
  end
end
