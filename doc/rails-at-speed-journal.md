This is a journal, not a memoir. I have recorded some snippets as I
learned them, and described some debugging experiences in
inappropriate detail. Rewritten with hindsight, this would be a lot
shorter. However, I have left the warts, as I think it has more value
as a record of what was easy and what was a little tricky for this
newcomer, than it would have if I rewrote it as a guidebook.

# December 2012

== Useful help requests ==
$ rails --help
$ rails generate --help
$ rails generate model --help
$ rails generate scaffold --help
$ man gittutorial

It is hard to get going without this:
http://guides.rubyonrails.org/testing.html

== Start a new app ==
(based on Ruby on Rails for Dummies, Barry Burd, 2007 - Chapter 12 'More Model Magic'.)

$ cd
$ mkdir dreamblog
$ cd dreamblog
$ rails new ./

Run it. It is small, so it boots quickly.
$ rails server -p 3003
(On my machine, port 3000 is occupied by ntop)

=> Booting WEBrick
=> Rails 3.1.0 application starting in development on http://0.0.0.0:3003
=> Call with -d to detach
=> Ctrl-C to shutdown server
[2012-12-04 15:23:54] INFO  WEBrick 1.3.1
[2012-12-04 15:23:54] INFO  ruby 1.9.2 (2011-07-09) [i686-linux]
[2012-12-04 15:23:54] INFO  WEBrick::HTTPServer#start: pid=9797 port=3003

With a web browser, http://localhost:3003 lists the next three steps to get started with sqlite. But if you are in a hurry, the page is at
dreamblog/public/index.html

$ rails generate model Dream
      invoke  active_record
      create    db/migrate/20121204160404_create_dreams.rb
      create    app/models/dream.rb
      invoke    test_unit
      create      test/unit/dream_test.rb
      create      test/fixtures/dreams.yml

Edit db/migrate/20121204160404_create_dreams.rb to add 2 columns

class CreateDreams < ActiveRecord::Migration
  def change
    create_table :dreams do |t|
      t.column :title, :string
      t.column :description, :text
      t.timestamps
    end
  end
end

db:create step clearly not needed these days:

$ rake db:create
db/development.sqlite3 already exists

$ rake db:migrate
==  CreateDreams: migrating ===================================================
-- create_table(:dreams)
   -> 0.0180s
==  CreateDreams: migrated (0.0186s) ==========================================

$ rm public/index.html

$ rails generate scaffold Dream title:string description:string
      invoke  active_record
Another migration is already named create_dreams: /home/david1/dreamblog/db/migrate/20121204160404_create_dreams.rb

I don't like the look of the response. I didn't want a migration, and I ended up without a scaffold.

Annoyingly, the word 'invoke' is not visible (it is grey): apparently a default
black-on-white terminal is not checked for.

Lets step backwards and blow away the migration and the db.

$ rm db/development.sqlite3 db/migrate/20121204160404_create_dreams.rb

and try again with the scaffold generator

$ rails generate scaffold Dream title:string description:string
      invoke  active_record
      create    db/migrate/20121206105527_create_dreams.rb
   identical    app/models/dream.rb
      invoke    test_unit
   identical      test/unit/dream_test.rb
    conflict      test/fixtures/dreams.yml
    Overwrite /home/david1/dreamblog/test/fixtures/dreams.yml? (enter "h" for help) [Ynaqdh] h
    Y - yes, overwrite
n - no, do not overwrite
a - all, overwrite this and all others
q - quit, abort
d - diff, show the differences between the old and the new
h - help, show this help
    Overwrite /home/david1/dreamblog/test/fixtures/dreams.yml? (enter "h" for help) [Ynaqdh] d
--- /home/david1/dreamblog/test/fixtures/dreams.yml     2012-12-04 16:04:04.000000000 +0000
+++ /home/david1/dreamblog/test/fixtures/dreams.yml20121206-4413-1m9cpz2        2012-12-06 11:11:59.000000000 +0000
@@ -1,11 +1,9 @@
 # Read about fixtures at http://api.rubyonrails.org/classes/Fixtures.html
 
-# This model initially had no columns defined.  If you add columns to the
-# model remove the '{}' from the fixture names and add the columns immediately
-# below each fixture, per the syntax in the comments below
-#
-one: {}
-# column: value
-#
-two: {}
-#  column: value
+one:
+  title: MyString
+  description: MyString
+
+two:
+  title: MyString
+  description: MyString
    Retrying...
    Overwrite /home/david1/dreamblog/test/fixtures/dreams.yml? (enter "h" for help) [Ynaqdh] Y
       force      test/fixtures/dreams.yml
       route  resources :dreams
      invoke  scaffold_controller
      create    app/controllers/dreams_controller.rb
      invoke    erb
      create      app/views/dreams
      create      app/views/dreams/index.html.erb
      create      app/views/dreams/edit.html.erb
      create      app/views/dreams/show.html.erb
      create      app/views/dreams/new.html.erb
      create      app/views/dreams/_form.html.erb
      invoke    test_unit
      create      test/functional/dreams_controller_test.rb
      invoke    helper
      create      app/helpers/dreams_helper.rb
      invoke      test_unit
      create        test/unit/helpers/dreams_helper_test.rb
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/dreams.js.coffee
      invoke    scss
      create      app/assets/stylesheets/dreams.css.scss
      invoke  scss
      create    app/assets/stylesheets/scaffolds.css.scss


