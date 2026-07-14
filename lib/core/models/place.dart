import 'place_categories.dart';
import 'place_location.dart';

class Place {
  final String id;
  final String name;
  final String city;
  final String image;
  final double rating;
  final String description;
  final List<String> images;
  final PlaceCategories category;
  final PlaceLocation location;

  Place({
    required this.id,
    required this.name,
    required this.image,
    required this.images,
    required this.location,
    required this.description,
    required this.category,
    required this.city,
    required this.rating,
  });

  copyWith({
    String? id,
    String? name,
    String? city,
    String? image,
    double? rating,
    String? description,
    List<String>? images,
    PlaceLocation? location,
    PlaceCategories? category,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      location: location ?? this.location,
      description: description ?? this.description,
      images: images != null ? List.from(images) : this.images,
      category: category ?? this.category,
      city: city ?? this.city,
      rating: rating ?? this.rating,
    );
  }
}
