class FixAcceptedInAnswers < ActiveRecord::Migration
  def change
    rename_column :answers, :is_accepted, :accepted
  end
end
