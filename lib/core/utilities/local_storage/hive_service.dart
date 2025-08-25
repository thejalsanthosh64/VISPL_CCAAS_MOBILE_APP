import 'package:hive_flutter/hive_flutter.dart';
import 'package:kommuno/features/leads/data/enum/lead_filter_enum.dart';
import 'package:kommuno/features/leads/data/model/request/leads_filter_request_model.dart';

part 'hive_keys_enum.dart';

class HiveService {
  static void initHive() {
    Hive
      ..initFlutter()
      ..registerAdapter(LeadsFilterRequestModelAdapter())
      ..registerAdapter(LeadFilterEnumAdapter());
  }

  static Future<Box> _openBox({required HiveKeysEnum hiveKeysEnum}) async {
    try {
      if (Hive.isBoxOpen(hiveKeysEnum.name)) {
        return Hive.box(hiveKeysEnum.name);
      } else {
        return await Hive.openBox(hiveKeysEnum.name);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> putData({
    required HiveKeysEnum hiveKeysEnum,
    required dynamic value,
  }) async {
    try {
      final box = await _openBox(hiveKeysEnum: hiveKeysEnum);
      await box.put("data", value);
      await box.close();
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> getData({required HiveKeysEnum hiveKeysEnum}) async {
    try {
      final box = await _openBox(hiveKeysEnum: hiveKeysEnum);
      final data = await box.get("data");
      await box.close();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> delete({required HiveKeysEnum hiveKeysEnum}) async {
    try {
      final box = await _openBox(hiveKeysEnum: hiveKeysEnum);
      await box.delete("data");
      await box.close();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteAll() async {
    try {
      await Future.forEach(HiveKeysEnum.values, (value) async {
        final box = await _openBox(hiveKeysEnum: value);
        await box.deleteFromDisk();
        await box.close();
      });
    } catch (e) {
      rethrow;
    }
  }
}
