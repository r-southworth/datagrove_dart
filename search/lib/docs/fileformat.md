  
  Each segment is represented by one file for the header, then a series of files split on some maximum size (default of 10MB). Each file will have its own dictionaries, which means comparisons between blocks will need some conversion.


  header (
     root_of_tuples
     table[]  // there is a dictionary for each table.attribute.
  )
  // first attribute is unified key? then other attributes to allow better compression, or just compress them as one value?
  table {
    name
    attribute[]
  }
  attribute {
     name
     dictionary
  }
  
  we have one tuple list, sorted by table.primarykey
  for fast searching of the table we append counted b+tree style interior nodes. It can be searched by offset or key value.

  tuples need to be 

  Any secondary index is also treated as a table, it may use an integer to point to the base tuple, or it may cover the original data like a vertica partition.

The term table schema with pointers into raw data encoded as elias fano
 create table(term, termlist, partitionIndex, partitionStart, 
   countStart, positionStartStart )


  

 When we fork something like the core curriculum, it will share the same tagged snapshot as the model school. The first tagged build though will break this. Is this a problem? Does fixing it cause a bigger problem?

 