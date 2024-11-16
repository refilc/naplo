class CloudSyncData {
  Map settings;
  List<String> deviceIds;
  String reFilcPlusId;
  Map json;

  CloudSyncData({
    this.settings = const {},
    this.deviceIds = const [],
    this.reFilcPlusId = "",
    required this.json,
  });

  factory CloudSyncData.fromJson(Map json) {
    return CloudSyncData(
      settings: json['settings'] ?? {},
      deviceIds: List<String>.from(json['device_ids'] ?? []),
      reFilcPlusId: json['refilc_plus_id'] ?? "",
      json: json,
    );
  }
}
