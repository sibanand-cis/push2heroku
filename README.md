# Push2heroku

Makes it easy to push to heroku.

## Installation

Add this to Gemfile:

    gem 'push2heroku'

## Usage

After installing the gem copy [this file](https://raw.github.com/gist/3098161/578dad8cd3933834712a8afdf33520221dbdb986/push2heroku.yml) to `config/push2heroku.yml` .

Change the contents of `config/push2heroku.yml` as per your needs after
reading rest of README.

## What problem it solves

Here at BigBinary we create a separate branch for each feature we work
on. Let's say that I am working on `authentication with facebook`.
When I am done with the feature then I send pull request to my team
members to review. However in order to review the work all the team
members need to pull down the branch and fire up `rails server` and then
review.

We like to see things working. So we developed `push2heroku` to push a
feature branch to heroku instantly with one command. Executing
`push2heroku` prints a url and we put that url in the pull request so
that team members can actually test the feature.

## Here is how it works

`push2heroku` reads the `push2heroku.yml` and executes those commands.
It's that simple.

Lets say that I am working in a branch called
`76-facebook-authentication`. When I execute `push2heroku` then the
application name under which it will be deployed to heroku will be
`nimbleshop-76-facebook-neeraj`.

`nimbleshop` is the name of the project.
`76-facebook` is the first 10 letters of the branch name.
`neeraj` is the first 5 letters of my github user name.

So in this case the url of the application will be
`http://nimbleshop-76-facebook-neeraj.herokuapp.com` .

In the `push2heroku.yml` file the keys `production` and `staging`
are branch names. And these branches are special branches. For these
branches the url generated will be just the application name and the
branch name. For example if I execute `rake push2heroku` from `staging`
branch then the heroku url will be
`http://nimbleshop-staging.herokuapp.com`.

However if I delete `staging` key from `push2heroku.yml` then `staging`
is no longer a special branch and the heroku url would be
`http://nimbleshop-staging-neeraj.herokuapp.com` .

## Callbacks

The new design of `push2heroku` is very flexible. Let's say that Artem
wants to test something then he can add to `push2heroku.yml` something
like this

```
regenerate_images:
  - bundle exec heroku run rake db:regenerate_images --app <%=ENV['HEROKU_APP_NAME']%> --trace
  - bundle exec heroku run rake db:post_image_cleanup --app <%=ENV['HEROKU_APP_NAME']%> --trace
```

Now to execute all the commands under key `regenrate_images` all he has to do is

```
rake push2heroku CALLBACKS=reset_db_using_fixtures,regenerate_images
```

Just comma separate all the tasks. It's that simple. Now `push2heroku` gives all the control to the developer.

## License

`push2heroku` is released under MIT License.

