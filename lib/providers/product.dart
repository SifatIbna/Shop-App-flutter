import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shop_app_flutter/models/http_exceptions.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final url =
        "https://shop-app-project-cb096-default-rtdb.firebaseio.com/prodcuts/$id.json";

    final response = await patch(
      Uri.parse(url),
      body: json.encode(
        {
          "isFavorite": !isFavorite,
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw HttpException(message: "Some Error Occured!");
    }

    isFavorite = !isFavorite;
    notifyListeners();
  }
}
