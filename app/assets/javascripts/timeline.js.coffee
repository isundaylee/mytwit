# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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
    confirmed = window.confirm("Do you really want to clear the tweet content? ")
    $('.tweetsheet-sheet').val('') if confirmed
    onTweetContentChanged()
    false

$ ->
    $('.tweetsheet-sheet').bind 'input propertychange', onTweetContentChanged
    $('#tweetsheet-clear-button').click onClearButtonClicked
    onTweetContentChanged()