#lang forge/bsl

sig Honeycomb {}

sig Player {}

sig State {
  players: pfunc Player -> Player,
  combs: pfunc Honeycomb -> Int,
  currPlayer: one Player,
  nextState: lone State
}

/*
wellformed [State]
- the players that are currently in the game must form a single cycle
  > eliminated players are not connected to any other players
- there must be exactly (number current players) - 1 honeycombs for every state
- no state is its own next state
*/
pred wellformed[s: State] {
  
  
  // the players that are currently in the game must form a single cycle
  // > eliminated players are not connected to any other players

  // there must be exactly (number current players) - 1 honeycombs for every state

  // no state is its own next state
  s != s.nextState
}


/*
init [State]
- all players are in the cycle
- there are (total number of players) - 1 honeycombs
- is not the "nextState" of any state
*/
pred init[s: State] {
  // all players are in the cycle
  all p1, p2: Player | reachable[p1, p2, s.players]

  // there are (total number of players) - 1 honeycombs
  #{Honeycomb} = subtract[#{Player}, 1]

  // is not the "nextState" of any state
  // also disallows a "one state" cycle
  no other: State | other.nextState = s
}


/*
final [State]
- there are no honecombs
- there is only 1 player (the currPlayer) in the "players" cycle
  > this means the players "next player" is themself
- there is no next state
*/
pred final[s: State] {
  // there are no honecombs
  #{Honeycomb} = 0
  
  // there is only 1 player (the currPlayer) in the "players" cycle
  s.players[s.currPlayer] = s.currPlayer
  no other: Player | {
    other != s.currPlayer implies {
      all otherAgain: Player | {
        s.players[other] = otherAgain // TODO: better name
      }
    }
  }

  //there is no next state
  no s.nextState
}


/*
move [State, State]
- player moves combs forward by {one or two}
- player's successor becomes the player in the next state
- a player is eliminated if, on their turn, a honeycomb is at position 0 or at position 1 and they player takes 2 fruit
  > if at position 0, all honeycombs move forward by exactly 1
  > if at position 1 and player takes 2, all honeycombs move forward by exactly 2 (as normal)
- we move to the current state's next state
*/
pred move[curr: State, next: State] {
  // gaurd


  // action



}

pred traces {
  // you must always have at least one player
  #{Player} > 0

  // state does not form a cycle (linear)
  all s: State | not reachable[s, s, nextState]

  // all states are well formed
  all s: State | wellformed[s]

  // an initial and final state exist
  some s: State | init[s]
  some s: State | final[s]

  // you can move between each state
  all s1, s2: State | s2 = s1.nextState implies move[s1, s2]
}

// unsat : TODO with number syntax like #{Honeycomb}
run {traces} for 3 Honeycomb, exactly 4 Player, exactly 3 State for {nextState is linear}