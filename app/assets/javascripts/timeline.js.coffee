# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if $('body.timeline_index').length > 0 
  onTweetContentChanged = ->
    length = $('.tweetsheet-sheet').val().length
    remaining = 140 - length
    $wordCountSpan = $('#tweetsheet-remaining')
    $wordCountSpan.text remaining
    $wordCount = $('.tweetsheet-wordcount')
    if remaining <= 10
      $wordCount.addClass 'tweetsheet-wordcount-alerting'
    else
      $wordCount.removeClass 'tweetsheet-wordcount-alerting'

  onClearButtonClicked = ->
    confirmed = window.confirm("do you really want to clear the tweet content? ")
    $('.tweetsheet-sheet').val('') if confirmed
    onTweetContentChanged()
    false

  checkForUpdates = ->
    $updates = $('#timeline-new-tweets')
    $updatesCount = $('#timeline-new-tweets-count')
    setNext = ->
      setInterval(checkForUpdates, CHECK_FOR_UPDATES_INTERVAL)
    $.get(
      Routes.timeline_updates_path({format: 'json'}),
      {since: pageLoadTime}, 
      (response, status, request) ->
        if response.result is 'success'
          updates = response.updates
          $updatesCount.text updates
          if updates > 0
            $updates.css('display', 'block')
          else
            $updates.css('display', 'none')
        setNext()
    ).error(setNext)

  $ ->
    $('.tweetsheet-sheet').bind 'input propertychange', onTweetContentChanged
    $('#tweetsheet-clear-button').unbind('click').click onClearButtonClicked
    onTweetContentChanged()

if $('body.timeline_index').length > 0 or $('body.timeline_show').length > 0

  CHECK_FOR_UPDATES_INTERVAL = 30000

  onRepostFormToSubmit = ->
    id = parseInt(@id.split('-')[2])
    $messageField = $("#repost-message-field-#{id}")
    message = $messageField.val()
    message = 'Repost' if message is ''
    $messageField.prop('disabled', true)
    $textContainer = $("#repost-text-container-#{id}")
    $textContainer.html '<p class="pull-right repost-sheet-text">Retweeting ...</p>'
    $form = $("#repost-form-#{id}")
    $repostButton = $("#repost-button-#{id}")
    $form.unbind('submit').submit ->
      false
    handleErrors = (msg = 'Retweet failed. ') ->
      $textContainer.html "<p class=\"pull-right repost-sheet-text color-error\">#{msg}</p>"
      $messageField.prop('disabled', false)
      $form.unbind('submit').submit onRepostFormToSubmit
    $.post(
      Routes.repost_tweet_path(id, {format: 'json'}),
      {repost_message: message},
      (response, status, request) ->
        if status is not 'success'
          handleErrors()
        else
          if response.result is 'success'
            $textContainer.html '<p class="pull-right repost-sheet-text color-success">Retweet succeeded. </p>'
            $form.css('display', 'none')
            $repostButton.unbind('click').click onRepostButtonClicked
            $repostButton.removeClass 'btn-primary'
          else
            handleErrors(response.error)
    ).error(->
      handleErrors
    )
    false

  onRepostButtonClicked = ->
    id = parseInt(@id.split('-')[2])
    $repostSheet = $('#repost-sheet-' + id)
    $repostSheet.html '<p class="pull-right repost-sheet-text">Loading retweet sheet ...</p>'
    handleErrors = ->
      $repostSheet.html '<p class="pull-right repost-sheet-text color-error">Loading retweet sheet failed. </p>'
    $repostSheet.load(
      Routes.retweet_tweet_path(id), 
      null, 
      (response, status, request) ->
        if status is 'success'
          $repostButton = $("#repost-button-#{id}")
          $repostButton.addClass 'btn-primary'
          $repostButton.unbind('click').click ->
            $("#repost-form-#{id}}").submit()
          $("#repost-message-field-#{id}").select()
          $("#repost-form-#{id}").submit onRepostFormToSubmit
        else
          handleErrors()
    ).error(handleErrors)

  pageLoadTime = 0

  $ ->
    $('.repost-button').click onRepostButtonClicked
    pageLoadTime = Math.round((new Date()).getTime() / 1000)
    setTimeout(checkForUpdates, CHECK_FOR_UPDATES_INTERVAL)

