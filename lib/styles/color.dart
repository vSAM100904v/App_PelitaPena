import 'dart:ui';
import "package:flutter/material.dart";

class AppColor {
  static const Color homePageBackground = Color(0xFFFFFFFF);
  static const Color descColor = Color(0xFFFFFFFF);
  static const Color primaryColor = Color(0xFF7FBC8C); // diperbaiki
  static const Color dangerColor = Color(0xFFFF0000);
  static const Color darkGreen = Color(0xFF22577a);
}

class AppTheme {
  final Color? appBarColor;
  final Color? backArrowColor;
  final Color? backgroundColor;
  final Color? replyDialogColor;
  final Color? replyTitleColor;
  final Color? textFieldBackgroundColor;

  final Color? outgoingChatBubbleColor;

  final Color? inComingChatBubbleColor;

  final Color? inComingChatBubbleTextColor;
  final Color? repliedMessageColor;
  final Color? repliedTitleTextColor;
  final Color? textFieldTextColor;

  final Color? closeIconColor;
  final Color? shareIconBackgroundColor;

  final Color? sendButtonColor;
  final Color? cameraIconColor;
  final Color? galleryIconColor;
  final Color? recordIconColor;
  final Color? stopIconColor;
  final Color? swipeToReplyIconColor;
  final Color? replyMessageColor;
  final Color? appBarTitleTextStyle;
  final Color? messageReactionBackGroundColor;
  final Color? messageTimeIconColor;
  final Color? messageTimeTextColor;
  final Color? reactionPopupColor;
  final Color? replyPopupColor;
  final Color? replyPopupButtonColor;
  final Color? replyPopupTopBorderColor;
  final Color? reactionPopupTitleColor;
  final Color? flashingCircleDarkColor;
  final Color? flashingCircleBrightColor;
  final Color? waveformBackgroundColor;
  final Color? waveColor;
  final Color? replyMicIconColor;
  final Color? messageReactionBorderColor;

  final Color? verticalBarColor;
  final Color? chatHeaderColor;
  final Color? themeIconColor;
  final Color? shareIconColor;
  final double? elevation;
  final Color? linkPreviewIncomingChatColor;
  final Color? linkPreviewOutgoingChatColor;
  final TextStyle? linkPreviewIncomingTitleStyle;
  final TextStyle? linkPreviewOutgoingTitleStyle;
  final TextStyle? incomingChatLinkTitleStyle;
  final TextStyle? outgoingChatLinkTitleStyle;
  final TextStyle? outgoingChatLinkBodyStyle;
  final TextStyle? incomingChatLinkBodyStyle;

  AppTheme({
    this.cameraIconColor,
    this.galleryIconColor,
    this.flashingCircleDarkColor,
    this.flashingCircleBrightColor,
    this.outgoingChatLinkBodyStyle,
    this.incomingChatLinkBodyStyle,
    this.incomingChatLinkTitleStyle,
    this.outgoingChatLinkTitleStyle,
    this.linkPreviewOutgoingChatColor,
    this.linkPreviewIncomingChatColor,
    this.linkPreviewIncomingTitleStyle,
    this.linkPreviewOutgoingTitleStyle,
    this.repliedTitleTextColor,
    this.swipeToReplyIconColor,
    this.textFieldTextColor,
    this.reactionPopupColor,
    this.replyPopupButtonColor,
    this.replyPopupTopBorderColor,
    this.reactionPopupTitleColor,
    this.appBarColor,
    this.backArrowColor,
    this.backgroundColor,
    this.replyDialogColor,
    this.replyTitleColor,
    this.textFieldBackgroundColor,
    this.outgoingChatBubbleColor,
    this.inComingChatBubbleColor,
    this.inComingChatBubbleTextColor,
    this.repliedMessageColor,
    this.closeIconColor,
    this.shareIconBackgroundColor,
    this.sendButtonColor,
    this.replyMessageColor,
    this.appBarTitleTextStyle,
    this.messageReactionBackGroundColor,
    this.messageReactionBorderColor,
    this.verticalBarColor,
    this.chatHeaderColor,
    this.themeIconColor,
    this.shareIconColor,
    this.elevation,
    this.messageTimeIconColor,
    this.messageTimeTextColor,
    this.replyPopupColor,
    this.recordIconColor,
    this.stopIconColor,
    this.waveformBackgroundColor,
    this.waveColor,
    this.replyMicIconColor,
  });
}

