class MusicFileUi {
  final String name, url;
  bool firstTime, allowed;
  Duration? duration;
  int positionInSecond, bufferInSecond;
  MusicFileUi(
      {required this.name,
      required this.url,
      required this.firstTime,
      required this.allowed,
      this.duration,
      required this.positionInSecond,
      required this.bufferInSecond});
}
