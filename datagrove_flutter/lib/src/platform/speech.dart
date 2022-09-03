import 'dart:math';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Speech {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String? _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  // crash on mac?
  final SpeechToText speech = SpeechToText();

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true,
        onDevice: true,
        listenMode: ListenMode.confirmation);
  }

  void stopListening() {
    speech.stop();
    level = 0.0;
  }

  void cancelListening() {
    speech.cancel();
    level = 0.0;
  }

  void resultListener(SpeechRecognitionResult result) {
    lastWords = "${result.recognizedWords} - ${result.finalResult}";
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");

    this.level = level;
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");

    lastError = "${error.errorMsg} - ${error.permanent}";
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");

    lastStatus = "$status";
  }

  _switchLang(selectedVal) {
    {
      _currentLocaleId = selectedVal;

      print(selectedVal);
    }
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale?.localeId;
    }
    _hasSpeech = hasSpeech;
  }
}
