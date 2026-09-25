import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/doctor_controller.dart';
import '../../../appointment/controllers/appointment_controller.dart';

class DoctorDetailsPage extends StatefulWidget {
  final String doctorId;

  const DoctorDetailsPage({
    super.key,
    required this.doctorId,
  });

  @override
  State<DoctorDetailsPage> createState() =>
      _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  final DoctorController doctorController =
      Get.find<DoctorController>();

  final AppointmentController appointmentController =
      Get.find<AppointmentController>();

  int? selectedDateIndex;
  String? selectedTime;

  @override
  void initState() {
    super.initState();

    doctorController.loadDoctorDetails(widget.doctorId);
  }

  // ============================================================
  // ONLY SHOW TODAY + FUTURE DATES
  // ============================================================

  List<dynamic> get _validAvailability {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final availability =
        doctorController.selectedDoctor.value?.availability;

    if (availability == null) {
      return [];
    }

    return availability.where((item) {
      final availabilityDate = DateTime(
        item.date.year,
        item.date.month,
        item.date.day,
      );

      return !availabilityDate.isBefore(today);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF111827),
          ),
          onPressed: () {
            if (Get.key.currentState?.canPop() ?? false) {
              Get.back();
            } else {
              Get.offAllNamed('/patient-home');
            }
          },
        ),

