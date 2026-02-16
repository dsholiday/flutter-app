class SightseeingDetailModel {
 final int id;
  final String name;
  final String city;
  final String country;
  final String slug;
  final int finalRate;
  final int ratelistdayId;

  SightseeingDetailModel({
     required this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.slug,
    required this.finalRate,
    required this.ratelistdayId,
  });

  factory SightseeingDetailModel.fromJson(Map<String, dynamic> json) {
    return SightseeingDetailModel(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      country: json['country'],
      slug: json['slug'],
      finalRate: json['final_rate'],
      ratelistdayId: json['ratelistday_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
        'name': name,
        'city': city,
        'country': country,
        'slug': slug,
        'final_rate': finalRate,
        'ratelistday_id': ratelistdayId,
    };
  }
}

class SightseeingDetailResponse {
  final SightseeingDetailModel sightseeingDetail;
  final List<dynamic> addons;

  SightseeingDetailResponse({required this.sightseeingDetail, required this.addons});

  factory SightseeingDetailResponse.fromJson(Map<String, dynamic> json) {
    return SightseeingDetailResponse(
      sightseeingDetail: SightseeingDetailModel.fromJson(json['sightseeing']),
      addons: json['addons'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'sightseeing': sightseeingDetail.toJson(),
        'addons': addons,
      };
}