import 'package:billify/Util/app_colors.dart';
import 'package:billify/navigation/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Billify",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Smart Billing Solution for Your Business",
                      style: TextStyle(
                        fontSize: 24,
                        color: white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => Get.offAllNamed(Routes.splashPage),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 18,
                          color: white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Features Section
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Key Features",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureCard(
                      icon: Icons.receipt_long,
                      title: "Easy Bill Generation",
                      description: "Create professional bills in seconds",
                    ),
                    _buildFeatureCard(
                      icon: Icons.search,
                      title: "Smart Search",
                      description:
                          "Find any bill instantly with powerful search",
                    ),
                    _buildFeatureCard(
                      icon: Icons.analytics,
                      title: "Business Analytics",
                      description:
                          "Track your business performance with detailed reports",
                    ),
                    _buildFeatureCard(
                      icon: Icons.share,
                      title: "Easy Sharing",
                      description: "Share bills instantly via PDF or print",
                    ),
                  ],
                ),
              ),

              // Testimonial Section
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Why Choose Billify?",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTestimonialCard(
                      "Perfect for small businesses",
                      "Streamline your billing process and focus on growing your business",
                    ),
                    _buildTestimonialCard(
                      "Specialized Templates",
                      "Custom templates for different business types including optical shops",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: white.withOpacity(0.1),
      child: ListTile(
        leading: Icon(icon, color: orangeColor, size: 32),
        title: Text(
          title,
          style: const TextStyle(
            color: white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildTestimonialCard(String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
