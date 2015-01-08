window.kikobeats = kikobeats = version: "1.1.8"

$ ->

  do kikobeats.effect.resize
  $(window).on "resize", kikobeats.effect.resize
  $(document).on "scroll", kikobeats.effect.scroll

  # Thirds

  new WOW().init()

  if parrot.device.type is 'desktop'
    $.firefly
      total    : 180 # anything over a few hundred is gonna crawl
      boundary : 100 # avoid the edge of the window
      fast     : 20 # fastest spark (a lower number is faster)
      slow     : 1 # slowest spark (a higher number is slower)
      limit    : 3600 # stop after this many seconds (one hour)

  # Others

  $(".post").each ->
    $(this).hover (e) ->
      $(this).find("figure").toggleClass "hover"
      $(this).find("figcaption").toggleClass "hover"
      $(this).find("h1").toggleClass "hover"

  console.info "Why so serious? :~)"
