import 'package:flutter/material.dart';

import '../components/api_service.dart';
import '../components/weather_model.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

//final weatherTest = weatherTestFromJson(jsonString);

class _TestState extends State<Test> {
  late WeatherTest? _userModel;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _userModel = (await ApiService().getWeatherForTargetCoord());
  }

//şuan bizim için önemli olan yukarıdaki fonksiyonun ve model sınıfının çalışıp çalışmadığı
  @override
  Widget build(BuildContext context) {
    debugPrint("Build içerisinde çalışan kısım: ${_userModel!.elevation}");
    return Container();
  }
}


// Scaffold(
//       appBar: AppBar(
//         title: const Text('REST API Example'),
//       ),
//       body: _userModel == null 
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : ListView.builder(
//               itemCount: _userModel!.daily!.temperature2MMax!.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text(_userModel!.daily!.temperature2MMax![index].timezone!),
//                           Text(_userModel![index]
//                               .daily!
//                               .temperature2MMax
//                               .toString()),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 20.0,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text(_userModel![index].latitude.toString()),
//                           Text(_userModel![index].longitude.toString()),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );