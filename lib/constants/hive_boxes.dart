import 'package:hive/hive.dart';
import 'package:pchr/models/user/user.dart';

const String languageBoxName = 'pchrlanguageBox';
const String userBoxName = 'pchrUserBox';

late Box languageBox;
late Box userBox;

User get storedUser => userBox.getAt(0);
