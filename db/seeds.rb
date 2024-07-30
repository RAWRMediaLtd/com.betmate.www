User.destroy_all

admin = User.create!(
	email: 'rob.forbes@rawrmedia.co.uk',
	password: 'AWm@4XcNLCrBE8',
	password_confirmation: 'AWm@4XcNLCrBE8',
	admin: true
)

puts "Created admin user: #{admin.email}"
