import 'package:finote_program/Models/ProgramModel.dart';
import 'package:finote_program/utils/dateUtils.dart';
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
              title: Text(program.title,style: TextStyle(fontSize: 14),),
              centerTitle: false,
              titlePadding: EdgeInsets.all(12),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: program.id,
                    child: Material(
                      color: Colors.transparent,
                      child: Image.network(
                        program.image_url!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
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
                      Icon(Icons.calendar_today,color: Colors.blueAccent, size: 14),
                      SizedBox(width: 6),
                      Text(formatDate(program.startDate), style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 16),
                      Icon(Icons.person,color: Colors.blueAccent, size: 14),
                      SizedBox(width: 6),
                      Text("By Finote Tsidk", style: TextStyle(color: Colors.grey)),
                    ],
                  ),

                  SizedBox(height: 16),

                  // 📝 Title
                  Text(
                    program.title,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12),

                  // 📄 Description
                  Text(
                    program.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 24),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.telegram,color: Colors.blueAccent)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.facebook,color: Colors.blueAccent)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.tiktok,color: Colors.blueAccent)),
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