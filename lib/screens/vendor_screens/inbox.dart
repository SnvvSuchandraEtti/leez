import 'package:flutter/material.dart';
import 'package:leez/constants/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatLauncherScreen extends StatefulWidget {
  const ChatLauncherScreen({super.key});

  @override
  State<ChatLauncherScreen> createState() => _ChatLauncherScreenState();
}

class _ChatLauncherScreenState extends State<ChatLauncherScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  List<Map<String, String>> complaints = [
    {
      'user': 'Deekshith Reddi',
      'message': 'The bike I rented had a flat tire during the ride.',
      'time': '2 hours ago',
      'image': 'https://info.aec.edu.in/AEC/StudentPhotos/22A91A05F4.jpg',
    },
    {
      'user': 'Suchi',
      'message': 'The car was delivered late by 2 hours.',
      'time': '5 hours ago',
      'image': 'https://info.aec.edu.in/AEC/StudentPhotos/22A91A0570.jpg',
    },
    {
      'user': 'Sai Teja',
      'message': 'The rental prices are too high compared to market rates.',
      'time': '1 day ago',
      'image': 'https://info.aec.edu.in/AEC/StudentPhotos/22A91A05E9.jpg',
    },
    {
      'user': 'Balaraju',
      'message': 'Uploaded pictures do not match the actual product.',
      'time': '1 day ago',
      'image': 'https://info.aec.edu.in/AEC/StudentPhotos/22A91A05J1.jpg',
    },
    {
      'user': 'Prudhvi',
      'message': 'The bike’s mileage does not match the listed specifications.',
      'time': '2 days ago',
      'image': 'https://info.aec.edu.in/AEC/StudentPhotos/22A91A0565.jpg',
    },
    {
      'user': 'Dhanunjay',
      'message': 'The car makes excessive noise while driving.',
      'time': '2 days ago',
      'image': 'https://info.aec.edu.in/AEC/StudentPhotos/22A91A0571.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward(); // Start animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FullScreenChat()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: () => {}, icon: Icon(null)),
        title: const Text(
          'Inbox Complaints',
          style: TextStyle(color: AppColors.secondary),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          final complaint = complaints[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,

              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(58, 0, 0, 0),
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Image.network(
                      complaint['image']!,
                      fit: BoxFit.fill,
                      errorBuilder:
                          (context, error, stackTrace) => Icon(Icons.error),
                    ),
                  ),
                ),

                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        complaint['user']!,
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        complaint['message']!,
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          complaint['time']!,
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: FloatingActionButton.extended(
              onPressed: () => _openChat(context),
              backgroundColor: Colors.black,
              foregroundColor: Colors.black,
              icon: const Icon(
                Icons.chat_bubble_outline,
                color: AppColors.primary,
              ),
              label: const Text(
                "Chat",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
// Dummy FullScreenChat for navigation

class FullScreenChat extends StatelessWidget {
  const FullScreenChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.primary, width: 0.1),
              ),
              color: AppColors.secondary,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                const Icon(Icons.support_agent, color: Colors.white),
                SizedBox(width: 10),
                Center(
                  child: const Text(
                    'LEEZ Assistant',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Spacer(),
              ],
            ),
          ),
          const Expanded(child: ChatBotWebView()),
        ],
      ),
    );
  }
}

class ChatBotWebView extends StatefulWidget {
  const ChatBotWebView({super.key});

  @override
  State<ChatBotWebView> createState() => _ChatBotWebViewState();
}

class _ChatBotWebViewState extends State<ChatBotWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setUserAgent(
            'Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) => setState(() => _isLoading = true),
              onPageFinished: (url) {
                setState(() => _isLoading = false);
                Future.delayed(const Duration(milliseconds: 1500), () {
                  _controller.runJavaScript('''
                document.documentElement.style.overflow = 'auto';
                document.documentElement.style.height = '100%';
                document.body.style.overflow = 'auto';
                document.body.style.height = '100%';
                document.body.style.margin = '0';
                document.body.style.padding = '0';
                document.body.style.touchAction = 'manipulation';
                document.body.style.webkitOverflowScrolling = 'touch';

                const enableScrolling = () => {
                  const selectors = [
                    '.bp-chat-container',
                    '.bp-widget-container',
                    '[class*="chat"]',
                    '[class*="message"]',
                    'div[style*="overflow"]'
                  ];
                  selectors.forEach(selector => {
                    document.querySelectorAll(selector).forEach(el => {
                      el.style.overflowY = 'auto';
                      el.style.overflow = 'auto';
                      el.style.webkitOverflowScrolling = 'touch';
                    });
                  });
                };

                enableScrolling();
                setTimeout(enableScrolling, 2000);
                setTimeout(enableScrolling, 5000);

                new MutationObserver(() => setTimeout(enableScrolling, 100)).observe(
                  document.body,
                  { childList: true, subtree: true }
                );
              ''');
                });
              },
            ),
          )
          ..loadRequest(
            Uri.parse(
              "https://cdn.botpress.cloud/webchat/v3.0/shareable.html?configUrl=https://files.bpcontent.cloud/2025/06/25/13/20250625130919-OYYF6SJ4.json",
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
              strokeWidth: 3,
            ),
          ),
      ],
    );
  }
}
