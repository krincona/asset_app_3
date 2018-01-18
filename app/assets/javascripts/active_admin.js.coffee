#= require active_admin/base
#= require best_in_place
#= require best_in_place.purr


$(document).ready ->
  jQuery(".best_in_place").best_in_place()


$ ->
  sPath = window.location.pathname
  sPage = sPath.substring(sPath.lastIndexOf('/') + 1)
  if sPage == 'admin'
    setTimeout 'location.reload(true);', 10000
  return