module.exports = (robot) ->

  # Entering and leaving
  # ---------------------------

  enterReplies = ['HEJ!', 'DU ER MIN BEDSTE VEN!', 'Shhh! Der kom han.', 'Så er freden forbi...']
  leaveReplies = ['Nå, så blev han sgu sur.', 'AND STAY OUT!']

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

  # Unicode test
  # ---------------------------

  robot.respond /tableflip/i, (res) ->
    res.send "(╯°□°)╯︵ ┻━┻"
    
