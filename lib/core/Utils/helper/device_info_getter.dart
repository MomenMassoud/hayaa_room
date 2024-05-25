import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
//import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../../features/auth/models/device_info.dart';

class DeviceInfoGetters {
  // static Future<String?> getIpAdress() async {
  //   try {
  //     final url = Uri.parse('https://api.ipify.org');
  //     Response response;
  //     response = http.get(url) as Response;
  //     log(response.data);
  //     return response.statusCode == 200 ? response.data : null;
  //   } catch (e) {
  //     throw Exception("can,t get ip adress");
  //   }
  // }

  static Future<DeviceInfo> basicDeviceInfo() async {
    try {
      // String imeiNumber = await DeviceInformation.deviceIMEINumber;
      late String id;
      late String deviceName;
      late String platformVersion;
      late bool isPhysicaleDevice;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appVersion = packageInfo.version;
      if (Platform.isAndroid) {
        final info = await DeviceInfoPlugin().androidInfo;
        deviceName = "${info.manufacturer}-${info.model}".trim();
        platformVersion = info.version.release;
        id = info.id;
        isPhysicaleDevice = info.isPhysicalDevice;
      } else if (Platform.isIOS) {
        final info = await DeviceInfoPlugin().iosInfo;
        deviceName = "${info.name}-${info.model}".trim();
        id = info.identifierForVendor ?? "";
        platformVersion = info.systemVersion;
        isPhysicaleDevice = info.isPhysicalDevice;
      }
      log("//////////////////////////////");
      // log("deviceIMEI:$imeiNumber");
      log("id:$id");
      log("deviceName:$deviceName");
      log("devicePlatform:${Platform.operatingSystem}");
      log("platformVersion:$platformVersion");
      log("appVersion:$appVersion");
      log("isPhysicaleDevice:$isPhysicaleDevice");
      log("//////////////////////////////");

      return DeviceInfo(
        // deviceIMEI: imeiNumber,
        id: id,
        deviceName: deviceName,
        devicePlatform: Platform.operatingSystem,
        platformVersion: platformVersion,
        appVersion: appVersion,
        isPhysicaleDevice: isPhysicaleDevice,
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
