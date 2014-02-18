_ = require 'underscore'
benv = require 'benv'
sinon = require 'sinon'
Backbone = require 'backbone'
{ resolve } = require 'path'

describe 'FilterArtworksNav', ->

  beforeEach (done) ->
    benv.setup =>
      benv.expose { $: benv.require 'jquery' }
      Backbone.$ = $
      $.fn.hidehover = sinon.stub()
      benv.render resolve(__dirname, '../template.jade'), {}, =>
        FilterArtworksNav = benv.require resolve(__dirname, '../view')
        FilterArtworksNav.__set__ 'mediator', @mediator = trigger: sinon.stub(), on: sinon.stub()
        @view = new FilterArtworksNav
          el: $('.filter-nav')
          params: new Backbone.Model
          counts: new Backbone.Model
        done()

  afterEach ->
    benv.teardown()

  it 'sets price', ->
    @view.filterAttr currentTarget: $ "<div data-attr='price_range' data-val='-1:1000'></div>"
    @view.params.get('price_range').should.equal '-1:1000'

  it 'renders counts', ->
    @view.counts.set {
      price_range: { "-1:1000": 51 }
      dimension: { "24": 38 }
    }
    @view.renderCounts()
    @view.$el.html().should.include '51'
    @view.$el.html().should.include '38'

  it 'defauls to selecting the all selctions', ->
    @view.counts.clear()
    @view.renderCounts()
    @view.$('.is-active').text().should.equal "All Works"