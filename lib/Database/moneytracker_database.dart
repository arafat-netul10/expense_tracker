// import 'package:expeense_tracker/Database/models/tasks.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart' as p;
//
// class MoneyTrackerDatabase {
//
//   static Database ? _dB;
//
//   static Future<Database> getdB() async {
//
//     if(_dB != null) return _dB!;
//
//     _dB = await openDatabase(
//       p.join(await getDatabasesPath(), 'Money.DB'),
//       onCreate: (dB, version){
//         dB.execute('CREATE TABLE Tasks iD INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, isDone INTEGER',);
//
//       },
//       version: 1,
//     );
//
//     return _dB!;
//   }
//
//
//   static Future<void> insertTask(Tasks tasks) async {
//     final dB = await getdB();
//     await dB.insert('Tasks', tasks.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//   }
//
//   static Future<List<Tasks>> getTask() async {
//     final dB = await getdB();
//     final List<Map<String, dynamic>> maps = await dB.query('Tasks');
//     return List.generate(maps.length, (i) => Tasks.formMap(maps[i]));
//   }
//
// }