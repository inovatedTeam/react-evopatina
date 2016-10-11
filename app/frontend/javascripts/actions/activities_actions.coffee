ActivitiesConstants = require '../constants/activities_constants'

ActivitiesActionCreators = Marty.createActionCreators
  id: 'ActivitiesActionCreators'

  edit: (activity) ->
    @dispatch ActivitiesConstants.ACTIVITY_EDIT, activity
  edit_count: (activity) ->
    @dispatch ActivitiesConstants.ACTIVITY_EDIT_COUNT, activity
  cancel: (activity) ->
    @dispatch ActivitiesConstants.ACTIVITY_CANCEL, activity
  update: (activity, params) ->
    @dispatch ActivitiesConstants.ACTIVITY_UPDATE, activity, params
  update_text: (activity, params) ->
    @dispatch ActivitiesConstants.ACTIVITY_UPDATE_TEXT, activity, params
  update_response: (activity, ok) ->
    @dispatch ActivitiesConstants.ACTIVITY_UPDATE_RESPONSE, activity, ok
  update_count: (activity, params) ->
    @dispatch ActivitiesConstants.ACTIVITY_UPDATE_COUNT, activity, params
  update_count_response: (activity, ok) ->
    @dispatch ActivitiesConstants.ACTIVITY_UPDATE_COUNT_RESPONSE, activity, ok
  save: (activity) ->
    @dispatch ActivitiesConstants.ACTIVITY_SAVE, activity
  destroy: (activity) ->
    @dispatch ActivitiesConstants.ACTIVITY_DELETE, activity
  destroy_response: (activity, ok) ->
    @dispatch ActivitiesConstants.ACTIVITY_DELETE_RESPONSE, activity, ok
  create: (subsector) ->
    @dispatch ActivitiesConstants.ACTIVITY_CREATE, subsector
  create_response: (activity, ok) ->
    @dispatch ActivitiesConstants.ACTIVITY_CREATE_RESPONSE, activity, ok
  move: (activity, to) ->
    @dispatch ActivitiesConstants.ACTIVITY_MOVE, activity, to
  move_response: (activity, ok) ->
    @dispatch ActivitiesConstants.ACTIVITY_MOVE_RESPONSE, activity, ok

module.exports = ActivitiesActionCreators