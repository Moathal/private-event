<a name="readme-top"></a>

<!--
HOW TO USE:
This is an example of how you may give instructions on setting up your project locally.

Modify this file to match your project and remove sections that don't apply.

REQUIRED SECTIONS:
- Table of Contents
- About the Project
  - Built With
  - Live Demo
- Getting Started
- Authors
- Future Features
- Contributing
- Show your support
- Acknowledgements
- License

After you're finished please remove all the comments and instructions!
-->

<!-- TABLE OF CONTENTS -->

# 📗 Table of Contents

- [📖 About the Project](#about-project)
  - [🔖 Learning objectives](#learning-objectives)
  - [🛠 Built With](#built-with)
    - [Tech Stack](#tech-stack)
    - [Key Features](#key-features)
  - [🚀 Live Demo](#live-demo)
- [💻 Getting Started](#getting-started)
  - [Setup](#setup)
  - [Prerequisites](#prerequisites)
  - [Install](#install)
  - [Usage](#usage)
  - [Run tests](#run-tests)
  - [Deployment](#triangular_flag_on_post-deployment)
- [👥 Authors](#authors)
- [🔭 Future Features](#future-features)
- [🤝 Contributing](#contributing)
- [⭐️ Show your support](#support)
- [🙏 Acknowledgements](#acknowledgements)
- [❓ FAQ](#faq)
- [📝 License](#license)

<!-- PROJECT DESCRIPTION -->

# 📖 [Private-events] <a name="about-project"></a>

> A site lets user create events private or public, and attend events. An event can be attended by many users, and take place at specific location, date and time. All pages are real time updated and all uses are notified thanks to noticed and hotrails gems. Tried to use as much association case in the database as possible to push active record to its peak. Used sass, Bootstrap and stimulus for styling and responsiveness all embedded in webpack.


## 🛠 Built With <a name="built-with"></a>
  - Ruby on Rails (RoR)

### Tech Stack <a name="tech-stack"></a>

<details>
<summary>Database</summary>
  <ul>
    <li><a href="https://www.postgresql.org/">PostgreSQL</a></li>
    <li><a href="https://github.com/heartcombo/devise">Devise</a></li>
    <li><a href="https://rubygems.org/gems/noticed/versions/1.6.3">Noticed</a></li>
    <li><a href="https://hotwired.dev">Hotwire</a></li>
    <li><a href="https://redis.io">Redis</a></li>
    <li><a href="https://getbootstrap.com">Bootstrap</a></li>
    <li><a href="https://sass-lang.com">SASS</a></li>
    <li><a href="https://webpack.js.org">Webpack</a></li>
  </ul>
</details>

<!-- Features -->

### Key Features <a name="key-features"></a>

- **[Delploy on render]** - realtime updates and notifications
- **[Improve security]** - Responsive

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LIVE DEMO -->

## 🚀 Live Version <a name="live-demo"></a>

- [Comming soon]()

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Presentation -->

## 🚀 Presenation video <a name="live-demo"></a>

- [Coming soon]()

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## 💻 Getting Started <a name="getting-started"></a>

To get a local copy up and running, follow these steps.

### Prerequisites

- [x] A web browser like Google Chrome.
- [x] A nodeJS and yarn.
- [x] A code editor like Visual Studio Code with Git, Ruby and redis.

You can check if Git is installed by running the following command in the terminal.

```
$ git --version

```

Likewise for Ruby installation (on UBUNTU and MAC PC's or windows only)

```
$ ruby --version && irb

```

Finally you can check if redis installed by this command.

```
redis-server --version

```


### Install

In the terminal, go to your file directory and run this command.

```
$ git clone https://github.com/melashu/hotel-room-reservation.git

```

$ gem install bundler

```
$ bundle install

$ rails db:create db:migrate

```

### Run tests (SOON)

To install rspec, in the terminal kindly run this command

```
$ gem install rspec
```

To run tests, please run this command

```
$ rspec ./spec/#{filename}_spec.rb

```

## Run the app

If its your first time to run the app run this command

```
$ bin/setup

```

The app is using redis so first run the redis server

```
$ redis-server

```

To run the app you need to run this command in the terminal

```
$ bin/div

```

### Usage

To run the project, execute the following command:

```bash command
` $ rails server`
```

### Run tests

To run tests, run the following command:
```bash command
 $ rspec
```


<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 👥 Authors <a name="authors"></a>

 👤 **Mo'athal S. Kachi**

- GitHub: [@githubhandle](https://github.com/Moathal)
- LinkedIn: [LinkedIn](https://linkedin.com/in/moathalkachi)

## 🔭 Future Features <a name="future-features"></a>

- [ ] **[Delploy on heroku]** - Delploy on heroku
- [ ] **[Improve security]** - Improve security
- [ ] **[ Add testes ]** -  Add testes

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🤝 Contributing <a name="contributing"></a>

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](ttps://github.com/melashu/Hotel-room-reservation-front/issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## ⭐️ Show your support <a name="support"></a>

If you like this project give as a star! ⭐️

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🙏 Acknowledgments <a name="acknowledgements"></a>

- [Microverse](https://www.microverse.org/)
- Coding Partners
- Code Reviewers

## ❓ FAQ <a name="faq"></a>

- **[How I can run this project?]**

  - [After cloning repository, run bin/setup then in another terminal redis-server and finally bin/dev.]


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## 📝 License

This project is [MIT](./LICENSE) licensed.
