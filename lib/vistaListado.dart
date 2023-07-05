import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:hola3/database/database.dart';


class vistaListado extends StatefulWidget {
  const vistaListado({super.key});

  @override
  State<vistaListado> createState() => _vistaListadoState();
}

class _vistaListadoState extends State<vistaListado> {
  @override
  Widget build(BuildContext context) {

    final database=AppDatabase(NativeDatabase.memory());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, icon:Icon(
          Icons.chevron_left_sharp,
        ),
        ),
        title: Text('Listado de Post'),
      ),

      body: FutureBuilder<List<PosteoData>>(
        future:database.getListado(),
        builder:(context, snapshot){
          if(snapshot.hasData){
            List<PosteoData>? postList=snapshot.data;
            return ListView.builder(
              itemCount: postList!.length,
                itemBuilder: (context, index){
                PosteoData postData=postList[index];
               /* return ListTile(
                  title:Text(postData.title),
                  subtitle: Text(postData.body),
                );*/
                  return Dismissible(
                    direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(Icons.delete_forever),
                      ),
                      key: (ValueKey<int>(postList[index].id)),
                      onDismissed: (DismissDirection direction) async{
                      await database.eliminarPost(postData.id);
                      setState(() {
                        postList.remove(postList[index]);
                      });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Container(
                            width: MediaQuery.of(context).size.width*1,

                            child: Row(
                              children: [
                               Container(
                                 width: MediaQuery.of(context).size.width*0.65,
                                 child:  Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text("ID: "+ postData.id.toString()),
                                       Text("TITLE: "+ postData.title),
                                       Text("BODY: "+ postData.body),

                                     ],
                                   ),
                                 ),
                               ),



                                ElevatedButton(
                                    onPressed: (){
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)
                                            )
                                          ),
                                          context: context,
                                          builder: (context)=>buildSheet(
                                            postData,database
                                          ));
                                    },
                                    child: Text('Modificar')),
                              ],



                            ),

                          ),


                          )
                        ),
                      );

                }
                );
          } else if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else{
            return Center(
              child: Text(''),
            );
          }
        }
      ),
    );
  }

   Widget buildSheet(PosteoData postData, AppDatabase database)=>
    Container(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
              ),
            Text('Codigo: ${postData.id}'),
            TextFormField(
              initialValue: '${postData.userId}',
              decoration: InputDecoration(
                border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
            ),
            SizedBox(
              height: 20,
              ),
            TextFormField(
              initialValue: '${postData.title}',
              decoration: InputDecoration(
                  border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: '${postData.body}',
              decoration: InputDecoration(
                  border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed:(){
                Navigator.pop(context);
              },
              child: Text('Editar registro')
            ),
          ],
        ),
      ),
    );
  
}
