# frozen_string_literal: true

# Author: Walter Schreppers
# Description:
#  Stores firms in database, helper for inserting missing migrations
#  relations to clients and invoices
class Firm < ActiveRecord::Base
  # attr_accessible :bank, :email, :fax, :logo, :name, :phone, :vat
  has_many :clients
  has_many :invoices, through: :clients

  # If schema_migrations is not up to date you can use:
  # User.insert_missing_migrations("20140206211952")
  # This skips all migrations up to that version
  # Here it's the one with removing index for username.
  # By inserting records in schema_migrations table so you can run rake db:migrate
  # run this in console if you only want to run latest migration (used this for removing the username index)
  #
  # Use with caution!
  def self.insert_missing_migrations(stop_migration = nil)
    files = Dir.glob('db/migrate/*')
    timestamps = files.collect { |f| f.split('/').last.split('_').first }
    only_n_first_migrations = timestamps.split(stop_migration).first

    only_n_first_migrations.each do |version|
      sql = "insert into `schema_migrations` (`version`) values (#{version})"
      begin
        ActiveRecord::Base.connection.execute(sql)
      rescue StandardError
        nil
      end
    end
  end
end
