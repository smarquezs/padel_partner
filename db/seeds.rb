# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data in development
if Rails.env.development?
  puts "🧹 Clearing existing data..."
  Availability.destroy_all
  User.destroy_all
end

puts "🌱 Creating seed data..."

# Create users with diverse availability patterns
users_data = [
  {
    name: "Alice Johnson",
    email: "alice@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 1, start_time: "18:00", end_time: "20:00" }, # Monday 6-8 PM
      { day_of_week: 3, start_time: "19:00", end_time: "21:00" }, # Wednesday 7-9 PM
      { day_of_week: 6, start_time: "09:00", end_time: "11:00" }  # Saturday 9-11 AM
    ]
  },
  {
    name: "Bob Martinez",
    email: "bob@example.com", 
    password: "password123",
    availabilities: [
      { day_of_week: 1, start_time: "19:00", end_time: "21:00" }, # Monday 7-9 PM
      { day_of_week: 2, start_time: "18:00", end_time: "20:00" }, # Tuesday 6-8 PM
      { day_of_week: 5, start_time: "17:00", end_time: "19:00" }  # Friday 5-7 PM
    ]
  },
  {
    name: "Carol Smith",
    email: "carol@example.com",
    password: "password123", 
    availabilities: [
      { day_of_week: 1, start_time: "17:30", end_time: "19:30" }, # Monday 5:30-7:30 PM
      { day_of_week: 4, start_time: "18:00", end_time: "20:00" }, # Thursday 6-8 PM
      { day_of_week: 0, start_time: "10:00", end_time: "12:00" }  # Sunday 10-12 PM
    ]
  },
  {
    name: "David Chen",
    email: "david@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 2, start_time: "19:00", end_time: "21:00" }, # Tuesday 7-9 PM
      { day_of_week: 4, start_time: "17:00", end_time: "19:00" }, # Thursday 5-7 PM
      { day_of_week: 6, start_time: "08:00", end_time: "10:00" }  # Saturday 8-10 AM
    ]
  },
  {
    name: "Elena Rodriguez",
    email: "elena@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 1, start_time: "18:30", end_time: "20:30" }, # Monday 6:30-8:30 PM
      { day_of_week: 3, start_time: "18:00", end_time: "20:00" }, # Wednesday 6-8 PM
      { day_of_week: 5, start_time: "18:00", end_time: "20:00" }  # Friday 6-8 PM
    ]
  },
  {
    name: "Frank Wilson",
    email: "frank@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 0, start_time: "16:00", end_time: "18:00" }, # Sunday 4-6 PM
      { day_of_week: 2, start_time: "17:30", end_time: "19:30" }, # Tuesday 5:30-7:30 PM
      { day_of_week: 6, start_time: "09:30", end_time: "11:30" }  # Saturday 9:30-11:30 AM
    ]
  },
  {
    name: "Grace Kim",
    email: "grace@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 1, start_time: "17:00", end_time: "19:00" }, # Monday 5-7 PM
      { day_of_week: 3, start_time: "19:30", end_time: "21:30" }, # Wednesday 7:30-9:30 PM
      { day_of_week: 4, start_time: "18:30", end_time: "20:30" }  # Thursday 6:30-8:30 PM
    ]
  },
  {
    name: "Henry Taylor",
    email: "henry@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 0, start_time: "09:00", end_time: "11:00" }, # Sunday 9-11 AM
      { day_of_week: 5, start_time: "17:30", end_time: "19:30" }, # Friday 5:30-7:30 PM
      { day_of_week: 6, start_time: "15:00", end_time: "17:00" }  # Saturday 3-5 PM
    ]
  },
  {
    name: "Isabel Garcia",
    email: "isabel@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 1, start_time: "19:30", end_time: "21:30" }, # Monday 7:30-9:30 PM
      { day_of_week: 2, start_time: "18:30", end_time: "20:30" }, # Tuesday 6:30-8:30 PM
      { day_of_week: 4, start_time: "17:30", end_time: "19:30" }  # Thursday 5:30-7:30 PM
    ]
  },
  {
    name: "Jake Brown",
    email: "jake@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 0, start_time: "11:00", end_time: "13:00" }, # Sunday 11-1 PM
      { day_of_week: 3, start_time: "18:30", end_time: "20:30" }, # Wednesday 6:30-8:30 PM
      { day_of_week: 6, start_time: "10:00", end_time: "12:00" }  # Saturday 10-12 PM
    ]
  },
  {
    name: "Katie Lee",
    email: "katie@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 1, start_time: "20:00", end_time: "22:00" }, # Monday 8-10 PM
      { day_of_week: 2, start_time: "19:00", end_time: "21:00" }, # Tuesday 7-9 PM
      { day_of_week: 5, start_time: "16:00", end_time: "18:00" }  # Friday 4-6 PM
    ]
  },
  {
    name: "Luis Fernandez",
    email: "luis@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 0, start_time: "15:00", end_time: "17:00" }, # Sunday 3-5 PM
      { day_of_week: 3, start_time: "17:00", end_time: "19:00" }, # Wednesday 5-7 PM
      { day_of_week: 6, start_time: "11:00", end_time: "13:00" }  # Saturday 11-1 PM
    ]
  },
  {
    name: "Maya Patel",
    email: "maya@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 1, start_time: "16:00", end_time: "18:00" }, # Monday 4-6 PM
      { day_of_week: 4, start_time: "19:00", end_time: "21:00" }, # Thursday 7-9 PM
      { day_of_week: 5, start_time: "18:30", end_time: "20:30" }  # Friday 6:30-8:30 PM
    ]
  },
  {
    name: "Nathan White",
    email: "nathan@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 0, start_time: "14:00", end_time: "16:00" }, # Sunday 2-4 PM
      { day_of_week: 2, start_time: "17:00", end_time: "19:00" }, # Tuesday 5-7 PM
      { day_of_week: 6, start_time: "16:00", end_time: "18:00" }  # Saturday 4-6 PM
    ]
  },
  {
    name: "Olivia Davis",
    email: "olivia@example.com",
    password: "password123",
    availabilities: [
      { day_of_week: 1, start_time: "15:00", end_time: "17:00" }, # Monday 3-5 PM
      { day_of_week: 3, start_time: "20:00", end_time: "22:00" }, # Wednesday 8-10 PM
      { day_of_week: 5, start_time: "19:00", end_time: "21:00" }  # Friday 7-9 PM
    ]
  }
]

