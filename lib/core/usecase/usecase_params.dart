import 'package:equatable/equatable.dart';

abstract class BaseParams extends Equatable {}

class NoParams extends BaseParams {
  NoParams._privateConstructor();

  static final NoParams _instance = NoParams._privateConstructor();

  factory NoParams() => _instance;

  @override
  List<Object?> get props => [];
}
