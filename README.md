# Wheelhouse

**Wheelhouse** is a web application for a local community bicycle repair shop. It follows a Ruby-on-Rails arquitecture styled with Bootstrap.

## Documentation

The projects documentation is located in the `docs/` folder

* [User Stories](docs/user-stories.md)
* [Domain Model For Database](docs/domain-model.md)
* [Personal Decisions Made](docs/decisions.md)
* [Wireframes](docs/wireframes.md)

## Prerequisites

Too be able to run this aplication locally in your own system you will need the following software:

* [Git 2.3.x](https://git-scm.com/docs/git)
* [Ruby 4.0.4](https://www.ruby-lang.org/en/documentation/)
* [Rails 8.0.x](https://rubyonrails.org/docs)
* [Node 26.1.x](https://nodejs.org/en)
* [Yarn 1.22.x](https://yarnpkg.com)

## Prerequisites Installation Guides

For the installation it is recommended you use version managers for Ruby and Node.js, such us
[Mise](https://mise.jdx.dev) (All purpose), [Rbenv](https://github.com/rbenv/rbenv) and/or [Nodenv](https://github.com/nodenv/nodenv).

* [Ruby on Rails — Install Rails](https://guides.rubyonrails.org/install_ruby_on_rails.html) , Which covers the installation for Ruby, Rails and Node for every operating system

* [Git - Install](https://git-scm.com/install/) , Which covers git installation for every operating system

After following the installation guides above, use the following comands on your respective terminal (zsh, bash, powershell, etc...) to install Yarn:

### MacOS (zsh | bash)

```zsh
brew install yarn
```

### Linux (bash)

```bash
sudo apt update
sudo npm install --global yarn
```

### Windows

For Windows Operating Systems is recommended to have [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/) (WSL) installed and running.

* [Install WSL | Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/install), Which covers WSL installation for Windows Systems

After the installation, use the Linux specification on how to install all the prerequisites including yarn inside your WSL.

## Setup for the program

### Clone the repository

Go to the directory where you want to store the repository and type in the terminal:

```bash
git clone https://github.com/AgustinFlores1/webtech-wheelhouse.git
cd webtech-wheelhouse
```

### Install Ruby and Yarn Dependencies

After cloning, you will need to install the projects dependencies and compile the bootstrap with the following commands:

```bash
bundle install
yarn install
```

### Compile Bootstrap Sass assets

```bash
rails css:build
```

## Running the Aplication Locally

### Start the App

Sit at the root of the repositories folder and type the following command on the terminal

```bash
bin/dev
```

### Access the App

Open your browser and navigate to the url `http://localhost:3000`

### Stopping the App

The app uses your terminal to run on the browser, if you want to stop it just use `ctrl+C`.
