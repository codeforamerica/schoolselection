# School Discovery App
The School Discovery App is designed to help parents 1) identify the schools to
which their children are eligible to apply and 2) understand the odds of their
children getting admitted. To search for schools, parents enter an address and
a grade level.  The search engine logic works as follows:

1. if no parameters are entered -> display a blank map and a welcome note (the default page)
2. if a grade level and no address are entered -> display the default page with an alert message
3. if a grade level and non-geocodeable address are entered -> display the default page with an alert message
4. if a grade level and non-Boston address are entered -> display the default page with an alert message
5. if a grade level and valid address are entered -> display the walk zone and assignment zone schools for that address
6. if high school and a valid address are entered -> display the walk zone schools and all of the other high schools throughout the city

[http://schoolselection.herokuapp.com/](http://schoolselection.herokuapp.com/)

## Installation
  git clone git@heroku.com:schoolselection.git


## Deploying to Heroku
there are a couple of obstacles to hosting this app on heroku.

1) You need to have a postgis-enabled database, which means that you need to have a private Heroku database, set up with "heroku addons:add heroku-postgresql postgis=true". Then promote it to your database with "heroku pg:promote"
2) When pushing with "heroku db:push", the taps gem doesn't recognize the postgis type. You need to temporarily change your config/database.yml file to have the adapter read "postgres" (not "postgis"). You also need to change heroku's DATABASE_URL to postgres using "heroku config:add DATABASE_URL=postgres://..."
3) taps doesn't seem to preserve geographic column type. You'll need to go into "heroku pg:psql" and run:
> ALTER TABLE parcels ALTER geometry TYPE Geography('MULTIPOLYGON',-1) USING ST_GeogFromText(geometry);
> ALTER TABLE assignment_zones ALTER geometry TYPE Geography('MULTIPOLYGON',-1) USING ST_GeogFromText(geometry);

4. RGeo spatial adapter needs the adapter name set to 'postgis' to load. you accomplish this by setting the heroku DATABASE_URL.
run "heroku config", and look at DATABASE_URL
NEW_URL is the existing DATABASE_URL, but with postgres:// replaced with postgis://
run "heroku config:add DATABASE_URL=NEW_URL", where NEW_URL is your current database url

5. Run 'heroku restart', to make sure your app loads the database correctly.

## Spacialdb

[step 0 not necessarily applicable]
[0.1 heroku db:pull*]
[0.2 psql -d <databasename>, \d <table name>, confirm that geometry columns are now text.]
[0.3 update column types locally - see below]

1. become beta user.
2. heroku addons:add spacialdb:test
3. heroku pg:info, heroku config
4. heroku config:add DATABASE_URL=postgres://(contents of SPATIALDB_URL)
  [why can't I pg:promote the spatial db? it's not on pg:info. why?]
5. heroku db:push
  [this takes a long time. a long time. especially on spatial_ref_s. it failed once.]
6. heroku pg:psql - can't. it's not a matching database.
7. reread the email, and install spacialdb gem
8. we don't need to create an account
9. look at heroku:config to get username/password [dan:randomstring]
10. except that username/password don't work.
11. give up and connect directly with:
    "psql -d heroku_dan_4fb9 -h beta.spacialdb.com -p 9999 -U dan --password", using given password.
    it works.
12. use \d <tablename> to verify geometry is text
    update columns per 0.3
    \d <tablename> to verify geometry is geometry
13. 'heroku run console', Parcel.first.geometry.class, to confirm need for postgis.
    update DATABASE_URL to use postgis:// (this resets app)
14. visit site. test. see odd saved form fields . . . .

*requires setting config/database.yml back to postgres, and DATABASE_URL to postgress://

0.3a ALTER TABLE parcels ALTER geometry TYPE Geography('MULTIPOLYGON',-1) USING ST_GeogFromText(geometry);
0.3b ALTER TABLE assignment_zones ALTER geometry TYPE Geography('MULTIPOLYGON',-1) USING ST_GeogFromText(geometry);

postgres://dan:83d37cb80a@beta.spacialdb.com:9999/heroku_dan_4fb9

## Contributing
In the spirit of [free software][free-sw], **everyone** is encouraged to help improve
this project.

[free-sw]: http://www.fsf.org/licensing/essays/free-sw.html

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by fixing [issues][]
* by reviewing patches
* [financially][]

[issues]: https://github.com/codeforamerica/schoolselection/issues
[financially]: https://secure.codeforamerica.org/page/contribute

## Submitting an Issue
We use the [GitHub issue tracker][issues] to track bugs and features. Before
submitting a bug report or feature request, check to make sure it hasn't
already been submitted. When submitting a bug report, please include a [Gist][]
that includes a stack trace and any details that may be necessary to reproduce
the bug, including your gem version, Ruby version, and operating system.
Ideally, a bug report should include a pull request with failing specs.

[gist]: https://gist.github.com/

## Submitting a Pull Request
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add specs for your unimplemented feature or bug fix.
4. Run `bundle exec rake spec`. If your specs pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rake spec`. If your specs fail, return to step 5.
7. Run `open coverage/index.html`. If your changes are not completely covered
   by your tests, return to step 3.
8. Add documentation for your feature or bug fix.
9. Run `bundle exec rake yard`. If your changes are not 100% documented, go
   back to step 8.
10. Add, commit, and push your changes.
11. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/

## Copyright
Copyright (c) 2011 Code for America. See [LICENSE][] for details.

[license]: https://github.com/codeforamerica/schoolselection/blob/master/LICENSE.md

[![Code for America Tracker](http://stats.codeforamerica.org/codeforamerica/schoolselection.png)](http://stats.codeforamerica.org/projects/schoolselection)