The scaffold generator even made a route for me, even though the generator help said it would only make a model, controller and views:
Dreamblog::Application.routes.draw do
  resources :dreams
end

(There are lots of terse examples left in the comments of routes.rb, which I guess really ought to be deleted, and then get my help from the api doc and rails guides. 
http://api.rubyonrails.org/classes/ActionDispatch/Routing.html
http://guides.rubyonrails.org/routing.html
It looks like resources :dreams will generate the basic CRUD methods at compile time.)

The db migration is more terse than the partly handwritten one I copied from the book. I thought I asked the generator for string datatypes but I don't get them generated.

class CreateDreams < ActiveRecord::Migration
  def change
    create_table :dreams do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end



Make the db again:
$ rake db:migrate
==  CreateDreams: migrating ===================================================
-- create_table(:dreams)
   -> 0.0093s
==  CreateDreams: migrated (0.0103s) ==========================================


$ rails server -p 3003

but the route I expected doesn't work

http://localhost:3003/dreams/show/1

Action Controller: Exception caught

Routing Error

No route matches [GET] "/dreams/show/1"

Troubleshoot:
$ rake routes
    dreams GET    /dreams(.:format)          {:action=>"index", :controller=>"dreams"}
           POST   /dreams(.:format)          {:action=>"create", :controller=>"dreams"}
 new_dream GET    /dreams/new(.:format)      {:action=>"new", :controller=>"dreams"}
edit_dream GET    /dreams/:id/edit(.:format) {:action=>"edit", :controller=>"dreams"}
     dream GET    /dreams/:id(.:format)      {:action=>"show", :controller=>"dreams"}
           PUT    /dreams/:id(.:format)      {:action=>"update", :controller=>"dreams"}
           DELETE /dreams/:id(.:format)      {:action=>"destroy", :controller=>"dreams"}

Aha! As is confirmed in the Rails Guide, I don't have 'show' in the default route.

This works

http://localhost:3003/dreams/
Listing dreams

Title	Description			

New Dream

Page title is "Dreamblog" - from my directory name :) I guess I
configure that somewhere

http://localhost:3003/dreams/1

ActiveRecord::RecordNotFound in DreamsController#show

Couldn't find Dream with id=1

As expected. I don't have a migration or other script to seed the
database, so I have only an empty table.

New dream takes me to 

http://localhost:3003/dreams/new

I write it, hit the button and now
http://localhost:3003/dreams/1
shows me the flash message "Dream was successfully created."  and the dream.

Yay! I have a working CRUD app in a few steps, with just a few slip
ups, that were easily undone. It looks a bit plain though!!!

