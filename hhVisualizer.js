const stage = new Stage()

div.innerHTML = ""
const wrapper = document.createElement("div")
wrapper.style.display = 'grid'

let STATES = []

let state = State;
while (nextState.join(state).tuples().length > 0) {
    state = nextState.join(state)
}
do {
    comb_dists = []
    for (const ind in Honeycomb.tuples()) {
        const comb = Honeycomb.tuples()[ind]
        const dist = comb.join(state.join(combs)).toString()
        if (dist != "") comb_dists.push(dist)
    }
    comb_dists = comb_dists.sort()

    turn_order = []
    let curr_player = state.join(currPlayer)
    let num_players = state.join(players).tuples().length
    let i = 0
    while (i < num_players) {
        turn_order.push(curr_player.toString())
        curr_player = curr_player.join(state.join(players));
        i++
    }

    let moved = -1
    if (comb_dists.length != 0) {
        next_dists = []
        for (const ind in Honeycomb.tuples()) {
            const comb = Honeycomb.tuples()[ind]
            const dist = comb.join(state.join(nextState).join(combs)).toString()
            if (dist != "") next_dists.push(dist)
        }
        next_dists = next_dists.sort()
        if (next_dists.length != 0) {
            moved = parseInt(comb_dists.at(-1)) - parseInt(next_dists.at(-1))
        } else {
            moved = parseInt(comb_dists.at(-1)) + 1
        }
    }
    STATES.push({
        name: state.toString(),
        hc: comb_dists,
        turn: turn_order,
        move_by: moved
    })
    state = state.join(nextState);
} while (state.tuples()[0]);

let left = true
let row = 1
function appendState(st) {
    const section = document.createElement('section')
    section.style.backgroundColor = '#f6f6f6'
    section.style.margin = '1%'
    section.style.padding = '1%'
    section.style.borderRadius = '25'
    section.style.fontSize = '1em'
    if (left) {
        section.style.gridColumn = 1
        section.style.gridRow = row
    } else {
        section.style.gridColumn = 2
        section.style.gridRow = row
        row++
    }
    left = !left

    const title = document.createElement("p")
    if (st.move_by == -1) {
        title.innerHTML = st.name + ", " + st.turn[0] + " won"
    } else {
        title.innerHTML = st.name + ", " + st.turn[0] + " took " + st.move_by + " fruit"
    }

    const comb_dists = document.createElement("p")
    if (st.hc.length == 0) {
        comb_dists.innerHTML = "No honeycombs left."
    } else {
        comb_dists.innerHTML = "Honeycombs: " + st.hc.toString()
    }

    const turn = document.createElement("p")
    if (st.turn.length == 1) {
        turn.innerHTML = ""
    } else {
        turn.innerHTML = "Next up: " + st.turn.slice(1).toString()
    }

    section.appendChild(title)
    section.appendChild(comb_dists)
    section.appendChild(turn)
    wrapper.appendChild(section)
}

STATES.forEach( (st, i) => appendState(st) )

div.appendChild(wrapper)
