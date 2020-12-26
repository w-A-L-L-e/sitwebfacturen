# Sitweb facturen rails application
Invoice management webtool used by my companies. It was quickly created during a weekend about 10 years ago, still it has been useful ever since. 
You can create clients, firms and then generate invoices for your firm to a certain client. It also supports 'offertes' aka pro-forma invoice and it generates
the belgian 'gestructureerde mededeling' which is valid on our banks and it generates a pdf to send digitally or to print out to give to clients.

## Installation
It still runs on mysql as back then I hadn't moved to postgresql yet (nowadays most projects I do postgresql is my go-to database along with some redis, memcached etc).
The usual bundle install, rails db:create, rails db:migrate, rails s that you need for a rails project.

```
$ rake db:create
Created database 'facturen_development'
Created database 'facturen_test'

$ rake db:migrate
== 20180402141152 CreateMessages: migrating ===================================
-- create_table(:messages)
   -> 0.0090s
== 20180402141152 CreateMessages: migrated (0.0091s) ==========================

== 20201224160549 CreateClients: migrating ====================================
-- create_table(:clients)
   -> 0.0085s
== 20201224160549 CreateClients: migrated (0.0086s) ===========================

== 20201224160709 CreateFirms: migrating ======================================
-- create_table(:firms)
   -> 0.0134s
== 20201224160709 CreateFirms: migrated (0.0135s) =============================

== 20201224160819 CreateInvoiceLines: migrating ===============================
-- create_table(:invoice_lines)
   -> 0.0108s
== 20201224160819 CreateInvoiceLines: migrated (0.0109s) ======================

== 20201224161009 CreateInvoices: migrating ===================================
-- create_table(:invoices)
   -> 0.0110s
== 20201224161009 CreateInvoices: migrated (0.0111s) ==========================

$ rails s
```
Now server is running on port 3000


## Testing
Tests have not been kept up to date and will likely not run (normally I do write a lot of tests with good coverage, but this freetime project hasn't really needed the need nor the time for it).

## Code style.
Just run rubocop -a and make all your code comply to get nice concise and up to date ruby code styling:
```
$ rubocop -a
Inspecting 57 files
.........................................................

57 files inspected, no offenses detected
```

## Further work
A lot of stuff has been done to make it just work for my usecase. It needs some cleanup and making some things dynamic like the company logo etc.
Apart from that it does work nicely and it has kept track + generated all my invoices in the past 10 years. The nice thing is you get a nice overview and searchable database of all your invoices, clients etc. And also that it works in the browser is great and generating pdf's is much cleaner/professional than some excel file in my opinion.

Translations on some buttons and labels still needs to be done (some are in english, some in dutch...). Basically no time was spent on it other than using adminlte to make it look rather clean and mostly the output (being the pdf for sending to the client) is only thing that got updated over the years. I'll clean this up some day if I've got time for it. For now it's just something I use once a month and its been rock solid and saves me time to work with. At the end of the month its a matter of firing up rails s, typing what i've done, enter days + daily tarrif and hit save to get a nice pdf for my client as invoice.