(As above there is no list URL, but instead 
http://localhost:3003/dreams
is both the app's home page , and the list of dreams.)

Tests don't run

$ rake test
/usr/local/lib/ruby/gems/1.9.1/gems/turn-0.9.6/lib/turn/minitest.rb:23:in `<top (required)>': MiniTest v1.6.0 is out of date. (RuntimeError)
`gem install minitest` and add `gem 'minitest' to you test helper.

So tweak the Gemfile and test/test_helper.rb

--- Gemfile.~1~ 2012-12-04 13:52:15.000000000 +0000
+++ Gemfile     2012-12-07 12:44:11.000000000 +0000
@@ -26,9 +26,10 @@
 # gem 'capistrano'
 
 # To use debugger
-# gem 'ruby-debug19', :require => 'ruby-debug'
+gem 'ruby-debug19', :require => 'ruby-debug'
 
 group :test do
   # Pretty printed test output
   gem 'turn', :require => false
+  gem 'minitest'
 end


$ diff -u test/test_helper.rb.~1~ test/test_helper.rb
--- test/test_helper.rb.~1~     2012-12-04 13:52:17.000000000 +0000
+++ test/test_helper.rb 2012-12-07 12:44:07.000000000 +0000
@@ -1,6 +1,7 @@
 ENV["RAILS_ENV"] = "test"
 require File.expand_path('../../config/environment', __FILE__)
 require 'rails/test_help'
+require 'minitest'
 
 class ActiveSupport::TestCase
   # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.

$ bundle install --without production


It went wrong again:
david1@exmouth:~/dreamblog$ rake test
/usr/local/lib/ruby/gems/1.9.1/gems/turn-0.9.6/lib/turn/minitest.rb:23:in `<top (required)>': MiniTest v1.6.0 is out of date. (RuntimeError)
`gem install minitest` and add `gem 'minitest' to you test helper.


$ gem search minitest

*** LOCAL GEMS ***

minitest (1.6.0)
$ gem update minitest

... You don't have write permissions  ...

$ sudo gem update minitest
[sudo] password for david1: 
Updating installed gems
Updating minitest
Fetching: minitest-4.3.3.gem (100%)
Successfully installed minitest-4.3.3
Gems updated: minitest
Installing ri documentation for minitest-4.3.3...
Installing RDoc documentation for minitest-4.3.3...
$ 

but I tried 'rake test' before 
$ bundle install --without production

After this, I have no idea why this is still happening:
/usr/local/lib/ruby/gems/1.9.1/gems/turn-0.9.6/lib/turn/minitest.rb:23:in `<top (required)>': MiniTest v1.6.0 is out of date. (RuntimeError)
`gem install minitest` and add `gem 'minitest' to you test helper.

Now I know. Gemfile.lock contains
    minitest (1.6.0)

Tried deleting that line. No good. bundler should manage Gemfile.lock

Reverted. Cargo cult administration:

$ bundle update --without production
Unknown switches '--without'
$ bundle update

Using activesupport (3.1.0) 
Using bcrypt-ruby (3.0.1) 
Using builder (3.0.4) 
Using i18n (0.6.1) 
Using activemodel (3.1.0) 
Using erubis (2.7.0) 
Using rack (1.3.6) 
Using rack-cache (1.0.3) 
Using rack-mount (0.8.3) 
Using rack-test (0.6.2) 
Using hike (1.2.1) 
Using tilt (1.3.3) 
Using sprockets (2.0.4) 
Using actionpack (3.1.0) 
Using mime-types (1.19) 
Using polyglot (0.3.3) 
Using treetop (1.4.12) 
Using mail (2.3.3) 
Using actionmailer (3.1.0) 
Using arel (2.2.3) 
Using tzinfo (0.3.35) 
Using activerecord (3.1.0) 
Using activeresource (3.1.0) 
Using ansi (1.4.3) 
Using bundler (1.1.4) 
Using coffee-script-source (1.4.0) 
Using execjs (1.4.0) 
Using coffee-script (2.2.0) 
Using rack-ssl (1.3.2) 
Using json (1.7.5) 
Using rdoc (3.12) 
Using thor (0.14.6) 
Using railties (3.1.0) 
Using coffee-rails (3.1.1) 
Using jquery-rails (2.1.4) 
Using rails (3.1.0) 
Installing ref (1.0.2) 
Using sass (3.2.3) 
Using sass-rails (3.1.6) 
Using sqlite3 (1.3.6) 
Installing therubyracer (0.11.0) with native extensions 
Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension.

        /usr/local/bin/ruby extconf.rb 
checking for main() in -lpthread... yes
checking for v8.h... no
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of
necessary libraries and/or headers.  Check the mkmf.log file for more
details.  You may need configuration options.

Provided configuration options:
        --with-opt-dir
        --without-opt-dir
        --with-opt-include
        --without-opt-include=${opt-dir}/include
        --with-opt-lib
        --without-opt-lib=${opt-dir}/lib
        --with-make-prog
        --without-make-prog
        --srcdir=.
        --curdir
        --ruby=/usr/local/bin/ruby
        --with-pthreadlib
        --without-pthreadlib
        --enable-debug
        --disable-debug
        --with-v8-dir
        --without-v8-dir
        --with-v8-include
        --without-v8-include=${v8-dir}/include
        --with-v8-lib
        --without-v8-lib=${v8-dir}/lib
/home/david1/.bundler/tmp/5070/gems/therubyracer-0.11.0/ext/v8/build.rb:42:in `build_with_system_libv8': unable to locate libv8. Please see output for details (RuntimeError)
        from extconf.rb:22:in `<main>'
    The Ruby Racer requires libv8 ~> 3.11.8
    to be present on your system in order to compile
    and link, but it could not be found.

    In order to resolve this, you will either need to manually
    install an appropriate libv8 and make sure that this
    build process can find it. If you install it into the
    standard system path, then it should just be picked up
    automatically. Otherwise, you'll have to pass some extra
    flags to the build process as a hint.

    If you don't want to bother with all that, there is a
    rubygem that will do all this for you. You can add
    following line to your Gemfile:
        gem 'libv8', '~> 3.11.8'

    We hope that helps, and we apologize, but now we have
    to push the eject button on this install.

    thanks,
    The Mgmt.



Gem files will remain installed in /home/david1/.bundler/tmp/5070/gems/therubyracer-0.11.0 for inspection.
Results logged to /home/david1/.bundler/tmp/5070/gems/therubyracer-0.11.0/ext/v8/gem_make.out
An error occured while installing therubyracer (0.11.0), and Bundler cannot continue.
Make sure that `gem install therubyracer -v '0.11.0'` succeeds before bundling.
$

This might be ok. Just find the previous therubyracer version in Gemfile.lock, and paste it into the Gemfile so the line becomes 
  gem 'therubyracer', '0.10.2'

'bundle update' works this time, but doesn't mention minitest, and doesn't actually update anythin.
$ gem query | grep minites
minitest (4.3.3, 1.6.0)

http://stackoverflow.com/questions/7870074/what-do-i-do-with-this-error-when-i-run-tests-in-rails

Add a versioned (minitest) to the group :test block in Gemfile:
$ diff -u Gemfile \#Gemfile# 
--- Gemfile     2012-12-07 15:48:04.000000000 +0000
+++ #Gemfile#   2012-12-07 15:52:55.000000000 +0000
@@ -32,4 +32,5 @@
 group :test do
   # Pretty printed test output
   gem 'turn', :require => false
+  gem 'minitest ">= 2.0"
 end

Nope. rake spec fails
There was an error in your Gemfile, and Bundler cannot continue.
Try this in the Gemfile instead:
  gem 'minitest ">= 4.3.3"

Bah - missing a quote mark
  gem 'minitest' ">= 2.0"

What is bothering me is why I am using the gem at all, rather than the minitest that comes in the Ruby 1.9 standard library. Probably because the built-in one is too old for Rails 3.

$ rake test
Could not find gem 'minitest>= 2.0 (>= 0) ruby' in the gems available on this machine.
Run `bundle install` to install missing gems.

Next I will try
   gem 'minitest' ">= 4.3.3"

$ rake test
Could not find gem 'minitest>= 4.3.3 (>= 0) ruby' in the gems available on this machine.
Run `bundle install` to install missing gems.


$ rake test
Could not find gem 'minitest>= 2.0 (>= 0) ruby' in the gems available on this machine.
Run `bundle install` to install missing gems.
$ rake test
Could not find gem 'minitest>= 4.3.3 (>= 0) ruby' in the gems available on this machine.
Run `bundle install` to install missing gems.

Cargo cults are useless, but we worship anyway:
david1@exmouth:~/dreamblog$ bundle exec rake test
$ bundle exec rake test
Could not find gem 'minitest>= 4.3.3 (>= 0) ruby' in the gems available on this machine.
Run `bundle install` to install missing gems.

Single quotes?
 gem 'minitest' '4.3.3'

And a comma?
  gem 'minitest', '4.3.3'

It's Ruby: parameter arrays need commas. Pay attention!

$ bundle exec rake test
/usr/local/lib/ruby/gems/1.9.1/gems/activesupport-3.1.0/lib/active_support/dependencies.rb:240:in `require': no such file to load -- minitest (LoadError)

At last the Gemfile.lock contains the line minitest (4.3.3) but we are not done.

Dealing with the above error, delete 
require 'minitest'
from line 4 of test/test_helper.rb

And, at last, after several frustrating hours, all 7 scaffold tests succeed:

$ bundle exec rake test
Loaded Suite test,test/unit/helpers,test/unit,test/performance,test/functional

Started at 2012-12-07 16:42:05 +0000 w/ seed 747.

Finished in 0.083326 seconds.

0 tests, 0 passed, 0 failures, 0 errors, 0 skips, 0 assertions

Loaded Suite test,test/unit/helpers,test/unit,test/performance,test/functional

Started at 2012-12-07 16:44:28 +0000 w/ seed 27599.

DreamsControllerTest
     PASS (0:00:01.441) test_should_create_dream
     PASS (0:00:01.509) test_should_destroy_dream
     PASS (0:00:03.033) test_should_get_edit
     PASS (0:00:03.148) test_should_get_index
     PASS (0:00:03.246) test_should_get_new
     PASS (0:00:03.321) test_should_show_dream
     PASS (0:00:03.428) test_should_update_dream

Finished in 3.429375 seconds.

7 tests, 7 passed, 0 failures, 0 errors, 0 skips, 10 assertions

Started a new git project:

~/dreamblog$ git init
~/dreamblog$ git add .

and when the tests passed
$ git commit -m "basic scaffold and Test::Unit tests"

To get 'autotest' to run added
  gem 'ZenTest'
to group :test in Gemfile

This is nice ('bundle exec' is vital to avoid a minitest version error):

$ xterm -T 'autotest' -e 'bundle exec autotest' &

but the result is unexpected:

/usr/local/bin/ruby -I.:lib:test -rubygems -e "%w[test/unit test/test_helper.rb].each { |f| require f }"
Loaded Suite test,test/unit/helpers,test/unit,test/performance,test/functional

Started at 2013-01-09 13:10:50 +0000 w/ seed 59231.

Finished in 0.037281 seconds.

0 tests, 0 passed, 0 failures, 0 errors, 0 skips, 0 assertions

Zero tests? What happened to the 7 tests from test/functional/dreams_controller_test.rb that pass when I run 'rake test'?

(Note: if I wanted rspec, I would have needed 
  gem 'rspec-rails'
in the Gemfile, and
$ rails generate rspec:install
)

Quick note: these placeholder tests PASS (with 'bundle exec test') and I'd prefer they were yellow:

  test "should reject new dream without description" do
    # not implemented
  end

  test "should reject edit to dream without title" do
    pending
    # not implemented
  end

Getting debugger, adding to test/test_helper.rb  (instead of spec/spec_helper.rb in rottenpotatoes with rspec)
require 'ruby-debug'

despite the ELLS book  p172 this isn't enough, I also need to add to the Gemfile
group :development, :test do
  gem 'ruby-debug'
end

but how did this error happen when it was ok a few minutes ago? Perhaps it is because linecache is a dependency of ruby-debug

Installing linecache (0.46) with native extensions 
Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension.

        /usr/local/bin/ruby extconf.rb 
Can't handle 1.9.x yet
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of
necessary libraries and/or headers.  Check the mkmf.log file for more
details.  You may need configuration options.

Provided configuration options:
        --with-opt-dir
        --without-opt-dir
        --with-opt-include
        --without-opt-include=${opt-dir}/include
        --with-opt-lib
        --without-opt-lib=${opt-dir}/lib
        --with-make-prog
        --without-make-prog
        --srcdir=.
        --curdir
        --ruby=/usr/local/bin/ruby


Gem files will remain installed in /home/david1/.bundler/tmp/5619/gems/linecache-0.46 for inspection.
Results logged to /home/david1/.bundler/tmp/5619/gems/linecache-0.46/ext/gem_make.out
An error occured while installing linecache (0.46), and Bundler cannot continue.
Make sure that `gem install linecache -v '0.46'` succeeds before bundling.

It turns out that I need a different version of ruby-debug, which ends up with this Gemfile stanza:

group :development, :test do
  gem 'ruby-debug19', :require => 'ruby-debug'
end

Per the ZenTest readme, adding to test/test_helper.rb

gem "minitest"
require "minitest/autorun"

still a bit stuck with this .... where do I put this add_hook stanza and how does it work?

.autotest:

    Autotest.add_hook :initialize do |at|
      at.testlib = ".minitest"
    end

I'll try it in test/test_helper.rb

Nope, definitely not there : )
"/home/david1/dreamblog/test/test_helper.rb:8:in `<top (required)>': uninitialized constant Autotest (NameError)"

Also added 
require 'ruby-debug'
to 
test/unit/helpers/dreams_helper_test.rb

====
Stuck on autotesting, I continued by commenting out the Autotest stanza and using 
bundle exec rake test 
when needed

I put some fixtures in test/fixtures/dreams.yml (though I didn't really need them) and found that while some fixtures loaded, others caused errors that I couldn't track down:
          a YAML error occurred parsing /home/david1/dreamblog/test/fixtures/dreams.yml. Please note that YAML must be consistently indented using spaces. Tabs are not allowed. Please have a look at http://www.yaml.org/faq.html
          The exact error was:
            ArgumentError: syntax error on line 30, col -2: `one_and_only:
            title: A duplicate title
            description: Titles must be unique
          
but I don't really need these set up in the database for every test, so I'll do without for now

To see if fixtures work without running all the tests, do this
rake db:fixtures:load
sqlite3 db/development.sqlite3 .dump
I should see all my fixtures. Syntax errors in the YAML will be spotted by the rake task.

Weirdly, I cut and pasted the fixture from the above error message into my shorter dreams.yml script, and this time it works without error. I wonder if there really was a hidden tab in there that I forgot to delete and retype as a space. I will never know.

====
MiniTest notes:

running in the app's root directory with 
bundle exec rake test

Tests are evaluated in reverse order (weird.)
Test methods get named on the fly according to their description, for example 
 test "should reject edit to dream without title" becomes 
test_should_reject_edit_to_dream_without_title

A test containing
do
pending
end
is marked SKIP in blue "Skipped, no message given"
with a stack trace:
        @ /usr/local/lib/ruby/gems/1.9.1/gems/activesupport-3.1.0/lib/active_support/testing/pending.rb:15:in `pending'

A test containing just
do
end
is marked PASS in green.

A test without a do end is marked FAIL red 'No implementation provided for should reject new dream without description'

If I want to debug in the context of a test, I can just include
debugger 
in the do .. end block of a test, and 
require 'test_helper'
at the start of the file.

Assertions are documented here:
file:///usr/local/lib/ruby/gems/1.9.1/doc/minitest-4.3.3/rdoc/MiniTest/Assertions.html
but there is a nice summary, if not always up to date, in this wonderful article
http://guides.rubyonrails.org/testing.html

Note that assert_raises does not accept a custom message.

Lots more experiences with minitest follow, as I try to test validations.
==

debugger in the test wasn't too bad, but an assertion led to the program continuing.

Troubleshooting this error 
DreamsControllerTest
    ERROR (0:00:00.577) test_should_create_dream
          No fixture with name 'one' found for table 'dreams'
        @ /usr/local/lib/ruby/gems/1.9.1/gems/activerecord-3.1.0/lib/active_record/fixtures.rb:851:in `block (4 levels) in setup_fixture_accessors'
led to using git diff like this

git diff HEAD^ HEAD ./test/fixtures/dreams.yml

which shows the diff between the last-but-one and the last commit.

So I was able to change my controller test to cope with a change of name of one of my fixtures.
==

Can write a test using the basic assertions listed in the MiniTest source code : there doesn't seem to be much of a doc in the rdoc.

/usr/local/lib/ruby/gems/1.9.1/gems/minitest-4.3.3/lib/minitest/unit.rb

For example, this is the first one I got this one to fail red:

class DreamTest < ActiveSupport::TestCase

  test "should reject new dream without title" do
    descr = 'This dream has no title'
    count = Dream.count
    Dream.create!(:title => '', :description => descr)
    assert_equal Dream.count, count # relies on single-threaded testing
    assert_nil Dream.find_by_description(descr)
  end

end

Note that execution does not continue to the second assertion.

However there are some useful examples of assertion style in dreams_controller_test.rb that was created by the generator.

I can see that while I prefer to write imperative assertions, the error message such as this one is not as quick to grasp as an error from a spec.

     FAIL (0:00:00.941) test_should_reject_new_dream_without_title
          Expected #<Dream id: 746868372, title: "", description: "This dream has no title", created_at: "2013-02-11 21:14:05", updated_at: "2013-02-11 21:14:05"> to be nil.


I wonder how practical it is to parse yml like this in the body of a test
# title_missing:
#   title:
#   description: This dream has no title.
instead of either putting in a fixture (where it may only be needed for 1 or 2 tests) or writing:
    descr = 'This dream has no title'
    Dream.create!(:title => '', :description => descr)

I wrote 4 new tests in above style for dream.rb
class Dream < ActiveRecord::Base
  validates_presence_of :title, :description
end
They worked, but they are the wrong style: I should obviously assert an error, as each test errors out like this
    ERROR (0:00:00.367) test_should_reject_edit_to_dream_without_description
          Validation failed: Description can't be blank

The validate hooks clearly work, so I am getting there. Just need to change my test assertions. :)

I could make up my own assertion based on exception handling. However, to be DRY , I should re-use one in Ruby or Rails.

The Rails docs aren't stored with my rails gem but instead are at
file:///usr/share/doc/rails-doc/html/index.html
(but these are for Rails 2.3.5 and don't even deprecate ActiveRecord:Errors#on even though it is missing from Rails 3.1.0. For some reason my docs at file:///usr/local/lib/ruby/gems/1.9.1/doc/rails-3.1.0/rdoc/index.html are almost empty.)

ActionController has some assertions including
assert_response(:error) but that represents an HTTP error response code (501-599). However the page give a 200 success response.

When I create or update a record it gets a message added to its errors property, like this.

$ bundle exec rails console
Loading development environment (Rails 3.1.0)
irb(main):001:0> dream = Dream.create
=> #<Dream id: nil, title: nil, description: nil, created_at: nil, updated_at: nil>
irb(main):002:0> dream.errors
=> #<ActiveModel::Errors:0xa8effa8 @base=#<Dream id: nil, title: nil, description: nil, created_at: nil, updated_at: nil>, @messages={:title=>["can't be blank"], :description=>["can't be blank"]}>
irb(main):008:0> dream.errors.include?(:title)
=> true
irb(main):009:0> dream.errors.include?(:description)
=> true
irb(main):010:0> dream.save!
ActiveRecord::RecordInvalid: Validation failed: Title can't be blank, Description can't be blank
        from /usr/local/lib/ruby/gems/1.9.1/gems/activerecord-3.1.0/lib/active_record/validations.rb:56:in `save!'

I can use this without trying to save the record and catching an error. It is not so thorough a test, but it is what I wanted. Notice that the attributes that failed validation are the keys for the errors, so I can use .include?(:title) and so on. 

class DreamTest < ActiveSupport::TestCase

  test "should reject new dream without title" do
    descr = 'This dream has no title'
    dream = Dream.create(:title => '', :description => descr)
    assert dream.errors.include?(:title)
  end
end

Silly syntax errors:

  test "should reject edit to dream without description" do
    dreams(:good).update_attributes(:title => 'I changed the title', :description => '')
    assert dream.errors.include?(:description)
  end

    ERROR (0:00:00.794) test_should_reject_edit_to_dream_without_description
          undefined local variable or method `dream' for #<DreamTest:0xb492220>
        @ test/unit/dream_test.rb:24:in `block in <class:DreamTest>'

I forgot 'dream = '

  test "should reject edit to dream without title" do
    dream = dreams(:good).update_attributes(:title => '', :description => 'I changed the description')
    assert dream.errors.include?(:title)
  end

    ERROR (0:00:00.835) test_should_reject_edit_to_dream_without_title
          undefined method `errors' for true:TrueClass
        @ test/unit/dream_test.rb:19:in `block in <class:DreamTest>'

It seems that update_attributes doesn't return a model as I expected, but merely returns true.

Also update_attributes doesn't set the errors property. Instead I need to use save.


pending "not implemented"
puts the 'not implemented' string in the skip log.

I'll also experiment with MiniTest::Assertions#assert_raises, documented in

file:///usr/local/lib/ruby/gems/1.9.1/doc/minitest-4.3.3/rdoc/MiniTest/Assertions.html

In MiniTest, the opposite of assert is refute.

    ERROR (0:00:01.616) test_should_reject_edit_to_dream_description_shorter_than_10_chars
          uninitialized constant DreamTest::RecordInvalid
        @ test/unit/dream_test.rb:51:in `block in <class:DreamTest>'

  test "should reject edit to dream description shorter than 10 chars" do
    assert_raises RecordInvalid, msg="didn't raise an invalid error for a short desciption" do
      Dream.create!(:title => 'Short dream', :description => 'Only 9 ch')
    end
  end

Needed to make the expected exception type a label with a colon ':' (what a mouthful) :

assert_raises :RecordInvalid, msg="didn't raise an invalid error for a short desciption" do ...

The I get 
     FAIL (0:00:04.257) test_should_reject_edit_to_dream_description_shorter_than_10_chars
          didn't raise an invalid error for a short desciption.
          :RecordInvalid expected but nothing was raised.
which I think is what I want.

But it doesn't pass when I expect:
    ERROR (0:00:04.005) test_should_reject_edit_to_dream_description_shorter_than_10_chars
          class or module required
        @ test/unit/dream_test.rb:51:in `block in <class:DreamTest>'

Also, this code looks right but maybe max and min parameters can't be set in same message.

  validates_length_of :description, :minimum => 10, 
  :maximum => 500
  # Following 2 tests have failed so I don't think my code for them is right.
  #  test_should_reject_edit_to_dream_description_longer_than_500_chars
  # test_should_reject_new_dream_with_description_longer_than_500_chars

Actually, it turns out that my validation code was fine, but my test string was too short!  

(This is fine
  validates_length_of :description, :minimum => 10, :maximum => 500
)

Next time I should either test my handmade string with
"A string".length
or make it programmatically, such as this way:
irb(main):020:0> str = ""
irb(main):021:0> 500.times { str = str + "x"}

Must return to the 'class or module required' error as it is the only one left.

Yay! I got it to fail, though not really what I wanted.
     FAIL (0:00:00.501) test_should_reject_edit_to_dream_description_shorter_than_10_chars
          RecordInvalid.
          [] exception expected, not
          Class: <ActiveRecord::RecordInvalid>
          Message: <"Validation failed: Description is too short (minimum is 10 characters)">
          ---Backtrace---
          /usr/local/lib/ruby/gems/1.9.1/gems/activerecord-3.1.0/lib/active_record/validations.rb:56:in `save!'

Now my test looks like this, but it should pass:
    assert_raises ('RecordInvalid') {Dream.create!(:title => 'Short dream', :description => 'Only 9 ch')}

By the way, rake test isn't needed. I can run the tests as shown in
the testing Rails Guide, preceded by bundle exec, such as
~/dreamblog$ bundle exec ruby -Itest test/unit/dream_test.rb -n  test_should_reject_edit_to_dream_description_shorter_than_10_chars

So I explicitly set out the superclass, and it becomes a ruby object,
and doesn't need to be quoted. This passes:
    assert_raises (ActiveRecord::RecordInvalid) {Dream.create!(:title => 'Short dream', :description => 'Only 9 ch')}

and it fails properly when I omit the validation:

     FAIL (0:00:00.573) test_should_reject_edit_to_dream_description_shorter_than_10_chars
          ActiveRecord::RecordInvalid expected but nothing was raised.

Notice that #assert_raises creates its own messages.

The multiline version of the block syntax is also fine:
    assert_raises (ActiveRecord::RecordInvalid) do
      Dream.create!(:title => 'Short dream', :description => 'Only 9 ch')
    end

## Moving to a new development machine, and upgrading to Rails 3.2
*August 4, 2013*

Git cloned, then edited the Gemfile to upgrade to Rails 3.2

Your bundle is updated!
david2@www:~/daves-dream-blog$ rails s
/home/david2/.rvm/gems/ruby-1.9.3-p448/gems/ruby-debug-base19-0.11.25/lib/ruby-debug-base\
.rb:1:in `require': /home/david2/.rvm/gems/ruby-1.9.3-p448/gems/ruby-debug-base19-0.11.25\
/lib/ruby_debug.so: undefined symbol: ruby_current_thread - /home/david2/.rvm/gems/ruby-1\
.9.3-p448/gems/ruby-debug-base19-0.11.25/lib/ruby_debug.so (LoadError)
        from /home/david2/.rvm/gems/ruby-1.9.3-p448/gems/ruby-debug-base19-0.11.25/lib/ru\
by-debug-base.rb:1:in `<top (required)>'

Switched from gem `'reby-debug19'` to `gem 'debugger'`

````
$ bundle install --without :production :assets`
david2@www:~/daves-dream-blog$ rails s
=> Booting WEBrick
=> Rails 3.2.14 application starting in development on http://0.0.0.0:3000
=> Call with -d to detach
=> Ctrl-C to shutdown server
[2013-08-04 08:15:21] INFO  WEBrick 1.3.1
[2013-08-04 08:15:21] INFO  ruby 1.9.3 (2013-06-27) [i686-linux]
[2013-08-04 08:15:21] WARN  TCPServer Error: Address already in use - bind(2)
Exiting
/home/david2/.rvm/rubies/ruby-1.9.3-p448/lib/ruby/1.9.1/webrick/utils.rb:85:in `initialize': Address already in use - bind(2) (Errno::EADDRINUSE)

Something already using port 3000 on that machine.

Logout and back in again forwarding port 3001 this time

````
david2@www:~/daves-dream-blog$ rails s -p 3001
=> Booting WEBrick
=> Rails 3.2.14 application starting in development on http://0.0.0.0:3001
=> Call with -d to detach
=> Ctrl-C to shutdown server
[2013-08-04 08:17:50] INFO  WEBrick 1.3.1
[2013-08-04 08:17:50] INFO  ruby 1.9.3 (2013-06-27) [i686-linux]
[2013-08-04 08:17:50] INFO  WEBrick::HTTPServer#start: pid=9412 port=3001


Started GET "/" for 127.0.0.1 at 2013-08-04 08:17:55 +0100
Connecting to database specified by database.yml

ActionController::RoutingError (No route matches [GET] "/"):
  actionpack (3.2.14) lib/action_dispatch/middleware/debug_exceptions.rb:21:in `call'
...
Started GET "/dreams" for 127.0.0.1 at 2013-08-04 08:18:02 +0100
Processing by DreamsController#index as HTML
Completed 500 Internal Server Error in 1ms

ActiveRecord::StatementInvalid (Could not find table 'dreams'):
  app/controllers/dreams_controller.rb:5:in `index'
...

david2@www:~/daves-dream-blog$ rake routes
    dreams GET    /dreams(.:format)          dreams#index
           POST   /dreams(.:format)          dreams#create
 new_dream GET    /dreams/new(.:format)      dreams#new
edit_dream GET    /dreams/:id/edit(.:format) dreams#edit
     dream GET    /dreams/:id(.:format)      dreams#show
           PUT    /dreams/:id(.:format)      dreams#update
           DELETE /dreams/:id(.:format)      dreams#destroy
david2@www:~/daves-dream-blog$ rake db:init
rake aborted!
Don't know how to build task 'db:init'
/home/david2/.rvm/gems/ruby-1.9.3-p448/bin/ruby_noexec_wrapper:14:in `eval'
/home/david2/.rvm/gems/ruby-1.9.3-p448/bin/ruby_noexec_wrapper:14:in `<main>'
(See full trace by running task with --trace)
david2@www:~/daves-dream-blog$ rake db:migrate
==  CreateDreams: migrating ===================================================
-- create_table(:dreams)
   -> 0.0013s
==  CreateDreams: migrated (0.0014s) ==========================================
```

But after the migration, I get a sass error, even after a more aggressive bundle install:
````
WARN: tilt autoloading 'sass' in a non thread-safe way; explicit require 'sass' suggested.
Connecting to database specified by database.yml
   (0.1ms)  select sqlite_version(*)
   (28.4ms)  CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL) 
   (3.4ms)  CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version")
   (0.1ms)  SELECT "schema_migrations"."version" FROM "schema_migrations" 
Migrating to CreateDreams (20121206105527)
   (0.0ms)  begin transaction
   (0.4ms)  CREATE TABLE "dreams" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "description" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL) 
   (0.1ms)  INSERT INTO "schema_migrations" ("version") VALUES ('20121206105527')
   (3.6ms)  commit transaction
   (0.1ms)  SELECT "schema_migrations"."version" FROM "schema_migrations" 


