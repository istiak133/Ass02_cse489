import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageScaleScreen extends StatefulWidget {
  const ImageScaleScreen({super.key});

  @override
  State<ImageScaleScreen> createState() => _ImageScaleScreenState();
}

class _ImageScaleScreenState extends State<ImageScaleScreen> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.blue.shade50,
          width: double.infinity,
          child: const Text(
            '📌 Pinch to zoom in/out on the image',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ),
        Expanded(
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 5.0,
            child: Center(
              child: CachedNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
                placeholder: (context, url) => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Loading image from internet...'),
                  ],
                ),
                errorWidget: (context, url, error) => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red),
                    SizedBox(height: 12),
                    Text(
                      'Failed to load image.\nCheck internet connection.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey.shade100,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Pinch to scale the image',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: () {
                  _transformationController.value = Matrix4.identity();
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
