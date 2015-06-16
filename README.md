# TheMysteriousX/authconfig #

Don't use this:

[![Build Status](https://travis-ci.org/TheMysteriousX/authconfig.svg)](https://travis-ci.org/TheMysteriousX/authconfig)
[![Coverage Status](https://coveralls.io/repos/TheMysteriousX/authconfig/badge.svg)](https://coveralls.io/r/TheMysteriousX/authconfig)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/TheMysteriousX/authconfig/badges/quality-score.png)](https://scrutinizer-ci.com/g/TheMysteriousX/authconfig/)

## What are tests? ##

No really, don't use it. I haven't even run it myself yet.

## What's a mollyguard? ##

You read to the end of the documentation. Good on you. Have a cookie.

There are no safe defaults possible for this kind of module. This module will break your ability to log in to all your servers at the speed of puppet, possibly even your master too.

For this reason, you need to override the variable "[mollyguard](https://en.wikipedia.org/wiki/Big_red_button#Molly-guard)" before the configuration will apply:

```puppet
class { 'authconfig':
  ...
  mollyguard => false,
  ...
}
```