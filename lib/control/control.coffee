ever = require 'ever' # DOM events
interact = require 'interact' # DOM events
EventEmitter = require('events').EventEmitter

class Control extends EventEmitter
  emitter: null
  interact: null
  el: null
  constructor: (@el) ->

    @emitter = ever(@el)
    @emitter.on 'keyup', @keyup
    @emitter.on 'keydown', @keydown
    @emitter.on 'mouseup', @mouseup
    @emitter.on 'mousedown', @mousedown

    @interact = interact(@el)
    @interact.on 'attain', @attain
    @interact.on 'release', @release
    @interact.on 'opt-out', @optOut

  wrapped: (fn) ->
    (ev) ->
      ev.preventDefault()
      fn(ev)

  keyup: (evt) =>
    switch evt.keyCode
      when 38, 87  # up, w
        @emit 'forward.stop'
      when 37, 65  # left, a
        @emit 'left.stop'
      when 40, 83  # down, s
        @emit 'backward.stop'
      when 39, 68  # right, d
        @emit 'right.stop'
      when 32 # space
        @emit 'jump.stop'
      when 16 # shift
        @emit 'descend.stop'

  keydown: (evt) =>
    switch evt.keyCode
      when 38, 87  # up, w
        @emit 'forward.start'
      when 37, 65  # left, a
        @emit 'left.start'
      when 40, 83  # down, s
        @emit 'backward.start'
      when 39, 68  # right, d
        @emit 'right.start'
      when 32 # space
        @emit 'jump.start'
      when 16 # shift
        @emit 'descend.start'

  mouseup: (evt) =>

  mousedown: (evt) =>

  attain: (@mouse) =>
    #@initial = { x: @mouse.x, y: @mouse.y }
    # movements is a readable stream
    @mouse.on 'data', @look
    # no more movements from this pointer-lock session.
    @mouse.on 'close', @releaseMouse

  release: =>

  optOut: =>

  look: (movement) => 
    @emit 'look', movement

  releaseMouse: =>
    @mouse = null

module.exports = Control
