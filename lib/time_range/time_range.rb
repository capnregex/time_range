class TimeRange < ApplicationRecord
  belongs_to :scheduleable, polymorphic: true, optional: true

  before_save :set_times_or_dates

  def get_time_zone
    zone = Time.zone
    self.time_zone_name = zone.name
    zone
  end

  def time_zone
    @time_zone ||= Time.find_zone(time_zone_name) || get_time_zone
  end

  def time_zone= timezone
    @time_zone = Time.find_zone!(timezone)
    self.time_zone_name = time_zone.name
    @time_zone
  end

  def set_times_or_dates
    if starting && !starting_date
      self.starting_date = starting.in_time_zone(time_zone).to_date
    end
    if ending && !ending_date
      self.ending_date = ending.in_time_zone(time_zone).to_date
    end
    if !starting && starting_date
      self.starting = starting_date.in_time_zone(time_zone).change(hour: 6)
    end
    if !ending && ending_date
      self.ending = ending_date.in_time_zone(time_zone).change(hour: 18)
    end
  end

  class << self
    ## class methods

    def all_fields 
      arel_table[Arel.star]
    end

    def starting
      arel_table[:starting]
    end

    def ending
      arel_table[:ending]
    end

    def time_range
      arel_table[:time_range]
    end

    def tsrange
      Arel::Nodes::NamedFunction.new("tsrange", [starting, ending] )
    end

    def with_range
      select(
        all_fields,
        tsrange
      )
    end

    def update_range
      update(time_range: tsrange)
    end
  end
end
