import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ximu3_app/core/utils/strings.dart';

import '../../features/data_logger/data/model/session.model.dart';

class Utils {
  static String sessionDateFormat(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  static String zipDateFormat(DateTime date) {
    return DateFormat('yyyy-MM-dd HH-mm-ss').format(date);
  }

  static String sessionKey(String sessionName) {
    return sessionName.replaceAll(":", "-");
  }

  static String formatSize(double? kb) {
    if ((kb ?? 0) < 1024) {
      return "${kb?.toStringAsFixed(0)} KB";
    } else {
      double mb = (kb ?? 0) / 1024;
      return "${mb.toStringAsFixed(2)} MB";
    }
  }

  static Future<void> shareSession(Session session) async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      String key = Utils.sessionKey(session.name);

      final zipPath = "${directory.path}/$key.zip";

      await Share.shareXFiles([XFile(zipPath)], subject: session.name);
    } catch (e) {
      print('$e');
    }
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');
    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = threeDigits(duration.inMilliseconds.remainder(1000));
    return "$hours:$minutes:$seconds.$milliseconds";
  }

  static Future<String> calculateStorageUsage() async {
    final directory = await getApplicationDocumentsDirectory();
    int totalSizeBytes = 0;

    try {
      final dataLoggerFolder = Directory(directory.path);

      if (await dataLoggerFolder.exists()) {
        await for (final entity in dataLoggerFolder.list(recursive: true, followLinks: false)) {
          if (entity is File && entity.path.endsWith('.zip')) {
            final fileStat = await entity.stat();
            totalSizeBytes += fileStat.size;
          }
        }
      }
    } catch (e) {
      print('Error calculating storage usage: $e');
    }

    double totalSizeKB = totalSizeBytes / 1024;

    return '${Strings.storageUsed}: ${Utils.formatSize(totalSizeKB)}';
  }

  static Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  static getSvgIcon(String icon) {
    return SvgPicture.asset(
      icon,
      width: 20,
      height: 20,
    );
  }
}
