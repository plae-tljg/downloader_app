
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import '../../models/anime.dart';
import 'dart:convert';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<String> names = [];
  bool isLoading = true;
  String fetchedHtml = '';

  @override
  void initState() {
    super.initState();
    _fetchNames();
  }

  // Future<void> _fetchNames() async {
  Future<List<Anime>> _fetchNames() async {    
    final response = await http.get(Uri.parse('https://anime1.me'));

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);

      final animeList = document.querySelectorAll('ul')[1].querySelectorAll('li');

      final animes = animeList.map((element) {
      final animeName = element.querySelector('a')?.text.trim();
      final animeUrl = element.querySelector('a')?.attributes['href'];
      return Anime(name: animeName ?? '', url: animeUrl ?? '');
    }).toList();

      return animes;  
      // Save the fetched HTML to display it
      // setState(() {
      //   fetchedHtml = response.body;
      // });

      // Use the correct selector for the elements you want to extract
      // final nameElements = document.querySelectorAll('main section ul li');

      // // Print the extracted elements to debug
      // nameElements.forEach((element) => print(element.text));

      // setState(() {
      //   names = nameElements.map((element) => element.text.trim()).toList();
      //   isLoading = false;
      // });
    } else {
      throw Exception('Failed to load webpage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Names List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fetched HTML:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SelectableText(fetchedHtml),
                  SizedBox(height: 20),
                  Text(
                    'Names List:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(names[index]),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}