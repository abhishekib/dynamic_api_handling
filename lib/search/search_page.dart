import 'package:allworkdone/search/search_custom_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  final SearchCustomController searchController =
      Get.put(SearchCustomController());

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchControllerInput = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final keywords = searchControllerInput.text.trim();
              if (keywords.isNotEmpty) {
                searchController.fetchSearchResults(
                  keywords: keywords,
                  page: 1,
                );
              } else {
                Get.snackbar(
                  'Error',
                  'Please enter a search term.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchControllerInput,
              decoration: InputDecoration(
                hintText: "Enter keywords...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  searchController.fetchSearchResults(
                    keywords: value.trim(),
                    page: 1,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Please enter a search term.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            // Results Section
            Expanded(
              child: Obx(() {
                if (searchController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final results = searchController.apiResponse.value.posts;
                if (results == null || results.isEmpty) {
                  return const Center(
                    child: Text("No results found."),
                  );
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final post = results[index];
                    final title = post.title; // Null safety check
                    final postType =
                        post.postType; // Null safety check

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(title),
                        subtitle: Text(postType),
                        onTap: () {
                          // Handle post click, e.g., navigate to details
                          Get.to(() => PostDetailsPage(post: post));
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class PostDetailsPage extends StatelessWidget {
  final dynamic post;

  const PostDetailsPage({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title ?? 'Post Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title ?? 'No Title',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(post.postType ?? 'Unknown Type'),
            const SizedBox(height: 20),
            // Add more details based on post structure
          ],
        ),
      ),
    );
  }
}
