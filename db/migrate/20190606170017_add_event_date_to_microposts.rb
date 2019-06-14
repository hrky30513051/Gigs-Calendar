class AddEventDateToMicroposts < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :event_date, :date, default: Date.today
  end
end
