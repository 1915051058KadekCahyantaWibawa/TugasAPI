import 'package:flutter/material.dart';
import 'Config.dart';
import 'package:http/http.dart' as http;

class CreateBlog extends StatefulWidget {
  final String title;
  CreateBlog({Key key, this.title}) : super(key: key);

  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  final isiController = TextEditingController();
  final judulController = TextEditingController();

  Future simpanBlog() async {
    Map<String, String> body = {
      'judul': judulController.text,
      'isi': isiController.text,
    };
    final response = await http.post(Uri.http(Config.apiUrl, '/'), body: body);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  List<Widget> formTambahBlog() {
    return <Widget>[
      Padding(
          child: TextField(
            controller: judulController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Judul'),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
      Padding(
          child: TextField(
            controller: isiController,
            decoration:
                InputDecoration(border: OutlineInputBorder(), hintText: 'Isi'),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
      Padding(
          child: ElevatedButton(
              onPressed: () {
                simpanBlog();
              },
              child: Text("Simpan")),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Tambah Blog")),
        body: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: formTambahBlog()),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    judulController.dispose();
    isiController.dispose();
    super.dispose();
  }
}
