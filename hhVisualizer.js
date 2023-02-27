const stage = new Stage()

// const theArray = instance.signature('Game').atoms()[0]
// const players = instance.signature('Player')
// const hcombs = instance.field('combs')

const state = new Grid({
    grid_location: {x: 50, y: 50},
    cell_size: {x_size: 100, y_size: 100},
    grid_dimensions: {x_size:4, y_size:1}
})

combs.tuples().forEach( (entry,idx) => {
    state.add({x: idx, y: 0}, 
        new TextBox(`Comb: ${entry.atoms()[2].__var__}`, {x:100, y:100},'black',16))
})

const playerLoc = new Grid({
    grid_location: {x: 50, y: 150},
    cell_size: {x_size: 100, y_size: 100},
    grid_dimensions: {x_size:4, y_size:1}
})

Player._subsignatures.forEach( (entry,idx) => {
    playerLoc.add({x: idx, y: 0}, 
        new TextBox(`${entry}`, {x:100, y:100},'black',16))
})

// stage.add(
//     new TextBox(`Combs at: ${theArray}`,
//     {x:100, y:100},'black',16)
// )
// stage.add(
//     new TextBox(`${theArray.join(elementsField)}`,
//     {x:200, y:200},'black',16)
// )
stage.add(state)
stage.add(playerLoc)

stage.render(svg, document)