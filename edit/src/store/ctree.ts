

import { decode } from 'cbor-x'

// return the new location 
export class PositionMap {
    // returns the next position in bias direction if deleted, and returns a boolean that it was deleted.
    map(old: number, bias = 1): [number, boolean] {
        return [old, true]
    }

    constructor(insert: number[], del: number[]) {

    }
}
export interface Comparable {
    compare(c: Comparable): number
}

// these are pushed from the server.
export class Delta<T extends Comparable>{
    opnumber = 0
    data: T[] = []
    op = new Int8Array(0)  // insert, delete, insertHead, replace
    childCount: number[] = []
}

// a common edge case is a single segment of indeterminate length
// in this case, how do we set the length of the items?
// we want to set the length as 

// represents an array where we know length, but we retrieve items
// lazily. We can
interface Query<T extends Comparable> {
    // key here will come from segment or empty
    fetch(key: Uint8Array): Promise<Uint8Array>
    fetchSegment(ch: bigint, tb: bigint, key: Uint8Array, level: number): Promise<Uint8Array>
    // deltas are shared with all queries on the channel
    // the view can call this onidle, but 
    observeDelta(fn: (delta: Delta<T>) => void): void
    // we could potentially add a "split" api that would let us resegment large segments
    // one at time. For example we might split a segment at some random key, get the count
    // of the two pieces of that now, they will add up to the previous segment as kept from
    // the log. we can't do that efficiently with badger though?

}
export async function query<T extends Comparable>(sql: string): Promise<Query<T> | string> {
    return "error"
}

class FetchSegmentReply {
    opnumber = 0
    segment = new Uint8Array
    key: Uint8Array[] = []
    level = 0
    count = 0
}


class Segment<T> {
    key: Uint8Array[] = []
    count: number[] | undefined   // empty if a leaf
    child: (Segment<T> | T | undefined)[] = []
}


function keyLevel(key: Uint8Array): number {
    return 0
}

interface TreeView {
    remap(pm: PositionMap): void
}
// can I use Ctree for items_ in the scroller?
// tricky part is height above the slice; we might know it, we might not.
// ranges of the height can be estimates
export class ScrollTree<T extends Comparable> {
    // this is going to go to max when we get an indetermine segment
    // we'll need a way to make the last segment determinate.
    // 
    length_ = 0
    listener = new Set<TreeView>()
    filling = 0  // count of filling segments, when 0, we clear the log.
    fillingLog = Array<Delta<T>>()
    root = new Segment<T>()

    constructor(public query: Query<T>) { }
    get length() {
        return this.length_
    }
    listen(s: TreeView) {
        this.listener.add(s)
    }
    unlisten(s: TreeView) {
        this.listener.delete(s)
    }

    // return segment and offset of index
    // if the segment is not in memory then return null, len(missing)
    // missing segments triggers asynchronous fill
    // find a segment when the next segment is missing also triggers a fill
    findIndex(index: number): [Segment<T>, number] {
        let lv = this.root
        let begin = 0
        let segend = 0
        this.fill_(begin, segend)

        return [lv, 0]
    }

    // this will could cross multiple segments, and could require recursively
    // filling higher levels to find the starting point for server request.
    async fill_(begin: number, end: number) {
        // count = Math.min(count, seg.length) - seg.child.length
        // if (count <= 0) return

        // let d: FetchSegmentReply
        // let seg = this.findSegment(d.segment)

        // push the data into the segment and 

        //this.filling.delete(seg)
        if (--this.filling == 0) {
            this.fillingLog.length = 0
        }
    }


    onchangeCapture(message: Uint8Array) {

        // the trickiest edge case is reducing the number of levels
        // not clearly worth it; the server might not delete any keys.
        // if we delete a head key then the count needs to be added to the previous key.
        const find = (key: Uint8Array): [Segment<T>, number] => {
            const gt = (a: Uint8Array, b: Uint8Array) => true
            // we can use level as a cutoff, but its not strictly necessary.
            // we could also stash the level in the last byte of the key
            // so we didn't need to recompute it?

            // on each level starting from top we
            let lv = this.root
            let count = 0
            let i = 0
            do {
                i = 0
                while (true) {
                    if (i + 1 == lv.key.length || gt(lv.key[i], key)) {
                        break
                    }
                    i++
                    count += lv.count ? lv.count[i] : 1
                }

            } while (lv.count)
            return [lv, i]
        }
        const insert = (key: Uint8Array, val: T) => {
            this.length_++
        }
        // server needs to send the count because this might not be filled.
        // 
        const insertHead = (key: Uint8Array, val: T, count: number) => {
            this.length_++
            let level = keyLevel(key)
            let [seg, i] = find(key)

        }
        const remove = (key: Uint8Array) => {
            this.length_--
            let level = keyLevel(key)
            let [seg, i] = find(key)
            // this will be a leaf
            // we also need to update the counts in the tree above, and if this is a head
            // key we need to delete the head key. if deleting the head key creates a root layer
            // with just one entry (0), then make this one entry the root, shrinking the height by 1
            seg.child.splice(i, 1)
            if (level > 0) {
                //
            }
        }

        let d = decode(message) as Delta<T>
        // if a fill is in progress keep the delta
        if (this.filling > 0) {
            this.fillingLog.push(d)
        }

        // update the segment tree
        // if a segment is filled 
        for (let i = 0; i < d.data.length; i++) {
            let dv = d.data[i]
            let op = d.op[i]

            // find the seg


        }
        // update the segment tree, update the data,
        for (let i = 0; i < d.data.length; i++) {
            let dv = d.data[i]
            let op = d.op[i]

            // find the seg


        }

        // better to use ranges?
        let ins: number[] = []
        let del: number[] = []
        let pm = new PositionMap(ins, del)

        // can I convert deltaT into kis? could I send it that way?
        // sort the keys, leap merge with the existing array to find the index (or use fork-join)
        // now we should have a delta tree, that given an index, tells us what is the position
        // in the new array, like a prosemirror position map. 

        for (let v of this.listener) {
            v.remap(pm)
        }

    }



}
