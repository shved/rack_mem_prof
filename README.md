# About
Use this middleware to profile API requests.

!!! Remember about huge overhead that enabling ObjectSpace stats gives to your application. !!!

# Installation
Add in Gemfile:

`gem 'rack_mem_prof'`

Install dependencies:

`$ bundle install`

Install middleware:

`config.middleware.use(Rack::MemProf::Middleware)`
or
```
require 'rack/mem_prof'

use Rack::MemProf::Middleware
```

# Options
path

scale_bytes
