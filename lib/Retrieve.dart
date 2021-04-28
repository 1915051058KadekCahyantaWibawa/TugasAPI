/**
 * Halaman utama dari aplikasi yang menampilkan list blog
 */
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
  // variable untuk menampung list data blog yang bertipe Future->List->BlogsModel
  Future<List<BlogsModel>> blogsData;

  @override
  // ignore: must_call_super
  void initState() {
    blogsData = getBlogs(); // Inisiasi variabel blogsData ketika initState
  }


  /**
   * Method untuk melakukan HTTP Request GET untuk mendapatkan daftar list blog dari REST API
   * response diserialisasi dengan BlogModel
   */
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
                    // Ketika salah satu item ListView ditap (disklik) tampilkan halaman EditDelete.dart
                    // passing parameter blog untuk mengirim data ke halaman EditDelete.dart
                    // agar digunakan saat melakukan edit data pada input textfield
                    builder: (context) => EditDelete(blog: data[index])),
                    
              );
            },
          );
        },
        itemCount: data.length);
  }

  // App bar dari halaman Retrieve yang berisikan tombol Tambah dan Refresh data
  List<Widget> tombolMenu() {
    return <Widget>[
      // Tombol Refresh Data
      IconButton(
          icon: Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            setState(() {
              // Get data ulang ketika tombol refresh diklik
              blogsData = getBlogs();

            });
          }),

      // Tombol Tambah
      IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            // Buka halaman CreateBlog.dar apabila tombol tambah diklik
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateBlog()),
            );
          })
    ];
  }

  /**
   * Bagian utama dari screen retrieve, yang terdiri dari appbar dan body.
   * body dibungkus dengan FutureBuilder karena saat diinisiasi Melakuka
   * request ke REST API secara async,
   */
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
