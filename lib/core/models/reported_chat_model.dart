class ReportedChat {
  final int id;
  final String reportId;
  final int reporterId;
  final int reportedUserId;
  final String chatMessageId;
  final String messageContent;
  final String reportType;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? updatedBy;
  final String? deletedAt;
  final String reporterUsername;
  final String reportedUserUsername;
  final String noRegistrasi;
  final DateTime tanggalPelaporan;

  ReportedChat({
    required this.id,
    required this.reportId,
    required this.reporterId,
    required this.reportedUserId,
    required this.chatMessageId,
    required this.messageContent,
    required this.reportType,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    required this.reporterUsername,
    required this.reportedUserUsername,
    required this.noRegistrasi,
    required this.tanggalPelaporan,
  });

  factory ReportedChat.fromJson(Map<String, dynamic> json) {
    return ReportedChat(
      id: json['ID'] as int,
      reportId: json['ReportID'] as String,
      reporterId: json['ReporterID'] as int,
      reportedUserId: json['ReportedUserID'] as int,
      chatMessageId: json['ChatMessageID'] as String,
      messageContent: json['MessageContent'] as String,
      reportType: json['ReportType'] as String,
      status: json['Status'] as String,
      notes: json['Notes'] as String?,
      createdAt: DateTime.parse(json['CreatedAt'] as String),
      updatedAt: DateTime.parse(json['UpdatedAt'] as String),
      updatedBy: json['UpdatedBy'] as int?,
      deletedAt: json['DeletedAt'] as String?,
      reporterUsername: json['reporter_username'] as String? ?? 'Unknown',
      reportedUserUsername:
          json['reported_user_username'] as String? ?? 'Unknown',
      noRegistrasi: json['ReportID'] as String,
      tanggalPelaporan: DateTime.parse(json['CreatedAt'] as String),
    );
  }
}
