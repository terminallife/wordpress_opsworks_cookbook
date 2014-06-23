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
    )

   only_if do
     File.directory?("#{deploy[:deploy_to]}/current")
   end
  end
end
