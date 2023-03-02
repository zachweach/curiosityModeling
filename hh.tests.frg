#lang forge

open "hh.frg"

// TODO -- move cannot take us into a non-wellformed state
// TODO - linearity -- can a final state exist that is not reachable from every other state

// wellformed
test suite for wellformed {

  // VALID WELLFORMED STATES

  // all players are in the game
  example validWellfAllIn is {some s:State | wellformed[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
      no eliminated
      combs = `S0 -> `H0 -> 0
            + `S0 -> `H1 -> 4
            + `S0 -> `H2 -> 7
      currPlayer = `S0 -> `Yoshi
      no nextState
  }

   // mix of players in the game and elimin
  example validWellformedMix is {some s:State | wellformed[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Mario
      eliminated = `S0 -> `Yoshi
                 + `S0 -> `Luigi
      combs = `S0 -> `H0 -> 3
      currPlayer = `S0 -> `Peach
      no nextState
  }

  // INVALID WELLFORMED STATES

  // the next state is itself
  example nextStateisSelf is not {some s:State | wellformed[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Mario
      eliminated = `S0 -> `Yoshi
                 + `S0 -> `Luigi
      combs = `S0 -> `H0 -> 3
      currPlayer = `S0 -> `Peach
      nextState = `S0 -> `S0
  }

  // players dont form a cycle
  example playersNoCylce is not {some s:State | wellformed[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
      eliminated = `S0 -> `Yoshi
      combs = `S0 -> `H0 -> 3
            + `S0 -> `H1 -> 5
      currPlayer = `S0 -> `Peach
      no nextState
  }

  // players still in the game form two seperate cycles
  example playersTwoCycles is not {some s:State | wellformed[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Mario
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Luigi
      no eliminated
      combs = `S0 -> `H0 -> 3
            + `S0 -> `H1 -> 4
            + `S0 -> `H2 -> 7
      currPlayer = `S0 -> `Peach
      no nextState
  }

  // players still in the game point to themself
  example playersPointToSelf is not {some s:State | wellformed[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Mario
              + `S0 -> `Peach -> `Peach
              + `S0 -> `Luigi -> `Luigi
              + `S0 -> `Yoshi -> `Yoshi
      no eliminated
      combs = `S0 -> `H0 -> 3
            + `S0 -> `H1 -> 4
            + `S0 -> `H2 -> 7
      currPlayer = `S0 -> `Peach
      no nextState
  }

   // honeycombs have negative values
  example negativeCombs is not {some s:State | wellformed[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
      no eliminated
      combs = `S0 -> `H0 -> -6
            + `S0 -> `H1 -> 4
            + `S0 -> `H2 -> 7
      currPlayer = `S0 -> `Yoshi
      no nextState
  }

  // two honeycombs are in the same location
  example combsSameLocation is not {some s:State | wellformed[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
      no eliminated
      combs = `S0 -> `H0 -> 2
            + `S0 -> `H1 -> 5 
            + `S0 -> `H2 -> 2
      currPlayer = `S0 -> `Yoshi
      no nextState
  }

  // more honeycombs than players
  example moreCombs is not {some s:State | wellformed[s]} for {
      Honeycomb = `H0 + `H1 + `H2 + `H3 + `H4
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
      no eliminated
      combs = `S0 -> `H0 -> 0
            + `S0 -> `H1 -> 1
            + `S0 -> `H2 -> 2
            + `S0 -> `H3 -> 3
            + `S0 -> `H4 -> 4
      currPlayer = `S0 -> `Yoshi
      no nextState
  }

  // same number of honeycombs and players
  example sameCombandPlayers is not {some s:State | wellformed[s]} for {
      Honeycomb = `H0 + `H1 + `H2 + `H3 + `H4
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
      no eliminated
      combs = `S0 -> `H0 -> 0
            + `S0 -> `H1 -> 1
            + `S0 -> `H2 -> 2
            + `S0 -> `H3 -> 3
      currPlayer = `S0 -> `Yoshi
      no nextState
  }

  // one player is in elimanted but still in players
  example playerInElimAndPlayers is not {some s:State | wellformed[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
      eliminated = `S0 -> `Yoshi
      combs = `S0 -> `H0 -> 2
            + `S0 -> `H1 -> 5
            + `S0 -> `H2 -> 6
      currPlayer = `S0 -> `Luigi
      no nextState
  }

}

// init

test suite for init {

  // VALID INITIAL STATES

  // 1 player (would also be a final state)
  example valid1PlayerInitState is {some s:State | init[s]} for {
      no Honeycomb
      Player = `Mario
      State = `S0
      players = `S0 -> `Mario -> `Mario
      no eliminated
      no combs
      currPlayer = `S0 -> `Mario
      no nextState
  }

  // 2 players
  example valid2PlayerInitState is {some s:State | init[s]} for {
      Honeycomb = `H0
      Player = `Mario + `Peach
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Mario
      no eliminated
      combs = `S0 -> `H0 -> 3
      currPlayer = `S0 -> `Peach
      no nextState
  }

  // 4 players
  example valid4PlayerInitState is {some s:State | init[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
      no eliminated
      combs = `S0 -> `H0 -> 3
            + `S0 -> `H1 -> 4
            + `S0 -> `H2 -> 7
      currPlayer = `S0 -> `Yoshi
      no nextState
  }

  // INVALID INITIAL STATES
  
  // honeycombs have negative values
  example invalidInitStateNegCombs is not {some s:State | init[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
      no eliminated
      combs = `S0 -> `H0 -> -8
            + `S0 -> `H1 -> -4
            + `S0 -> `H2 -> -2
      currPlayer = `S0 -> `Yoshi
      no nextState
  }

   // two honeycombs are in the same location
  example invalidInitCombSameLoc is not {some s:State | init[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
      no eliminated
      combs = `S0 -> `H0 -> 2
            + `S0 -> `H1 -> 5 
            + `S0 -> `H2 -> 2
      currPlayer = `S0 -> `Yoshi
      no nextState
  }

  // more honeycombs than players
  example invalidInitMoreCombs is not {some s:State | init[s]} for {
      Honeycomb = `H0 + `H1 + `H2 + `H3 + `H4
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
      no eliminated
      combs = `S0 -> `H0 -> 0
            + `S0 -> `H1 -> 1
            + `S0 -> `H2 -> 2
            + `S0 -> `H3 -> 3
            + `S0 -> `H4 -> 4
      currPlayer = `S0 -> `Yoshi
      no nextState
  }

  // one player is in eliminated
  example invalidInitEliminated is not {some s:State | init[s]} for {
      Honeycomb = `H0 + `H1 +`H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Mario
      eliminated = `S0 -> `Yoshi
      combs = `S0 -> `H0 -> 2
            + `S0 -> `H1 -> 5
      currPlayer = `S0 -> `Luigi
      no nextState
  }

   // one player is in elimanted but still in players
  example invalidInitElimAndNot is not {some s:State | init[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
      eliminated = `S0 -> `Yoshi
      combs = `S0 -> `H0 -> 2
            + `S0 -> `H1 -> 5
            + `S0 -> `H2 -> 6
      currPlayer = `S0 -> `Luigi
      no nextState
  }
 
  // all players are eliminated
  example invalidInitAllElim is not {some s:State | init[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      no players
      eliminated = `S0 -> `Yoshi +
                   `S0 -> `Mario +
                   `S0 -> `Peach +
                   `S0 -> `Luigi
      combs = `S0 -> `H0 -> 2
            + `S0 -> `H1 -> 5
            + `S0 -> `H2 -> 6
      currPlayer = `S0 -> `Luigi
      no nextState
  }
}

// final
test suite for final {

  // VALID FINAL STATES

  // 2 players
  example valid2PlayerFinaltate is {some s:State | final[s]} for {
      Honeycomb = `H0
      Player = `Mario + `Peach
      State = `S0
      players = `S0 -> `Mario -> `Mario
      eliminated = `S0 -> `Peach
      no combs
      currPlayer = `S0 -> `Mario
      no nextState
  }

  // 4 players
  example valid4PlayerFinalState is {some s:State | final[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Yoshi -> `Yoshi
      eliminated = `S0 -> `Mario +
                   `S0 -> `Peach +
                   `S0 -> `Luigi
      no combs
      currPlayer = `S0 -> `Yoshi
      no nextState
  }

  // INVALID FINAL STATES
      
  // more than one player remaining
  example moreThanOnePlayerRemaining is not {some s:State | final[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Yoshi -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
      eliminated = `S0 -> `Mario +
                   `S0 -> `Peach
      no combs
      currPlayer = `S0 -> `Yoshi
      no nextState
  }

  // all players are eliminated
  example invalidFinalAllElim is not {some s:State | final[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      no players
      eliminated = `S0 -> `Yoshi +
                   `S0 -> `Mario +
                   `S0 -> `Peach +
                   `S0 -> `Luigi
      no combs
      currPlayer = `S0 -> `Peach
      no nextState
  }

  // one honeycomb remains
  example invalidOneComb is not {some s:State | final[s]} for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0
      players = `S0 -> `Yoshi -> `Yoshi
      eliminated = `S0 -> `Mario
                 + `S0 -> `Peach
                 + `S0 -> `Luigi
      combs = `S0 -> `H0 -> 2
      currPlayer = `S0 -> `Yoshi
      no nextState
  }
}


// currPlayerEliminated
test suite for currPlayerEliminated {
  // VALID TESTS

  // player takes one fruit but a honeycomb is zero moves away
  example combAtZeroOneFruit is {some s: State | currPlayerEliminated[s, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Luigi
            + `S0 -> `Luigi -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
    no eliminated
    combs = `S0 -> `H0 -> 0 // this comb eliminates Yoshi
          + `S0 -> `H1 -> 4
          + `S0 -> `H2 -> 7
    currPlayer = `S0 -> `Yoshi
    no nextState
  }

  // player takes two fruit but a honeycomb is zero moves away
  example combAtZeroTwoFruit is {some s: State | currPlayerEliminated[s, 2]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Luigi
            + `S0 -> `Luigi -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
    no eliminated
    combs = `S0 -> `H0 -> 0 // this comb eliminated Yoshi
          + `S0 -> `H1 -> 4
          + `S0 -> `H2 -> 7
    currPlayer = `S0 -> `Yoshi
    no nextState
  }

  // the comb is one move away, but player takes two fruit
  example combAtOne is {some s: State | currPlayerEliminated[s, 2]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Luigi
            + `S0 -> `Luigi -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
    no eliminated
    combs = `S0 -> `H0 -> 1 // this comb eliminated Yoshi
          + `S0 -> `H1 -> 4
          + `S0 -> `H2 -> 7
    currPlayer = `S0 -> `Yoshi
    no nextState
  }

  // player will still be eliminated if multiple combs share an eliminating position
  example multipleCombsAtZero is {some s: State | currPlayerEliminated[s, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Luigi
            + `S0 -> `Luigi -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
    no eliminated
    combs = `S0 -> `H0 -> 0
          + `S0 -> `H1 -> 0
          + `S0 -> `H2 -> 0
    currPlayer = `S0 -> `Yoshi
    no nextState
  }

  // INVALID TESTS

  // the comb is one move away, but the player doesn't take enough fruit to eliminate them
  example combAtOneTakeOne is not {some s: State | currPlayerEliminated[s, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Luigi
            + `S0 -> `Luigi -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
    no eliminated
    combs = `S0 -> `H0 -> 1
          + `S0 -> `H1 -> 4
          + `S0 -> `H2 -> 7
    currPlayer = `S0 -> `Yoshi
    no nextState
  }

  // no combs could possibly eliminate the player
  example combsFarAway is not {some s: State | currPlayerEliminated[s, 2]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Luigi
            + `S0 -> `Luigi -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
    no eliminated
    combs = `S0 -> `H0 -> 3
          + `S0 -> `H1 -> 4
          + `S0 -> `H2 -> 7
    currPlayer = `S0 -> `Yoshi
    no nextState
  }

  // there are no combs in the state (not possible/wellformed)
  example noCombs is not {some s: State | currPlayerEliminated[s, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0
    players = `S0 -> `Mario -> `Mario
    eliminated = `S0 -> `Peach + `S0 -> `Luigi + `S0 -> `Yoshi
    no combs
    currPlayer = `S0 -> `Mario
    no nextState
  }

}


// move
test suite for move {
  test expect {
    // induction: move preserves wellformedness
    base: {
      some s: State | init[s] and not wellformed[s]
    } for exactly 1 State
    is unsat

    inductiveOne: {
      some s1, s2: State | {
        wellformed[s1]
        move[s1, s2, 1]
        not wellformed[s2]
      }
    } for exactly 2 State
    is unsat

    inductiveTwo: {
      some s1, s2: State | {
        wellformed[s1]
        move[s1, s2, 2]
        not wellformed[s2]
      }
    } for exactly 2 State
    is unsat
  }

  // VALID EXAMPLES
  
  // player takes one fruit and is not eliminated ("normal" case)
  example noEliminationTakeOneFruit is {some s1, s2: State | move[s1, s2, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Luigi
            + `S0 -> `Luigi -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Luigi
            + `S1 -> `Luigi -> `Yoshi
            + `S1 -> `Yoshi -> `Mario
    no eliminated
    combs = `S0 -> `H0 -> 2
          + `S0 -> `H1 -> 4
          + `S0 -> `H2 -> 7
          + `S1 -> `H0 -> 1 // these decrement by one
          + `S1 -> `H1 -> 3
          + `S1 -> `H2 -> 6
    currPlayer = `S0 -> `Yoshi + `S1 -> `Mario
    nextState = `S0 -> `S1
  }

  // player takes two fruit and is not eliminated
  example noEliminationTakeTwoFruit is {some s1, s2: State | move[s1, s2, 2]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Luigi
            + `S0 -> `Luigi -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Luigi
            + `S1 -> `Luigi -> `Yoshi
            + `S1 -> `Yoshi -> `Mario
    no eliminated
    combs = `S0 -> `H0 -> 2
          + `S0 -> `H1 -> 4
          + `S0 -> `H2 -> 7
          + `S1 -> `H0 -> 0 // these decrement by two
          + `S1 -> `H1 -> 2
          + `S1 -> `H2 -> 5
    currPlayer = `S0 -> `Yoshi + `S1 -> `Mario
    nextState = `S0 -> `S1
  }

  // player is eliminated by taking one fruit
  example eliminatedByTakingOneFruit is {some s1, s2: State | move[s1, s2, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Mario
    eliminated = `S0 -> `Luigi + `S1 -> `Luigi + `S1 -> `Yoshi // Yoshi added to eliminated
    combs = `S0 -> `H0 -> 0 // this comb eliminates Yoshi
          + `S0 -> `H2 -> 7
          + `S1 -> `H2 -> 6
    currPlayer = `S0 -> `Yoshi + `S1 -> `Mario // Yoshi is the current player
    nextState = `S0 -> `S1
  }

  // player takes two fruit, but a comb is zero moves away so they would always be eliminated
  example takeTwoFruitCombZeroAway is {some s1, s2: State | move[s1, s2, 2]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Mario
    eliminated = `S0 -> `Luigi + `S1 -> `Luigi + `S1 -> `Yoshi
    combs = `S0 -> `H0 -> 0 // this comb eliminates Yoshi
          + `S0 -> `H2 -> 7
          + `S1 -> `H2 -> 6 // this comb only decrements by one
    currPlayer = `S0 -> `Yoshi + `S1 -> `Mario
    nextState = `S0 -> `S1
  }

  // INVALID EXAMPLES
  
  // honeycombs move by 3 spots instead of 1 or 2
  example cannotMoveByThree is not {some s1, s2: State | move[s1, s2, 3]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Yoshi
            + `S1 -> `Yoshi -> `Mario
    eliminated = `S0 -> `Luigi + `S1 -> `Luigi
    combs = `S0 -> `H0 -> 4
          + `S0 -> `H2 -> 7
          + `S1 -> `H0 -> 1 // decrement by 3, but this is still not valid
          + `S1 -> `H2 -> 4
    currPlayer = `S0 -> `Yoshi + `S1 -> `Mario
    nextState = `S0 -> `S1
  }

  // there is no next state
  example noNextStates is not {some s1, s2: State | move[s1, s2, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Yoshi
            + `S1 -> `Yoshi -> `Mario
    eliminated = `S0 -> `Luigi + `S1 -> `Luigi
    combs = `S0 -> `H0 -> 4
          + `S0 -> `H2 -> 7
          + `S1 -> `H0 -> 3
          + `S1 -> `H2 -> 6
    currPlayer = `S0 -> `Yoshi + `S1 -> `Mario
    no nextState
  }

  // the next state does not have the correct next player
  example randomNextPlayer is not {some s1, s2: State | move[s1, s2, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Yoshi
            + `S1 -> `Yoshi -> `Mario
    eliminated = `S0 -> `Luigi + `S1 -> `Luigi
    combs = `S0 -> `H0 -> 4
          + `S0 -> `H2 -> 7
          + `S1 -> `H0 -> 3
          + `S1 -> `H2 -> 6
    currPlayer = `S0 -> `Yoshi + `S1 -> `Peach // currPlayer in S1 should be Mario
    nextState = `S0 -> `S1
  }

  // an eliminated player is no longer eliminated in the next turn
  example playerNoLongerEliminated is not {some s1, s2: State | move[s1, s2, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Yoshi
            + `S1 -> `Yoshi -> `Luigi // Luigi is back in the turn order!
            + `S1 -> `Luigi -> `Mario
    eliminated = `S0 -> `Luigi
    combs = `S0 -> `H0 -> 4
          + `S0 -> `H2 -> 7
          + `S1 -> `H0 -> 3
          + `S1 -> `H2 -> 6
    currPlayer = `S0 -> `Yoshi + `S1 -> `Mario
    nextState = `S0 -> `S1
  }

  // a player is eliminated in the next turn even though the honeycomb is far enough way
  example playerShouldNotBeEliminated is not {some s1, s2: State | move[s1, s2, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Mario
    eliminated = `S0 -> `Luigi + `S1 -> `Luigi + `S1 -> `Yoshi // Yoshi is gone :(
    combs = `S0 -> `H0 -> 4
          + `S0 -> `H2 -> 7
          + `S1 -> `H0 -> 3 // no combs disappear
          + `S1 -> `H2 -> 6
    currPlayer = `S0 -> `Yoshi + `S1 -> `Mario
    nextState = `S0 -> `S1
  }

  // two honeycombs switch the positions they should be in for the next turn
  example honeycombsSwapPositions is not {some s1, s2: State | move[s1, s2, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Yoshi
            + `S1 -> `Yoshi -> `Mario
    eliminated = `S0 -> `Luigi + `S1 -> `Luigi
    combs = `S0 -> `H0 -> 4
          + `S0 -> `H2 -> 7
          + `S1 -> `H2 -> 3 // H2 should be at 6
          + `S1 -> `H0 -> 6 // H1 should be at 3
    currPlayer = `S0 -> `Yoshi + `S1 -> `Mario
    nextState = `S0 -> `S1
  }

  // one of the honeycombs stays in the same spot between turns
  example notAllCombsMove is not {some s1, s2: State | move[s1, s2, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Yoshi
            + `S1 -> `Yoshi -> `Mario
    eliminated = `S0 -> `Luigi + `S1 -> `Luigi
    combs = `S0 -> `H0 -> 4
          + `S0 -> `H2 -> 7
          + `S1 -> `H0 -> 3
          + `S1 -> `H2 -> 7 // does not move
    currPlayer = `S0 -> `Yoshi + `S1 -> `Mario
    nextState = `S0 -> `S1
  }
  
  // a honeycomb is still in the game even though it eliminated a player
  example combRemainsAfterEliminating is not {some s1, s2: State | move[s1, s2, 1]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Mario
    eliminated = `S0 -> `Luigi + `S1 -> `Luigi + `S1 -> `Yoshi
    combs = `S0 -> `H0 -> 0
          + `S0 -> `H2 -> 7
          + `S1 -> `H0 -> -1 // the decrement was correct, but this shouldn't be here
          + `S1 -> `H2 -> 6
    currPlayer = `S0 -> `Yoshi + `S1 -> `Mario
    nextState = `S0 -> `S1
  }

  // the honeycombs decrease by 1 space even though the player selected 2 spaces
  example combsMoveWrongAmount is not {some s1, s2: State | move[s1, s2, 2]} for {
    Honeycomb = `H0 + `H1 + `H2
    Player = `Mario + `Peach + `Luigi + `Yoshi
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Yoshi
            + `S0 -> `Yoshi -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Yoshi
            + `S1 -> `Yoshi -> `Mario
    eliminated = `S0 -> `Luigi + `S1 -> `Luigi
    combs = `S0 -> `H0 -> 4
          + `S0 -> `H2 -> 7
          + `S1 -> `H0 -> 3 // these only decreased by one
          + `S1 -> `H2 -> 6 
    currPlayer = `S0 -> `Yoshi + `S1 -> `Mario
    nextState = `S0 -> `S1
  }
}


// traces
test suite for traces {

  // a game with two players, where the second player is eliminated in the second turn
  example twoPlayerGame is traces for {
    Honeycomb = `H0
    Player = `Mario + `Peach
    State = `S0 + `S1 + `S2
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Mario
            + `S2 -> `Peach -> `Peach
    eliminated = `S2 -> `Mario
    combs = `S0 -> `H0 -> 3
          + `S1 -> `H0 -> 1
    currPlayer = `S0 -> `Peach 
               + `S1 -> `Mario 
               + `S2 -> `Peach 
    nextState = `S0 -> `S1 + `S1 -> `S2
  }

  // a game with three players and three states
  example threePlayerGame is traces for {
    Honeycomb = `H1 + `H2
    Player = `P1 + `P2 + `P3
    State = `S1 + `S2 + `S3
    players = `S1 -> `P1 -> `P2
            + `S1 -> `P2 -> `P3
            + `S1 -> `P3 -> `P1
            + `S2 -> `P1 -> `P2
            + `S2 -> `P2 -> `P1
            + `S3 -> `P2 -> `P2
    eliminated = `S  + `S3 -> `P3 + `S3 -> `P1
    combs = `S1 -> `H1 -> 0
          + `S1 -> `H2 -> 1
          + `S2 -> `H2 -> 0
    currPlayer = `S1 -> `P3
              + `S2 -> `P1
              + `S3 -> `P2
    nextState = `S1 -> `S2 + `S2 -> `S3
  }

  // a game with four players and 8 states
  example fourPlayerGame is traces for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0 + `S1 + `S2 + `S3 + `S4 + `S5 + `S6 + `S7
      players =  // Mario -> Peach -> Luigi -> Yoshi
                `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
              + `S1 -> `Mario -> `Peach
              + `S1 -> `Peach -> `Luigi
              + `S1 -> `Luigi -> `Yoshi
              + `S1 -> `Yoshi -> `Mario
              + `S2 -> `Mario -> `Peach
              + `S2 -> `Peach -> `Luigi
              + `S2 -> `Luigi -> `Yoshi
              + `S2 -> `Yoshi -> `Mario
              // Mario-> Luigi -> Yoshi
              + `S3 -> `Mario -> `Luigi
              + `S3 -> `Luigi -> `Yoshi
              // Mario -> Yoshi
              + `S3 -> `Yoshi -> `Mario
              + `S4 -> `Mario -> `Yoshi
              + `S4 -> `Yoshi -> `Mario
              + `S5 -> `Mario -> `Yoshi
              + `S5 -> `Yoshi -> `Mario
              + `S6 -> `Mario -> `Yoshi
              + `S6 -> `Yoshi -> `Mario
              // Mario
              + `S7 -> `Mario -> `Mario
      eliminated = `S3 -> `Peach // Peach now eliminated
                 + `S4 -> `Peach
                 + `S4 -> `Luigi // Luigi now eliminated
                 + `S5 -> `Peach
                 + `S5 -> `Luigi
                 + `S6 -> `Peach
                 + `S6 -> `Luigi
                 + `S7 -> `Peach
                 + `S7 -> `Luigi
                 + `S7 -> `Yoshi // Yoshi now eliminated
      combs = `S0 -> `H0 -> 3
            + `S0 -> `H1 -> 4
            + `S0 -> `H2 -> 7
            // Yoshi took one fruit
            + `S1 -> `H0 -> 2 
            + `S1 -> `H1 -> 3
            + `S1 -> `H2 -> 6
            // Mario took one fruit
            + `S2 -> `H0 -> 1 
            + `S2 -> `H1 -> 2
            + `S2 -> `H2 -> 5
            // Peach took two fruit (Peach is eliminated)
            + `S3 -> `H1 -> 0 
            + `S3 -> `H2 -> 3
            // Luigi took two fruit (but only decremented by one) (Luigi is eliminated)
            + `S4 -> `H2 -> 2
            // Yoshi took one fruit
            + `S5 -> `H2 -> 1 
            // Mario took one fruit
            + `S6 -> `H2 -> 0 // last player (Yoshi) eliminated!
      currPlayer = `S0 -> `Yoshi
                 + `S1 -> `Mario
                 + `S2 -> `Peach
                 + `S3 -> `Luigi
                 + `S4 -> `Yoshi
                 + `S5 -> `Mario
                 + `S6 -> `Yoshi
                 + `S7 -> `Mario
      nextState = `S0 -> `S1 
                + `S1 -> `S2 
                + `S2 -> `S3 
                + `S3 -> `S4 
                + `S4 -> `S5 
                + `S5 -> `S6 
                + `S6 -> `S7 
  }

  // no valid inital state exists
  example noInitState is not traces for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S3 + `S4 + `S5 + `S6 + `S7
      players =  // Mario-> Luigi -> Yoshi
                `S3 -> `Mario -> `Luigi
              + `S3 -> `Luigi -> `Yoshi
              // Mario -> Yoshi
              + `S3 -> `Yoshi -> `Mario
              + `S4 -> `Mario -> `Yoshi
              + `S4 -> `Yoshi -> `Mario
              + `S5 -> `Mario -> `Yoshi
              + `S5 -> `Yoshi -> `Mario
              + `S6 -> `Mario -> `Yoshi
              + `S6 -> `Yoshi -> `Mario
              // Mario
              + `S7 -> `Mario -> `Mario
      eliminated = `S3 -> `Peach // Peach starts eliminated
                 + `S4 -> `Peach
                 + `S4 -> `Luigi
                 + `S5 -> `Peach
                 + `S5 -> `Luigi
                 + `S6 -> `Peach
                 + `S6 -> `Luigi
                 + `S7 -> `Peach
                 + `S7 -> `Luigi
                 + `S7 -> `Yoshi
      combs = `S3 -> `H1 -> 0 
            + `S3 -> `H2 -> 3
            // Luigi took two fruit (but only decremented by one) (Luigi is eliminated)
            + `S4 -> `H2 -> 2
            // Yoshi took one fruit
            + `S5 -> `H2 -> 1 
            // Mario took one fruit
            + `S6 -> `H2 -> 0 // last player (Yoshi) eliminated!
      currPlayer = `S3 -> `Luigi
                 + `S4 -> `Yoshi
                 + `S5 -> `Mario
                 + `S6 -> `Yoshi
                 + `S7 -> `Mario
      nextState = `S3 -> `S4 
                + `S4 -> `S5 
                + `S5 -> `S6 
                + `S6 -> `S7 
  }

  // no final state exists
  example noFinalState is not traces for {
      Honeycomb = `H0 + `H1 + `H2
      Player = `Mario + `Peach + `Luigi + `Yoshi
      State = `S0 + `S1 + `S2 + `S3 + `S4 + `S5 + `S6
      players =  // Mario -> Peach -> Luigi -> Yoshi
                `S0 -> `Mario -> `Peach
              + `S0 -> `Peach -> `Luigi
              + `S0 -> `Luigi -> `Yoshi
              + `S0 -> `Yoshi -> `Mario
              + `S1 -> `Mario -> `Peach
              + `S1 -> `Peach -> `Luigi
              + `S1 -> `Luigi -> `Yoshi
              + `S1 -> `Yoshi -> `Mario
              + `S2 -> `Mario -> `Peach
              + `S2 -> `Peach -> `Luigi
              + `S2 -> `Luigi -> `Yoshi
              + `S2 -> `Yoshi -> `Mario
              // Mario-> Luigi -> Yoshi
              + `S3 -> `Mario -> `Luigi
              + `S3 -> `Luigi -> `Yoshi
              // Mario -> Yoshi
              + `S3 -> `Yoshi -> `Mario
              + `S4 -> `Mario -> `Yoshi
              + `S4 -> `Yoshi -> `Mario
              + `S5 -> `Mario -> `Yoshi
              + `S5 -> `Yoshi -> `Mario
              + `S6 -> `Mario -> `Yoshi
              + `S6 -> `Yoshi -> `Mario
      eliminated = `S3 -> `Peach // Peach now eliminated
                 + `S4 -> `Peach
                 + `S4 -> `Luigi // Luigi now eliminated
                 + `S5 -> `Peach
                 + `S5 -> `Luigi
                 + `S6 -> `Peach
                 + `S6 -> `Luigi
      combs = `S0 -> `H0 -> 3
            + `S0 -> `H1 -> 4
            + `S0 -> `H2 -> 7
            // Yoshi took one fruit
            + `S1 -> `H0 -> 2 
            + `S1 -> `H1 -> 3
            + `S1 -> `H2 -> 6
            // Mario took one fruit
            + `S2 -> `H0 -> 1 
            + `S2 -> `H1 -> 2
            + `S2 -> `H2 -> 5
            // Peach took two fruit (Peach is eliminated)
            + `S3 -> `H1 -> 0 
            + `S3 -> `H2 -> 3
            // Luigi took two fruit (but only decremented by one) (Luigi is eliminated)
            + `S4 -> `H2 -> 2
            // Yoshi took one fruit
            + `S5 -> `H2 -> 1 
            // Mario took one fruit
            + `S6 -> `H2 -> 0
      currPlayer = `S0 -> `Yoshi
                 + `S1 -> `Mario
                 + `S2 -> `Peach
                 + `S3 -> `Luigi
                 + `S4 -> `Yoshi
                 + `S5 -> `Mario
                 + `S6 -> `Yoshi
      nextState = `S0 -> `S1 
                + `S1 -> `S2 
                + `S2 -> `S3 
                + `S3 -> `S4 
                + `S4 -> `S5 
                + `S5 -> `S6
  }

  // a cycle exists in nextState
  example stateCycle is not traces for {
    Honeycomb = `H0
    Player = `Mario + `Peach
    State = `S0 + `S1 + `S2
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Mario
            + `S2 -> `Peach -> `Peach
    eliminated = `S2 -> `Mario
    combs = `S0 -> `H0 -> 3
          + `S1 -> `H0 -> 1
    currPlayer = `S0 -> `Peach 
               + `S1 -> `Mario 
               + `S2 -> `Peach 
    nextState = `S0 -> `S1 + `S1 -> `S2 + `S2 -> `S0
  }

  // transition between states is not valid
  example randomMove is not traces for {
    Honeycomb = `H0
    Player = `Mario + `Peach
    State = `S0 + `S1
    players = `S0 -> `Mario -> `Peach
            + `S0 -> `Peach -> `Mario
            + `S1 -> `Mario -> `Peach
            + `S1 -> `Peach -> `Mario
    eliminated = `S1 -> `Mario // Mario is randomly eliminated
    combs = `S0 -> `H0 -> 3
          + `S1 -> `H0 -> 1
    currPlayer = `S0 -> `Peach 
               + `S1 -> `Mario
    nextState = `S0 -> `S1
  }

  // can a valid game exist with 5 players?
  test expect {
    fivePlayers: {traces} 
    for exactly 5 Player, 8 State
    is sat 
  }
}
