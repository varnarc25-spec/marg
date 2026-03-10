class ShopProductItem {
  final String title;
  final String meta;
  final String price;

  const ShopProductItem({
    required this.title,
    required this.meta,
    required this.price,
  });

  factory ShopProductItem.fromJson(Map<String, dynamic> json) {
    return ShopProductItem(
      title: json['title']?.toString() ?? '',
      meta: json['meta']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
    );
  }
}

