// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_expense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectExpenseAdapter extends TypeAdapter<ProjectExpense> {
  @override
  final int typeId = 8;

  @override
  ProjectExpense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectExpense(
      title: fields[0] as String,
      amount: fields[1] as double,
      description: fields[2] as String,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectExpense obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