class DarkTheme extends AppTheme {
  DarkTheme({
    Color flashingCircleDarkColor = const Color(0xFF1565C0), // blue.shade800
    Color flashingCircleBrightColor = const Color(0xFFBBDEFB), // blue.shade100
    TextStyle incomingChatLinkTitleStyle = const TextStyle(
      color: Color(0xFF1E88E5),
    ), // blue.shade600
    TextStyle outgoingChatLinkTitleStyle = const TextStyle(
      color: Color(0xFFFFFFFF),
    ),
    TextStyle outgoingChatLinkBodyStyle = const TextStyle(
      color: Color(0xFFFFFFFF),
    ),
    TextStyle incomingChatLinkBodyStyle = const TextStyle(
      color: Color(0xFF1E88E5),
    ), // blue.shade600
    double elevation = 1,
    Color repliedTitleTextColor = const Color(0xFFFFFFFF),
    Color? swipeToReplyIconColor = const Color(0xFFFFFFFF),
    Color textFieldTextColor = const Color(0xFF1E88E5),
    Color appBarColor = const Color(0xFF1E88E5),
    Color backArrowColor = const Color(0xFFFFFFFF),
    Color backgroundColor = const Color(0xFFE3F2FD), // blue.shade50
    Color replyDialogColor = const Color(0xFFE3F2FD),
    Color linkPreviewOutgoingChatColor = const Color(0xFF1E88E5),
    Color linkPreviewIncomingChatColor = const Color(
      0xFF64B5F6,
    ), // blue.shade300
    TextStyle linkPreviewIncomingTitleStyle = const TextStyle(
      color: Color(0xFF1E88E5),
    ),
    TextStyle linkPreviewOutgoingTitleStyle = const TextStyle(
      color: Color(0xFFFFFFFF),
    ),
    Color replyTitleColor = const Color(0xFFFFFFFF),
    Color textFieldBackgroundColor = const Color(0xFF90CAF9), // blue.shade200
    Color outgoingChatBubbleColor = const Color(0xFF1E88E5),
    Color inComingChatBubbleColor = const Color(0xFF64B5F6),
    Color reactionPopupColor = const Color(0xFF90CAF9),
    Color replyPopupColor = const Color(0xFF90CAF9),
    Color replyPopupButtonColor = const Color(0xFF1E88E5),
    Color replyPopupTopBorderColor = const Color(0xFF1976D2), // blue.shade700
    Color reactionPopupTitleColor = const Color(0xFFFFFFFF),
    Color inComingChatBubbleTextColor = const Color(0xFFFFFFFF),
    Color repliedMessageColor = const Color(0xFF1E88E5),
    Color closeIconColor = const Color(0xFFFFFFFF),
    Color shareIconBackgroundColor = const Color(0xFF90CAF9),
    Color sendButtonColor = const Color(0xFFFFFFFF),
    Color cameraIconColor = const Color(0xFF42A5F5), // blue.shade400
    Color galleryIconColor = const Color(0xFF42A5F5),
    Color recorderIconColor = const Color(0xFF42A5F5),
    Color stopIconColor = const Color(0xFF42A5F5),
    Color replyMessageColor = const Color(0xFF90CAF9),
    Color appBarTitleTextStyle = const Color(0xFFFFFFFF),
    Color messageReactionBackGroundColor = const Color(0xFF90CAF9),
    Color messageReactionBorderColor = const Color(0xFFE3F2FD),
    Color verticalBarColor = const Color(0xFF90CAF9),
    Color chatHeaderColor = const Color(0xFFFFFFFF),
    Color themeIconColor = const Color(0xFFFFFFFF),
    Color shareIconColor = const Color(0xFFFFFFFF),
    Color messageTimeIconColor = const Color(0xFFFFFFFF),
    Color messageTimeTextColor = const Color(0xFFFFFFFF),
    Color waveformBackgroundColor = const Color(0xFF90CAF9),
    Color waveColor = const Color(0xFFFFFFFF),
    Color replyMicIconColor = const Color(0xFFFFFFFF),
  }) : super(
         closeIconColor: closeIconColor,
         verticalBarColor: verticalBarColor,
         textFieldBackgroundColor: textFieldBackgroundColor,
         replyTitleColor: replyTitleColor,
         replyDialogColor: replyDialogColor,
         backgroundColor: backgroundColor,
         appBarColor: appBarColor,
         appBarTitleTextStyle: appBarTitleTextStyle,
         backArrowColor: backArrowColor,
         chatHeaderColor: chatHeaderColor,
         inComingChatBubbleColor: inComingChatBubbleColor,
         inComingChatBubbleTextColor: inComingChatBubbleTextColor,
         messageReactionBackGroundColor: messageReactionBackGroundColor,
         messageReactionBorderColor: messageReactionBorderColor,
         outgoingChatBubbleColor: outgoingChatBubbleColor,
         repliedMessageColor: repliedMessageColor,
         replyMessageColor: replyMessageColor,
         sendButtonColor: sendButtonColor,
         shareIconBackgroundColor: shareIconBackgroundColor,
         themeIconColor: themeIconColor,
         shareIconColor: shareIconColor,
         elevation: elevation,
         messageTimeIconColor: messageTimeIconColor,
         messageTimeTextColor: messageTimeTextColor,
         textFieldTextColor: textFieldTextColor,
         repliedTitleTextColor: repliedTitleTextColor,
         swipeToReplyIconColor: swipeToReplyIconColor,
         reactionPopupColor: reactionPopupColor,
         replyPopupColor: replyPopupColor,
         replyPopupButtonColor: replyPopupButtonColor,
         replyPopupTopBorderColor: replyPopupTopBorderColor,
         reactionPopupTitleColor: reactionPopupTitleColor,
         linkPreviewOutgoingChatColor: linkPreviewOutgoingChatColor,
         linkPreviewIncomingChatColor: linkPreviewIncomingChatColor,
         linkPreviewIncomingTitleStyle: linkPreviewIncomingTitleStyle,
         linkPreviewOutgoingTitleStyle: linkPreviewOutgoingTitleStyle,
         incomingChatLinkBodyStyle: incomingChatLinkBodyStyle,
         incomingChatLinkTitleStyle: incomingChatLinkTitleStyle,
         outgoingChatLinkBodyStyle: outgoingChatLinkBodyStyle,
         outgoingChatLinkTitleStyle: outgoingChatLinkTitleStyle,
         flashingCircleDarkColor: flashingCircleDarkColor,
         flashingCircleBrightColor: flashingCircleBrightColor,
         galleryIconColor: galleryIconColor,
         cameraIconColor: cameraIconColor,
         recordIconColor: recorderIconColor,
         stopIconColor: stopIconColor,
         waveformBackgroundColor: waveformBackgroundColor,
         waveColor: waveColor,
         replyMicIconColor: replyMicIconColor,
       );
}

