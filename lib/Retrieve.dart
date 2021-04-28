import 'dart:convert';
import 'package:flutter/material.dart';
import 'BlogsModel.dart';
import 'Config.dart';
import 'EditDelete.dart';
import 'package:http/http.dart' as http;
import 'Create.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<BlogsModel>> blogsData;

  @override
  // ignore: must_call_super
  void initState() {
    blogsData = getBlogs();
  }

  Future<List<BlogsModel>> getBlogs() async {
    final response = await http.get(Uri.http(Config.apiUrl, '/'));
    if (response.statusCode == 200) {
      print(response.body);
      return (jsonDecode(response.body) as List)
          .map((e) => BlogsModel.fromJson(e))
          .toList();
    } else {
      return List<BlogsModel>();
    }
  }

  // Widget Listview untuk menampilkan daftar blogs
  ListView blogListView(List<BlogsModel> data) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(data[index].judul),
            subtitle: Text(data[index].isi),
            leading: Icon(Icons.book, color: Colors.red),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditDelete(blog: data[index])),
              );
            },
          );
        },
        itemCount: data.length);
  }

  List<Widget> tombolMenu() {
    return <Widget>[
      // Tombol Refresh Data
      IconButton(
          icon: Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            setState(() {
              blogsData = getBlogs();
            });
          }),

      // Tombol Tambah
      IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateBlog()),
            );
          })
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: tombolMenu()),
      body: FutureBuilder<List<BlogsModel>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return blogListView(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("Terjadi kesalahan ${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
        future: blogsData,
      ),
    );
  }
}
