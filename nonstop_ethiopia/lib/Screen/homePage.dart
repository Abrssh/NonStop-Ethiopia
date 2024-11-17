import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nonstop_ethiopia/Provider/counter_provider.dart';
import 'package:nonstop_ethiopia/Data/Firebase/databaseServ.dart';
import 'package:nonstop_ethiopia/Util/loading.dart';
import 'package:nonstop_ethiopia/Data/Models/musicFileUi.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loaded = false;
  AudioPlayer? player;
  int positionInSecond = 0, bufferInSecond = 0;

  List<MusicFileUi> musicFileUis = [];

  Future<Duration?> audioFunction(String url) async {
    player = AudioPlayer();
    final duration = await player?.setUrl(url);
    return duration;
  }

  @override
  void initState() {
    DatabaseServ().returnMusicFiles().then((value) {
      for (var element in value) {
        musicFileUis.add(new MusicFileUi(
            name: element.name,
            url: element.url,
            allowed: false,
            firstTime: false,
            bufferInSecond: 0,
            positionInSecond: 0));
      }
      setState(() {
        loaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var deviceWidth = deviceSize.width;
    var deviceHeight = deviceSize.height;

    Future<bool> _onBackPressed() {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "In Order to Quit Swipe Off the App.",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(fontSize: deviceWidth * 0.07),
                    )),
              ],
            );
          }).then((value) => true);
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title +
              " " +
              context.watch<FirstProvider>().firstProvValAcc.toString()),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<FirstProvider>().increment();
                  context.push("/secondPage");
                },
                icon: Icon(Icons.ac_unit))
          ],
          leading: Row(),
        ),
        body: loaded
            ? Container(
                height: deviceHeight * 0.88,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Text("Name: " + musicFileUis[index].name),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      musicFileUis[index].allowed
                                          ? Text(
                                              'Duration: ' +
                                                  musicFileUis[index]
                                                      .positionInSecond
                                                      .toString() +
                                                  "  /  " +
                                                  musicFileUis[index]
                                                      .bufferInSecond
                                                      .toString() +
                                                  "  /  " +
                                                  musicFileUis[index]
                                                      .duration!
                                                      .inSeconds
                                                      .toString(),
                                            )
                                          : !musicFileUis[index].firstTime
                                              ? Text("Ready")
                                              : Text(
                                                  'Loading...',
                                                ),
                                      IconButton(
                                          onPressed: () {
                                            if (player!.playing &&
                                                musicFileUis[index]
                                                            .positionInSecond -
                                                        10 >
                                                    0) {
                                              player?.seek(Duration(
                                                  seconds: musicFileUis[index]
                                                          .positionInSecond -
                                                      10));
                                            }
                                          },
                                          icon: Icon(Icons.fast_rewind)),
                                      IconButton(
                                        icon: musicFileUis[index].allowed
                                            ? player!.playing
                                                ? Icon(Icons.pause)
                                                : Icon(Icons.play_arrow)
                                            : Icon(Icons.play_arrow_sharp),
                                        onPressed: () {
                                          if (!musicFileUis[index].firstTime) {
                                            if (player != null) {
                                              if (player!.playing) {
                                                player?.pause();
                                              }
                                            }
                                            for (var element in musicFileUis) {
                                              if (element.url !=
                                                  musicFileUis[index].url) {
                                                element.allowed = false;
                                                element.firstTime = false;
                                                element.positionInSecond = 0;
                                                element.bufferInSecond = 0;
                                              }
                                            }
                                            audioFunction(
                                                    musicFileUis[index].url)
                                                .then((value) {
                                              setState(() {
                                                musicFileUis[index].allowed =
                                                    true;
                                                musicFileUis[index].duration =
                                                    value!;
                                              });
                                              player?.positionStream
                                                  .listen((event) {
                                                // print("Position Val: " + event.inSeconds.toString());
                                                setState(() {
                                                  musicFileUis[index]
                                                          .positionInSecond =
                                                      event.inSeconds;
                                                });
                                              });
                                              player?.bufferedPositionStream
                                                  .listen((event) {
                                                // print("Buffer Val: " + event.inSeconds.toString());
                                                setState(() {
                                                  musicFileUis[index]
                                                          .bufferInSecond =
                                                      event.inSeconds;
                                                });
                                              });
                                            });
                                            setState(() {
                                              musicFileUis[index].firstTime =
                                                  true;
                                            });
                                          } else if (musicFileUis[index]
                                              .allowed) {
                                            if (player!.playing) {
                                              player?.pause();
                                            } else {
                                              player!.play();
                                            }
                                          }
                                        },
                                        color: Colors.black,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            if (player!.playing &&
                                                musicFileUis[index]
                                                            .positionInSecond +
                                                        10 <
                                                    musicFileUis[index]
                                                        .duration!
                                                        .inSeconds) {
                                              player!.seek(Duration(
                                                  seconds: musicFileUis[index]
                                                          .positionInSecond +
                                                      10));
                                            }
                                          },
                                          icon: Icon(Icons.fast_forward)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      itemCount: musicFileUis.length,
                    ))
                  ],
                ),
              )
            : Center(
                child: Loading(),
              ),
      ),
    );
  }
}
