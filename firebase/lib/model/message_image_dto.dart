import 'package:equatable/equatable.dart';

class MessageImageDto extends Equatable {
  final int order;
  final String fileName;

  const MessageImageDto({required this.order, required this.fileName});

  MessageImageDto.fromJson(Map<String, dynamic>? json)
      : this(
          order: json?[_orderField],
          fileName: json?[_fileNameField],
        );

  @override
  List<Object?> get props => [order, fileName];

  Map<String, dynamic> toJson() => {
        _orderField: order,
        _fileNameField: fileName,
      };
}

const String _orderField = 'order';
const String _fileNameField = 'fileName';
