import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApodData {
  final String title;
  final String date;
  final String explanation;
  final String url;
  final String? copyright;

  ApodData({
    required this.title,
    required this.date,
    required this.explanation,
    required this.url,
    this.copyright,
  });

  factory ApodData.fromJson(Map<String, dynamic> json) {
    return ApodData(
      title: json['title'],
      date: json['date'],
      explanation: json['explanation'],
      url: json['url'],
      copyright: json['copyright'],
    );
  }
}

class PlanetPage extends StatefulWidget {
  const PlanetPage({super.key});

  @override
  State<PlanetPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<PlanetPage> {
  ApodData? apodData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApodData();
  }

  Future<void> fetchApodData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.nasa.gov/planetary/apod?api_key=APIKEY'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          apodData = ApodData.fromJson(data);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load APOD data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading APOD data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings - Astronomy Picture'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : apodData == null
                ? const Center(
                    child: Text('No data available'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          apodData!.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Date: ${apodData!.date}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        if (apodData!.copyright != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Copyright: ${apodData!.copyright}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Image.network(
                          apodData!.url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Error loading image');
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          apodData!.explanation,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
