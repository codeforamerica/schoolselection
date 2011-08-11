class CreateMailClusters < ActiveRecord::Migration
  def change
    create_table :mail_clusters do |t|
      t.string :name

      t.timestamps
    end
  end
end
