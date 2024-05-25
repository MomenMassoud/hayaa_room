class DeviceInfo {
  // final String deviceIMEI;
  final String id;
  final String deviceName;
  final String devicePlatform;
  final String platformVersion;
  final String appVersion;
  final bool isPhysicaleDevice;

  DeviceInfo({
    // required this.deviceIMEI,
    required this.id,
    required this.deviceName,
    required this.devicePlatform,
    required this.platformVersion,
    required this.appVersion,
    required this.isPhysicaleDevice,
  });
}
