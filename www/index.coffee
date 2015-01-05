"use strict"

## -- Dependencies -------------------------------------------------------------

rss      = require 'parserss'
scrapper = require 'scrapper'
async    = require 'async'
gravatar = require 'gravatar'
fs       = require 'fs'
yaml     = require 'zenserver/node_modules/js-yaml'
config   = yaml.safeLoad fs.readFileSync('config.yml', "utf8")

getImage = (url, selector, cb) ->
  scrapper.get url, ($) => cb($(selector).attr('src'))

## -- Exports ------------------------------------------------------------------

module.exports = (zen) ->

  zen.get "/", (request, response) ->

    bindings =
      page   : "landing"
      avatar : gravatar.url(config.gravatar.email, {s: config.gravatar.avatar_size})

    rss config.blog.url, config.blog.max_posts,  (err, result) ->

      unless err
        lastPosts = []

        for post in result.articles
          lastPosts.push
            title : post.title
            url   : post.link

        async.each lastPosts, ((post, cb) ->
          getImage post.url, config.blog.image_selector, (image) ->
            post.image = image
            cb()
        ), (err) ->
          bindings.posts = lastPosts
          response.page "base", bindings, ["landing", "partial/social", "partial/post"]
      else
        response.page "base", bindings, ["landing", "partial/social"]
