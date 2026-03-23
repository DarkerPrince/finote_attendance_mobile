import 'package:flutter/material.dart';

class ProgramDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String author;

  const ProgramDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [

          // 🔥 Collapsing App Bar
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 📄 Content Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 📅 Meta Info
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14),
                      SizedBox(width: 6),
                      Text(date, style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 16),
                      Icon(Icons.person, size: 14),
                      SizedBox(width: 6),
                      Text(author, style: TextStyle(color: Colors.grey)),
                    ],
                  ),

                  SizedBox(height: 16),

                  // 📝 Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12),

                  // 📄 Description
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),

                  SizedBox(height: 24),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.telegram)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.facebook)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.tiktok)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}