class Property {
  final int id;
  final String name;
  final String description;
  final String location;
  final String type;
  final String state;
  final String propertyType;
  final String furniture;
  final String certificate;
  final String price;
  final String area;
  final String floor;
  final String bedroom;
  final String bathroom;
  final String createdAt;
  final List<String> images; // New field for multiple images

  Property({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.type,
    required this.state,
    required this.propertyType,
    required this.furniture,
    required this.certificate,
    required this.price,
    required this.area,
    required this.floor,
    required this.bedroom,
    required this.bathroom,
    required this.createdAt,
    this.images = const [], // Default to empty list
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      type: json['type'] ?? '',
      state: json['state'] ?? '',
      propertyType: json['property_type'] ?? '',
      furniture: json['furniture'] ?? '',
      certificate: json['certificate'] ?? '',
      price: json['price'] ?? '',
      area: json['area'] ?? '',
      floor: json['floor'] ?? '',
      bedroom: json['bedroom'] ?? '',
      bathroom: json['bathroom'] ?? '',
      createdAt: json['created_at'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }
}
