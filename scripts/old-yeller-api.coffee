#debug = false
#
#debugLog = (msg) ->
#  if(debug)
#    console.log msg
#
#getYoutubeVideoId = (url) ->
#  videoIdMatch = /v\=.*\&?/i.exec(url)
#  debugLog "videoIdMatch: " + videoIdMatch 
#  if(videoIdMatch && videoIdMatch[0])
#    return videoIdMatch[0]
#  else
#    return url
#  
#module.exports = (robot) ->
#  robot.hear /https?\:\/\/(\S*)/i, (res) ->
#    url = res.match[1]
#
#    debugLog "url: " + url
#    debugLog "user: " + res.message.user.name
#    debugLog "channel: " + res.message.user.room
#    
#    url = getYoutubeVideoId(url)
#    apiToken = process.env.HUBOT_SLACK_OLDYELLER_TOKEN
#    debugLog "apiToken: " + apiToken
#    if(!apiToken)
#      res.reply "I couldn't find apiToken in process.env.HUBOT_SLACK_OLDYELLER_TOKEN. I need human assistance."
#    
#    requestUri = 'https://slack.com/api/search.messages?token=' + apiToken + '&query=' + url + ' in:' + res.message.user.room
#    debugLog "requestUri: " + requestUri
#    res.http(requestUri).get() (err, result, body) ->
#      #debugLog "body: " + body
#      response = JSON.parse(body);
#      messageCount = response.messages.total
#      if(messageCount > 0)
#        debugLog "messageCount: " + messageCount
#        match = response.messages.matches[messageCount-1] #oldest
#        debugLog "match.ts: " + match.ts
#        timeMs = match.ts.split("\.")[0]*1000;
#        debugLog "timeMs: " + timeMs
#        #res.reply "OOOOOOLD!!1 " + match.username + " posted " + match.text + " @ " + new Date(timeMs)
#        res.reply "OOOOOOLD!!1 " +  match.permalink
#
