import 'package:travel_suite/model/traveler_details/traveler_ratelistday.dart' show TravelerRatelistday;
import 'package:travel_suite/model/traveler_details/traveler_sightseeing.dart';

class TravelerApiResponse {
  final TravelerRatelistday rateListDay;
  final TravelerSightseeing sightseeing;
  final dynamic addon;

  TravelerApiResponse({
    required this.rateListDay,
    required this.sightseeing,
    this.addon,
  });

  factory TravelerApiResponse.fromJson(Map<String, dynamic> json) {
    return TravelerApiResponse(
      rateListDay: TravelerRatelistday.fromJson(json['ratelist_day']),
      sightseeing: TravelerSightseeing.fromJson(json['sightseeing']),
      addon: json['addon'],
    );
  }
}