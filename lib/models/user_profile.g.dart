// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 10;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      displayName: fields[0] as String,
      firstLaunch: fields[1] as bool,
      cloudConnected: fields[2] as bool,
      email: fields[3] as String?,
      photoUrl: fields[4] as String?,
      appVersion: fields[5] as String,
      pinEnabled: fields[6] as bool,
      pinCode: fields[7] as String?,
      autoLockMinutes: fields[8] as int,
      lastUnlockTime: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.displayName)
      ..writeByte(1)
      ..write(obj.firstLaunch)
      ..writeByte(2)
      ..write(obj.cloudConnected)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.photoUrl)
      ..writeByte(5)
      ..write(obj.appVersion)
      ..writeByte(6)
      ..write(obj.pinEnabled)
      ..writeByte(7)
      ..write(obj.pinCode)
      ..writeByte(8)
      ..write(obj.autoLockMinutes)
      ..writeByte(9)
      ..write(obj.lastUnlockTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
