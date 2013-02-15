## Admin

admins = [
{:email => "cloud@wafflestudio.com", :password => "rlaxorals"}
]

puts "MODEL::Admin"

admins.each do |admin|
	e = Admin.new
	e.email = admin[:email]
	e.password = admin[:password]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end

users = [
{:email => "tantara@wafflestudio.com", :password => "rlaxorals"}
]

puts "MODEL::User"

users.each do |user|
	e = Admin.new
	e.email = user[:email]
	e.password = user[:password]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end

templates = [
{:filename => "", :name => "", :description => "", :type => Template::PVM, :arch => Template::X86_64},
{:filename => "", :name => "", :description => "", :type => Template::PVM, :arch => Template::X86_64},
{:filename => "", :name => "", :description => "", :type => Template::PVM, :arch => Template::X86_64},
{:filename => "", :name => "", :description => "", :type => Template::HVM, :arch => Template::X86_64}
]

puts "MODEL::Template"

templates.each do |template|
	e = Template.new
	e.path = Cloud::TEMPLATE_ROOT+"/"+template[:filename]
	e.active = File.exist?(e.path)
	e.name = template[:name]
	e.description = template[:description]
	e.type = template[:type]
	e.arch = template[:arch]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end

instance_specs = [
{:name => "", :description => "", :ram => 0, :core => 0}
]

puts "MODEL::InstanceSpec"

instance_specs.each do |spec|
	e = InstanceSpec.new
	e.active = true
	e.name = spec[:name]
	e.description = spec[:description]
	e.ram = spec[:ram]
	e.core = spec[:core]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end

disk_specs = [
{:name => "", :description => "", :type => DiskSpec::HDD, :size => 64 * DiskSpec::GB},
{:name => "", :description => "", :type => DiskSpec::HDD, :size => 64 * DiskSpec::GB},
{:name => "", :description => "", :type => DiskSpec::HDD, :size => 64 * DiskSpec::GB}
]

puts "MODEL::DiskSpec"

disk_specs.each do |spec|
	e = DiskSpec.new
	e.active = true
	e.name = spec[:name]
	e.description = spec[:description]
	e.type = spec[:type]
	e.size = spec[:size]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end

network_specs = [
{:name => "", :description => "", :type => NetworkSpec::PRIVATE}
]

puts "MODEL::NetworkSpec"

network_specs.each do |spec|
	e = NetworkSpec.new
	e.active = true
	e.name = spec[:name]
	e.description = spec[:description]
	e.type = spec[:type]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end

network_pools = [
{:ip => "", :port => {}}
]

puts "MODEL::NetworkPool"

network_pools.each do |spec|
	e = NetworkPool.new
	e.active = true
	e.ip = spec[:ip]
	e.port = spec[:port]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end