        title: const Text(
          'Doctor Details',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: Obx(() {
        if (doctorController.isDetailsLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (doctorController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    doctorController.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final doctor =
            doctorController.selectedDoctor.value;

        if (doctor == null) {
          return const Center(
            child: Text('Doctor not found'),
          );
        }

        // Get filtered availability once for this build.
        final validAvailability = _validAvailability;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            120,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==================================================
              // DOCTOR PROFILE CARD
              // ==================================================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF1D4ED8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  borderRadius: BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.20),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    // Doctor image
                    _doctorImage(
                      doctor.image,
                      large: true,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      doctor.name,
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      doctor.specialization,
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [

                        Expanded(
                          child: _profileInfo(
                            Icons.work_outline,
                            '${doctor.experience} Years',
                            'Experience',
                          ),
                        ),

                        Container(
                          height: 45,
                          width: 1,
                          color: Colors.white24,
                        ),

                        Expanded(
                          child: _profileInfo(
                            Icons.medical_services_outlined,
                            doctor.categoryName ??
                                'General',
                            'Department',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // CONTACT INFORMATION
              // ==================================================

              const Text(
                'Doctor Information',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 14),

              _informationCard(
                icon: Icons.email_outlined,
                title: 'Email',
                value: doctor.email,
              ),

              const SizedBox(height: 10),

              _informationCard(
                icon: Icons.phone_outlined,
                title: 'Phone',
                value: doctor.phone,
              ),

              const SizedBox(height: 28),

              // ==================================================
              // DATE
              // ==================================================

              const Text(
                'Select Date',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Choose an available date for your appointment.',

                style: TextStyle(
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 14),

              // ==================================================
              // DATE LIST
              // ==================================================

              if (validAvailability.isEmpty)
                _emptyAvailability(),

              if (validAvailability.isNotEmpty)
                SizedBox(
                  height: 105,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: validAvailability.length,

                    itemBuilder: (context, index) {
                      final availability =
                          validAvailability[index];

                      final isSelected =
                          selectedDateIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDateIndex = index;
                            selectedTime = null;
                          });
                        },

                        child: Container(
                          width: 105,

                          margin: const EdgeInsets.only(
                            right: 12,
                          ),

                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2563EB)
                                : Colors.white,

                            borderRadius:
                                BorderRadius.circular(18),

                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFFE5E7EB),
                            ),

                            boxShadow: [
                              if (!isSelected)
                                BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black
                                      .withOpacity(0.04),
                                ),
                            ],
                          ),

                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              Text(
                                DateFormat('EEE').format(
                                  availability.date,
                                ),

                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white70
                                      : Colors.grey,

                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                DateFormat('dd').format(
                                  availability.date,
                                ),

                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(
                                          0xFF111827,
                                        ),

                                  fontSize: 25,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              Text(
                                DateFormat('MMM').format(
                                  availability.date,
                                ),

                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white70
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // ==================================================
              // TIME SLOTS
              // ==================================================

              if (selectedDateIndex != null &&
                  selectedDateIndex! >= 0 &&
                  selectedDateIndex! <
                      validAvailability.length) ...[
                const SizedBox(height: 28),

                const Text(
                  'Select Time',

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Choose a convenient appointment time.',

                  style: TextStyle(
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 14),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,

                  children: validAvailability[
                          selectedDateIndex!]
                      .slots
                      .map<Widget>(
                    (slot) {
                      final isSelected =
                          selectedTime == slot;

                      return ChoiceChip(
                        label: Padding(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),

                          child: Text(
                            slot,

                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(
                                      0xFF111827,
                                    ),

                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),

                        selected: isSelected,

                        selectedColor:
                            const Color(0xFF2563EB),

                        backgroundColor:
                            Colors.white,

                        side: BorderSide(
                          color: isSelected
                              ? const Color(
                                  0xFF2563EB,
                                )
                              : const Color(
                                  0xFFE5E7EB,
                                ),
                        ),

                        onSelected: (_) {
                          setState(() {
                            selectedTime = slot;
                          });
                        },
                      );
                    },
                  ).toList(),
                ),
              ],

              const SizedBox(height: 30),

              // ==================================================
              // BOOK BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 55,

                child: Obx(
                  () => ElevatedButton.icon(
                    onPressed:
                        appointmentController
                                .isLoading.value
                            ? null
                            : selectedDateIndex != null &&
                                    selectedDateIndex! >= 0 &&
                                    selectedDateIndex! <
                                        validAvailability.length &&
                                    selectedTime != null
                                ? _showBookingDialog
                                : null,

                    icon: appointmentController
                            .isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,

                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.calendar_month,
                          ),

                    label: Text(
                      appointmentController
                              .isLoading.value
                          ? 'Booking Appointment...'
                          : 'Book Appointment',

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF2563EB),

                      foregroundColor:
                          Colors.white,

                      disabledBackgroundColor:
                          Colors.grey.shade300,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ============================================================
  // BOOKING DIALOG
  // ============================================================

  Future<void> _showBookingDialog() async {
    final doctor =
        doctorController.selectedDoctor.value;

    final validAvailability =
        _validAvailability;

    if (doctor == null ||
        selectedDateIndex == null ||
        selectedTime == null ||
        selectedDateIndex! < 0 ||
        selectedDateIndex! >=
            validAvailability.length) {
      return;
    }

    final availability =
        validAvailability[selectedDateIndex!];

    final reasonController =
        TextEditingController();

    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        title: const Text(
          'Book Appointment',

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              doctor.name,

              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              '${DateFormat('EEE, dd MMM yyyy').format(
                availability.date,
              )} • $selectedTime',

              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Reason for visit',

              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: reasonController,

              maxLines: 3,

              decoration: InputDecoration(
                hintText:
                    'Enter your reason (optional)',

                filled: true,

                fillColor:
                    const Color(0xFFF7F9FC),

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),
          ],
        ),

        actions: [

          TextButton(
            onPressed: () {
              Get.back(result: false);
            },

            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },

            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF2563EB),

              foregroundColor:
                  Colors.white,
            ),

            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (result != true) {
      reasonController.dispose();
      return;
    }

    final success =
        await appointmentController.bookAppointment(
      doctorId: doctor.id,

      date: availability.date,

      time: selectedTime!,

      reason: reasonController.text,
    );

    reasonController.dispose();

    if (!mounted) return;

    if (success) {
      Get.snackbar(
        'Appointment Confirmed',

        'Your appointment with ${doctor.name} has been booked.',

        snackPosition:
            SnackPosition.BOTTOM,

        backgroundColor:
            Colors.green,

        colorText:
            Colors.white,

        margin:
            const EdgeInsets.all(16),

        borderRadius:
            12,
      );

      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );

      Get.offNamed(
        '/my-appointments',
      );
    } else {
      Get.snackbar(
        'Booking Failed',

        appointmentController
            .errorMessage.value,

        snackPosition:
            SnackPosition.BOTTOM,

        backgroundColor:
            Colors.red,

        colorText:
            Colors.white,

        margin:
            const EdgeInsets.all(16),

        borderRadius:
            12,
      );
    }
  }

  // ============================================================
  // DOCTOR IMAGE
  // ============================================================

  Widget _doctorImage(
    String image, {
    bool large = false,
  }) {
    final size =
        large ? 105.0 : 70.0;

    if (image.isEmpty) {
      return Container(
        width: size,
        height: size,

        decoration: BoxDecoration(
          color: Colors.white
              .withOpacity(0.18),

          shape:
              BoxShape.circle,
        ),

        child: Icon(
          Icons.medical_services_rounded,

          size:
              large ? 50 : 35,

          color:
              Colors.white,
        ),
      );
    }

    return ClipOval(
      child: Image.network(
        image,

        width: size,
        height: size,

        fit:
            BoxFit.cover,

        errorBuilder:
            (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,

            color: Colors.white
                .withOpacity(0.18),

            child: Icon(
              Icons.medical_services_rounded,

              size:
                  large ? 50 : 35,

              color:
                  Colors.white,
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // PROFILE INFO
  // ============================================================

  Widget _profileInfo(
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [

        Icon(
          icon,

          color:
              Colors.white,

          size:
              22,
        ),

        const SizedBox(height: 5),

        Text(
          value,

          textAlign:
              TextAlign.center,

          style:
              const TextStyle(
            color:
                Colors.white,

            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,

          style:
              const TextStyle(
            color:
                Colors.white70,

            fontSize:
                12,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INFORMATION CARD
  // ============================================================

  Widget _informationCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(15),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          Container(
            padding:
                const EdgeInsets.all(10),

            decoration:
                BoxDecoration(
              color:
                  const Color(0xFFE8F0FE),

              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Icon(
              icon,

              color:
                  const Color(0xFF2563EB),

              size:
                  21,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style:
                      const TextStyle(
                    color:
                        Color(0xFF6B7280),

                    fontSize:
                        12,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value.isEmpty
                      ? 'Not available'
                      : value,

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w600,

                    color:
                        Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY AVAILABILITY
  // ============================================================

  Widget _emptyAvailability() {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(25),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: const Column(
        children: [

          Icon(
            Icons.event_busy_outlined,

            size:
                42,

            color:
                Colors.grey,
          ),

          SizedBox(height: 10),

          Text(
            'No available appointments',

            style:
                TextStyle(
              fontWeight:
                  FontWeight.w600,

              color:
                  Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

