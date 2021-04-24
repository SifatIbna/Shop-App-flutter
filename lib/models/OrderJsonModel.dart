// To parse this JSON data, do
//
//     final OrderModel = OrderModelFromJson(jsonString);

import 'dart:convert';

class OrderModel {
  OrderModel({
    this.amount,
    this.dateTime,
    this.products,
  });

  final double amount;
  final String dateTime;
  final List<Product> products;

  factory OrderModel.fromRawJson(String str) =>
      OrderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        amount: json["amount"] == null ? null : json["amount"].toDouble(),
        dateTime: json["dateTime"] == null ? null : json["dateTime"],
        products: json["products"] == null
            ? null
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount == null ? null : amount,
        "dateTime": dateTime == null ? null : dateTime,
        "products": products == null
            ? null
            : List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    this.id,
    this.price,
    this.quantity,
    this.title,
  });

  final String id;
  final double price;
  final int quantity;
  final String title;

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? null : json["id"],
        price: json["price"] == null ? null : json["price"].toDouble(),
        quantity: json["quantity"] == null ? null : json["quantity"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "price": price == null ? null : price,
        "quantity": quantity == null ? null : quantity,
        "title": title == null ? null : title,
      };
}
