class TravelerSightseeing {
  final int id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final String location;
  final String country;
  final String city;
  final String shortUrl;
  final String seoFriendlyUrl;
  final String slug;
  final String masterImage;
  final String openingTime;
  final String closingTime;
  final String weeklyOffDay;
  final int isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double finalRate;

  TravelerSightseeing({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.location,
    required this.country,
    required this.city,
    required this.shortUrl,
    required this.seoFriendlyUrl,
    required this.slug,
    required this.masterImage,
    required this.openingTime,
    required this.closingTime,
    required this.weeklyOffDay,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.finalRate,
  });

  factory TravelerSightseeing.fromJson(Map<String, dynamic> json) {
    return TravelerSightseeing(
      id: json['id'],
      name: json['name'],
      shortDescription: json['short_description'],
      longDescription: json['long_description'],
      location: json['location'],
      country: json['country'],
      city: json['city'],
      shortUrl: json['short_url'],
      seoFriendlyUrl: json['seo_friendly_url'],
      slug: json['slug'],
      masterImage: json['master_image'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      weeklyOffDay: json['weekly_off_day'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      finalRate: (json['final_rate'] as num).toDouble(),
    );
  }
}
