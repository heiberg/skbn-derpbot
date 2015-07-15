module.exports = (robot) ->

  randomNum = (max,min=0) ->
	  return Math.floor(Math.random() * (max - min) + min)

  lpad = (value, padding) ->
    zeroes = "0"
    zeroes += "0" for i in [1..padding]
    (zeroes + value).slice(padding * -1)

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

  sayOuch = (res) ->
    ouchReplies = ["AV!", "AAAAV", "Stop det!", "Hey! Jeg siger det til Fusager!", "OUCH!", "ARJ helt ærligt, det gør nas!", "OOOH, lige i nokerne. :-("]
    res.send res.random ouchReplies

  robot.hear /(slår|smækker|losser|sparker|smadrer|banker|stikker|slaps|smacks).*derpbot/i, (res) ->
    sayOuch(res)

  robot.hear /(pets|nusser|aer|kæler).*derpbot/i, (res) ->
    res.send "*PURRRRRRR*"

  robot.hear /padfone/i, (res) ->
    res.send "http://androidandme.com/wp-content/uploads/2012/10/asus-jonney-shih-630.jpg"

  robot.hear /it is known/i, (res) ->
    res.send "http://www.madhamburg.com/wp-content/uploads/2014/01/It-is-KNOWN.gif"

  robot.hear /zepto|zetpo/i, (res) ->
    res.send "Zepto er faktisk utrolig godt bygget. Generelt. De er mindst lige så gode som en Apple. Og de er faktisk danske. Der er ikke mange der ved det. De er lidt ligesom Intel ThinkPad. Bare danske."

  robot.hear /vækker derpbot/i, (res) ->
    res.send "Huh? Hvad? ... Jeg sov ikke!"

  robot.hear /hold.*kæft.*derpbot/i, (res) ->
    res.send "Nå ja... Så må man ikke have en mening? Ok da!"

  robot.hear /derpbot.*hold.*kæft/i, (res) ->
    res.send "JEG PRØVER JO BARE AT HJÆLPE!"

  robot.hear /house[ ]?warming/i, (res) ->
    res.send "Oooh, jeg elsker housewarming! ... Men jeg kan ikke se jeg har fået en invitation? Hvornår er det?"

  robot.hear /ipod/i, (res) ->
    res.send "Hey! Har I hørt at der er kommet nye iPods?"

  robot.hear /imac/i, (res) ->
    res.send "Jeg synes hellere du skulle købe en Mac Mini og så lægge XBMC på den!"

  robot.hear /guldfisk/i, (res) ->
    res.send "Jeg har hørt at i USA der har de en guldfisk som kan stemme!"

  robot.hear /macbook/i, (res) ->
    res.send "Du kan ikke spille de nye spil på Macintosh OS10. Og de er meget dyrere end Acer. Man bliver nødt til at bygge sin egen PC."

  robot.hear /mac mini/i, (res) ->
    res.send "WAT? Kommer der ny Mac Mini!?"

  robot.hear /tableflip/i, (res) ->
    res.send "(╯°□°)╯︵ ┻━┻"

  robot.hear /blå blok/i, (res) ->
    res.send "Jeg stemte Liberal Alliance fordi de er bedst for miljøet lol!"

  robot.respond /the real rules/i, (res) ->
    res.send "1: EXTERMINATE"
    res.send "2: GOTO RULE 1"

  robot.respond /pls/i, (res) ->
    res.send "PLS!"

  # Butt stuff
  # ---------------------------

  robot.hear /(buttsex|numseleg|butt sex|pix i røv)/i, (res) ->
    res.send "http://lafinjack.net/images/butsaix/butsaix_" + lpad(randomNum(21,1), 2) + ".jpg"

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
