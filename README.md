# Wheelhouse

**Wheelhouse** is a web application for a local community bicycle repair shop. It follows a Ruby-on-Rails arquitecture styled with Bootstrap.

## Documentation

The projects documentation is located in the `docs/` folder

* [User Stories](docs/user-stories.md)
* [Domain Model For Database](docs/domain-model.md)
* [Personal Decisions Made](docs/decisions.md)
* [Wireframes](docs/wireframes.md)
* [JSON API](docs/api.md): routes, documents, errors and the decisions behind them

## Prerequisites

Too be able to run this aplication locally in your own system you will need the following software:

* [Git 2.3.x](https://git-scm.com/docs/git)
* [Ruby 4.0.4](https://www.ruby-lang.org/en/documentation/)
* [Rails 8.0.x](https://rubyonrails.org/docs)
* [Node 26.1.x](https://nodejs.org/en)
* [Yarn 1.22.x](https://yarnpkg.com)
* [PostgreSQL 16.x](https://www.postgresql.org/docs/current/) — running locally, with a role that can create databases
* [libvips 8.x](https://www.libvips.org/install.html) — the image library that generates the photo thumbnails

## Prerequisites Installation Guides

For the installation it is recommended you use version managers for Ruby and Node.js, such us
[Mise](https://mise.jdx.dev) (All purpose), [Rbenv](https://github.com/rbenv/rbenv) and/or [Nodenv](https://github.com/nodenv/nodenv).

* [Ruby on Rails — Install Rails](https://guides.rubyonrails.org/install_ruby_on_rails.html) , Which covers the installation for Ruby, Rails and Node for every operating system

* [Git - Install](https://git-scm.com/install/) , Which covers git installation for every operating system

After following the installation guides above, use the following commands in your terminal (zsh, bash, powershell, etc...) to install Yarn and libvips:

### MacOS (zsh | bash)

```zsh
brew install yarn
brew install vips
```

### Linux (bash)

```bash
sudo apt update
sudo npm install --global yarn
sudo apt install -y libvips-tools
```

`libvips-tools` installs the libvips library together with the `vips` command line tool.

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

### Set up the database

The application connects to PostgreSQL using a role matching your operating system username. Create
it if it doesn't already exist:

```bash
sudo -u postgres createuser -d $(whoami)
```

Then create, load, and seed the database in one step:

```bash
bin/rails db:setup
```

### Seed data

The seed creates customers, bikes, staff, services and repairs. Most repairs come with intake photos and a
diagnosis. The photos are in `db/seeds/` and were taken by the author of this repository. Uploaded photos
are stored in the `storage/` folder, which is not committed.

The seed can be run again at any time with the following command:

```bash
bin/rails db:seed
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

## The JSON API

Besides its pages, Wheelhouse answers a versioned JSON API under `/api/v1`, for programs that are not a browser. Reading the price list is public, while reading repairs and creating a service need a token. Every route, document and error is described in [docs/api.md](docs/api.md).

The API runs inside the same application: when `bin/dev` is running, the API is at `http://127.0.0.1:3000/api/v1`. **It has to run on port 3000** (the default of `bin dev`), because that is the address the personal page asks.

### Set the API token

The private routes compare the token of each request with `api_token`, stored in the application's encrypted credentials. The author's credentials can only be read with a key that is not in the repository, so after cloning you set a token of your own, in credentials for the development environment

First you need to generate a random personal token, you can do it with a random generator or by running the next command:

```bash
   bin/rails secret
```

After that, you need to add that token to the `development credentials`, which then created its own file in `config/credentials/development.yml.enc` with its own development key.

```bash
   EDITOR="code --wait" bin/rails credentials:edit --environment development
   # code opens VSCode for the editing, you can use any editor
```

Add this line with the token you copied, save and then close the file so rails can encrypt it

```yaml
   api_token: <paste-your-token-here>
```

Finally, restart or open the application using the `bin/dev` command on the console.

### Ask the API from the terminal

The price list, public:

```bash
curl -i http://127.0.0.1:3000/api/v1/services
```

The repairs, with the token. Put your token in a shell variable first, so it is not typed into every command:

```bash
TOKEN=paste-your-token-here
curl -i -H "Authorization: Bearer $TOKEN" http://127.0.0.1:3000/api/v1/repairs
curl -i -H "Authorization: Bearer $TOKEN" "http://127.0.0.1:3000/api/v1/repairs?state=closed"
```

Create a service, with the token and a JSON body:

```bash
curl -i -X POST http://127.0.0.1:3000/api/v1/services \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"service": {"name": "Disc Brake Pads", "price": 35}}'
```

`-i` prints the status and the headers, `-H` adds a header, `-X POST` changes the verb and `-d` sends the body.

### The personal page that reads the price list

The page lives in another repository, [webtech-lab-01](https://github.com/AgustinFlores1/webtech-lab-01), and is published at [https://agustinflores1.github.io/webtech-lab-01/](https://agustinflores1.github.io/webtech-lab-01/). Its "Wheelhouse Repair Prices" section asks for `http://127.0.0.1:3000/api/v1/services` from the browser.

There are to ways to see the connection between the two via the API:

#### Published page

start this application with `bin/dev` on port 3000 and open the published page, you should see the prices in its corresponding section.

#### The page served locally

The API only lets two origins read it, the published page from before and `http://127.0.0.1:5500` (see `config/initializers/cors.rb`). To start the page on that other origin, in a second terminal type the following:

```bash
  git clone https://github.com/AgustinFlores1/webtech-lab-01.git
  cd webtech-lab-01
  python3 -m http.server 5500 --bind 127.0.0.1
```

This will clone the other page onto your system and connect to your browser via a Python server.

Then open `http://127.0.0.1:5500` and you should see the same as with the fisrt method.

Opening `index.html` by double-clicking it does not work because a file opened from the disk has no origin, so the API cannot allow it.
