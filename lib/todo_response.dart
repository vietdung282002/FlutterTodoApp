class TodoItem {
  final int category;
  final String title;
  final DateTime time;
  bool isComplete;

  // Constructor
  TodoItem({
    required this.category,
    required this.title,
    required this.time,
    this.isComplete = false,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      category: json['category'] as int,
      title: json['title'] as String,
      time: DateTime.parse(json['time'] as String),
      isComplete: json['is_complete'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'time': time.toIso8601String(),
      'is_complete': isComplete,
    };
  }

  @override
  String toString() {
    return 'TodoItem(category: $category, title: $title, time: $time, isComplete: $isComplete)';
  }
}
