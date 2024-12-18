import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Wrinklyze',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF052135),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Discover Your Skin\'s Story',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF052135),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Wrinklyze is a cutting-edge mobile application designed to help you understand and analyze the wrinkles on your face. By using advanced facial recognition technology, our app detects and classifies wrinkles into four distinct types, providing you with valuable insights into your skin\'s condition.',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Color(0xFF052135),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Why Wrinklyze?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF052135),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'In today\'s world, understanding skin health is crucial for making informed decisions about skincare and overall well-being. Wrinklyze empowers you with knowledge, allowing you to track changes in your skin over time and recognize patterns that may affect your skin\'s health.',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Color(0xFF052135),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Features:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF052135),
                ),
              ),
              const SizedBox(height: 8),
              BulletPoint(
                  text:
                      'Wrinkle Detection: Effortlessly scan your face to identify wrinkle types.'),
              BulletPoint(
                  text:
                      'Detailed Classification: Learn about the four types of wrinkles and what they mean for your skin.'),
              BulletPoint(
                  text:
                      'Personalized Insights: Receive tailored tips based on your skin analysis to enhance your skin health.'),
              const SizedBox(height: 16),
              const Text(
                'Join the Community',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF052135),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Be part of a growing community that prioritizes skin health and knowledge. Together, we can foster a better understanding of our skin and make informed choices for a healthier future.',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Color(0xFF052135),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text("•", style: TextStyle(fontSize: 20)),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: Color(0xFF052135),
            ),
          ),
        ),
      ],
    );
  }
}
