import 'package:coined_one/application/schedule_list/schedule_list_bloc.dart';
import 'package:coined_one/domain/schedules/i_schedules_repo.dart';
import 'package:coined_one/presentation/widgets/validation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/schedules/models/schedule_model.dart';

class AddScheduleWidget extends StatelessWidget {
  Function() onClose;
  AddScheduleWidget({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  final namecontroller = TextEditingController();
  ValueNotifier<DateTime> startTime = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime> endTime =
      ValueNotifier(DateTime.now().add(const Duration(hours: 1)));
  ValueNotifier<DateTime> date = ValueNotifier(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Schedule',
                    style: TextStyle(color: Colors.blue, fontSize: 24),
                  ),
                  IconButton(
                    onPressed: () {
                      onClose();
                      validationAlertBox(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Text('Name'),
              TextFormField(
                controller: namecontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const Text('Date & Time'),
              ValueListenableBuilder(
                  valueListenable: startTime,
                  builder: (context, index, _) {
                    return ListTile(
                      onTap: () => _selectTime(context, true),
                      tileColor: Colors.blue[100],
                      title: const Text('Start Time'),
                      trailing: Text(
                        DateFormat('hh:mmaa').format(startTime.value),
                        style: const TextStyle(color: Colors.blue),
                      ),
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: endTime,
                  builder: (context, index, _) {
                    return ListTile(
                      onTap: () => _selectTime(context, false),
                      tileColor: Colors.blue[100],
                      title: const Text('End Time'),
                      trailing: Text(
                        DateFormat('hh:mmaa').format(endTime.value),
                        style: const TextStyle(color: Colors.blue),
                      ),
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: date,
                  builder: (context, index, _) {
                    return ListTile(
                      onTap: () => _selectDate(context),
                      tileColor: Colors.blue[100],
                      title: const Text('Date'),
                      trailing: Text(
                        DateFormat('dd/MM/yyyy').format(date.value),
                        style: const TextStyle(color: Colors.blue),
                      ),
                    );
                  }),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    ScheduleListState state =
                        BlocProvider.of<ScheduleListBloc>(context).state;
                    List<ScheduleModel> schedules = state.schedules
                        .where((element) =>
                            element.date ==
                            DateFormat('dd/MM/yyyy').format(date.value))
                        .toList();

                    int flag = 0;

                    for (var schedule in schedules) {
                      String start = schedule.startTime!;
                      String end = schedule.endTime!;
                      DateTime scheduleStartTime = DateTime(
                        startTime.value.year,
                        startTime.value.month,
                        startTime.value.day,
                        int.parse(start.split(':').first),
                        int.parse(start.split(':')[1].substring(0, 1)),
                      );
                      DateTime scheduleEndTime = DateTime(
                        endTime.value.year,
                        endTime.value.month,
                        endTime.value.day,
                        int.parse(end.split(':').first),
                        int.parse(end.split(':')[1].substring(0, 1)),
                      );

                      if (startTime.value.isBefore(scheduleStartTime) &&
                          endTime.value.isAfter(scheduleStartTime)) {
                        flag = 1;
                        break;
                      }
                      if (startTime.value.isBefore(scheduleEndTime) &&
                          endTime.value.isAfter(scheduleEndTime)) {
                        flag = 1;
                        break;
                      }
                      if (startTime.value == scheduleEndTime ||
                          endTime.value == scheduleEndTime) {
                        flag = 1;
                        break;
                      }
                    }
                    if (flag == 1) {
                      validationAlertBox(context);
                      onClose();
                    } else {
                      ISchedulesRepo schedule = ISchedulesRepo();
                      await schedule.setSchedule(
                        name: namecontroller.text,
                        startTime:
                            DateFormat('HH:mm aa').format(startTime.value),
                        endTime: DateFormat('HH:mm aa').format(endTime.value),
                        date: DateFormat('dd/MM/yyyy').format(date.value),
                      );
                      // ignore: use_build_context_synchronously
                      context.read<ScheduleListBloc>().add(GetSchedule());
                      onClose();
                    }
                  },
                  child: const Text('Add Schedule'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: startTime.value,
      firstDate: startTime.value,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selectedDate == null) return;
    date.value = selectedDate;
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: isStart
          ? TimeOfDay.fromDateTime(
              startTime.value.add(
                const Duration(minutes: 5),
              ),
            )
          : TimeOfDay.fromDateTime(
              endTime.value.add(
                const Duration(minutes: 15),
              ),
            ),
    );

    if (selectedTime == null) return;
    if (isStart) {
      startTime.value = DateTime(
        startTime.value.year,
        startTime.value.month,
        startTime.value.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    } else {
      endTime.value = DateTime(
        endTime.value.year,
        endTime.value.month,
        endTime.value.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    }
  }
}
