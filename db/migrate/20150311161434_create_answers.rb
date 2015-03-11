class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :body
      t.belongs_to :question, index: true

      t.timestamps
    end
  end
end
