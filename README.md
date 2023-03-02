# Curiosity Modeling - Honeycomb Havoc!

## What are we trying to model?
[Honeycomb Havoc](https://www.mariowiki.com/Honeycomb_Havoc) is a Mario Party minigame first introduced in Mario Party 2. It is inspired by the classical game [Nim](https://en.wikipedia.org/wiki/Nim). In the game, both fruit and honeycombs are being dropped out of a tree. Players can select either 1 or 2 fruit to drop in their basket. Honeycombs are dispersed among the fruit. If a honeycomb is dropped into their basket, the player is eliminated from the game. The last player remaining wins. Here is a picture from gameplay:
![Honeycomb Havoc gameplay](https://i.ytimg.com/vi/x-gw57R9-vg/maxresdefault.jpg) 



## Overview of the model design choices
### Checks and run statements
We wrote examples and counterexamples for all our predicates to verify that they operate as expected. Additionally, we wrote inductive reasoning to show that wellformedness is preserved by the move predicate. A full explanation of each test is documented in our test file.

// TODO: run statements
We have various run statements with varying amounts of players and states.

### What to expect in the Sterling visualizer

### How to interpret an instance created by the spec

### Custom visualization (?)
A custom visualizer is included (`hhVisualizer.js`) which can be used to better visualize an instance in Sterling using the `</> Script` tab. This visualizer is simple and text-based, but allows the data of an instance to be understood in a turn-based way. Each state is shown in order, from left-to-right then top-to-bottom. Each state shows the current player and how many fruit they took, the distance of each honeycomb, and the next players in the turn order. An example of a simple game in the default visualizer and the custom visualization is shown here:

![Default visualization of a basic game](/hh-default-simple.png)
![Custom visualization of a basic game](/hh-vis-simple.png)

The sig instance names are shown as they are represented in the instance (i.e. `State7` represents the `State7` instance and can be used in the evaluator.

Our model contains a `run` statement that contains a long trace with far away honeycombs. Since instances take a while to generate, a sample instance is provided here, using all three visualizations (graph, table, and custom):

![Default visualization of a complex game](/hh-graph.png)
![Table visualization of a complex game](/hh-table.png)
![Custom visualization of a complex game](/hh-vis.png)

Note: There is a visual bug in the visualizer when honeycombs are multiple-digit distances away. The lists of honeycombs are sorted with the distances represented as strings, so the sorting is off, which is why is *appears* as if `-6` fruit is taken. This is not the case in the model, but is only a visualization bug.



## What do each of the sigs and preds represent in the context of the model?
### Sigs
#### `Honeycomb`
This sig represents a honeycomb and has no fields. This might be able to be replaced with a `Set` of `Int`s in the `State` sig, but remains to exist because we want to ensure that the honeycombs are “swapping places” between states (i.e. the first and third honeycombs trade places, which would not be detected with a `Set` of `Int`s).
#### `Player`
This sig represents a player and has no fields. In our very initial implementation of the game, `Player` had a next field to maintain player order but we got rid of that and replaced it with `players` and `eliminated` in `State`, which are further explained below.
#### `State`
This sig represents a state of the game.
Its fields are:
* `players`: a `pfunc` that represents the turn order in the given state. Players that exist in `players` are still in the game in that state, and point to the next player in the turn order.
* `eliminated`: a `Set` of the `Player`s that have been eliminated from the game at the given `State`.
* `combs`: a `pfunc` of all `Honeycombs` that are still in the game. A `Honeycomb` points to an `Int` that represents how far away the honeycomb is (which represents how many fruit exist before the honeycomb will fall). This could also be a `Set` of `Int`s, as discussed in the `Honeycomb` sig description.
* `currPlayer`: the `Player` whose turn it is. There must be exactly one.
* `nextState`: the `State` that occurs sequentially after this `State`. There can be either one or no `nextState`.

### Predicates
* `wellformed`: true if the given state conforms to our expectations for a valid state, including the `eliminated` set and `players` being mutually exclusive,` Honeycomb` positions make sense, and there are no self-cycles in `nextState`.
* `init`: what the initial state of the game should look like. 
* `final`: what the final state of the game should look like.
* `currPlayerEliminated`: true if a given player will be eliminated. Takes in how many “fruits” the player picked that turn (called `moveBy`, which can only be 1 or 2). This is used as a helper in `move`, since different properties hold depending on a player being eliminated or not.
* `move`: given two states and the number of fruits picked by the current player, evaluates to true if the transition between the two states is valid. 
* `traces`: validates an entire game space. evaluates to true if the instance represents a valid game of Honeycomb Havoc! according to the rules.

