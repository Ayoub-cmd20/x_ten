class Paginated<T> {
  const Paginated({required this.count, required this.items, this.next});

  const Paginated.empty()
      : count = 0,
        items = const <Never>[],
        next = null;

  final int count;
  final List<T> items;
  final String? next;

  bool get hasMore => next != null;

  Paginated<T> append(Paginated<T> page) => Paginated(
        count: page.count,
        items: [...items, ...page.items],
        next: page.next,
      );
}

Paginated<T> parsePaginated<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic> json) item,
) =>
    Paginated(
      count: json['count'] as int,
      next: json['next'] as String?,
      items: [
        for (final e in json['results'] as List) item(e as Map<String, dynamic>),
      ],
    );
