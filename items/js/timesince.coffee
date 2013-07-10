---
coffeescript: { bare: true }
---
###
Copyright (c) 2013 David Brunow
http://opensource.org/licenses/MIT
Adapted from 'timeago.coffee'
Copyright (c) 2012 Don Melton
http://opensource.org/licenses/MIT
Adapted from 'jquery.timeago.js'
Copyright (c) 2008-2011 Ryan McGeary
###

(($) ->
  $.fn.timesince = ->
    @each adjustTime

    setInterval =>
        @each adjustTime
        return
      , 60000

    this

  adjustTime = ->
    element = $ this
    data = element.data 'timesince'

    unless data
      text = $.trim element.text()
      element.attr 'title', text if text.length > 0

      datetime = element.attr 'datetime'
      datetime = $.trim datetime
      datetime = datetime .replace(/\.\d\d\d+/, '')
                          .replace(/-/, '/').replace(/-/, '/')
                          .replace(/T/, ' ').replace(/Z/, ' UTC')
                          .replace /([\+\-]\d\d)\:?(\d\d)/, " $1$2"

      data = new Date datetime
      element.data 'timesince', data

    return false if isNaN data
    
    startDate = new Date("02/07/2011")

    seconds = Math.abs(data.getTime() - startDate.getTime()) / 1000
    minutes = seconds / 60
    hours   = minutes / 60
    days    = hours   / 24
    weeks   = days    / 7
    months  = days    / 30
    years   = days    / 365
    daysLeft = days - ((Math.floor years) * 365)

    if (Math.floor (days - ((Math.floor years) * 365)) / 30) > 0
      monthsLeft = ', ' + (Math.floor (days - ((Math.floor years) * 365)) / 30) + ' months old'
    else
      monthsLeft = ' old'

    words   = seconds < 60  and 'seconds old'                                         or
              minutes < 2   and 'a minute old'                                        or
              minutes < 60  and properNumber(Math.floor minutes)    + ' minutes old'  or
              hours   < 2   and 'an hour old'                                         or
              hours   < 24  and properNumber(Math.floor hours)      + ' hours old'    or
              days    < 2   and 'one day old'                                         or
              days    < 7   and properNumber(Math.floor days)       + ' days old'     or
              weeks   < 2   and 'one week old'                                        or
              months  < 1   and properNumber(Math.floor weeks)      + ' weeks old'    or
              years   < 1   and properNumber(Math.floor months)     + ' months old'   or
              days    < 60  and 'last month'                                          or
              days    < 365 and properNumber(Math.floor monthsLeft)  + ' months old'  or
              years   < 2   and 'one year' + monthsLeft or
              properNumber(Math.floor years) + ' years' + monthsLeft

    element.text words

    return

  properNumber = (number) ->
    number = parseInt number, 10

    if number > 1 and number < 10
      number = ['two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'][number - 2]

    number

  return
) jQuery
