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
