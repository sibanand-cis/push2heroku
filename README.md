# Push2heroku

Makes it easy to push to heroku.

## Installation

Add this to Gemfile:

    gem 'push2heroku'

## Usage

After installing the gem execute

`rake push2heroku:install`

It will put `push2heroku.yml` file in the `config` folder of your
application.

## Here is how it works

`push2heroku` reads the `push2heroku.yml` and executes those commands.
It's that simple.

Lets say that I am working in a branch called
`76-facebook-authentication`. When I execute `push2heroku` then the
application name under which it will be deployed to heroku will be
`nimbleshop-76-facebook-neeraj`.

`nimbleshop` is the name of the application.
`76-facebook` is the first 10 letters of the branch name.
`neeraj` is the first 5 letters of my github user name.

So in this case the url of the application will be
`http://nimbleshop-76-facebook-neeraj.herokuapp.com` .

In the push2heroku.yml file the keys `production`, `staging` and `lab`
are branch names. And these branches are special branches. For these
branches the url generated will be just the application name and the
branch name. For example if I execute `rake push2heroku` from `staging`
branch then the heroku url will be
`http://nimbleshop-staging.herokuapp.com`.



If you want to reset the whole thing then you can force `push2heroku`
into running everything like this

`rake push2heroku HARD=true` . This will do hard push.

- it will push new content to heroku
- it will reset the database
- it will execute `rake db:migrate`
- it will execute `rake setup`

