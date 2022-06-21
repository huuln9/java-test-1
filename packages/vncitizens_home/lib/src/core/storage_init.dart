import 'package:vncitizens_home/src/util/storage_util.dart';

Future<void> initSessionStorage() async {
  await StorageUtil.writeShowedUpdate(false);
}