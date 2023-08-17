import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'homepage.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Harita Görünümü",
            style: GoogleFonts.barlowCondensed(
                textStyle: const TextStyle(
                    fontSize: 35, fontWeight: FontWeight.w300))),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            icon: const Icon(CupertinoIcons.chevron_back)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(CupertinoIcons.question_diamond),
            onPressed: () {
              setState(() {
                Widget okButton = TextButton(
                  child: const Text("Tamam"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );
                AlertDialog alert = AlertDialog(
                  title: Text("Harita Görünümü Nedir?",
                      style: GoogleFonts.barlowCondensed(
                          textStyle: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w300))),
                  content: Text(
                    "Harita görünümü ile hava durumunu takip etmek için eklediğiniz şehirleri harita üzerinde görebilirsiniz.",
                    style: GoogleFonts.dmSans(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  actions: [
                    okButton,
                  ],
                );

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              });
            },
          )
        ],
      ),
    );
  }
}
