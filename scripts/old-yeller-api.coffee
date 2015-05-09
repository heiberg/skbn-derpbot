debug = false

debugLog = (msg) ->
  if(debug)
    console.log msg

getYoutubeVideoId = (url) ->
  videoIdMatch = /v\=.*\&?/i.exec(url)
  debugLog "videoIdMatch: " + videoIdMatch 
  if(videoIdMatch && videoIdMatch[0])
    return videoIdMatch[0]
  else
    return url
  
module.exports = (robot) ->
  robot.hear /https?\:\/\/(\S*)/i, (res) ->
    url = res.match[1]

    debugLog "url: " + url
    debugLog "user: " + res.message.user.name
    
    url = getYoutubeVideoId(url)
    apiToken = "xoxp-4345566228-4351839546-4426387439-4edd94"
#    debugLog "apiToken: " + apiToken
#    if(!apiToken)
#      res.reply "I couldn't find apiToken in process.env.HUBOT_SLACK_TOKEN. I need human assistance."
    
    requestUri = 'https://slack.com/api/search.messages?token=' + apiToken + '&query=' + url
    debugLog "requestUri: " + requestUri
    res.http(requestUri).get() (err, result, body) ->
      #debugLog "body: " + body
      response = JSON.parse(body);
      if(response.messages.total > 0)
        debugLog "response.messages.total: " + response.messages.total
        match = response.messages.matches[0]
        debugLog "match.ts: " + match.ts
        timeMs = match.ts.split("\.")[0]*1000;
        debugLog "timeMs: " + timeMs
        #res.reply "OOOOOOLD!!1 " + match.username + " posted " + match.text + " @ " + new Date(timeMs)
        res.reply "OOOOOOLD!!1 " +  match.permalink

