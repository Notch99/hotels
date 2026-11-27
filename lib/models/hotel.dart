class Hotel {
  final String name;
  final String address;
  final List<String> services;
  final double price;
  final String image;

  Hotel({
    required this.name,
    required this.address,
    required this.services,
    required this.price,
    required this.image,
  });

  factory Hotel.fromMap(Map<String, dynamic> data) {
    return Hotel(
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      services: data['services'] is List
          ? List<String>.from(data['services'])
          : [],
      price: (data['price'] ?? 0).toDouble(),
      image: data['image'] ?? '',
    );
  }
}
