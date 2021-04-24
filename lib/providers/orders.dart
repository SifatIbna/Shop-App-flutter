import 'package:flutter/foundation.dart';
import 'package:shop_app_flutter/models/OrderJsonModel.dart';
import 'package:shop_app_flutter/models/http_exceptions.dart';
import '../providers/cart.dart' show CartItem;

import 'cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;

  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url =
        "https://shop-app-project-cb096-default-rtdb.firebaseio.com/orders.json";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode >= 400) {
      throw HttpException(message: "Something Went Wrong!");
    }

    final List<OrderItem> loadedOrders = [];
    final extractData = json.decode(response.body) as Map<String, dynamic>;
    extractData.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      },
    );
    _orders = loadedOrders.reversed.toList();
    notifyListeners();

    // OrderModel orderModel = OrderModel.fromRawJson(response.body.toString());
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url =
        "https://shop-app-project-cb096-default-rtdb.firebaseio.com/orders.json";
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map(
                  (e) => {
                    'id': e.id,
                    'title': e.title,
                    'price': e.price,
                    'quantity': e.quantity,
                  },
                )
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
