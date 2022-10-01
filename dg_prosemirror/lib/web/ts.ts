

// is it enough to give every cell a uuid? then when remapping we can still easily find the results.

// each cell gets a number based on when it is allocated.
// a grid step copies chunks 

class Sequence {
    nextCell: number
    id: number[]

    apply(x: SequenceStep){
        
    }
}

class SequenceStep {
    insert: number[]
    remove: number[]
    count: number[]
}
class Grid {
    localCell: number // negative numbers for local cells.

    applyStep(g: GridStep) {

    }
}
interface GridStep {
    width,height: number
    x : number[]
    y : number[] 

    dispatch: {x,y: number}[]
    dispatchData: PmStep[]
}

interface Step {
    begin,end: number // everything <begin and >= end is tombstone
    anchor: number
    anchorOffset: number

    cell: CellStep[]
}

interface CellStep {
    Path: string
    Steps: PmStep[]
}

interface PmStep{

}

interface Notify {
    Version: number
    Scroll: Offset
    Path: string  // uuid identifying the document mapped to the cell.
    Step: any // prosemirror step
    Selection: Selection[]
}

// Codemirror has a more complex selection model
interface Selection {
    left,top,right,bottom

}
interface Offset {
    x,y: number
}

interface MeasureRow {
    height: number

}