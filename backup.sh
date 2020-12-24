today=`date "+%Y-%m-%d"`
mysqldump sitwebfacturen_development -u root  > facturen_$today.sql
