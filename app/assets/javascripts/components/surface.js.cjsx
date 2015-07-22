React.initializeTouchEvents true

@Surface = React.createClass

  getInitialState: ->
    isTouchDevice: false
    isTouchDown: false
    didVote: false
    innerHeight: 0
    cursorTop: 0
    cursorLeft: 0
    votePercent: 0

  componentDidMount: ->
    @setState innerHeight: window.innerHeight
    @setState cursorTop: window.innerHeight * .5

  calculateCoefficient: ->
    @state.innerHeight / 100 * 1

  calculatePercent: (y) ->
    if @calculateCoefficient() is 0
      0
    else
      y / @calculateCoefficient()

  roundPercent: (y) ->
    Math.round @calculatePercent(y)

  calculateColor: (y) ->
    rMax = 235
    gMax = 235
    percent = 100 - @calculatePercent(y)

    if percent < 50
      r = (rMax).toString(16)
      g = (Math.round(gMax / 100 * (percent * 2))).toString(16)

    if percent > 50
      r = (rMax - Math.round(rMax / 100 * ((percent - 50) * 2))).toString(16)
      g = (gMax).toString(16)

    if percent == 50
      r = (rMax).toString(16)
      g = (gMax).toString(16)

    r = '0' + r if r.length is 1
    g = '0' + g if g.length is 1
    '#' + r + g + '00'

  handleTouchStart: (e) ->
    e.preventDefault()
    @setState isTouchDown: true
    @setState didVote: true
    @setCursorPositionAndColor(e)

  handleTouchMove: (e) ->
    e.preventDefault()
    @setCursorPositionAndColor(e)

  handleTouchEnd: (e) ->
    e.preventDefault()
    @setState isTouchDown: false
    @setCursorPositionAndColor(e)

  handleMouseDown: (e) ->
    e.preventDefault()
    @setState isTouchDown: true
    @setState didVote: true
    @setCursorPositionAndColor(e)

  handleMouseMove: (e) ->
    e.preventDefault()
    @setCursorPositionAndColor(e) if @state.isTouchDown

  handleMouseUp: (e) ->
    e.preventDefault()
    @setState isTouchDown: false
    @setCursorPositionAndColor(e)

  setCursorPositionAndColor: (e) ->
    if e.nativeEvent.clientY
      y = e.nativeEvent.clientY
    else
      y = e.nativeEvent.changedTouches[0].screenY

    if e.nativeEvent.clientX
      x = e.nativeEvent.clientX
    else
      x = e.nativeEvent.changedTouches[0].screenX

    @setState cursorTop: y
    @setState cursorLeft: x
    @setState votePercent: 100 - @roundPercent(y)

  render: ->
    classSet = React.addons.classSet

    mainWrapperClasses = classSet
      'mainWrapper': true
      'didVote': @state.didVote
      'touchDown': @state.isTouchDown

    cursorPosition =
      webkitTransform: 'translate(' + (@state.cursorLeft - 100 + 'px') + ',' + (@state.cursorTop - 100 + 'px') + ')'

    cursorColor =
      borderColor: @calculateColor(@state.cursorTop)

    <section
      className={ mainWrapperClasses }
      onMouseDown={ @handleMouseDown }
      onMouseMove={ @handleMouseMove }
      onMouseUp={ @handleMouseUp }
      onTouchStart={ @handleTouchStart }
      onTouchMove={ @handleTouchMove }
      onTouchEnd={ @handleTouchEnd }>

      <section className="legendWrapper">
        <aside className="ruller"></aside>

        <section className="content">
          <header>
            <div>Touchback</div>
          </header>

          <section>
            <h1>{ @props.title }</h1>
          </section>

          <footer>
            <p>{ @props.description }</p>
          </footer>
        </section>
      </section>

      <section className="cursorWrapper" style={ cursorPosition }>
        <div className="percent">{ @state.votePercent }%</div>
        <div className="cursor" style={ cursorColor }></div>
      </section>

    </section>
