class TravelerRatelistday {
  final int id;
  final int day;
  final String dayName;
  final String dayType;
  final double rate;
  final int rateListId;
  final int supplierId;
  final int sightseeingId;
  final int isAddon;
  final int parentSightseeingId;
  final int year;
  final int month;

  TravelerRatelistday({
    required this.id,
    required this.day,
    required this.dayName,
    required this.dayType,
    required this.rate,
    required this.rateListId,
    required this.supplierId,
    required this.sightseeingId,
    required this.isAddon,
    required this.parentSightseeingId,
    required this.year,
    required this.month,
  });

  factory TravelerRatelistday.fromJson(Map<String, dynamic> json) {
    return TravelerRatelistday(
      id: json['id'],
      day: json['day'],
      dayName: json['day_name'] ?? '',
      dayType: json['day_type'],
      rate: (json['rate'] as num).toDouble(),
      rateListId: json['rate_list_id'],
      supplierId: json['supplier_id'],
      sightseeingId: json['sightseeing_id'],
      isAddon: json['is_addon'],
      parentSightseeingId: json['parent_sightseeing_id'],
      year: json['year'],
      month: json['month'],
    );
  }
}