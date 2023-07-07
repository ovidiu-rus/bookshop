import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookshop',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Bookshop'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Set<int> _selectedIndices = {};
  List<dynamic> _selectedItems = [];

  Future<List<dynamic>> fetchBookstoreData() async {
    const url = "https://henri-potier.techx.fr/books";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData as List<dynamic>;
      } else {
        // handle errors in better way
        return [];
      }
    } catch (e) {
      // handle errors in better way
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(
            widget.title,
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CommercialOffers(selectedIsbns: _selectedItems.map((item) => item['isbn']).toList())));
                },
                child: const Text('Order')),
            FutureBuilder<List<dynamic>>(
              future: fetchBookstoreData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final jsonData = snapshot.data;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: jsonData?.length,
                    itemBuilder: (context, index) {
                      final item = jsonData?[index];
                      final bool checked = _selectedIndices.contains(index);
                      return ListTile(
                        title: Text(item['title']),
                        subtitle: Text('${item['price']}€'),
                        leading: Checkbox(
                          value: checked,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null && value) {
                                _selectedIndices.add(index);
                                _selectedItems.add(item);
                              } else {
                                _selectedIndices.remove(index);
                                _selectedItems.remove(item);
                              }
                            });
                          },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ));
  }
}

class CommercialOffers extends StatelessWidget {
  final List<dynamic> selectedIsbns;

  CommercialOffers({required this.selectedIsbns});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
