# Push2heroku

Push to heroku.

## Installation

Add this line to your application's Gemfile:

    gem 'push2heroku'

And then execute:

    $ bundle

## Usage

First copy `push2heroku.yml` from [here]().

`rake push2heroku`

push2heroku uses `cedar` stack which has now become the default stack
for Heroku.

If `push2heroku` detects that it is a new branch and it has never been
pushed to heroku before then it will do the whole thing including
resetting the database and then running `rake setup`.

If `push2heroku` detects that a branch is already deployed then it will
do only two things

- it will push the new content to heroku
- it will execute `rake db:migrate`

If you want to reset the whole thing then you can force `push2heroku`
into running everything like this

`rake push2heroku HARD=true` . This will do hard push.

- it will push new content to heroku
- it will reset the database
- it will execute `rake db:migrate`
- it will execute `rake setup`

