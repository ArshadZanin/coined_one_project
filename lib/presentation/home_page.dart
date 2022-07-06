import 'package:coined_one/application/schedule_list/schedule_list_bloc.dart';
import 'package:coined_one/domain/schedules/models/schedule_model.dart';
import 'package:coined_one/presentation/widgets/add_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  ValueNotifier<bool> showAddSchedule = ValueNotifier(false);
  // ValueNotifier<int> selectedIndex = ValueNotifier(0);
  ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());

  @override
  Widget build(BuildContext context) {
    context.read<ScheduleListBloc>().add(GetSchedule());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ValueListenableBuilder(
            valueListenable: selectedDate,
            builder: (context, index, _) {
              return BlocBuilder<ScheduleListBloc, ScheduleListState>(
                builder: (context, state) {
                  // DateTime date = state.schedules.isEmpty
                  //     ? DateTime.now()
                  //     : DateTime(
                  //         int.parse(state.schedules[selectedIndex.value].date
                  //                 ?.split('/')
                  //                 .last ??
                  //             DateTime.now().year.toString()),
                  //         int.parse(state.schedules[selectedIndex.value].date
                  //                 ?.split('/')[1] ??
                  //             DateTime.now().month.toString()),
                  //         int.parse(state.schedules[selectedIndex.value].date
                  //                 ?.split('/')
                  //                 .first ??
                  //             DateTime.now().day.toString()),
                  //       );
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          DateTime date = DateTime(
                            selectedDate.value.month == 1
                                ? selectedDate.value.year - 1
                                : selectedDate.value.year,
                            selectedDate.value.month == 1
                                ? 12
                                : selectedDate.value.month - 1,
                            1,
                          );
                          selectedDate.value = date;
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        DateFormat('MMMM yyyy')
                            .format(selectedDate.value)
                            .toUpperCase(),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () {
                          DateTime date = DateTime(
                            selectedDate.value.month == 12
                                ? selectedDate.value.year + 1
                                : selectedDate.value.year,
                            selectedDate.value.month == 12
                                ? 1
                                : selectedDate.value.month + 1,
                            1,
                          );
                          selectedDate.value = date;
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
          valueListenable: selectedDate,
          builder: (context, index, _) {
            return BlocBuilder<ScheduleListBloc, ScheduleListState>(
              builder: (context, state) {
                List<ScheduleModel> schedules = state.schedules
                    .where((element) =>
                        element.date ==
                        DateFormat('dd/MM/yyyy').format(selectedDate.value))
                    .toList();
                schedules.sort((a, b) => DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      int.parse(a.startTime!.split(':').first),
                      int.parse(a.startTime!.split(':')[1].substring(0, 1)),
                    ).compareTo(DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      int.parse(b.endTime!.split(':').first),
                      int.parse(b.endTime!.split(':')[1].substring(0, 1)),
                    )));
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: BlocBuilder<ScheduleListBloc, ScheduleListState>(
                        builder: (context, state) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 31,
                            itemBuilder: (context, index) {
                              DateTime date = DateTime(
                                selectedDate.value.year,
                                selectedDate.value.month,
                                index + 1,
                              );
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(DateFormat('EEE').format(date)),
                                    InkWell(
                                      onTap: () {
                                        // selectedIndex.value = index;
                                        selectedDate.value = date;
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: selectedDate.value.day ==
                                                          date.day &&
                                                      selectedDate
                                                              .value.month ==
                                                          date.month &&
                                                      selectedDate.value.year ==
                                                          date.year
                                                  // index == selectedIndex.value
                                                  ? Colors.blue
                                                  : Colors.white),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text('${index + 1}')),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    schedules.isEmpty
                        ? Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[200],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Center(
                                child: Text('No Schedules!'),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[200],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: ListView.separated(
                                primary: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.schedules
                                    .where((element) =>
                                        element.date ==
                                        DateFormat('dd/MM/yyyy')
                                            .format(selectedDate.value))
                                    .length,
                                itemBuilder: (context, index) {
                                  String selectedDay = DateFormat('dd/MM/yyyy')
                                      .format(selectedDate.value);
                                  DateTime startTime = DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    int.parse(schedules[index]
                                        .startTime!
                                        .split(':')
                                        .first),
                                    // DateTime.now().minute,
                                    int.parse(schedules[index]
                                        .startTime!
                                        .split(':')[1]
                                        .substring(0, 1)),
                                  );
                                  DateTime endTime = DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    int.parse(schedules[index]
                                        .endTime!
                                        .split(':')
                                        .first),
                                    // DateTime.now().minute,
                                    int.parse(schedules[index]
                                        .endTime!
                                        .split(':')[1]
                                        .substring(0, 1)),
                                  );

                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // print(state.schedules
                                            //     .where((element) =>
                                            //         element.date ==
                                            //         DateFormat('dd/MM/yyyy')
                                            //             .format(selectedDate.value))
                                            //     .toList()[index]
                                            //     .startTime!
                                            //     .split(':')[1]);
                                            // print(state.schedules
                                            //     .where((element) =>
                                            //         element.date ==
                                            //         DateFormat('dd/MM/yyyy')
                                            //             .format(selectedDate.value))
                                            //     .toList()[index]
                                            //     .endTime!
                                            //     .split(':')[1]);
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 400),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue,
                                                width: 1,
                                              ),
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.calendar_today_outlined,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${DateFormat('hh:mm aa').format(startTime)} - ${DateFormat('hh:mm aa').format(endTime)}',
                                              ),
                                              Text(
                                                schedules[index].name!,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) => Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 3),
                                          height: 5,
                                          width: 3,
                                          color: Colors.blue,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 3),
                                          height: 5,
                                          width: 3,
                                          color: Colors.blue,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 3),
                                          height: 5,
                                          width: 3,
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    // BlocBuilder<BottomSheetBloc, BottomSheetState>(
                    //   builder: (context, state) {
                    //     return state.showBottomSheet
                    //         ? AddScheduleWidget()
                    //         : const Offstage();
                    //   },
                    // ),
                    ValueListenableBuilder(
                      valueListenable: showAddSchedule,
                      builder: (BuildContext context, bool value, _) {
                        return value
                            ? AddScheduleWidget(
                                onClose: () {
                                  showAddSchedule.value = false;
                                },
                              )
                            : const Offstage();
                      },
                    ),
                  ],
                );
              },
            );
          }),
      floatingActionButton:
          // FloatingActionButton(
          //   onPressed: () {
          //     // context.read<BottomSheetBloc>().add(ShowAndHide());
          //     context.read<ScheduleListBloc>().add(GetSchedule());
          //   },
          //   child: const Icon(Icons.add),
          // ),
          ValueListenableBuilder(
        valueListenable: showAddSchedule,
        builder: (BuildContext context, bool value, _) {
          return !value
              ? FloatingActionButton(
                  onPressed: () {
                    showAddSchedule.value = !showAddSchedule.value;
                    // context.read<BottomSheetBloc>().add(ShowAndHide());
                    // context.read<ScheduleListBloc>().add(GetSchedule());
                  },
                  child: const Icon(Icons.add),
                )
              : const Offstage();
        },
      ),
      // floatingActionButton: BlocBuilder<BottomSheetBloc, BottomSheetState>(
      //   builder: (context, state) {
      //     return !state.showBottomSheet
      //         ? FloatingActionButton(
      //             onPressed: () {
      //               // context.read<BottomSheetBloc>().add(ShowAndHide());
      //               context.read<ScheduleListBloc>().add(GetSchedule());
      //             },
      //             child: const Icon(Icons.add),
      //           )
      //         : const Offstage();
      // },
      // ),
    );
  }
}
