#include <YSI_Coding\y_hooks>

  // Dialog IDs untuk menu help
  #define DIALOG_HELP_MENU         9200
  #define DIALOG_HELP_ACCOUNT      9201
  #define DIALOG_HELP_CHAT         9202
  #define DIALOG_HELP_VEHICLE      9203
  #define DIALOG_HELP_ADMIN        9204
  #define DIALOG_HELP_REPORT_INFO  9205

  // ======================================
  // CMD:help — Menu utama
  // ======================================

  CMD:help(playerid, params[])
  {
      if(!pInfo[playerid][pLoggedIn])
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Kamu harus login terlebih dahulu.");

      new menu[512];
      format(menu, sizeof(menu),
          "Account & Karakter\n"
          "Chat & Roleplay\n"
          "Kendaraan\n"
          "Help & Report\n"
          "Info Server"
      );

      // Tambahkan menu Admin kalau player adalah admin
      if(pInfo[playerid][pAdminLevel] >= ADMIN_HELPER)
          strcat(menu, "\nAdmin Commands", sizeof(menu));

      ShowPlayerDialog(playerid, DIALOG_HELP_MENU, DIALOG_STYLE_LIST,
          "{FFFF00}[ HELP MENU ]{FFFFFF} - Pilih Kategori",
          menu, "Pilih", "Tutup");
      return 1;
  }

  // ======================================
  // DIALOG HANDLER
  // ======================================

  hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
  {
      switch(dialogid)
      {
          // ======== MENU UTAMA ========
          case DIALOG_HELP_MENU:
          {
              if(!response) return 1;

              switch(listitem)
              {
                  case 0: // Account & Karakter
                  {
                      new info[1024];
                      format(info, sizeof(info),
                          "{FFFF00}=== Account & Karakter ===\n\n"
                          "{FFFFFF}/login          {AAAAAA}— Login ke server\n"
                          "/register       {AAAAAA}— Daftar akun baru\n"
                          "/charlist       {AAAAAA}— Daftar karakter milikmu\n"
                          "/stats          {AAAAAA}— Lihat statistik karaktermu\n"
                          "/mask           {AAAAAA}— Pasang/lepas masker\n"
                          "\n"
                          "{FFFF00}[ Kills: %d | Deaths: %d | Level: %d ]",
                          pInfo[playerid][pKills], pInfo[playerid][pDeaths], pInfo[playerid][pLevel]
                      );
                      ShowPlayerDialog(playerid, DIALOG_HELP_ACCOUNT, DIALOG_STYLE_MSGBOX,
                          "Account & Karakter", info, "Kembali", "Tutup");
                  }
                  case 1: // Chat & Roleplay
                  {
                      new info[1024];
                      format(info, sizeof(info),
                          "{FFFF00}=== Chat & Roleplay ===\n\n"
                          "{FFFFFF}/me  [aksi]      {AAAAAA}— Aksi IC (kelihatan semua)\n"
                          "/do  [desk]      {AAAAAA}— Deskripsi situasi\n"
                          "/try [aksi]      {AAAAAA}— Coba sesuatu (acak sukses/gagal)\n"
                          "/shout [pesan]   {AAAAAA}— Teriak (radius luas)\n"
                          "/low   [pesan]   {AAAAAA}— Bicara pelan (radius kecil)\n"
                          "/w [id] [pesan]  {AAAAAA}— Bisik ke pemain tertentu\n"
                          "\n"
                          "{AAAAAA}IC Chat: ketik biasa di chat\n"
                          "Masker aktif menyembunyikan namamu"
                      );
                      ShowPlayerDialog(playerid, DIALOG_HELP_CHAT, DIALOG_STYLE_MSGBOX,
                          "Chat & Roleplay", info, "Kembali", "Tutup");
                  }
                  case 2: // Kendaraan
                  {
                      new info[1024];
                      format(info, sizeof(info),
                          "{FFFF00}=== Kendaraan ===\n\n"
                          "{FFFFFF}/engine         {AAAAAA}— Nyalakan/matikan mesin\n"
                          "/lock            {AAAAAA}— Kunci/buka kunci kendaraan\n"
                          "/park            {AAAAAA}— Parkir & simpan posisi\n"
                          "/fuel            {AAAAAA}— Cek bahan bakar\n"
                          "/myveh           {AAAAAA}— Lihat daftar kendaraanmu\n"
                          "/getveh [id]     {AAAAAA}— Panggil kendaraan\n"
                          "/storeveh [id]   {AAAAAA}— Simpan kendaraan ke garasi\n"
                          "/vehcolor [1] [2]{AAAAAA}— Ganti warna kendaraan\n"
                          "/plate [teks]    {AAAAAA}— Ganti nomor plat\n"
                          "/impound         {AAAAAA}— Keluarkan kendaraan dari kandang\n"
                          "/rental          {AAAAAA}— Info rental kendaraan"
                      );
                      ShowPlayerDialog(playerid, DIALOG_HELP_VEHICLE, DIALOG_STYLE_MSGBOX,
                          "Kendaraan", info, "Kembali", "Tutup");
                  }
                  case 3: // Help & Report
                  {
                      new info[512];
                      format(info, sizeof(info),
                          "{FFFF00}=== Help & Report ===\n\n"
                          "{FFFFFF}/ask [pertanyaan]  {AAAAAA}— Tanya sesuatu ke admin\n"
                          "/report [laporan]  {AAAAAA}— Laporkan masalah/pemain\n"
                          "\n"
                          "{AAAAAA}Cooldown: 120 detik per pertanyaan/laporan.\n"
                          "Tunggu admin membalas sebelum kirim lagi."
                      );
                      ShowPlayerDialog(playerid, DIALOG_HELP_REPORT_INFO, DIALOG_STYLE_MSGBOX,
                          "Help & Report", info, "Kembali", "Tutup");
                  }
                  case 4: // Info Server
                  {
                      new info[512];
                      format(info, sizeof(info),
                          "{FFFF00}=== Info Server ===\n\n"
                          "{FFFFFF}Nama Server : {FFFF00}%s\n"
                          "{FFFFFF}Versi GM    : {FFFF00}%s\n"
                          "{FFFFFF}Bahasa      : {FFFF00}%s\n"
                          "{FFFFFF}Website     : {FFFF00}%s\n"
                          "\n"
                          "{AAAAAA}Butuh bantuan? Gunakan /ask\n"
                          "Ada pelanggaran? Gunakan /report",
                          NamaServer, Versi, Bahasa, WEB
                      );
                      ShowPlayerDialog(playerid, DIALOG_HELP_REPORT_INFO + 1, DIALOG_STYLE_MSGBOX,
                          "Info Server", info, "Kembali", "Tutup");
                  }
                  case 5: // Admin Commands (hanya muncul kalau admin)
                  {
                      if(pInfo[playerid][pAdminLevel] < ADMIN_HELPER) return 1;

                      new info[1024];
                      format(info, sizeof(info),
                          "{FFFF00}=== Admin Commands ===\n\n"
                          "{FFFFFF}/setadmin [id] [0-4]  {AAAAAA}— Set level admin (RCON only)\n"
                          "/checkadmin [id]      {AAAAAA}— Cek level admin pemain\n"
                          "/spectate [id]        {AAAAAA}— Spectate pemain\n"
                          "/stopspec             {AAAAAA}— Stop spectate\n"
                          "/duty                 {AAAAAA}— Toggle admin duty\n"
                          "/settime [jam] [mnt]  {AAAAAA}— Set waktu server\n"
                          "/setfuel [jumlah]     {AAAAAA}— Set fuel kendaraan\n"
                          "/asks                 {AAAAAA}— Lihat daftar pertanyaan\n"
                          "/reports              {AAAAAA}— Lihat daftar laporan\n"
                          "/ans [#id] [jawaban]  {AAAAAA}— Jawab pertanyaan\n"
                          "/ar  [#id] [jawaban]  {AAAAAA}— Balas laporan\n"
                          "\n"
                          "{FF5555}Level kamu: %s (Level %d)",
                          GetAdminName(pInfo[playerid][pAdminLevel]),
                          pInfo[playerid][pAdminLevel]
                      );
                      ShowPlayerDialog(playerid, DIALOG_HELP_ADMIN, DIALOG_STYLE_MSGBOX,
                          "Admin Commands", info, "Kembali", "Tutup");
                  }
              }
              return 1;
          }

          // ======== TOMBOL "KEMBALI" di semua sub-menu ========
          case DIALOG_HELP_ACCOUNT:
          case DIALOG_HELP_CHAT:
          case DIALOG_HELP_VEHICLE:
          case DIALOG_HELP_ADMIN:
          case DIALOG_HELP_REPORT_INFO:
          {
              if(response) // Klik "Kembali"
              {
                  new menu[512];
                  format(menu, sizeof(menu),
                      "Account & Karakter\n"
                      "Chat & Roleplay\n"
                      "Kendaraan\n"
                      "Help & Report\n"
                      "Info Server"
                  );
                  if(pInfo[playerid][pAdminLevel] >= ADMIN_HELPER)
                      strcat(menu, "\nAdmin Commands", sizeof(menu));

                  ShowPlayerDialog(playerid, DIALOG_HELP_MENU, DIALOG_STYLE_LIST,
                      "{FFFF00}[ HELP MENU ]{FFFFFF} - Pilih Kategori",
                      menu, "Pilih", "Tutup");
              }
              return 1;
          }
          // Info server juga punya kembali
          case DIALOG_HELP_REPORT_INFO + 1:
          {
              if(response)
              {
                  new menu[512];
                  format(menu, sizeof(menu),
                      "Account & Karakter\n"
                      "Chat & Roleplay\n"
                      "Kendaraan\n"
                      "Help & Report\n"
                      "Info Server"
                  );
                  if(pInfo[playerid][pAdminLevel] >= ADMIN_HELPER)
                      strcat(menu, "\nAdmin Commands", sizeof(menu));

                  ShowPlayerDialog(playerid, DIALOG_HELP_MENU, DIALOG_STYLE_LIST,
                      "{FFFF00}[ HELP MENU ]{FFFFFF} - Pilih Kategori",
                      menu, "Pilih", "Tutup");
              }
              return 1;
          }
      }
      return 1;
  }
  