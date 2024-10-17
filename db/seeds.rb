User.destroy_all

admin = User.create!(
	email: 'rob.forbes@rawrmedia.co.uk',
	password: 'AWm@4XcNLCrBE8',
	password_confirmation: 'AWm@4XcNLCrBE8',
	admin: true
)

usage = ApiUsage.create!(
	last_reset: Date.today,
	usage: 0,
	limit: 75000
)

puts "Created admin user: #{admin.email}"
puts "Created API usage: #{usage.usage}/#{usage.limit}"
