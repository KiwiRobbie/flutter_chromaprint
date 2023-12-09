library flutter_chromaprint;

import 'dart:ffi';
import 'dart:io';
import "package:ffi/ffi.dart";
import 'package:flutter_chromaprint/chromaprint_native.g.dart';

import 'package:flutter_coast_audio_miniaudio/flutter_coast_audio_miniaudio.dart';

class FingerprintResultStatus {
  final Duration elapsed;
  final Duration duration;
  final double rate;

  FingerprintResultStatus(
      {required this.elapsed, required this.duration, required this.rate});
}

sealed class FingerprintingResult {}

class FingerprintingResultOk extends FingerprintingResult {
  (int, String) get acoustidItem => (length, fingerprint);

  final File file;
  final String fingerprint;
  final int length;
  final FingerprintResultStatus status;

  FingerprintingResultOk(this.file, this.fingerprint, this.length, this.status);
}

class FingerprintingResultErr extends FingerprintingResult {
  final File file;
  FingerprintingResultErr(this.file);
}

class ChromaprintApi {
  NativeLibrary nativeLibrary =
      NativeLibrary(DynamicLibrary.open('libchromaprint.so'));
  late Pointer<ChromaprintContextPrivate> _context;
  ChromaprintApi() {
    int algorithm = ChromaprintAlgorithm.CHROMAPRINT_ALGORITHM_DEFAULT;
    _context = nativeLibrary.chromaprint_new(algorithm);
  }

  String getVersion() {
    return nativeLibrary.chromaprint_get_version().cast<Utf8>().toDartString();
  }

  FingerprintingResult processFile(File file) {
    final startTime = DateTime.now();

    const audioFormat = AudioFormat(
        sampleRate: 44100, channels: 2, sampleFormat: SampleFormat.int16);
    final dataSource = AudioFileDataSource(file: file, mode: FileMode.read);

    final decoder = MabAudioDecoder(
        dataSource: dataSource,
        outputFormat: audioFormat,
        encodingFormat: MabEncodingFormat.mp3);

    int length = 0;

    int res = 0;
    res = nativeLibrary.chromaprint_start(
        _context, audioFormat.sampleRate, audioFormat.channels);
    if (res != 1) {
      return FingerprintingResultErr(file);
    }

    final frames = AllocatedAudioFrames(length: 8192 * 32, format: audioFormat);
    final buffer = frames.lock();
    while (true) {
      final result = decoder.decode(destination: buffer);
      if (result.isEnd) {
        break;
      }
      final readBuffer = buffer.limit(result.frames);
      res = nativeLibrary.chromaprint_feed(
          _context,
          readBuffer.pBuffer.cast<Int16>(),
          audioFormat.channels * result.frames);
      if (res != 1) {
        return FingerprintingResultErr(file);
      }
      length += result.frames;
      // if (length / (audioFormat.sampleRate) > 120.0) {
      //   break;
      // }
    }
    frames.unlock();
    frames.dispose();
    decoder.dispose();
    dataSource.dispose();

    res = nativeLibrary.chromaprint_finish(_context);
    if (res != 1) {
      return FingerprintingResultErr(file);
    }
    Pointer<Pointer<Char>> fp = malloc.allocate(0);

    res = nativeLibrary.chromaprint_get_fingerprint(_context, fp);
    if (res != 1) {
      return FingerprintingResultErr(file);
    }
    String result = (fp.value.cast<Utf8>().toDartString());
    nativeLibrary.chromaprint_dealloc(fp.cast());
    // print(
    //     "https://api.acoustid.org/v2/lookup?client=ublXEetqEAo&duration=81&fingerprint=$result");
    final endTime = DateTime.now();
    final ellapsed = endTime.difference(startTime);
    final duration =
        Duration(milliseconds: 1000 * length ~/ (audioFormat.sampleRate));
    final double rate = duration.inMilliseconds / ellapsed.inMilliseconds;

    return FingerprintingResultOk(
        file,
        result,
        (length / (audioFormat.sampleRate)).floor(),
        FingerprintResultStatus(
            elapsed: ellapsed, duration: duration, rate: rate));
  }
}
