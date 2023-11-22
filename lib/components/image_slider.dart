import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class ImageSliderWithDescription extends StatelessWidget {
  final List<String> images;
  final String title;
  final String description;

  const ImageSliderWithDescription({super.key, 
    required this.images,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: images.map((image) {
            return Image.asset(image);
          }).toList(),
          options: CarouselOptions(
            // autoPlayAnimationDuration: const Duration(milliseconds: ),
            autoPlayInterval: const Duration(seconds: 3),
            height: 300, // Altura del slider
            autoPlay: true, // Reproducción automática de las imágenes
            enlargeCenterPage: true, // Ampliar la imagen central
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(description),
            ],
          ),
        ),
      ],
    );
  }
}
