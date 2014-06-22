node[:deploy].each do |app_name, deploy|
  template "#{deploy[:deploy_to]}/current/wp-config.php" do
    source "wp-config.php.erb"
    mode 0660
    group deploy[:group]

    if platform?("ubuntu")
      owner "www-data"
    elsif platform?("amazon")   
      owner "apache"
    end

    variables(
      :db_host =>     (deploy[:database][:host] rescue nil),
      :db_user =>     (deploy[:database][:username] rescue nil),
      :db_pass => (deploy[:database][:password] rescue nil),
      :db_name =>       (deploy[:database][:database] rescue nil),
      :salt1 => rand(36**length).to_s(36),
      :salt2 => rand(36**length).to_s(36),
      :salt3 => rand(36**length).to_s(36),
      :salt4 => rand(36**length).to_s(36),
      :salt5 => rand(36**length).to_s(36),
      :salt6 => rand(36**length).to_s(36),
      :salt7 => rand(36**length).to_s(36),
      :salt8 => rand(36**length).to_s(36),
    )

   only_if do
     File.directory?("#{deploy[:deploy_to]}/current")
   end
  end
end
