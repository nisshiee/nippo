#= require raven
if dsn = gon?.raven?.dsn
  Raven.config(dsn).install()
