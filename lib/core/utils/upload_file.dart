import 'package:equatable/equatable.dart';

class UploadFile extends Equatable {
  const UploadFile({required this.path, required this.name, required this.size});

  final String path;
  final String name;
  final int size;

  @override
  List<Object?> get props => [path, name, size];
}
