/**
 * File Model ini berfungsi untuk serialisasi response dari API
 */
class Blog {
  int id;
  String judul;
  String isi;
  Null createdAt;
  Null updatedAt;

  Blog({this.id, this.judul, this.isi, this.createdAt, this.updatedAt});

  Blog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    judul = json['judul'];
    isi = json['isi'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['judul'] = this.judul;
    data['isi'] = this.isi;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
