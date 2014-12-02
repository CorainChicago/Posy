hendrix = Location.create!(name: "Hendrix College", slug: "hendrix")
admin = Admin.create(email: ENV["ORIGINAL_ADMIN_EMAIL"], password: ENV["ORIGINAL_ADMIN_PASSWORD"])
admin.locations << hendrix