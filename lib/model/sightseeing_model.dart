class SightseeingModel {
  // final int id;
  // final int supplierId;
  // final String name;
  // final String city;
  // final String shortDescription;
  // final String longDescription;
  // final num finalRate;
  // final String slug;
  int ratelistdayId;
  int day;
  String dayName;
  String dayType;
  int ratelistId;
  double rate;
  int supplierId;
  int sightseeingId;
  int year;
  int month;
  int id;
  String name;
  String shortDescription;
  String longDescription;
  String location;
  String country;
  String city;
  String shortUrl;
  String seoFriendlyUrl;
  String? metaTitle;
  String? metaDescription;
  String? metaKeywords;
  String slug;
  String masterImage;
  String openingTime;
  String closingTime;
  String weeklyOffDay;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  double finalRate;

  SightseeingModel({
    // required this.id,
    // required this.supplierId,
    // required this.name,
    // required this.city,
    // required this.shortDescription,
    // required this.longDescription,
    // required this.finalRate,
    // required this.slug,
     required this.ratelistdayId,
    required this.day,
    required this.dayName,
    required this.dayType,
    required this.ratelistId,
    required this.rate,
    required this.supplierId,
    required this.sightseeingId,
    required this.year,
    required this.month,
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.location,
    required this.country,
    required this.city,
    required this.shortUrl,
    required this.seoFriendlyUrl,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
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

  factory SightseeingModel.fromJson(Map<String, dynamic> json) {
    return SightseeingModel(
      // id: json['id'],
      // supplierId: json['supplier_id'],
      // name: json['name'],
      // city: json['city'],
      // shortDescription: json['short_description'],
      // longDescription: json['long_description'],
      // finalRate: json['final_rate'],
      // slug: json['slug'],
      ratelistdayId: json['ratelistday_id'],
      day: json['day'],
      dayName: json['day_name'] ?? '',
      dayType: json['day_type'],
      ratelistId: json['ratelist_id'],
      rate: (json['rate'] as num).toDouble(),
      supplierId: json['supplier_id'],
      sightseeingId: json['sightseeing_id'],
      year: json['year'],
      month: json['month'],
      id: json['id'],
      name: json['name'],
      shortDescription: json['short_description'],
      longDescription: json['long_description'],
      location: json['location'],
      country: json['country'],
      city: json['city'],
      shortUrl: json['short_url'],
      seoFriendlyUrl: json['seo_friendly_url'],
      metaTitle: json['meta_title'],
      metaDescription: json['meta_description'],
      metaKeywords: json['meta_keywords'],
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

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      // 'supplier_id': supplierId,
      // 'name': name,
      // 'city': city,
      // 'short_description': shortDescription,
      // 'long_description': longDescription,
      // 'final_rate': finalRate,
      // 'slug': slug,
      'ratelistday_id': ratelistdayId,
      'day': day,
      'day_name': dayName,
      'day_type': dayType,
      'ratelist_id': ratelistId,
      'rate': rate,
      'supplier_id': supplierId,
      'sightseeing_id': sightseeingId,
      'year': year,
      'month': month,
      'id': id,
      'name': name,
      'short_description': shortDescription,
      'long_description': longDescription,
      'location': location,
      'country': country,
      'city': city,
      'short_url': shortUrl,
      'seo_friendly_url': seoFriendlyUrl,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,
      'slug': slug,
      'master_image': masterImage,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'weekly_off_day': weeklyOffDay,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'final_rate': finalRate,
    };
  }
}