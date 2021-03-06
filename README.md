Task List
=================

### System dependencies

- Ruby version: `2.4.2`

### Setup

1. Install Homebrew (package manager):

```bash
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew doctor
  brew update
  brew tap homebrew/versions
```

1. Install Redis (cache):

```bash
  brew install redis
  ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
  brew services start redis
```

1. Install Postgres (db):

```bash
  brew install postgres
```

1. Install RVM (Ruby Version Manager):

```bash
  \curl -L https://get.rvm.io | bash -s stable
  rvm requirements run
```

  * Close terminal and open new one

1. Install Git (version control):

  * Modify name/email below

```bash
  brew install git
  git config --global user.name "John Doe"
  git config --global user.email john.doe@example.com
  echo $'rvm_install_on_use_flag=1\nrvm_gemset_create_on_use_flag=1' > ~/.rvmrc
```

1. Install project:

```bash
  git clone git@github.com:scottmalone/tasklist.git
  cd tasklist
  echo '2.4.2' > .ruby-version
  echo 'tasklist' > .ruby-gemset
  cd ..; cd -
```

1. Install gems (Ruby libraries):

```bash
  gem install bundler
  bundle install
```

1. Bootstrap the databases

```bash
  rails db:create db:migrate
```

1. Install Google Chrome

1. Install Chromedriver

```bash
  brew tap homebrew/cask
  brew cask install chromedriver
```

1. Test your environment

```bash
  rails s
  curl http://localhost:3000/healthcheck
```

### Testing

Run all unit tests:

```bash
  bundle exec rake test
```
