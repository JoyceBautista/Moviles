import 'package:drift/native.dart';
import 'package:drift/drift.dart' as dr;
import 'package:hola3/vistaListado.dart';
import 'package:flutter/material.dart';
import 'package:hola3/api/post.dart';
import 'package:hola3/api/service.dart';
import 'package:hola3/database/database.dart';

class vistaPrincipal extends StatefulWidget {
  const vistaPrincipal({super.key});

  @override
  State<vistaPrincipal> createState() => _vistaPrincipalState();
}

class _vistaPrincipalState extends State<vistaPrincipal> {

  final TextEditingController txtId=TextEditingController();
  late Future<Post> _futurePost;


  @override
  void initState() {
    super.initState();
    _futurePost=Service.fetchPost();
  }

  @override
  Widget build(BuildContext context) {

    final database=AppDatabase(NativeDatabase.memory());


    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Post'),
      ),
      body: Container(
        child:FutureBuilder<Post>(
          future: _futurePost,
          builder: (context,snapshot){
            if(snapshot.hasData){
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: txtId,
                      decoration: InputDecoration(
                        border:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Ingrese ID',
                      ),
                    ),

                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(onPressed: (){
                          setState(() {
                            _futurePost=Service.queryPost(txtId.text);
                          });
                        },
                            child: Text('Realizar Consulta')),
                      ),
                    ),


                    Text("ID: " + snapshot.data!.id.toString()),
                    Text("TITLE: " + snapshot.data!.title.toString()),
                    Text("BODY: " + snapshot.data!.body.toString()),

                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                            onPressed: (){
                              database.insertPost(
                                  PosteoCompanion(
                                    id:dr.Value(snapshot.data!.id),
                                    userId:dr.Value(snapshot.data!.userId),
                                    title:dr.Value(snapshot.data!.title),
                                    body:dr.Value(snapshot.data!.body),

                                  )
                              ).then((value){
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>vistaListado()));
                              });


                            },
                            child: Text('Grabar en Drift')),
                      )
                    )

                  ],
                ),
              );
            } else if(snapshot.hasError){
              return Text("${snapshot.error}");
            } else{
              return Text("");
            }

          },
        ),
      ),
    );
  }
}
