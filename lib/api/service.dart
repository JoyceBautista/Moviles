import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hola3/api/post.dart';

class Service{

  static Future<Post> fetchPost() async{
    final response= await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"));
    if(response.statusCode==200)
      return Post.fromJson(json.decode(response.body));
    else
      throw Exception('Error en servicio');
  }



  static Future<Post> queryPost(String id) async{
    final response= await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/${id}"));
    if(response.statusCode==200)
      return Post.fromJson(json.decode(response.body));
    else
      throw Exception('Error en servicio');
  }
}
