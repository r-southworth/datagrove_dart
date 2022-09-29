typedef DocId = int;

class Db {
  int nextDocId = 0;

  DocId createId(String type) {
    return nextDocId++;
  }

  Tx begin() {
    return Tx(this);
  }
}

// docs have a url, they can offer deep links.
class DbDoc {
  Db db;
  DocId url;
  DbDoc(this.db, this.url);
}

class Tx {
  Db db;
  List<DocTx> doc = [];

  void add(DocTx tx) {
    doc.add(tx);
  }

  Tx(this.db);
  //
  void commit() {}
}

class DocTx {}

class DbStep {}
