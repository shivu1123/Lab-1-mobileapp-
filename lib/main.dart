import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Status bar ka color control karne ke liye

void main() {
  runApp(const BeachApp()); // Application ko run kar raha hai
}

class BeachApp extends StatelessWidget {
  const BeachApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Application sirf portrait mode me run karega
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Canadian Beaches', // App ka title set kiya hai
      debugShowCheckedModeBanner: false, // Debug banner hide kiya hai
      theme: ThemeData(
        primarySwatch: Colors.blue, // Theme ka primary color set kiya hai
      ),
      home: const BeachListScreen(), // Home screen set kiya hai
    );
  }
}

// Beach ka data store karne ke liye ek model class banayi hai
class Beach {
  final String name; // Beach ka naam
  final String location; // Beach ka location
  final String image; // Beach ka image path
  final double rating; // Beach ka rating (1 se 5 tak)
  final String description; // Beach ka description

  const Beach({
    required this.name,
    required this.location,
    required this.image,
    required this.rating,
    required this.description,
  });
}

// Yaha pe beaches ki list banayi hai
const List<Beach> beaches = [
  Beach(
    name: 'Wasaga Beach',
    location: 'Ontario, Canada',
    image: 'assets/images/wasaga_beach.jpg',
    rating: 4.5,
    description:
        'Wasaga Beach world ka sabse lamba freshwater beach maana jata hai. Yaha pe sand, summer activities aur sundown views best hain.',
  ),
  Beach(
    name: 'Grand Beach',
    location: 'Muskoka, Ontario',
    image: 'assets/images/grand_beach.jpg',
    rating: 4.2,
    description:
        'Grand Beach Muskoka ka ek popular destination hai, jisme soft white sand aur blue water milta hai.',
  ),
  Beach(
    name: 'Ingonish Beach',
    location: 'Nova Scotia, Canada',
    image: 'assets/images/ingonish_beach.jpg',
    rating: 4.7,
    description:
        'Ingonish Beach Nova Scotia ka ek peaceful aur relaxing jagah hai, jisme beautiful coastal views milte hain.',
  ),
  Beach(
    name: 'Long Beach',
    location: 'British Columbia, Canada',
    image: 'assets/images/long_beach.jpg',
    rating: 4.3,
    description:
        'Pacific Rim National Park me located ye beach nature lovers ke liye perfect hai.',
  ),
  Beach(
    name: 'Singing Sands Beach',
    location: 'Prince Edward Island, Canada',
    image: 'assets/images/singing_sands_beach.jpg',
    rating: 4.6,
    description:
        'Ye beach isliye famous hai kyunki yaha ki sand chalne par sound produce karti hai.',
  ),
];

// BeachListScreen class jo saari beaches ko ek list me show karegi
class BeachListScreen extends StatelessWidget {
  const BeachListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canadian Beaches'), // App bar ka title
      ),
      body: ListView(
        children: [
          // Welcome message jo user ko greet karega
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Beach Info App', // Welcome text
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select a beach to get detailed information', // User ko instructions deta hai
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const Divider(height: 1), // Line separator

          // Beaches list generate ki gayi hai
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
              title: Text(beach.name), // Beach ka naam show karega
              subtitle: Text(beach.location), // Beach ka location show karega
              trailing: const Icon(Icons.arrow_forward_ios), // Forward arrow icon
              onTap: () {
                // Jab kisi beach pe click hoga to detail screen pe jayega
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

// Ye screen ek specific beach ka pura detail dikhayegi
class BeachDetailScreen extends StatelessWidget {
  final Beach beach;
  const BeachDetailScreen({Key? key, required this.beach}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(beach.name), // App bar pe beach ka naam show karega
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Beach ka image display karega
            Image.asset(
              beach.image,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),

            // Beach ke naam, location aur rating dikhayega
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

            // Action buttons (Call, Route, Share)
            buttonSection(context),

            // Beach ka description dikhayega
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

  // Buttons ke liye ek function jo call, route aur share button show karega
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
}
