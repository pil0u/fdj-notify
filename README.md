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

> :warn: You should never share your `MAILER_PASSWORD`.

## Usage

``` sh
bundle install # Install script requirements
```

``` sh
ruby run.rb
```

Ideally, this command should be executed on a schedule (cron) every Tuesday and Friday 09:00 UTC.
