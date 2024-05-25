part of 'room_creation_cubit.dart';

@immutable
sealed class RoomCreationState {}

final class RoomCreationInitial extends RoomCreationState {}

final class RoomCreationLoading extends RoomCreationState {}

final class RoomCreationSuccess extends RoomCreationState {}

final class RoomCreationFailure extends RoomCreationState {
  final String errorMessage;

  RoomCreationFailure({required this.errorMessage});
}
