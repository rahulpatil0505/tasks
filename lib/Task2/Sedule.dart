// ignore_for_file: unused_local_variable, prefer_const_declarations

import 'package:flutter/material.dart';
import 'dart:convert';

class VetScheduleScreen extends StatefulWidget {
  @override
  _VetScheduleScreenState createState() => _VetScheduleScreenState();
}

class _VetScheduleScreenState extends State<VetScheduleScreen> {
  List<ScheduleDay> _userSchedules = [];
  final clinicSchedule = json.decode(clinicScheduleJson);
  final vetSchedule = json.decode(vetScheduleJson);

  @override
  void initState() {
    super.initState();
    _loadUserSchedules();
  }

  void _loadUserSchedules() {
    List<dynamic> vetDays = vetSchedule['vetSchedule']['clinic']['day'];

    for (var day in vetDays) {
      List<dynamic> vetSchedules = day['schedule'];
      for (var schedule in vetSchedules) {
        _userSchedules.add(
          ScheduleDay(
            day['number'],
            day['name'],
            TimeOfDay(
              hour: int.parse(schedule['start'].split(':')[0]),
              minute: int.parse(schedule['start'].split(':')[1]),
            ),
            TimeOfDay(
              hour: int.parse(schedule['end'].split(':')[0]),
              minute: int.parse(schedule['end'].split(':')[1]),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: const Text("Schedule Task"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var scheduleDay in _userSchedules)
              _buildScheduleCard(scheduleDay),
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () => _showAddScheduleDialog(),
                child: const Text("Add Schedule"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleDay scheduleDay) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(scheduleDay.name),
        subtitle: Text(
          "${_formatTime(scheduleDay.startTime)} - ${_formatTime(scheduleDay.endTime)}",
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Color.fromARGB(255, 244, 54, 54),
          ),
          onPressed: () => _removeSchedule(scheduleDay),
        ),
      ),
    );
  }

  void _showAddScheduleDialog() {
    List<String> days = clinicSchedule['day']
        .map<String>((day) => day['name'].toString())
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        TimeOfDay startTime = TimeOfDay.now();
        TimeOfDay endTime = TimeOfDay.now();
        List<String> selectedDays = [];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: const Text("Add Schedule"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Days:"),
                  Wrap(
                    children: days
                        .map(
                          (day) => FilterChip(
                            label: Text(day),
                            selected: selectedDays.contains(day),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedDays.add(day);
                                } else {
                                  selectedDays.remove(day);
                                }
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text("Start Time:"),
                  _buildTimePicker(
                    time: startTime,
                    onTimeChanged: (time) => startTime = time,
                  ),
                  const SizedBox(height: 16),
                  const Text("End Time:"),
                  _buildTimePicker(
                    time: endTime,
                    onTimeChanged: (time) => endTime = time,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    _addSchedule(startTime, endTime, selectedDays);
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTimePicker({
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onTimeChanged,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey.shade600,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      onPressed: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (pickedTime != null && pickedTime != time) {
          onTimeChanged(pickedTime);
        }
      },
      child: Text(_formatTime(time)),
    );
  }

  void _addSchedule(TimeOfDay startTime, TimeOfDay endTime, List<String> days) {
    // Validation a) Entered schedule should be valid as per clinic timings
    bool isScheduleValid = _validateSchedule(startTime, endTime, days);

    if (isScheduleValid) {
      for (var day in days) {
        int dayNumber =
            clinicSchedule['day'].firstWhere((d) => d['name'] == day)['number'];

        _userSchedules.add(
          ScheduleDay(
            dayNumber,
            day,
            startTime,
            endTime,
          ),
        );
      }
      setState(() {});
    }
  }

  bool _validateSchedule(
      TimeOfDay startTime, TimeOfDay endTime, List<String> days) {
    // Validation a) Entered schedule should be valid as per clinic timings
    for (var day in days) {
      var clinicDay = clinicSchedule['day']
          .firstWhere((d) => d['name'] == day, orElse: () => null);
      if (clinicDay != null) {
        var clinicStart = TimeOfDay(
          hour: int.parse(clinicDay['schedule'][0]['start'].split(':')[0]),
          minute: int.parse(clinicDay['schedule'][0]['start'].split(':')[1]),
        );
        var clinicEnd = TimeOfDay(
          hour: int.parse(clinicDay['schedule'][0]['end'].split(':')[0]),
          minute: int.parse(clinicDay['schedule'][0]['end'].split(':')[1]),
        );

        if (!_checkTimeWithinSchedule(
            startTime, endTime, clinicStart, clinicEnd)) {
          _showErrorDialog("Clinic is not open in between entered schedule.");
          return false;
        }
      }
    }

    // Validation b) Entered schedule should not clash with any currently entered schedule.
    for (var schedule in _userSchedules) {
      if (days.contains(schedule.name)) {
        if (_checkClash(
            startTime, endTime, schedule.startTime, schedule.endTime)) {
          _showErrorDialog("Entered schedule clashes with current schedule.");
          return false;
        }
      }
    }

    return true;
  }

  bool _checkClash(
    TimeOfDay startTime1,
    TimeOfDay endTime1,
    TimeOfDay startTime2,
    TimeOfDay endTime2,
  ) {
    final start1 = startTime1.hour * 60 + startTime1.minute;
    final end1 = endTime1.hour * 60 + endTime1.minute;
    final start2 = startTime2.hour * 60 + startTime2.minute;
    final end2 = endTime2.hour * 60 + endTime2.minute;

    return (start1 < end2 && start2 < end1);
  }

  bool _checkTimeWithinSchedule(
    TimeOfDay startTime,
    TimeOfDay endTime,
    TimeOfDay scheduleStart,
    TimeOfDay scheduleEnd,
  ) {
    final start = startTime.hour * 60 + startTime.minute;
    final end = endTime.hour * 60 + endTime.minute;
    final scheduleStartTime = scheduleStart.hour * 60 + scheduleStart.minute;
    final scheduleEndTime = scheduleEnd.hour * 60 + scheduleEnd.minute;

    return (start >= scheduleStartTime && end <= scheduleEndTime);
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        elevation: 15.00,
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 196, 25, 25),
      ),
    );
  }

  void _removeSchedule(ScheduleDay scheduleDay) {
    _userSchedules.remove(scheduleDay);
    setState(() {});
  }

  String _formatTime(TimeOfDay time) {
    final formatter = TimeOfDayFormat.HH_colon_mm;
    return time.format(context);
  }
}

class ScheduleDay {
  final int dayNumber;
  final String name;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  ScheduleDay(this.dayNumber, this.name, this.startTime, this.endTime);
}

// ... (JSON data remains the same as provided before)
const clinicScheduleJson = '''
{
  "id": 1,
  "name": "john's clinic",
  "day": [
    {
      "number": 1,
      "name": "Monday",
      "schedule": [
        {
          "start": "08:00",
          "end": "20:00"
        }
      ]
    },
    {
      "number": 2,
      "name": "Tuesday",
      "schedule": [
        {
          "start": "08:00",
          "end": "20:00"
        }
      ]
    },
    {
      "number": 3,
      "name": "Wednesday",
      "schedule": [
        {
          "start": "08:00",
          "end": "11:00"
        },
        {
          "start": "13:00",
          "end": "20:00"
        }
      ]
    },
    {
      "number": 4,
      "name": "Thursday",
      "schedule": [
        {
          "start": "08:00",
          "end": "20:00"
        }
      ]
    },
    {
      "number": 5,
      "name": "Friday",
      "schedule": [
        {
          "start": "08:00",
          "end": "20:00"
        }
      ]
    },
    {
      "number": 6,
      "name": "Saturday",
      "schedule": [
        {
          "start": "08:00",
          "end": "15:00"
        }
      ]
    }
  ]
}
''';

const vetScheduleJson = '''
{
  "id": 1,
  "name": "Aric Michell",
  "vetSchedule": {
    "clinic": {
      "clinic_id": 1,
      "day": [
        {
          "number": 1,
          "name": "Monday",
          "schedule": [
            {
              "start": "09:00",
              "end": "15:00"
            }
          ]
        },
        {
          "number": 2,
          "name": "Tuesday",
          "schedule": [
            {
              "start": "09:00",
              "end": "15:00"
            }
          ]
        },
        {
          "number": 3,
          "name": "Wednesday",
          "schedule": [
            {
              "start": "09:00",
              "end": "10:00"
            },
            {
              "start": "14:00",
              "end": "15:00"
            }
          ]
        },
        {
          "number": 4,
          "name": "Thursday",
          "schedule": [
            {
              "start": "09:00",
              "end": "15:00"
            }
          ]
        },
        {
          "number": 5,
          "name": "Friday",
          "schedule": [
            {
              "start": "09:00",
              "end": "15:00"
            }
          ]
        },
        {
          "number": 6,
          "name": "Saturday",
          "schedule": [
            {
              "start": "09:00",
              "end": "13:00"
            }
          ]
        }
      ]
    }
  }
}
''';
