# Description:
# Post animated Skype emojis.
#
# Dependencies:
# none
#
# Configuration:
# none
#
# Commands:
# hubot skype list - Print a list of supported Skype emoji names
# hubot skype <emoji name> - Post the names Skype emoji.
#
# Author:
# Morten Heiberg

emoji_names = ['angel','angry','bandit','beer','bertlett','bike','blush','bow','brokenheart','bug','cake','call','cash','cat','clap','coffee','cool','cry','dance','devil','dog','doh','drink','drunk','dull','eg','emo','envy','facepalm','fingerscrossed','flower','giggle','handshake','happy','headbang','heart','heidy','hi','highfive','hug','idea','inlove','kiss','lalala','laugh','lipssealed','mail','makeup','mlt','mmm','mooning','movie','muscle','music','nerdy','ninja','no','nod','oliver','party','phone','pizza','poolparty','priidu','puke','punch','rain','rock','rofl','sad','shake','sheep','skype','sleepy','smile','smirk','smoke','speechless','star','sun','surprised','swear','sweat','talk','talktothehand','taur','think','time','tmi','toivo','tongueout','tumbleweed','wait','waiting','wasntme','wfh','whew','wink','wonder','worry','yawn','yes']
emoji_aliases = {
  'flex': 'muscle'
  'gnubbetænder': 'clap'
  'gnubtissetrold': 'heidy'
}
link_prefix = 'https://dl.dropboxusercontent.com/u/2439290/skype_gifs/'
link_suffix = '.gif'

isFoundIn = (term, array) ->
  array.indexOf(term) isnt -1

postEmoji = (msg, name, help_on_error) ->
  mapped_name = emoji_aliases[name]
  if mapped_name != undefined
    name = mapped_name
  if isFoundIn(name, emoji_names)
    msg.send(link_prefix + name + link_suffix)
  else if help_on_error
    msg.send("That's not a Skype emoji. Say 'skype list' to me to get a list of all the Skype emojis I know.")

postEmojiList = (msg) ->
    msg.send('These are the Skype emojis I know: ' + emoji_names.join(', '))

module.exports = (robot) ->
  robot.respond /skype(.*)/i, (msg) ->
    cmd = msg.match[1].trim()
    if cmd == 'list'
      postEmojiList(msg)
    else
      postEmoji(msg, cmd, true)

  robot.hear /\(([a-z]+)\)/i, (msg) ->
    cmd = msg.match[1]
    postEmoji(msg, cmd, false)
