maxUrlStorageSize = 1024 * 1024 * 5
#maxUrlStorageSize = 700
debug = false

debugLog = (msg) ->
  if(debug)
    console.log msg

sizeOfUrls = (urls) ->
  # debugLog "sizeOfUrls"
  totalSize = 0
  for url in urls
    # debugLog "url.userName.length: " + url.userName.length + " url.dateTime.length: " + url.dateTime.length + " url.url.length: " + url.url.length
    # debugLog "url.userName: " + url.userName + " url.dateTime: " + url.dateTime + " url.url: " + url.url
    totalSize += url.userName.length
    totalSize += url.dateTime.length
    totalSize += url.url.length
  totalSize

module.exports = (robot) ->
  robot.hear /oldyeller info/i, (res) ->
    console.log "OldYeller info"
    console.log "debug: " + debug
    console.log "maxUrlStorageSize:" + maxUrlStorageSize
    urls = robot.brain.get('urls')
    console.log "urls: " + urls
    if(urls != null)
      console.log "urls.length: " + urls.length
      urlsSize = sizeOfUrls(urls)
      console.log "urls size:" + urlsSize

  robot.hear /oldyeller debug (.*)/i, (res) ->
    if(res.match[1] == "on")
      console.log "Debug on"
      debug = true
    else if(res.match[1] == "off")
      console.log "Debug off"
      debug = false

  getUrl = (url) ->
    debugLog "getUrl"
    allUrls = robot.brain.get('urls')
    if(allUrls == null)
      return false
    result = (item for item in allUrls when item.url is url)[0]

  storeUrl = (response, url) ->
    debugLog "storeUrl"
    saveUrl = {
      userName: response.message.user.name,
      dateTime: new Date().toLocaleString(),
      url: url
      }
    allUrls = robot.brain.get('urls')
    debugLog "allUrls.length: " + allUrls.length
    urlsPruned = pruneUrls(allUrls)
    debugLog "urlsPruned.length: " + urlsPruned.length
    debugLog "allUrls.length: " + allUrls.length
    if(allUrls == null)
      allUrls = []
    allUrls.push saveUrl
    robot.brain.set('urls', allUrls)

  pruneUrls = (urls) ->
    urlsSize = sizeOfUrls(urls)
    debugLog "urls size:" + urlsSize
    if(urlsSize >= maxUrlStorageSize)
      debugLog "urls exceeding maxUrlStorageSize: " + urlsSize + " >= " + maxUrlStorageSize
      #oldest
      oldestDate = new Date("01-01-3000")
      for url in urls
        urlDate = new Date(url.dateTime)
        # debugLog "url.dateTime: " + url.dateTime
        # debugLog "urlDate: " + urlDate
        # debugLog "oldestDate: " + oldestDate
        # debugLog "urlDate.getTime(): " + urlDate.getTime() + " oldestDate.getTime()" + oldestDate.getTime()
        # debugLog urlDate.getTime() < oldestDate.getTime()
        if(urlDate.getTime() < oldestDate.getTime())
          oldestDate = urlDate
          oldestUrl = url
      debugLog "oldestUrl.url: " + oldestUrl.url
      #remove
      for key, url of urls
        if url.url == oldestUrl.url
          debugLog "url.url == oldestUrl.url"
          debugLog "url.url: " + url.url
          debugLog "oldestUrl.url: " + oldestUrl.url
          debugLog "key: " + key
          urls.splice(key, 1)
      debugLog "urls.length: " + urls.length
    return urls

  ensureRedisUrls = ->
    debugLog "OldYeller: ensureRedisUrls"
    urls = robot.brain.get('urls')
    if(urls == null)
      debugLog "OldYeller: no Redis urls detected. Bootstrapping."
      urls = []
      robot.brain.set('urls', urls)

  robot.hear /https?\:\/\/(\S*)/i, (res) ->
    ensureRedisUrls()
    url = res.match[1]

    debugLog "url: " + res.match[1]
    debugLog "message: " + res.message.user.name

    oldUrl = getUrl(url)
    debugLog "oldUrl: " + oldUrl
    if(oldUrl)
      debugLog "dateTime: " + oldUrl.dateTime
      res.reply "OOOOOOLD!!1 " + oldUrl.userName + " posted " + url + " @ " + oldUrl.dateTime
    else
      storeUrl(res, url)
