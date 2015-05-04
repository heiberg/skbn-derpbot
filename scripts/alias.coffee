debug = true

debugLog = (msg) ->
  if(debug)
    console.log msg

ensureRedisAliases = (robot) ->
  debugLog "Alias: ensureRedisAliases"
  aliases = robot.brain.get('aliases')
  if aliases == null
    debugLog "Alias: no Redis aliases detected. Bootstrapping."
    aliases = []
    robot.brain.set('aliases', aliases)

module.exports = (robot) ->
  robot.respond /alias set (\#[a-z0-9_-]+) (https?\:\/\/\S+)/i, (res) ->
    ensureRedisAliases(robot)
    alias = res.match[1]
    url = res.match[2]
    aliases = robot.brain.get('aliases')
    aliases[alias] = url
    res.send("Alias set for "+ alias)
    debugLog "Aliases updated with " + alias + " to " + aliases
    robot.brain.set('aliases', aliases)

  robot.respond /alias clear (\#[a-z0-9_-]+)/i, (res) ->
    ensureRedisAliases(robot)
    alias = res.match[1]
    aliases = robot.brain.get('aliases')
    if aliases[alias] != undefined
      delete aliases[alias]
      res.send("Cleared alias for " + alias)
      robot.brain.set('aliases', aliases)
    else
      res.send("No alias named " + alias)

  robot.hear /(\#[a-z0-9_-]+)/i, (res) ->
    ensureRedisAliases(robot)
    alias = res.match[1]
    aliases = robot.brain.get('aliases')
    if aliases[alias] != null
      res.send(aliases[alias])