# Create users and their availabilities
users_data.each do |user_data|
  user = User.find_or_create_by!(email: user_data[:email]) do |u|
    u.name = user_data[:name]
    u.password = user_data[:password]
  end
  
  puts "👤 Created user: #{user.name}"
  
  # Create availabilities for this user
  user_data[:availabilities].each do |availability_data|
    availability = user.availabilities.find_or_create_by!(
      day_of_week: availability_data[:day_of_week],
      start_time: availability_data[:start_time],
      end_time: availability_data[:end_time]
    )
    
    day_name = Availability::DAYS_OF_WEEK[availability_data[:day_of_week]]
    puts "  📅 Available #{day_name} #{availability_data[:start_time]} - #{availability_data[:end_time]}"
  end
end

puts "\n✅ Seed data created successfully!"
puts "📊 Created #{User.count} users with #{Availability.count} availability slots"
puts "\nSome overlapping time slots to test:"
puts "🕕 Monday 6-8 PM: Alice, Carol, Elena (overlapping schedules)"
puts "🕰️ Tuesday 6-8 PM: Bob, David, Isabel (overlapping schedules)"  
puts "🕕 Wednesday 6-8 PM: Alice, Elena, Grace (overlapping schedules)"
puts "🕰️ Saturday 9-11 AM: Alice, Frank, Jake (overlapping schedules)"
