# API Template

## Introduction

This is a api template build upon Cuba and Grape.

## Usage

### Setup

```
bundle install
rake
```

There are several rake tasks which can make you happy :)

### API Documentation

visit something like `/swagger`

## Reference

### API

[cuba](https://github.com/soveran/cuba)    
[grape](https://github.com/ruby-grape/grape)    
[grape-swagger](https://github.com/ruby-grape/grape-swagger)

### Deploy

[puma](https://github.com/puma/puma)    
[mina](https://github.com/mina-deploy/mina)    
[mina-puma](https://github.com/untitledkingdom/mina-puma)    

### Database

[sequel](https://github.com/jeremyevans/sequel)    

Init a development database

```sql
CREATE DATABASE `api_template_development` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```
