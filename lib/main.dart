import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Optional: For controlling status bar color

void main() {
  runApp(const BeachApp());
}

class BeachApp extends StatelessWidget {
  const BeachApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Optional: Lock orientation to portrait if desired.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Canadian Beaches',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BeachListScreen(),
    );
  }
}

class Beach {
  final String name;
  final String location;
  final String image;
  final double rating;
  final String description;

  const Beach({
    required this.name,
    required this.location,
    required this.image,
    required this.rating,
    required this.description,
  });
}

// List of 5 Canadian beaches
const List<Beach> beaches = [
  Beach(
    name: 'Wasaga Beach',
    location: 'Ontario, Canada',
    image: 'assets/images/wasaga_beach.jpg',
    rating: 4.5,
    description:
    'Wasaga Beach is known as the world\'s longest freshwater beach. It offers an expansive stretch of sandy shoreline, vibrant summer activities, and beautiful sunsets.',
  ),
  Beach(
    name: 'Grand Beach',
    location: 'Muskoka, Ontario',
    image: 'assets/images/grand_beach.jpg',
    rating: 4.2,
    description:
    'Grand Beach is a popular destination in Muskoka with soft white sands, clear blue water, and plenty of recreational activities for families.',
  ),
  Beach(
    name: 'Ingonish Beach',
    location: 'Nova Scotia, Canada',
    image: 'assets/images/ingonish_beach.jpg',
    rating: 4.7,
    description:
    'Ingonish Beach in Nova Scotia offers breathtaking coastal views and a serene environment, perfect for those seeking a peaceful retreat by the sea.',
  ),
  Beach(
    name: 'Long Beach',
    location: 'British Columbia, Canada',
    image: 'assets/images/long_beach.jpg',
    rating: 4.3,
    description:
    'Located in Pacific Rim National Park, Long Beach is known for its rugged beauty, dramatic sunsets, and excellent opportunities for beachcombing and nature walks.',
  ),
  Beach(
    name: 'Singing Sands Beach',
    location: 'Prince Edward Island, Canada',
    image: 'assets/images/singing_sands_beach.jpg',
    rating: 4.6,
    description:
    'Singing Sands Beach on Prince Edward Island is famous for the unique sound its sand makes underfoot. It\'s a magical spot for relaxation and exploration.',
  ),
];

class BeachListScreen extends StatelessWidget {
  const BeachListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using ListView with a header (welcome message) and the list of beaches.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canadian Beaches'),
      ),
      body: ListView(
        children: [
          // Welcome Message
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Beach Info App',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select a beach to get detailed information',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // List of Beaches
          ...beaches.map((beach) {
            return ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  beach.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(beach.name),
              subtitle: Text(beach.location),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BeachDetailScreen(beach: beach),
                  ),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}

class BeachDetailScreen extends StatelessWidget {
  final Beach beach;
  const BeachDetailScreen({Key? key, required this.beach}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Detail screen with image, title, location, rating, description, and three action buttons.
    return Scaffold(
      appBar: AppBar(
        title: Text(beach.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Beach Image
            Image.asset(
              beach.image,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),
            // Title, Location, and Rating Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    beach.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        beach.location,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        beach.rating.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action Buttons: Call, Route, Share
            buttonSection(context),
            // Description Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                beach.description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a row of action buttons.
  Widget buttonSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(context, Icons.call, 'CALL'),
          buildButtonColumn(context, Icons.near_me, 'ROUTE'),
          buildButtonColumn(context, Icons.share, 'SHARE'),
        ],
      ),
    );
  }

  // Reusable widget for creating a button column.
  Widget buildButtonColumn(BuildContext context, IconData icon, String label) {
    return TextButton(
      onPressed: () {
        // Display a simple SnackBar for demonstration.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label button clicked'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}