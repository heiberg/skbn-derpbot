module.exports = (robot) ->
  robot.hear /https?\:\/\/(\S*)/i, (res) ->
    #maxUrlStorage = 1024 * 1024 * 5
    maxUrlStorage = 700
    getUrl = (url) ->
      console.log "getUrl"
      allUrls = robot.brain.get('urls')
      if(allUrls == null)
        return false
      result = (item for item in allUrls when item.url is url)[0]

    storeUrl = (response, url) ->
      console.log "storeUrl"
      saveUrl = {
        userName: response.message.user.name,
        dateTime: new Date().toLocaleString(),
        url: url
        }
      allUrls = robot.brain.get('urls')
      console.log "allUrls.length: " + allUrls.length
      urlsPruned = pruneUrls(allUrls)
      console.log "urlsPruned.length: " + urlsPruned.length
      console.log "allUrls.length: " + allUrls.length
      if(allUrls == null)
        allUrls = []
      allUrls.push saveUrl
      robot.brain.set('urls', allUrls)

    pruneUrls = (urls) ->
      urlsSize = sizeOfUrls(urls)
      console.log "urls size:" + urlsSize
      if(urlsSize >= maxUrlStorage)
        console.log "urls exceeding maxUrlStorage: " + urlsSize + " >= " + maxUrlStorage
        #oldest
        oldestDate = new Date("01-01-3000")
        for url in urls
          urlDate = new Date(url.dateTime)
          # console.log "url.dateTime: " + url.dateTime
          # console.log "urlDate: " + urlDate
          # console.log "oldestDate: " + oldestDate
          # console.log "urlDate.getTime(): " + urlDate.getTime() + " oldestDate.getTime()" + oldestDate.getTime()
          # console.log urlDate.getTime() < oldestDate.getTime()
          if(urlDate.getTime() < oldestDate.getTime())
            oldestDate = urlDate
            oldestUrl = url
        console.log "oldestUrl.url: " + oldestUrl.url
        #remove
        for key, url of urls
          if url.url == oldestUrl.url
            console.log "url.url == oldestUrl.url"
            console.log "url.url: " + url.url
            console.log "oldestUrl.url: " + oldestUrl.url
            console.log "key: " + key
            urls.splice(key, 1)
        console.log "urls.length: " + urls.length
      return urls

    sizeOfUrls = (urls) ->
      # console.log "sizeOfUrls"
      totalSize = 0
      for url in urls
        # console.log "url.userName.length: " + url.userName.length + " url.dateTime.length: " + url.dateTime.length + " url.url.length: " + url.url.length
        # console.log "url.userName: " + url.userName + " url.dateTime: " + url.dateTime + " url.url: " + url.url
        totalSize += url.userName.length
        totalSize += url.dateTime.length
        totalSize += url.url.length
      totalSize
      
    url = res.match[1]
    
    console.log "url: " + res.match[1]
    console.log "message: " + res.message.user.name

    oldUrl = getUrl(url)
    console.log "oldUrl: " + oldUrl
    if(oldUrl)
      console.log "dateTime: " + oldUrl.dateTime
      res.reply "OldYeller detected old! " + oldUrl.userName + " posted " + url + " @ " + oldUrl.dateTime
    else
      storeUrl(res, url)
