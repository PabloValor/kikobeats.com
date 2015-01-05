kikobeats.effect = do (s = kikobeats) ->

  _el =
    page    : $ window
    document: $ document
    header  : $ "header"
    landing : $ ".landing > .row"
    more    : $ ".landing .more"

  resize = ->
      _el.landing.height $(window).height()

  scroll = (event) ->
    percent = (_el.document.scrollTop() * 100) / _el.landing.height()
    if percent > 10
      _el.more.addClass "hide"
    else
      _el.more.removeClass "hide"

    if percent > 68
      _el.header.addClass "active"
    else
      _el.header.removeClass "active"

  resize: resize
  scroll: scroll