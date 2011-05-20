Factory.define :user do |user|
	user.name										"Clark Russell"
	user.email									"clark.russell@bfd.org"
	user.password								"foobar"
	user.password_confirmation  "foobar"
end

Factory.sequence :email do |n|
	"person-#{n}@example.com"
end 

Factory.define :micropost do |micropost|
	micropost.content "Foo bar"
	micropost.association :user
end
