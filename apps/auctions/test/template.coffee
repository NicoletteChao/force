_ = require 'underscore'
benv = require 'benv'
{ resolve } = require 'path'
{ fabricate } = require 'antigravity'
Auction = require '../../../models/auction'

describe 'Auctions template', ->
  before ->
    auctions = [
      @openAuction = new Auction fabricate 'sale', auction_state: 'open', id: 'open-auction'
      @closedAuction = new Auction fabricate 'sale', auction_state: 'closed', id: 'closed-auction'
      @previewAuction = new Auction fabricate 'sale', auction_state: 'preview', id: 'preview-auction'
      @promoAuction = new Auction fabricate 'sale', auction_state: 'open', id: 'promo-sale', eligible_sale_artworks_count: 1, sale_type: 'auction promo'
    ]

  describe 'with at least one of every kind of auction', ->
    before (done) ->
      benv.setup =>
        benv.expose $: benv.require 'jquery'
        benv.render resolve(__dirname, '../templates/index.jade'),
          sd: {}
          asset: (->)
          pastAuctions: [@closedAuction]
          currentAuctions: [@openAuction]
          upcomingAuctions: [@previewAuction]
          promoAuctions: []
          nextAuction: @previewAuction
        done()

    after ->
      benv.teardown()

    it 'renders correctly', ->
      $('.auctions-placeholder').length.should.eql 0
      # Current ("Featured") auctions
      $('.af-name').length.should.eql 1
      # Past auctions
      $('.leader-dots-list-item').length.should.eql 1
      # Upcoming auctions
      $('.ap-upcoming-item').length.should.eql 1
      # How Auctions Work
      $('.auction-cta-group').length.should.eql 3


  describe 'without current auctions', ->
    before (done) ->
      benv.setup =>
        benv.expose $: benv.require 'jquery'
        benv.render resolve(__dirname, '../templates/index.jade'),
          sd: {}
          asset: (->)
          pastAuctions: [@closedAuction]
          currentAuctions: []
          upcomingAuctions: [@previewAuction]
          promoAuctions: []
          nextAuction: @previewAuction
        done()

    after ->
      benv.teardown()

    it 'renders correctly', ->
      $('.auctions-placeholder').length.should.eql 1
      # Current ("Featured") auctions
      $('.ap-featured-item').length.should.eql 0
      # Upcoming & Past auctions
      $('.auctions-list--upcoming').length.should.eql 1
