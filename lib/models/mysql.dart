import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host='localhost',user='root',password='1234',db='chatapp';
  static int port=3308;
  Mysql();
  Future<MySqlConnection> getConnection() async
  {
    var setting = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db
    );
    return await MySqlConnection.connect(setting);
  }
}