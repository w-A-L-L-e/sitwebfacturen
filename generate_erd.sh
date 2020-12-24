
#this is broken
#bundle exec rails g erd:install
#bundle exec rails db:migrate

#this still works after some patching (remove the auto task on db migrate as this does not work)
# remove this:  lib/tasks/auto_generate_diagram.rake
echo "Generating Entity Relationship Diagram..."
echo "using settings in .erdconfig"

bundle exec erd


