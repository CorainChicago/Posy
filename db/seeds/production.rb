hendrix = Location.create!(name: "Hendrix College", slug: "hendrix")
demo = Location.create!(name: "University of Demonstrations", slug: "demo")

admin = Admin.create(email: ENV["ORIGINAL_ADMIN_EMAIL"], password: ENV["ORIGINAL_ADMIN_PASSWORD"])
admin.locations << hendrix
admin.locations << demo

