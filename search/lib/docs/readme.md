
Every tuple store globally by table locally as well as by community



the rollup index is potentially kept as a prolly/c tree so that we can do reads over the packed segments. Is such a c tree deterministic such that we can write it to a log and use integer pointers?

note that rollup indices can eventually cross communities though it would be in some community and would update consistently.

the rollup is in segments
( key | count, cid, segment )

hyder chose to use binary tree because of immutability. ctree is an interesting tradeoff that rewrites one leaf, but not the parents as a cow btree would.

It's not clear how often we want to rewrite the rollup snapshots. We might have lightweight stale searches and heavyweight current searches.

can we supplement auto checkpointing with a manual checkpoint, e.g. monthly or daily update even if not enough. Flush. Potentially log this? it could mess up the numbering, might need another sequence?





posting {
    
}

fast fields are columns that are bitpacked. note that doc id is itself a fast field. so each cid, segment, fastfieldId -> packed integers.

stored fields are just tuples, so we need an 

class PackedInt {

}

create table ef(cid, segment, term, doclist int[], start int[], pos int[]) 

// all the keys in the segment, sorted and packed end to end.
// we should use btree style sorting? It's not clearly of value since
// the client must maintain a full keyset anyway?


create table segmentKeys( 
    cid, segment, startKey, 
)

create table position


api  getFast()