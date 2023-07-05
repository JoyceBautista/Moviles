import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
part 'database.g.dart';


class Posteo extends Table{
  IntColumn get id=>integer().named('id')();
  IntColumn get userId=>integer().named('userId')();
  TextColumn get title=>text().named('title')();
  TextColumn get body=>text().named('body')();
}

LazyDatabase abrirConexion(){
  return LazyDatabase(() async{
    final dbFolder=await getApplicationDocumentsDirectory();
    final file=File(p.join(dbFolder.path,'dbPost.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables:[Posteo])
class AppDatabase extends _$AppDatabase{
  AppDatabase(NativeDatabase nativeDatabase):super(abrirConexion());
  @override
  int get schemaVersion=>1;

  Future<int> insertPost(PosteoCompanion posteoCompanion) async {
    return await into(posteo).insert(posteoCompanion);
  }
  Future<List<PosteoData>> getListado() async{
    return await select(posteo).get();
  }

  Future<int> eliminarPost(int id) async{
    return await (delete(posteo)..where((tbl) => tbl.id.equals(id))).go();
  }
}