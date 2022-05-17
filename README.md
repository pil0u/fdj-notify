# fdj-notify

Auto-send yourself an email when a EuroMillions draw matches your criteria.

## Requirements

- Ruby 3.1.2
- Bundler

## Configuration

Use a `.env` file with these keys:
- `THRESHOLD`, your minimum jackpot value in millions of € (default: `130`)
- `DRAW_DAYS`, value should be one of: `mardi`, `vendredi` or `mardi,vendredi` (default: `mardi,vendredi`)
- `MAILER_USER_NAME`, your Gmail email address
- `MAILER_PASSWORD`, your [generated app password](https://myaccount.google.com/apppasswords) (select "Other" and choose any name you want)

> **⚠️ You should never share your `MAILER_PASSWORD`, as it grants access to your entire Google Account.**

## Usage

``` sh
bundle install # Install script requirements
```

``` sh
ruby run.rb
```

Ideally, this command should be executed on a schedule (cron) every Tuesday and Friday at 04:00AM UTC.

## Deploy on Heroku

This section required [`heroku-cli`](https://devcenter.heroku.com/articles/heroku-cli)

``` sh
heroku login
heroku create --region=eu fdj-notify
git push heroku main
heroku config:set MAILER_USER_NAME=<your_gmail_address>
heroku config:set MAILER_PASSWORD=<your_gmail_app_password>
heroku config:set THRESHOLD=<your_prefered_minimum> # optional
heroku config:set DRAW_DAYS=<your_prefered_draw_days> # optional
```

Trigger the script immediately with
``` sh
heroku run ruby run.rb
```

### Setup the Heroku Scheduler to trigger the script once a day

``` sh
heroku addons:create scheduler:standard
heroku addons:open scheduler
```

This last command opens a web page, the Scheduler dashboard.
1. Click on `Create a job`
2. Choose an interval (I recommend `Every day at 04:00AM UTC`)
3. Add the command `ruby run.rb`
