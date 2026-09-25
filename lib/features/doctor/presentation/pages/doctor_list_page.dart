import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/doctor_controller.dart';
import '../../models/doctor_model.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({super.key});

  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  final DoctorController doctorController =
      Get.find<DoctorController>();

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    doctorController.loadDoctors();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _searchDoctors(String value) {
    doctorController.loadDoctors(
      search: value.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Get.offAllNamed('/patient-home');
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF111827),
          ),
        ),

        title: const Text(
          'Doctors',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // =========================
            // SEARCH
            // =========================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                12,
              ),
              child: TextField(
                controller: searchController,
                onChanged: _searchDoctors,
                decoration: InputDecoration(
                  hintText: 'Search doctors...',
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  suffixIcon:
                      searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();

                                setState(() {});

                                doctorController
                                    .loadDoctors();
                              },
                              icon: const Icon(
                                Icons.clear,
                              ),
                            )
                          : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // =========================
            // DOCTORS
            // =========================

            Expanded(
              child: Obx(() {
                if (doctorController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (doctorController.errorMessage.value
                    .isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 50,
                            color: Colors.red,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            doctorController
                                .errorMessage.value,
                            textAlign:
                                TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: () {
                              doctorController
                                  .loadDoctors(
                                search:
                                    searchController
                                        .text
                                        .trim(),
                              );
                            },
                            child:
                                const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final doctors =
                    doctorController.doctors;

                if (doctors.isEmpty) {
                  return const Center(
                    child: Text(
                      'No doctors found',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await doctorController
                        .loadDoctors(
                      search:
                          searchController.text.trim(),
                    );
                  },
                  child: ListView.separated(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      20,
                    ),
                    itemCount: doctors.length,
                    separatorBuilder:
                        (_, __) =>
                            const SizedBox(height: 12),
                    itemBuilder:
                        (context, index) {
                      final doctor =
                          doctors[index];

                      return _doctorCard(
                        doctor,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _doctorCard(
    DoctorModel doctor,
  ) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          '/doctor-details/${doctor.id}',
        );
      },
      borderRadius:
          BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color:
                  Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            // =========================
            // IMAGE
            // =========================

            CircleAvatar(
              radius: 34,
              backgroundColor:
                  const Color(0xFFE0ECFF),
              backgroundImage:
                  doctor.image.isNotEmpty
                      ? NetworkImage(
                          doctor.image,
                        )
                      : null,
              child: doctor.image.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 34,
                      color:
                          Color(0xFF2563EB),
                    )
                  : null,
            ),

            const SizedBox(width: 16),

            // =========================
            // DETAILS
            // =========================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    doctor.specialization,
                    style: const TextStyle(
                      fontSize: 14,
                      color:
                          Color(0xFF2563EB),
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '${doctor.experience} years experience',
                    style: const TextStyle(
                      fontSize: 13,
                      color:
                          Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}