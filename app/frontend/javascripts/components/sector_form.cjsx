SectorsActionCreators = require '../actions/sectors_actions'
ItemErrorsBlock = require './shared/item_errors_block'
ColorSelector = require './selectors/color_selector'

SectorForm = React.createClass
  displayName: 'SectorForm'

  propTypes:
    sector: React.PropTypes.object.isRequired

  _onNameChange: (e) ->
    params =
      name: e.target.value
    SectorsActionCreators.update_text @props.sector, params

  _onDescChange: (e) ->
    params =
      description: e.target.value
    SectorsActionCreators.update_text @props.sector, params

  _onSave: ->
    SectorsActionCreators.save @props.sector

  _onCancel: ->
    SectorsActionCreators.cancel @props.sector

  _onKeyDown: (e) ->
    if e.keyCode is 13
      @_onSave()
    if e.keyCode is 27
      @_onCancel()

  _onDelete: ->
    if not _.isEmpty(@props.sector.subsectors)
      react_confirm I18n.sectors.notempty.replace('%{name}', @props.sector.name)
        .then =>
          SectorsActionCreators.destroy @props.sector

    else
      SectorsActionCreators.destroy @props.sector

  _onMove: (to) ->
    SectorsActionCreators.move @props.sector, to

  _onColorSelect: ->
    if window.support_color_input
      React.findDOMNode(this.refs.color_input).click()
    else
      react_modal ColorSelector, { color: @props.sector.color }
        .then (color) =>
          SectorsActionCreators.update @props.sector,
            color: color

  _onNativeColorSelect: (e) ->
    SectorsActionCreators.update @props.sector,
      color: e.target.value

  componentDidMount: ->
    #move cursor to the end of the text
    input = React.findDOMNode(this.refs.sector_input)
    length = input.value.length
    input.setSelectionRange(length, length)

  render: ->
    if @props.sector.have_errors
      errors_elem = <ItemErrorsBlock errors={@props.sector.errors} title='Server errors' />

    <div className='sector-form'>
      <div className='list-form-head'>
        <input
          id={'sector_' + @props.sector.id}
          ref='sector_input'
          placeholder={I18n.sector}
          onChange={@_onNameChange}
          onKeyDown={@_onKeyDown}
          value={@props.sector.name}
          autoFocus={true}
        />
        <div className='btns-right'>
          <button onClick={@_onSave} className="btn btn-default btn-sm" title={I18n.save}>
            <span className="glyphicon glyphicon-ok" aria-hidden="true"></span>
          </button>
          <button onClick={@_onCancel} className="btn btn-default btn-sm" title={I18n.cancel}>
            <span className="glyphicon glyphicon-remove" aria-hidden="true"></span>
          </button>
        </div>
      </div>
      <div className='list-form-body'>
        <div className='btns-left'>
          <button onClick={@_onDelete} className="btn btn-default btn-sm" title={I18n.delete}>
            <span className="glyphicon glyphicon-trash" aria-hidden="true"></span>
          </button>
        </div>
        <textarea
          rows="3"
          placeholder={I18n.description_placeholder}
          onChange={@_onDescChange}
          value={@props.sector.description}
        />
        {if typeof @props.sector.id isnt "string"
          <div className='btns-right'>
            <button onClick={@_onColorSelect} className="btn btn-default btn-sm" title={I18n.select_color}>
              <span className="glyphicon glyphicon-adjust" aria-hidden="true"></span>
              <input type='color' onChange=@_onNativeColorSelect value={@props.sector.color}
                style={{opacity: '0', width: '100%'}}
                ref='color_input'/>
            </button>

            <button onClick={@_onMove.bind(@, 'up')} className="btn btn-default btn-sm" title={I18n.move_up}>
              <span className="glyphicon glyphicon-chevron-up" aria-hidden="true"></span>
            </button>
            <button onClick={@_onMove.bind(@, 'down')} className="btn btn-default btn-sm" title={I18n.move_down}>
              <span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>
            </button>
          </div>
        }
      </div>
      {errors_elem}
    </div>

module.exports = SectorForm