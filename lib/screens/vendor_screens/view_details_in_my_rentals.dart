import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ReturnConfirmationScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String rentedBy;
  final String returnDueDate;

  const ReturnConfirmationScreen({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.rentedBy,
    required this.returnDueDate,
  }) : super(key: key);

  @override
  State<ReturnConfirmationScreen> createState() =>
      _ReturnConfirmationScreenState();
}

class _ReturnConfirmationScreenState extends State<ReturnConfirmationScreen>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;
  final List<String> steps = ['Requested', 'Accepted', 'Picked Up', 'Returned'];
  final List<IconData> stepIcons = [
    Icons.assignment_outlined,
    Icons.check_circle_outline,
    Icons.local_shipping_outlined,
    Icons.task_alt,
  ];
  late AnimationController _controller;
  late Animation<double> _stepAnimation;
  late Animation<double> _fadeAnimation;
  DateTime? returnedOn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _stepAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );
    _controller.forward();
  }

  void nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
        _controller.reset();
        _controller.forward();
        if (currentStep == 3) {
          returnedOn = DateTime.now();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildVerticalStepIndicator() {
    return Container(
      width: 120,
      child: Column(
        children: List.generate(steps.length, (index) {
          bool isCompleted = index < currentStep;
          bool isCurrent = index == currentStep;
          bool isUpcoming = index > currentStep;

          return Column(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double scale =
                      isCurrent ? 1.0 + (_stepAnimation.value * 0.1) : 1.0;
                  double opacity = _fadeAnimation.value;

                  return Transform.scale(
                    scale: scale,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            isCompleted || isCurrent
                                ? Colors.black
                                : Colors.transparent,
                        border: Border.all(
                          color:
                              isCompleted || isCurrent
                                  ? Colors.black
                                  : Colors.grey.shade400,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow:
                            isCompleted || isCurrent
                                ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                                : [],
                      ),
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: opacity,
                        child: Icon(
                          isCompleted ? Icons.check : stepIcons[index],
                          color:
                              isCompleted || isCurrent
                                  ? Colors.white
                                  : Colors.grey.shade400,
                          size: 24,
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (index < steps.length - 1)
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 2,
                  height: 40,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        index < currentStep
                            ? Colors.black
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepLabels() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(steps.length, (index) {
          bool isCompleted = index < currentStep;
          bool isCurrent = index == currentStep;

          return AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Container(
                height: index == 0 ? 50 : 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: isCurrent ? 18 : 16,
                        fontWeight:
                            isCurrent ? FontWeight.bold : FontWeight.w500,
                        color:
                            isCompleted || isCurrent
                                ? Colors.black
                                : Colors.grey.shade500,
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(steps[index]),
                      ),
                    ),
                    if (isCurrent) ...[
                      SizedBox(height: 5),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          _getStepDescription(index),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  String _getStepDescription(int index) {
    switch (index) {
      case 0:
        return 'Return request initiated';
      case 1:
        return 'Request approved by owner';
      case 2:
        return 'Item collected for return';
      case 3:
        return 'Return process completed';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFinalStep = currentStep == steps.length - 1;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Return Confirmation",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: BackButton(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rental Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            _buildDetailRow('Rented by', widget.rentedBy),
                            SizedBox(height: 4),
                            _buildDetailRow('Return Due', widget.returnDueDate),
                            if (returnedOn != null) ...[
                              SizedBox(height: 16),
                              Text(
                                'Returned on',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  returnedOn!.toString().split(' ')[0],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.imageUrl,
                          height: 70,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Progress Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Return Progress',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVerticalStepIndicator(),
                      SizedBox(width: 20),
                      _buildStepLabels(),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Bottom Section
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This action completes the rental cycle.',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isFinalStep) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Marked as Returned'),
                              backgroundColor: Colors.black,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          nextStep();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isFinalStep ? 'Finish' : 'Next Step',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
