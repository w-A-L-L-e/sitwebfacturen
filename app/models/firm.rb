class Firm < ActiveRecord::Base
  #attr_accessible :bank, :email, :fax, :logo, :name, :phone, :vat
  has_many :clients
  has_many :invoices, :through=>:clients

   #If schema_migrations is not up to date you can use:
   # User.insert_missing_migrations("20140206211952")
   # This skips all migrations up to that version (here it's the one with removing index for username) by inserting records in schema_migrations table so you can run rake db:migrate 
   # run this in console if you only want to run latest migration (used this for removing the username index)
   # Use with caution!
   def self.insert_missing_migrations(stop_migration=nil)
     files = Dir.glob("db/migrate/*")
     timestamps = files.collect{|f| f.split("/").last.split("_").first}
     only_n_first_migrations = timestamps.split(stop_migration).first
 
     only_n_first_migrations.each do |version|
       sql = "insert into `schema_migrations` (`version`) values (#{version})"
       ActiveRecord::Base.connection.execute(sql) rescue nil
     end
   end

end
