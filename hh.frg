#lang forge

sig Honeycomb {}

sig Player {}

sig State {
  players: pfunc Player -> Player,
  eliminated: set Player,
  combs: pfunc Honeycomb -> Int, // explain in readme -- could do set of ints
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
  all p: Player | {
    // if p has been eliminated
    p in s.eliminated implies {
      // no other player can reach them
      all other: Player | {
        not reachable[p, other, s.players] // no one can reach me
        not reachable[other, p, s.players] // i can reach no one
      }
    } else {
      // p has not been eliminated
      all other: Player | {
        // all other players that have not been eliminated
        not (other in s.eliminated) implies {
          reachable[p, other, s.players] // all others can reach me
          reachable[other, p, s.players] // i can reach all others
        }
      }
    }
  }

  // honeycombs must be a nonnegative int away TODO no duplicates
  all comb: Honeycomb | {
    s.combs[comb] >= 0
  }

  // there must be exactly (number current players) - 1 honeycombs for every state
  subtract[#{s.players}, 1] = #{s.combs}

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

  no s.eliminated

  // there are (total number of players) - 1 honeycombs
  #{s.combs} = subtract[#{Player}, 1]

  // is not the "nextState" of any state
  // also disallows a "one state" cycle
  no other: State | other.nextState = s

  // can reach all other states
  all other: State | other != s implies reachable[other, s, nextState]
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
  #{s.combs} = 0
  
  // there is only 1 player (the currPlayer) in the "players" cycle
  #{s.players} = 1
  #{s.eliminated} = subtract[#{Player}, 1]
  s.players[s.currPlayer] = s.currPlayer

  //there is no next state
  no s.nextState
}

// assumes moveBy is 1 or 2
pred currPlayerEliminated[s: State, moveBy: Int] {
  // a player is eliminated if, on their turn:
  // a honeycomb is at position 0
  some comb: Honeycomb | s.combs[comb] = 0
  or
  // at position 1 and they player takes 2 fruit
  (some comb: Honeycomb | s.combs[comb] = 1) and (moveBy = 2)
}

/*
move [State, State]
- player moves combs forward by {one or two}
- player's successor becomes the player in the next state
  
  //     
- we move to the current state's next state
*/

//assume wellformed
pred move[curr: State, next: State, moveBy: Int] {
  // GAURD
  // we move to the current state's next state
  next = curr.nextState

  // player's successor becomes the player in the next state
  next.currPlayer = curr.players[curr.currPlayer]

  moveBy = 1 or moveBy = 2

  // ACTION
  // if the current player is eliminated
  currPlayerEliminated[curr, moveBy] implies {
    curr.currPlayer in next.eliminated // player is actually eliminated
    #{next.combs} = subtract[#{curr.combs}, 1] // a honeycomb is removed
    // if the eliminating honeycomb was at position 0, all other honeycombs move forward by exactly 1
    (some comb: Honeycomb | curr.combs[comb] = 0) implies {
      all comb: Honeycomb | {
        // all combs except the eliminating one are moved forward by 1
        curr.combs[comb] != 0 implies {
          next.combs[comb] = subtract[curr.combs[comb], 1]
        } 
      }
    } else {
      // if at position 1 and player takes 2, all honeycombs move forward by exactly 2 (as normal)
      all comb: Honeycomb | {
        curr.combs[comb] != 1 implies {
          next.combs[comb] = subtract[curr.combs[comb], 2]
        }
      }
    }
    // turn order is preserved
    all disj p1, p2: Player | {
      p1 = curr.currPlayer implies {
        // if p1 is eliminated, then p1's previous player will point
        // to p1's next player in the next state
        some prev: Player | {
          curr.players[prev] = curr.currPlayer // prev is previous
          next.players[prev] = curr.players[p1] // p1 removed correctly
        }
      } else {
        // all non-eliminated players keep the ordering
        p2 != curr.currPlayer implies {
          curr.players[p1] = p2 implies next.players[p1] = p2
        }
      }
    }
  } else { // no one is eliminated
    curr.eliminated = next.eliminated // no one new is eliminated
    #{next.combs} = #{curr.combs} // no honeycombs are removed
    // combs move forward by 1 or 2
    moveBy = 1 implies {
      all comb: Honeycomb | {
        next.combs[comb] = subtract[curr.combs[comb], 1]
      }
    } else {
      all comb: Honeycomb | {
        next.combs[comb] = subtract[curr.combs[comb], 2]
      }
    }

    // turn order preserved
    all p1, p2: Player | {
      curr.players[p1] = p2 implies next.players[p1] = p2
    }
  }
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
  all s1, s2: State | s2 = s1.nextState implies move[s1, s2, 1] or move[s1, s2, 2]
}

// TODO - linearity -- can a final state exist that is not reachable from every other state
run {traces} for exactly 3 Player, 8 State

//TODO -- only works for two players... what's wrong with three?