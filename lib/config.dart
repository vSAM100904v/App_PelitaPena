class Config {
  static const String maleFallbackImage =
      "https://avatar.iran.liara.run/public/boy";
  static const String femaleFallbackImage =
      "https://avatar.iran.liara.run/public/girl";

  // Base API URL

  // // ! For Deployment Server
  //   static const String apiUrl =
  //       "https://backendpelitapena-production.up.railway.app";
  // ! For Devlopment Server
  // static const String apiUrl = "http://172.30.40.85:8080";
  // static const String apiUrl = "http://172.28.0.190:8080";

  static const String apiUrl = "https://gopelitapena-production.up.railway.app";

  static const String AREA_API =
      "https://www.emsifa.com/api-wilayah-indonesia/api/districts/1206.json";
  static const String PROVINCES = "provinces";
  static const String CITIES = "regencies";
  static const String DISTRICTS = "districts";
  static const String SUB_DISTRICTS = "villages";

  // Autentikasi
  static const String loginAPI = "/api/user/login";
  static const String registerAPI = "/api/user/register";
  static const String forgotPassdword = "/api/masyarakat/lupa-sandi";
  static const String userProfileAPI = "/api/masyarakat/profile";

  // Tambahkan endpoint untuk admin (mengambil seluruh laporan)
  static const String GetLatestReports = "/api/admin/laporans-pagination";

  // Form DPMADPPA
  static const String getFormAPIDPMADPPA =
      "/api/pelaporan-masyarakat-ke-dinas/";
  static const String postFormAPIDPMADPPA =
      "/api/pelaporan-masyarakat-ke-dinas/";
  static const String getFormByIdAPIDPMADPPA =
      "/api/pelaporan-masyarakat-ke-dinas/";

  static const String getFormAPIPolice = "/api/pelaporan-masyarakat-ke-polisi/";
  static const String postFormAPIPolice =
      "/api/pelaporan-masyarakat-ke-polisi/";
  static const String getFormByIdAPIPolice =
      "/api/pelaporan-masyarakat-ke-polisi/";

  static const String getViolenceCategory =
      "/api/masyarakat/kategori-kekerasan";

  static const String postReport = "/api/masyarakat/buat-laporan";

  static const String updateNotificationToken =
      "/api/masyarakat/update-notification-token";
  static const String postReportKorban =
      "/api/masyarakat/create-korban-kekerasan";
  static const String getReportByUser = "/api/masyarakat/laporans";
  static const String getDetailReportByUser = "/api/masyarakat/detail-laporan";
  static const String cancelReport = "/api/masyarakat/batalkan-laporan";
  static const String changePassword = "/api/masyarakat/change-password";
  static const String createJanjiTemu = "/api/masyarakat/create-janjitemu";
  static const String getJanjiTemu = "/api/masyarakat/janjitemus";
  static const String editJanjiTemu = "/api/masyarakat/edit-janjitemu";
  static const String batalJanjiTemu = "/api/masyarakat/batal-janjitemu";
  static const String editProfil = "/api/masyarakat/edit-profile";
  static const String ResetPassword = "/api/publik/forgot-password";

  static const String getContent = "/api/publik-content";
  static const String getEventContent = "/api/publik-event";
  // Endpoint tambahan untuk emergency contacts dan donations
  static const String emergencyContactAPI = "/api/admin/emergency-contact";
  static const String editEmergencyContactAPI =
      "/api/admin/emergency-contact-edit";
  static const String donationsAPI = "/api/donations";
  static const String retrieveUserNotification =
      "/api/masyarakat/retrieve-notification";
  static const String retrieveUnreadNotificationCount =
      "/api/masyarakat/unread-notification-count";

  static const String markNotificationAsRead =
      "/api/masyarakat/read-notification";
  static const String fallbackImage = "https://picsum.photos/200/300";

  // ADMINNN ROUTERR
  static const String getSpecifiReportAdminRouter = "/api/admin/detail-laporan";
  static const String updateStatusReportAsReadAdminRouter =
      "/api/admin/lihat-laporan";
  static const String updateStatusReportAsProcessAdminRouter =
      "/api/admin/proses-laporan";
  static const String updateStatusReportAsDoneAdminRouter =
      "/api/admin/proses-laporan";
  static const String getDetailReportByAdmin = "/api/admin/detail-laporan";
  static const String createTrackingReportAdminRouter =
      "/api/admin/create-tracking-laporan";
  static const String deleteTrackingReportAdminRouter =
      "/api/admin/delete-tracking-laporan";
  static const String updateTrackingReportAdminRouter =
      "/api/admin/edit-tracking-laporan";
  static const String reportStatusCountRouter = "/api/admin/status-stats";

  static const String reportAdminMessageRouter = "/api/masyarakat/report/admin";
  static const String reportUserMessageRouter = "/api/admin/report/client";
  static const String getReportedChat = "/api/admin/report";
  static const String pushNotificationRouter = "/api/admin/notification/push";
  static const String deletedImage = "/api/publik/delete-image";
}
