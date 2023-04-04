global function WhatAreYouTalkingAbout_Init

struct {
  table<entity, entity> lastKilledBy
} file

void function WhatAreYouTalkingAbout_Init() {
  AddCallback_OnPlayerKilled(SetLastKiller)
  AddCallback_OnReceivedSayTextMessage(ChatHook)
}

void function SetLastKiller( entity victim, entity attacker, int damageSourceId )
{
  if( victim != attacker )
    file.lastKilledBy[victim] <- attacker
  else if( victim in file.lastKilledBy )
    delete file.lastKilledBy[victim]
}

ClClient_MessageStruct function ChatHook(ClClient_MessageStruct msg)
{
  entity localPlayer = GetLocalClientPlayer()
  if( msg.player in file.lastKilledBy && file.lastKilledBy[msg.player] == localPlayer )
    msg.playerName = format("%s [killed]", msg.playerName)
  return msg
}
