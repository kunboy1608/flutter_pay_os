/// `PayOsItemData` is a class that represents an item in your order.
///
/// Each instance of `PayOsItemData` represents a single item, with details about the item's name, quantity, and price.
class PayOsItemData {
  /// The name of the item.
  String name;

  /// The quantity of the item in the order.
  int quantity;

  /// The price of the item.
  double price;

  /// Creates a new instance of `PayOsItemData`.
  ///
  /// Requires the [name], [quantity], and [price] of the item.
  PayOsItemData({
    required this.name,
    required this.quantity,
    required this.price,
  });

  /// Converts the `PayOsItemData` instance into a Map.
  ///
  /// The keys of the Map are 'name', 'quantity', and 'price'.
  /// The values are the corresponding properties of the `PayOsItemData` instance.
  Map<String, dynamic> toMap() =>
      {'name': name, 'quantity': quantity, 'price': price};
}
