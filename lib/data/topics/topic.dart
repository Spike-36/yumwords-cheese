class Topic {
  final String id;
  final String title;
  final String description;
  final int sortOrder;
  final bool featured;
  final bool active;
  final int weight;

  const Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.sortOrder,
    required this.featured,
    required this.active,
    required this.weight,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        sortOrder: json['sortOrder'],
        featured: json['featured'] == 1,
        active: json['active'] == 1,
        weight: json['weight'],
      );
}