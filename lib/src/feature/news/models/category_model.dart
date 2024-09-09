class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  static List<Category> categories = [
    Category(id: 'health', name: 'Health'),
    Category(id: 'business', name: 'Business'),
    Category(id: 'entertainment', name: 'Entertainment'),
    Category(id: 'general', name: 'General'),
    Category(id: 'science', name: 'Science'),
    Category(id: 'sports', name: 'Sports'),
    Category(id: 'technology', name: 'Technology'),
  ];
}