Started GET "/dreams" for 127.0.0.1 at 2013-08-04 08:19:52 +0100
Processing by DreamsController#index as HTML
  Dream Load (0.1ms)  SELECT "dreams".* FROM "dreams" 
  Rendered dreams/index.html.erb within layouts/application (1.0ms)
Completed 500 Internal Server Error in 17ms

ActionView::Template::Error (cannot load such file -- sass
  (in /home/david2/daves-dream-blog/app/assets/stylesheets/dreams.css.scss)):
    2: <html>
    3: <head>
    4:   <title>Dreamblog</title>
    5:   <%= stylesheet_link_tag    "application" %>
    6:   <%= javascript_include_tag "application" %>
    7:   <%= csrf_meta_tags %>
    8: </head>
  app/views/layouts/application.html.erb:5:in `_app_views_layouts_application_html_erb___813278160_95592860'
  app/controllers/dreams_controller.rb:7:in `index'

````

The framework trace looks like this:

````
activesupport (3.2.14) lib/active_support/dependencies.rb:251:in `require'
activesupport (3.2.14) lib/active_support/dependencies.rb:251:in `block in require'
activesupport (3.2.14) lib/active_support/dependencies.rb:236:in `load_dependency'
activesupport (3.2.14) lib/active_support/dependencies.rb:251:in `require'
tilt (1.4.1) lib/tilt/template.rb:144:in `require_template_library'
tilt (1.4.1) lib/tilt/css.rb:16:in `initialize_engine'
tilt (1.4.1) lib/tilt/template.rb:56:in `initialize'
...
````

So I should probably do what I was told with sass.

I think adding this to Gemfile might help:
    gem 'saas', :require => 'saas'
http://stackoverflow.com/questions/6091865/sass-in-a-non-thread-safe-way

    bundle install --without :production

No change. Restarted server

I got one line further. Asset pipeline is broken.

````
Sprockets::FileNotFound in Dreams#index
Showing /home/david2/daves-dream-blog/app/views/layouts/application.html.erb where line #6 raised:

couldn't find file 'jquery'
  (in /home/david2/daves-dream-blog/app/assets/javascripts/application.js:7)
````

So perhaps I should have explicit asset pipeline versions in the Gemfile, as in the release notes.

/home/david2/.rvm/gems/ruby-1.9.3-p448/gems/railties-3.2.14/guides/source/3_2_release_notes.textile

  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>=1.0.3'

(bundle install and restart)

````
Sprockets::FileNotFound in Dreams#index

Showing /home/david2/daves-dream-blog/app/views/layouts/application.html.erb where line #6 raised:

couldn't find file 'jquery'
  (in /home/david2/daves-dream-blog/app/assets/javascripts/application.js:7)
````

Clearly I should not have deleted 
gem 'jquery-rails'
from the Gemfile.

So a plain Rails app needs jquery even if I don't explicitly use it.

And so it is up - successfully upgraded. Straightforward. At least it
wasn't complicated, though it took time, perhaps because I unfairly
slashed at the Gemfile, nor did I follow the release notes.

magit-push didn't work

````
$ git --no-pager push -v origin master:refs/heads/master
Pushing to git@github.com:dcorking/daves-dream-blog.git

fatal: The remote end hung up unexpectedly
git exited abnormally with code 128.
````
but the shell error message was more helpful
````
$ git push
Permission denied (publickey).
fatal: The remote end hung up unexpectedly
david2@www:~/daves-dream-blog$ 
````

Maybe something to do with detaching from screen, logging out and back in again.

Pretty sure it was, as I quit screen, logged out, back in again,
restarted screen and ran git push from an emacs subshell. It worked fine!

rake test traceback

````
david2@www:~/daves-dream-blog$ bundle exec rake test
/home/david2/.rvm/gems/ruby-1.9.3-p448/gems/activerecord-3.2.14/lib/active_record/dynamic_matchers.rb:55:in `method_missing': undefined method `state_machine' for Subscription(Table doesn't exist):Class (NoMethodError)
	from /home/david2/.rvm/gems/ruby-1.9.3-p448/gems/saas-0.1.1/app/models/subscription.rb:20:in `<class:Subscription>'
	from /home/david2/.rvm/gems/ruby-1.9.3-p448/gems/saas-0.1.1/app/models/subscription.rb:1:in `<top (required)>'
````

Also there is a repeated warning from the asset pipeline

Started GET "/assets/application.css?body=1" for 127.0.0.1 at 2013-08-04 22:58:06 +0100
Served asset /application.css - 304 Not Modified (4ms)
[2013-08-04 22:58:06] WARN  Could not determine content-length of response body. Set content-length of the response or set Response#chunked = true

### August 5, 2013

david2@www:~/daves-dream-blog$ bundle exec ruby -Itest test/functional/dreams_controller_test.rb 
/home/david2/.rvm/gems/ruby-1.9.3-p448/gems/activerecord-3.2.14/lib/active_record/dynamic_matchers.rb:55:in `method_missing': undefined method `state_machine' for Subscription(Table doesn't exist):Class (NoMethodError)
	from /home/david2/.rvm/gems/ruby-1.9.3-p448/gems/saas-0.1.1/app/models/subscription.rb:20:in `<class:Subscription>'




