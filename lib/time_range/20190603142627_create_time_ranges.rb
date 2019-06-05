class CreateTimeRanges < ActiveRecord::Migration[5.2]
  def change
    create_table :time_ranges do |table|
      table.belongs_to :scheduleable, polymorphic: true # id of the record that this time_range applies to

      table.timestamp :starting # following rails convention stored in UTC
      table.timestamp :ending # following rails convention stored in UTC
      table.tsrange :time_range # postgresql timezone range [starting, ending) will make time based queries faster. 
        # // I would probably set this using a postgresql function that gets called on create and update
      table.date :starting_date # saved on create and or update
      table.date :ending_date # also saved on create and or update```
      table.daterange :date_range #

      table.string :time_zone_name # ether by name, or by offset from UTC..  

      table.interval :precision

      # so, some record could be `scheduleable` with a matching concern, and we can find the record based upon a single search in one table.
      # oh.. and I forgot the precision field..
      # the precision field would be for 'all day' tasks, but would also be applicable to "within 15 minutes of"
      # for the time ranges where the uses only care about the date, the starting time would be set to say 6am.. and the ending time for like 6pm.. and the precision set to 'day'
      # this would allow for easy "this is the same day in both hawaii and maine"  while still being able to handle 'Oh, this time is going to be a different day in Japan'
      # from a mathematical perspective, by putting the starting and ending back from the edge you end up avoiding rounding errors..

      table.timestamps
    end
  end
end
