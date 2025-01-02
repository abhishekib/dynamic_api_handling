import 'dart:developer';

import 'package:allworkdone/controller.dart';
import 'package:allworkdone/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.put(CategoryController());

    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.to(() => SearchPage());
        },
        child: Icon(Icons.search),
      ),
      appBar: AppBar(
        title: Text("Cities"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final data = controller.apiResponse.value.data;

        if (data.isEmpty) {
          return Center(child: Text("No data available"));
        }

        // Combine cities from all countries into a single map
        final Map<String, dynamic> cities = {};
        data.forEach((country, cityData) {
          cities.addAll(cityData);
        });

        // Pass the combined city-level data to DynamicScreen
        return DynamicScreen(title: "Cities", data: cities);
      }),
    );
  }
}

class DynamicScreen extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;

  DynamicScreen({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: data.keys.length,
        itemBuilder: (context, index) {
          final key = data.keys.elementAt(index);
          final value = data[key];

          return ListTile(
            title: Text(key),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              log("Screen Tapped $key");
              if (value is Map<String, dynamic>) {
                // If the next level is a map, navigate to the same screen
                log("first level map");
                Get.to(
                    preventDuplicates: false,
                    () => DynamicScreen(title: key, data: value));
                // Navigator.push(context,MaterialPageRoute(
                //     builder: (context) =>
                //         DynamicScreen(title: key, data: value)));
              } else if (value is List<dynamic>) {
                log("first level list");
                // If it's a list, navigate to a content-specific screen
                Get.to(() => ContentScreen(title: key, categories: value));
              }
            },
          );
        },
      ),
    );
  }
}

class ContentScreen extends StatelessWidget {
  final String title;
  final List<dynamic> categories;

  ContentScreen({required this.title, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Card(
            child: ListTile(
              title: Text(category['title'] ?? 'Unknown'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category['cdata'] != null) Text('Data Available'),
                ],
              ),
              onTap: () {
                // Handle deeper navigation if needed
              },
            ),
          );
        },
      ),
    );
  }
}
