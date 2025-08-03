class FindPartnersController < ApplicationController
  before_action :require_user

  def index
    @day_of_week = params[:day_of_week]&.to_i
    @start_time = params[:start_time]
    @end_time = params[:end_time]

    # Set default values if not provided
    if @day_of_week.nil? && @start_time.nil? && @end_time.nil?
      @day_of_week = Date.current.wday
      @start_time = "18:00"
      @end_time = "20:00"
    end

    @partners = []
    
    if @day_of_week && @start_time && @end_time
      # Find users with overlapping availability
      @partners = find_partners_with_overlapping_availability
    end

    # Paginate results
    @pagy, @paginated_partners = pagy_array(@partners, limit: 10)
  end

  private

  def find_partners_with_overlapping_availability
    return [] unless valid_search_params?

    # Convert time strings to Time objects for comparison
    # Use a consistent base date (2000-01-01) to match how Rails stores time fields
    base_date = Date.new(2000, 1, 1)
    search_start = Time.zone.parse("#{base_date} #{@start_time}")
    search_end = Time.zone.parse("#{base_date} #{@end_time}")

    # Find availabilities that overlap with the search window
    # Overlap condition: availability.start_time < search_end AND availability.end_time > search_start
    overlapping_availabilities = Availability.joins(:user)
      .where(day_of_week: @day_of_week)
      .where("start_time < ? AND end_time > ?", search_end, search_start)
      .where.not(user: current_user)
      .includes(:user)

    # Group by user and collect overlapping time ranges
    users_with_overlaps = {}
    overlapping_availabilities.each do |availability|
      user = availability.user
      users_with_overlaps[user] ||= []
      
      # Calculate the actual overlap
      overlap_start = [availability.start_time, search_start].max
      overlap_end = [availability.end_time, search_end].min
      
      users_with_overlaps[user] << {
        start_time: overlap_start,
        end_time: overlap_end
      }
    end

    # Convert to array and sort by user name
    users_with_overlaps.map do |user, overlaps|
      {
        user: user,
        overlaps: overlaps
      }
    end.sort_by { |item| item[:user].name.downcase }
  end

  def valid_search_params?
    return false unless @day_of_week.between?(0, 6)
    return false unless valid_time_format?(@start_time) && valid_time_format?(@end_time)
    
    base_date = Date.new(2000, 1, 1)
    start_time = Time.zone.parse("#{base_date} #{@start_time}")
    end_time = Time.zone.parse("#{base_date} #{@end_time}")
    
    start_time < end_time
  rescue ArgumentError
    false
  end

  def valid_time_format?(time_string)
    return false if time_string.blank?
    base_date = Date.new(2000, 1, 1)
    Time.zone.parse("#{base_date} #{time_string}")
    true
  rescue ArgumentError
    false
  end
end
