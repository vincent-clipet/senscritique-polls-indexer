class CreatePolls < ActiveRecord::Migration[5.0]
	def change



		create_table :poll_types do |t|

			t.string :name

		end



		create_table :polls do |t|

			t.integer :poll_type
			t.string :name
			t.string :link
			t.string :description
			t.string :info
			t.string :img_url
			t.string :badge_img_url
			
			t.timestamps

			t.add_foreign_key :poll_type, :poll_types

		end



	end
end
