import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leez/constants/colors.dart';

class RentalRequestsScreen extends StatefulWidget {
  @override
  _RentalRequestsScreenState createState() => _RentalRequestsScreenState();
}

class _RentalRequestsScreenState extends State<RentalRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<RentalRequest> pendingRequests = [];
  List<RentalRequest> acceptedRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://leez-app.onrender.com/api/bookings/pending-rentals/684fb005ef0c1addb3ee47f3',
        ),
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        if (jsonBody['success'] == true) {
          final bookings = jsonBody['bookings'] as List;

          List<RentalRequest> pending = [];
          List<RentalRequest> accepted = [];

          for (var booking in bookings) {
            final bookingData = booking['bookings'];
            final product = booking['product'];

            final status = bookingData['status'];

            RentalRequest request = RentalRequest(
              id: bookingData['_id'],
              userName: booking['name'],
              itemName: product['name'],
              imageUrl:
                  "https://res.cloudinary.com/dyigkc2zy/image/upload/v1750151597/${product['images'][0]}",
              dateTime: DateTime.parse(bookingData['startDateTime']),
              rentalDuration: _calculateDuration(
                bookingData['startDateTime'],
                bookingData['endDateTime'],
              ),
              estimatedCost:
                  double.tryParse(bookingData['price'].toString()) ?? 0,
            );

            if (status == "pending") {
              pending.add(request);
            } else if (status == "accepted") {
              accepted.add(request);
            }
          }

          setState(() {
            pendingRequests = pending;
            acceptedRequests = accepted;
          });
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String _calculateDuration(String start, String end) {
    final startDate = DateTime.parse(start);
    final endDate = DateTime.parse(end);
    final diff = endDate.difference(startDate);

    if (diff.inDays >= 1) {
      return '${diff.inDays} day(s)';
    } else {
      return '${diff.inHours} hour(s)';
    }
  }

  void _acceptRequest(RentalRequest request) {
    setState(() {
      pendingRequests.remove(request);
      acceptedRequests.add(request);
    });

    _tabController.animateTo(1);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${request.itemName} has been moved to accepted requests!',
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            _tabController.animateTo(1);
          },
        ),
      ),
    );
  }

  void _cancelRequest(RentalRequest request) {
    setState(() {
      pendingRequests.remove(request);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${request.itemName} request has been cancelled!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Rental Requests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: 'Pending'), Tab(text: 'Accepted')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PendingRequestsTab(
            pendingRequests: pendingRequests,
            onAcceptRequest: _acceptRequest,
            onCancelRequest: _cancelRequest,
          ),
          AcceptedRequestsTab(acceptedRequests: acceptedRequests),
        ],
      ),
    );
  }
}

class PendingRequestsTab extends StatelessWidget {
  final List<RentalRequest> pendingRequests;
  final Function(RentalRequest) onAcceptRequest;
  final Function(RentalRequest) onCancelRequest;

  const PendingRequestsTab({
    Key? key,
    required this.pendingRequests,
    required this.onAcceptRequest,
    required this.onCancelRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pendingRequests.isEmpty) {
      return Center(child: Text('No pending requests.'));
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: pendingRequests.length,
      itemBuilder: (context, index) {
        return ExpandableRequestCard(
          request: pendingRequests[index],
          isPending: true,
          onAcceptRequest: onAcceptRequest,
          onCancelRequest: onCancelRequest,
        );
      },
    );
  }
}

class AcceptedRequestsTab extends StatelessWidget {
  final List<RentalRequest> acceptedRequests;

  const AcceptedRequestsTab({Key? key, required this.acceptedRequests})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (acceptedRequests.isEmpty) {
      return Center(child: Text('No accepted requests.'));
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: acceptedRequests.length,
      itemBuilder: (context, index) {
        return ExpandableRequestCard(
          request: acceptedRequests[index],
          isPending: false,
        );
      },
    );
  }
}

class ExpandableRequestCard extends StatefulWidget {
  final RentalRequest request;
  final bool isPending;
  final Function(RentalRequest)? onAcceptRequest;
  final Function(RentalRequest)? onCancelRequest;

  const ExpandableRequestCard({
    Key? key,
    required this.request,
    required this.isPending,
    this.onAcceptRequest,
    this.onCancelRequest,
  }) : super(key: key);

  @override
  _ExpandableRequestCardState createState() => _ExpandableRequestCardState();
}

class _ExpandableRequestCardState extends State<ExpandableRequestCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      margin: EdgeInsets.only(bottom: 20.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        child: Column(
          children: [
            ListTile(
              tileColor: AppColors.primary,
              contentPadding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 15.0,
              ), // More vertical spacing
              leading: ClipOval(
                child: Image.network(
                  widget.request.imageUrl,
                  width: 70, // Increase size
                  height: 70,
                  fit: BoxFit.fill,
                ),
              ),
              title: Text(
                widget.request.itemName,
                style: TextStyle(
                  fontSize: 18, // Larger font
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                widget.request.userName,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                size: 28,
              ),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),

            if (isExpanded) ...[
              Divider(),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Request ID:', widget.request.id),
                    SizedBox(height: 8),
                    _buildDetailRow(
                      'Date & Time:',
                      '${widget.request.dateTime.day}/${widget.request.dateTime.month}/${widget.request.dateTime.year} at ${widget.request.dateTime.hour}:${widget.request.dateTime.minute.toString().padLeft(2, '0')}',
                    ),
                    SizedBox(height: 8),
                    _buildDetailRow(
                      'Rental Duration:',
                      widget.request.rentalDuration,
                    ),
                    SizedBox(height: 8),
                    _buildDetailRow(
                      'Total Estimated Cost:',
                      '\$${widget.request.estimatedCost.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(widget.request.imageUrl),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    if (widget.isPending) ...[
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _showConfirmDialog(
                                  context,
                                  'Cancel Request',
                                  'Are you sure you want to cancel this request?',
                                  () => widget.onCancelRequest?.call(
                                    widget.request,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text('Cancel Request'),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _showConfirmDialog(
                                  context,
                                  'Accept Request',
                                  'Are you sure you want to accept this request?',
                                  () => widget.onAcceptRequest?.call(
                                    widget.request,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: Text('Accept Request'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(child: Text(value, style: TextStyle(color: Colors.black87))),
      ],
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    title.contains('Accept') ? Colors.green : Colors.red,
              ),
              child: Text(
                title.contains('Accept') ? 'Accept' : 'Cancel Request',
              ),
            ),
          ],
        );
      },
    );
  }
}

class RentalRequest {
  final String id;
  final String userName;
  final String itemName;
  final String imageUrl;
  final DateTime dateTime;
  final String rentalDuration;
  final double estimatedCost;

  RentalRequest({
    required this.id,
    required this.userName,
    required this.itemName,
    required this.imageUrl,
    required this.dateTime,
    required this.rentalDuration,
    required this.estimatedCost,
  });
}
