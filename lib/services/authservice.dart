import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final baseUrl = 'https://leez-app.onrender.com/';
  Future<Map<String, dynamic>> signUpUser({
    required String email,
    required String phoneNo,
  }) async {
    final url = Uri.parse('${baseUrl}api/customer/signup');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'phoneNo': phoneNo}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // ✅ returning data
    } else {
      return {
        'success': false,
        'message': 'Signup failed with status ${response.statusCode}',
      };
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    required String phoneNo,
    required String name,
    required String password,
  }) async {
    final url = Uri.parse('${baseUrl}api/customer/verify-otp');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'phoneNo': phoneNo,
        'name': name,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response);
      return jsonDecode(response.body); // ✅ returning data
    } else {
      return {
        'success': false,
        'message': 'otp failed with status ${response.body}',
      };
    }
  }

  // login

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${baseUrl}api/customer/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response);
      return jsonDecode(response.body); // ✅ returning data
    } else {
      return {
        'success': false,
        'message': 'login failed with status ${response.body}',
      };
    }
  }

  Future<Map<String, dynamic>> fetchAllPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://leez-app.onrender.com/api/products/all-products'),
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return json.decode(response.body);
      } else {
        print('Server error: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to load posts: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> fetchPosts(String name) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://leez-app.onrender.com/api/products/products-by-category/${name}',
        ),
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return json.decode(response.body);
      } else {
        print('Server error: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to load posts: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> addWishList({
    required String customerId,
    required String productId,
  }) async {
    final url = Uri.parse('${baseUrl}api/favorites/add-to-favorite');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': customerId, 'productId': productId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response);
      return jsonDecode(response.body); // ✅ returning data
    } else {
      return {
        'success': false,
        'message': 'adding failed with status ${response.body}',
      };
    }
  }

  Future<Map<String, dynamic>> removeWishList({
    required String customerId,
    required String productId,
  }) async {
    final url = Uri.parse('${baseUrl}api/favorites/remove-from-favorite');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': customerId, 'productId': productId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response);
      return jsonDecode(response.body); // ✅ returning data
    } else {
      return {
        'success': false,
        'message': 'removing failed with status ${response.body}',
      };
    }
  }

  Future<Map<String, dynamic>> fetchfavorites() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${baseUrl}api/favorites/get-all-favorites?userId=6858ed546ab8ecdbc9264c2e',
        ),
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return json.decode(response.body);
      } else {
        print('Server error: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to load cards: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> itemDetails(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}api/products/get-product-by-id?productId=${id}'),
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return json.decode(response.body);
      } else {
        print('Server error: ${response.body}');
        return {'success': false, 'message': 'Failed : ${response.statusCode}'};
      }
    } catch (e) {
      print('Exception: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> feedBackDetails(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}api/review/get-reviews/${id}'),
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return json.decode(response.body);
      } else {
        print('Server error: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed load details: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> sendRequests({
    required String productId,
    required String customerId,
    required int count,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required int price,
  }) async {
    final url = Uri.parse('${baseUrl}api/bookings/book');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'productId': productId,
          'customerId': customerId,
          'count': count,
          'startDateTime': startDateTime.toIso8601String(),
          'endDateTime': endDateTime.toIso8601String(),
          'price': price,
        }),
      );

      // Check status before parsing JSON
      if (response.statusCode == 200) {
        try {
          final responseBody = jsonDecode(response.body);
          return {
            'success': responseBody['success'],
            'message': responseBody['message'],
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Invalid JSON response: ${response.body}',
          };
        }
      } else {
        return {
          'success': false,
          'message':
              'Booking failed (status ${response.statusCode}): ${response.body}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception occurred: $e'};
    }
  }
}
