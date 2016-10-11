SubsectorsConstants = require '../constants/subsectors_constants'
SubsectorsAPI = require '../sources/subsectors_api'

SubsectorsStore = Marty.createStore
  id: 'SubsectorsStore'
  displayName: 'SubsectorsStore'
  typingTimer: null

  get: (id) ->
    AppStore.get_subsector id

  set: (id, params = {}) ->
    AppStore.update_subsector id, params

  unset: (id) ->
    AppStore.delete_subsector id

  handlers:
    create: SubsectorsConstants.SUBSECTOR_CREATE
    create_response: SubsectorsConstants.SUBSECTOR_CREATE_RESPONSE
    edit: SubsectorsConstants.SUBSECTOR_EDIT
    cancel: SubsectorsConstants.SUBSECTOR_CANCEL
    update: SubsectorsConstants.SUBSECTOR_UPDATE
    update_text: SubsectorsConstants.SUBSECTOR_UPDATE_TEXT
    update_response: SubsectorsConstants.SUBSECTOR_UPDATE_RESPONSE
    save: SubsectorsConstants.SUBSECTOR_SAVE
    destroy: SubsectorsConstants.SUBSECTOR_DELETE
    destroy_response: SubsectorsConstants.SUBSECTOR_DELETE_RESPONSE
    move: SubsectorsConstants.SUBSECTOR_MOVE
    move_response: SubsectorsConstants.SUBSECTOR_MOVE_RESPONSE

  #create empty subsector in sector with placeholder ID
  create: (sector) ->
    AppStore.new_subsector(sector.id)

  edit: (subsector) ->
    @set(subsector.id,
      editing: true
      name_old: subsector.name
      description_old: subsector.description
    )

  cancel: (subsector) ->
    if typeof subsector.id is "string" && !subsector.name_old
      #unset new empty cancelled subsector
      @unset subsector.id
    else
      @set subsector.id,
        editing: false
        name: subsector.name_old
        description: subsector.description_old

      if subsector.name_old != subsector.name || subsector.description_old != subsector.description
        SubsectorsAPI.update @get(subsector.id)

  update_text: (subsector, params) ->
    @set subsector.id, params
    if typeof subsector.id isnt "string"
      clearTimeout @typingTimer
      callback = => SubsectorsAPI.update @get(subsector.id)
      @typingTimer = setTimeout(callback , 500)

  update: (subsector, params) ->
    @set subsector.id, params
    #put to server
    if typeof subsector.id isnt "string"
      SubsectorsAPI.update @get(subsector.id)

  update_response: (subsector, ok) ->
    if !ok
      @set(subsector.id,
        editing: true
        have_errors: true
        errors: subsector.errors
      )
    else
      @set(subsector.id,
        have_errors: false
        errors: {}
      )

  save: (subsector) ->
    @typingTimer = null
    @update subsector,
      editing: false
      name_old: subsector.name
      description_old: subsector.description

    if typeof subsector.id is "string"
      #create to server, replase ID on success
      SubsectorsAPI.create(subsector)

  create_response: (subsector, ok) ->
    if !ok
      @set(subsector.old_id,
        editing: true
        have_errors: true
        errors: subsector.errors
      )
    else
      AppStore.update_subsector_id(subsector.old_id, subsector.id)

  destroy: (subsector) ->
    @set(subsector.id,
      hidden: true
    )
    #delete to server
    if typeof subsector.id isnt "string"
      SubsectorsAPI.destroy(subsector)

  destroy_response: (subsector, ok) ->
    if !ok
      @set(subsector.id,
        hidden: false
        have_errors: true
        errors: subsector.errors
      )
    else
      @unset subsector.id

  move: (subsector, to) ->
    if to in ['up', 'down']
      AppStore.move_subsector subsector.id, to
      SubsectorsAPI.move(subsector, to)
    if to is 'sector'
      select_sector(subsector)
        .then (dest) =>
          AppStore.move_subsector subsector.id, to, dest
          SubsectorsAPI.move({id: subsector.id, sector_id: dest.sector_id}, 'sector')


  move_response: (subsector, ok) ->

module.exports = SubsectorsStore