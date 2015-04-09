module.exports = (robot) ->

  # Entering and leaving
  # ---------------------------

  enterReplies = ['DU ER MIN BEDSTE VEN!', 'Shhh! Der kom han.', 'Ja, så er freden forbi...', 'Arj, hvem inviterede ham?!']
  leaveReplies = ['Nå, så blev han sgu sur.', 'AND STAY OUT!', 'SES! ... Men ikke hvis jeg ser dig først! LOOOL']

  robot.enter (res) ->
    res.send res.random enterReplies
  robot.leave (res) ->
    res.send res.random leaveReplies

  # Misc. idiocy
  # ---------------------------

  robot.hear /ipod/i, (res) ->
    res.send "Hey! Har I hørt at der er kommet nye iPods?"

  robot.hear /guldfisk/i, (res) ->
    res.send "Jeg har hørt at i USA der har de en guldfisk som kan stemme!"

  robot.hear /mac mini/i, (res) ->
    res.send "WAT? Kommer der ny Mac Mini!?"

  robot.respond /tableflip/i, (res) ->
    res.send "(╯°□°)╯︵ ┻━┻"

  # Beer test of Redis storage connection
  # ---------------------------

  robot.respond /have a beer/i, (res) ->
    # Get number of beers had (coerced to a number).
    totalBeers = robot.brain.get('totalBeers') * 1 or 0

    if totalBeers > 4
      res.reply "I'm not feeling too well... I already had " + totalBeers
    else
      res.reply 'Cheers! *<CLINK>*'
      robot.brain.set 'totalBeers', totalBeers+1

  robot.respond /sleep it off/i, (res) ->
    robot.brain.set 'totalBeers', 0
    res.reply 'zzzzz'
