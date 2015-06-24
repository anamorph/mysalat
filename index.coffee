# $id:    mysalat/index.coffee
# 
# author  nicolas 'ali' david - nicolas.david@anamor.ph
# 
# Calculation Method used
# 1  Egyptian General Authority of Survey
# 2  University Of Islamic Sciences, Karachi (Shafi)
# 3  University Of Islamic Sciences, Karachi (Hanafi)
# 4  Islamic Circle of North America
# 5  Muslim World League
# 6  Umm Al-Qura
# 7  Fixed Isha 
#
method = "4"

currentDate = new Date  
dd = currentDate.getDate()  
mm = currentDate.getMonth() + 1  
yyyy = currentDate.getFullYear()  
if dd < 10  
  dd = '0' + dd  
if mm < 10  
  mm = '0' + mm  
currentDate = dd + '-' + mm + '-' + yyyy  


command: "curl -s http://muslimsalat.com/#{currentDate}/#{method}.json?key=1e06021586be03ee8461686f61195b03 | jq .items[] -r | jq -r '. | [.fajr,.shurooq,.dhuhr,.asr,.maghrib,.isha] | @csv' | sed 's/\"//g'"

# Refresh every 24 hours
refreshFrequency: 86400000

style: """
  top: 60px
  left: 8px
  color: #fff
  font-family: Helvetica Neue

  table 
    border-collapse: collapse
    table-layout: fixed
    width: 510px

  td 
    font-weight: 100
    text-shadow: 0 0 1px rgba(#000, 0.5)
    background: rgba(#000, 0.2)
  
  .location 
    text-overflow: clip
    font-size: 30px
    font-weight: 100
    -webkit-transform: rotate(270deg)
    -moz-transform: rotate(270deg)
    -o-transform: rotate(270deg)
    width: 60px
    height: 10px
  
  .wrapper 
    padding: 4px 6px
    position: relative

  .prayerName 
    font-size: 18px

  .prayerNameAr 
    font-size: 16px
    color: green
    margin-top: -12px
    margin-left: 30px
    text-direction: rtl
    text-shadow: 0 0 1px rgba(#fff, 0.5)
    height: 8px
  
  .prayerTime 
    font-size: 14px
    text-align: center
"""

render: -> """
  <table></table>
"""

update: (output, domEl) ->
  table  = $(domEl).find('table')
  prayers = output.split(',')

  table.append  "
  <tr>
    <td class='prayerName'><div class='wrapper'>Fajr<div class='prayerNameAr'>فجر</div></div></td>
    <td class='prayerName'><div class='wrapper'>Shurooq<div class='prayerNameAr'>شُرُوق</div></div></td>
    <td class='prayerName'><div class='wrapper'>Dhuhr<div class='prayerNameAr'>ظهر</div></div></td>
    <td class='prayerName'><div class='wrapper'>Asr<div class='prayerNameAr'>عصر</div></div></td>
    <td class='prayerName'><div class='wrapper'>Maghrib<div class='prayerNameAr'>مغرب</div></div></td>
    <td class='prayerName'><div class='wrapper'>Isha<div class='prayerNameAr'>عشاء</div></div></td>
  </tr>
  <tr>"

  for prayer, i in prayers
    am_pm_to_hours = (time) ->
      console.log time
      hours = Number(time.match(/^[0-9]{1,2}/))
      minutes = Number(time.match(/:(\d+)/)[1])
      AMPM = time.match(/(am|pm)/)[1]
      if AMPM == 'pm' and hours < 12
        hours = hours + 12
      if AMPM == 'am' and hours == 12
        hours = hours - 12
      sHours = hours.toString()
      sMinutes = minutes.toString()
      if hours < 10
        sHours = '0' + sHours
      if minutes < 10
        sMinutes = '0' + sMinutes
      sHours + ':' + sMinutes

    table.find("tr:last").append "<td class='prayerTime'><div class='wrapper'>#{am_pm_to_hours(prayer);}</div></td>"
  table.append  "</tr>"
