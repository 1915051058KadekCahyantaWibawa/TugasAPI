/**
 * Halaman untuk melakuakn edit data blog dan menghapus data blog
 */
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
  // Input text controller untuk siklus hidup text input judul dan isi
  final isiController = TextEditingController();
  final judulController = TextEditingController();


  @override
  // ignore: must_call_super
  void initState() {
    judulController.text = widget.blog.judul;
    isiController.text = widget.blog.isi;
  }

  /**
   * Method untuk melakukan HTTP request PATCH ke REST API untuk mengupdate data blog
   * yang dipilih oleh user
   */
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

  /**
   * Method untuk melakukan HTTP request DELETE ke REST API untuk mengupdate data blog
   * yang dipilih oleh user
   */
  Future deleteBlog() async {
    final response = await http.delete(Uri.http(Config.apiUrl, "/${widget.blog.id}"));
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }


  // Modul Widget untuk form input yang terdiri dari input field
  // judul, isi dan tombol Update
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
                    updateBlog(); // Ketika tombol update ditekan, update data dengan updateBlog()
                  },
                  child: Text('Update')),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4))
    ];
  }

  /**
   * Program utama dari screen Edit/Delee
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Blog"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  deleteBlog(); // Ketika tombol delete ditekan, panggil method deleteBlog untuk menghapus data
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
