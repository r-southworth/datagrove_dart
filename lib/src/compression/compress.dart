// one for the entire tree? how do we sample
// not great to rely on gzip because of encryption in general
import 'dart:typed_data';

class HopeCompressor {
  Uint8List compress(Uint8List data) {
    return data;
  }

  Uint8List get dictionary => Uint8List(0);
  static HopeCompressor fromSample(List<Uint8List> sample) {
    return HopeCompressor();
  }
}

class FsstCompressor {
  Uint8List compress(Uint8List data) {
    return data;
  }

  Uint8List get dictionary => Uint8List(0);

  static FsstCompressor fromSample(List<Uint8List> sample) {
    return FsstCompressor();
  }
}
