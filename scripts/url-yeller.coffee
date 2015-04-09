module.exports = (robot) ->
  # Beer test of Redis storage connection
  # ---------------------------

  robot.hear /http\:\/\/(\S*)/i, (res) ->
    getUrl = (url) ->
      res.send "getUrl"
      allUrls = robot.brain.get('urls')
      if(allUrls == null)
        return false
      result = (item for item in allUrls when item.url is url)[0]

    storeUrl = (response, url) ->
      res.send "storeUrl"
      saveUrl = {
        userName: response.message.user.name,
        dateTime: new Date(),
        url: url
        }
      allUrls = robot.brain.get('urls')
      #check size
      if(allUrls == null)
        allUrls = []
      allUrls.push saveUrl
      robot.brain.set('urls', allUrls)

    url = res.match[1]
    
    res.send "url: " + res.match[1]
    res.send "message: " + res.message.user.name

    oldUrl = getUrl(url)
    res.send "oldUrl: " + oldUrl
    if(oldUrl)
      res.send "OLD! " + oldUrl.userName + " posted " + url + " @ " + oldUrl.dateTime.toLocaleString()
    else
      storeUrl(res, url)
      
    ###
    if(isOld(url))
      dateTime = new Date()
      res.send "OLD! " + oldUser + " posted this @ " + dateTime.toLocaleString()
    else
      storeUrl(url)
    
    isOld (url) ->
      robot.brain.get
    ###

    # Get number of beers had (coerced to a number).
    #totalBeers = robot.brain.get('totalBeers') * 1 or 0

    # if totalBeers > 4
      # res.reply "I'm not feeling too well... I already had " + totalBeers
    # else
      # res.reply 'Cheers! *<CLINK>*'
      # robot.brain.set 'totalBeers', totalBeers+1

  # robot.respond /sleep it off/i, (res) ->
    # robot.brain.set 'totalBeers', 0
    # res.reply 'zzzzz'
