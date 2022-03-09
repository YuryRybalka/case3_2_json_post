import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  if (response.statusCode == 200) {
    // если сервак вернул код 200 - грузите апельсины бочками, парсить джейсон

    return Post.fromJson(jsonDecode(response.body));
  } else {
    // а если не 200, то увы - швыряем исключение

    throw Exception('сорьки... ну ни шмагла я загрузить ваш Post(((');
  }
}


class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
    userId : json['userId'],
    id : json['id'],
    title : json['title'],
    body : json['body'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Вывод данных из формата JSON',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Вывод данных из формата JSON'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Center(
            child: FutureBuilder<Post>(
              future: futurePost,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Title:  ' +
                    snapshot.data!.title + '\n'+ '\n' +
                    'Body:  '+
                    snapshot.data!.body,
                    style :
                        const TextStyle(fontSize : 28,
                        color : Color(0xFFFF4500)
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // По умолчанию показать спиннер загрузки
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}