class LightTheme extends AppTheme {
  LightTheme({
    Color flashingCircleDarkColor = const Color(0xFF57CC99), // primary
    Color flashingCircleBrightColor = Colors.white,
    TextStyle incomingChatLinkTitleStyle = const TextStyle(
      color: Color(0xFF333333),
    ), // hampir hitam, netral
    TextStyle outgoingChatLinkTitleStyle = const TextStyle(color: Colors.white),
    TextStyle outgoingChatLinkBodyStyle = const TextStyle(
      color: Colors.white70,
    ),
    TextStyle incomingChatLinkBodyStyle = const TextStyle(
      color: Color(0xFF444444),
    ),
    Color textFieldTextColor = const Color(0xFF222222),
    Color repliedTitleTextColor = const Color(0xFF222222),
    Color swipeToReplyIconColor = const Color(0xFF57CC99),
    double elevation = 2,
    Color appBarColor = Colors.white,
    Color backArrowColor = const Color(0xFF57CC99),
    Color backgroundColor = Colors.white,
    Color replyDialogColor = const Color(0xFFF5F5F5), // putih keabuan lembut
    Color linkPreviewOutgoingChatColor = const Color(0xFFF5F5F5),
    Color linkPreviewIncomingChatColor = const Color(0xFFF9F9F9),
    TextStyle linkPreviewIncomingTitleStyle = const TextStyle(
      color: Color(0xFF333333),
    ),
    TextStyle linkPreviewOutgoingTitleStyle = const TextStyle(
      color: Color(0xFF57CC99),
    ),
    Color replyTitleColor = const Color(0xFF57CC99),
    Color reactionPopupColor = Colors.white,
    Color replyPopupColor = Colors.white,
    Color replyPopupButtonColor = const Color(0xFF57CC99),
    Color replyPopupTopBorderColor = const Color(0xFFE0E0E0),
    Color reactionPopupTitleColor = const Color(0xFF666666),
    Color textFieldBackgroundColor = const Color(0xFFF0F0F0),
    Color outgoingChatBubbleColor = const Color(0xFF57CC99),
    Color inComingChatBubbleColor = const Color(0xFFF0F0F0),
    Color inComingChatBubbleTextColor = const Color(0xFF222222),
    Color repliedMessageColor = const Color(0xFFB4EED2), // pastel soft green
    Color closeIconColor = const Color(0xFF444444),
    Color shareIconBackgroundColor = const Color(0xFFF0F0F0),
    Color sendButtonColor = const Color(0xFF57CC99),
    Color cameraIconColor = const Color(0xFF444444),
    Color galleryIconColor = const Color(0xFF444444),
    Color replyMessageColor = const Color(0xFF333333),
    Color appBarTitleTextStyle = const Color(0xFF222222),
    Color messageReactionBackGroundColor = const Color(0xFFF5F5F5),
    Color messageReactionBorderColor = Colors.white,
    Color verticalBarColor = const Color(0xFF57CC99),
    Color chatHeaderColor = const Color(0xFF222222),
    Color themeIconColor = const Color(0xFF444444),
    Color shareIconColor = const Color(0xFF444444),
    Color messageTimeIconColor = const Color(0xFF666666),
    Color messageTimeTextColor = const Color(0xFF666666),
    Color recorderIconColor = const Color(0xFF444444),
    Color stopIconColor = const Color(0xFF444444),
    Color waveformBackgroundColor = const Color(0xFFF9F9F9),
    Color waveColor = const Color(0xFF57CC99),
    Color replyMicIconColor = const Color(0xFF444444),
  }) : super(
         reactionPopupColor: reactionPopupColor,
         closeIconColor: closeIconColor,
         verticalBarColor: verticalBarColor,
         textFieldBackgroundColor: textFieldBackgroundColor,
         replyTitleColor: replyTitleColor,
         replyDialogColor: replyDialogColor,
         backgroundColor: backgroundColor,
         appBarColor: appBarColor,
         appBarTitleTextStyle: appBarTitleTextStyle,
         backArrowColor: backArrowColor,
         chatHeaderColor: chatHeaderColor,
         inComingChatBubbleColor: inComingChatBubbleColor,
         inComingChatBubbleTextColor: inComingChatBubbleTextColor,
         messageReactionBackGroundColor: messageReactionBackGroundColor,
         messageReactionBorderColor: messageReactionBorderColor,
         outgoingChatBubbleColor: outgoingChatBubbleColor,
         repliedMessageColor: repliedMessageColor,
         replyMessageColor: replyMessageColor,
         sendButtonColor: sendButtonColor,
         shareIconBackgroundColor: shareIconBackgroundColor,
         themeIconColor: themeIconColor,
         shareIconColor: shareIconColor,
         elevation: elevation,
         messageTimeIconColor: messageTimeIconColor,
         messageTimeTextColor: messageTimeTextColor,
         textFieldTextColor: textFieldTextColor,
         repliedTitleTextColor: repliedTitleTextColor,
         swipeToReplyIconColor: swipeToReplyIconColor,
         replyPopupColor: replyPopupColor,
         replyPopupButtonColor: replyPopupButtonColor,
         replyPopupTopBorderColor: replyPopupTopBorderColor,
         reactionPopupTitleColor: reactionPopupTitleColor,
         linkPreviewOutgoingChatColor: linkPreviewOutgoingChatColor,
         linkPreviewIncomingChatColor: linkPreviewIncomingChatColor,
         linkPreviewIncomingTitleStyle: linkPreviewIncomingTitleStyle,
         linkPreviewOutgoingTitleStyle: linkPreviewOutgoingTitleStyle,
         incomingChatLinkBodyStyle: incomingChatLinkBodyStyle,
         incomingChatLinkTitleStyle: incomingChatLinkTitleStyle,
         outgoingChatLinkBodyStyle: outgoingChatLinkBodyStyle,
         outgoingChatLinkTitleStyle: outgoingChatLinkTitleStyle,
         flashingCircleDarkColor: flashingCircleDarkColor,
         flashingCircleBrightColor: flashingCircleBrightColor,
         galleryIconColor: galleryIconColor,
         cameraIconColor: cameraIconColor,
         stopIconColor: stopIconColor,
         recordIconColor: recorderIconColor,
         waveformBackgroundColor: waveformBackgroundColor,
         waveColor: waveColor,
         replyMicIconColor: replyMicIconColor,
       );
}
