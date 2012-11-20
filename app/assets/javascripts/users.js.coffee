# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if $('body.users_edit_avatar').length > 0

  onAvatarUploadButtonClicked = ->
    $('input[id=user_avatar]').click()

  onAvatarChanged = ->
    $('#avatar_cover').val($(@).val())

  $ ->
    $('#avatar_upload_button').click onAvatarUploadButtonClicked
    $('input[id=user_avatar]').change onAvatarChanged
