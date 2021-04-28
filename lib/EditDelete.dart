import 'package:flutter/material.dart';
import 'BlogsModel.dart';
import 'package:http/http.dart' as http;
import 'Config.dart';

class EditDelete extends StatefulWidget {
  final BlogsModel blog;
  EditDelete({Key key, @required this.blog}) : super(key: key);

  @override
  _EditDeleteState createState() => _EditDeleteState();
}

class _EditDeleteState extends State<EditDelete> {
  final isiController = TextEditingController();
  final judulController = TextEditingController();


  @override
  // ignore: must_call_super
  void initState() {
    judulController.text = widget.blog.judul;
    isiController.text = widget.blog.isi;
  }

  Future updateBlog() async {
    Map<String, String> body = {
      'judul': judulController.text,
      'isi': isiController.text,
    };
    final response =
        await http.patch(Uri.http(Config.apiUrl, "/${widget.blog.id}"), body: body);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  Future deleteBlog() async {
    final response = await http.delete(Uri.http(Config.apiUrl, "/${widget.blog.id}"));
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  List<Widget> formEditBlog() {
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
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    updateBlog();
                  },
                  child: Text('Update')),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Blog"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  deleteBlog();
                })
          ],
        ),
        body: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: formEditBlog()),
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
