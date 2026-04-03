
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProgramCardShimmer extends StatelessWidget {
  const ProgramCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left side text placeholder
                Container(
                  width: width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Program type pill
                      Container(
                        width: 80,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 4),
                      // Description
                      Container(
                        width: double.infinity,
                        height: 40,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      // Author
                      Container(
                        width: 100,
                        height: 16,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Right side image placeholder
                Container(
                  width: width * 0.3,
                  height: width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Info row
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  return Container(
                    width: 60,
                    height: 16,
                    color: Colors.grey.shade400,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
