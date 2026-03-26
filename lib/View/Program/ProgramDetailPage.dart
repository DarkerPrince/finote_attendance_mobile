import 'package:finote_program/Models/ProgramModel.dart';
import 'package:flutter/material.dart';

class ProgramDetailPage extends StatelessWidget {
  final ProgramModel program;

  const ProgramDetailPage({
    super.key,
    required this.program,
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
                "https://images.squarespace-cdn.com/content/v1/5759a0b362cd94a47d9c6242/1465498218086-IO3IIO7FP8QBHL6N585H/slide3.jpg?format=1500w",
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
                      Text(program.startDate, style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 16),
                      Icon(Icons.person, size: 14),
                      SizedBox(width: 6),
                      Text("By Temert Kefel", style: TextStyle(color: Colors.grey)),
                    ],
                  ),

                  SizedBox(height: 16),

                  // 📝 Title
                  Text(
                    program.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12),

                  // 📄 Description
                  Text(
                    program.description,
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