import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/doctor_controller.dart';
import '../../models/doctor_model.dart';

class DoctorListPage extends StatelessWidget {
  const DoctorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Doctor'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.loadDoctors,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.doctors.isEmpty) {
          return const Center(
            child: Text(
              'No doctors available',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadDoctors,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.doctors.length,
            itemBuilder: (context, index) {
              final doctor = controller.doctors[index];

              return _DoctorCard(
                doctor: doctor,
              );
            },
          ),
        );
      }),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final DoctorModel doctor;

  const _DoctorCard({
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _DoctorImage(
              image: doctor.image,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    doctor.specialization,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${doctor.experience} years experience',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  if (doctor.categoryName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      doctor.categoryName!,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorImage extends StatelessWidget {
  final String image;

  const _DoctorImage({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.person,
          size: 40,
          color: Colors.blue,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        image,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 72,
            height: 72,
            color: Colors.blue.shade50,
            child: const Icon(
              Icons.person,
              size: 40,
              color: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}