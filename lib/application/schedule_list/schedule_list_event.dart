part of 'schedule_list_bloc.dart';

@immutable
abstract class ScheduleListEvent {}

class SetSchedule extends ScheduleListEvent {}

class GetSchedule extends ScheduleListEvent {}