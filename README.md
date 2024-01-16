SYNOPSIS
========

dvla.lua is a simple script that uses the uk.gov API to display MOT expiry and TAX expiry dates for a supplied vehicle licence-plate/registration. It requries libUseful-lua and therefore libUseful.

dvla.lua is (c) 2024 Colum Paget (colums.projects@gmail.com)


USAGE 
=====

```
     lua dvla.lua [car license plate] <-api [apikey]> <-D>
```


OPTIONS
=======

```
     -api <key>    supply api key to use
     -D            print debugging
     -?            this help
     -h            this help
     -help         this help
     --help        this help
```


ENVIRONMENT VARIABLES
=====================

dvla.lua can get its information from environment variables instead of from the command-line.

```
    DVLA_API_KEY         - supply api key as environment variable
    DVLA_VEHICLE_REG     - supply car registration/licence plate as environment variable
```
