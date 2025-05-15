import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../model/content_model.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/styles/color.dart';

class ContentDetailPage extends StatelessWidget {
  final Content content;
  const ContentDetailPage({Key? key, required this.content}) : super(key: key);

  // Helper method to clean HTML paragraph tags
  String _cleanHtmlTags(String? text) {
    if (text == null) return '';

    // Remove <p> and </p> tags
    return text
        .replaceAll('<p>', '')
        .replaceAll('</p>', '')
        // Add a line break between paragraphs (optional)
        .replaceAll('</p><p>', '\n\n');
  }

  @override
  Widget build(BuildContext context) {
    final scale =
        MediaQuery.of(context).size.width < 600
            ? 1.0
            : MediaQuery.of(context).size.width < 1200
            ? 1.5
            : 2.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver app bar with image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColor.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                content.judul,
                style: TextStyle(
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: content.imageContent,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                  ),
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: [0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Content body
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // This creates space for our overlapping container
                Container(height: 24),

                // Content container with top border radius
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with decorative element
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              content.judul,
                              style: TextStyle(
                                fontSize: 24 * scale,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 60,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content text - now with HTML tags removed
                      if (content.isiContent != null)
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: Text(
                            _cleanHtmlTags(content.isiContent),
                            style: TextStyle(
                              fontSize: 16 * scale,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
