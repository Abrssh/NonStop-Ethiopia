import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nonstop_ethiopia/Data/Models/musicFile.dart';

class DatabaseServ {
  final CollectionReference musicFileCollection =
      FirebaseFirestore.instance.collection("musicFile");

  List<MusicFile> _mapQuerySnapToMusicFile(QuerySnapshot querySnapshot) {
    // print("Query : " + querySnapshot.docs.toString());
    return querySnapshot.docs.map((e) {
      return MusicFile(name: e.get("fileName"), url: e.get("url"));
    }).toList();
  }

  Future<List<MusicFile>> returnMusicFiles() async {
    try {
      return musicFileCollection.get().then(_mapQuerySnapToMusicFile);
    } catch (e) {
      print("Error: " + e.toString());
      return [];
    }
  }
}
