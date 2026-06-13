#include <YSI_Coding\y_hooks>

  // ======================================
  // ASK SYSTEM — data & state
  // ======================================

  enum E_ASK_DATA
  {
      bool:askExists,
      askPlayer,
      askText[128]
  };
  new AskData[MAX_ASKS][E_ASK_DATA];
  new ListAsks[MAX_PLAYERS][MAX_ASKS];
  new AskCooldown[MAX_PLAYERS];

  // ======================================
  // REPORT SYSTEM — data & state
  // ======================================

  enum E_REPORT_DATA
  {
      bool:rExists,
      rPlayer,
      rText[128]
  };
  new ReportData[MAX_REPORTS][E_REPORT_DATA];
  new ListReports[MAX_PLAYERS][MAX_REPORTS];
  new ReportCooldown[MAX_PLAYERS];

  // ======================================
  // INTERNAL — HELPERS
  // ======================================

  static Ask_GetCount(playerid)
  {
      new count;
      for(new i = 0; i < MAX_ASKS; i++)
          if(AskData[i][askExists] && AskData[i][askPlayer] == playerid) count++;
      return count;
  }

  static Ask_Count()
  {
      new count;
      for(new i = 0; i < MAX_ASKS; i++)
          if(AskData[i][askExists]) count++;
      return count;
  }

  static Ask_Add(playerid, const text[])
  {
      for(new i = 0; i < MAX_ASKS; i++)
      {
          if(!AskData[i][askExists])
          {
              AskData[i][askExists] = true;
              AskData[i][askPlayer] = playerid;
              format(AskData[i][askText], 128, "%s", text);
              return i;
          }
      }
      return -1;
  }

  static Ask_Remove(askid)
  {
      if(askid < 0 || askid >= MAX_ASKS) return 1;
      AskData[askid][askExists]  = false;
      AskData[askid][askPlayer]  = INVALID_PLAYER_ID;
      AskData[askid][askText][0] = EOS;
      return 1;
  }

  static Report_GetCount(playerid)
  {
      new count;
      for(new i = 0; i < MAX_REPORTS; i++)
          if(ReportData[i][rExists] && ReportData[i][rPlayer] == playerid) count++;
      return count;
  }

  static Report_Count()
  {
      new count;
      for(new i = 0; i < MAX_REPORTS; i++)
          if(ReportData[i][rExists]) count++;
      return count;
  }

  static Report_Add(playerid, const text[])
  {
      for(new i = 0; i < MAX_REPORTS; i++)
      {
          if(!ReportData[i][rExists])
          {
              ReportData[i][rExists] = true;
              ReportData[i][rPlayer] = playerid;
              format(ReportData[i][rText], 128, "%s", text);
              return i;
          }
      }
      return -1;
  }

  static Report_Remove(repid)
  {
      if(repid < 0 || repid >= MAX_REPORTS) return 1;
      ReportData[repid][rExists]  = false;
      ReportData[repid][rPlayer]  = INVALID_PLAYER_ID;
      ReportData[repid][rText][0] = EOS;
      return 1;
  }

  // Broadcast ke semua admin yang sedang login
  static SendToAdmins(color, const msg[])
  {
      foreach(new i : Player)
          if(pInfo[i][pLoggedIn] && pInfo[i][pAdminLevel] >= ADMIN_HELPER)
              SendClientMessage(i, color, msg);
  }

  // Bersihkan data saat player disconnect
  hook OnPlayerDisconnect(playerid, reason)
  {
      for(new i = 0; i < MAX_ASKS; i++)
          if(AskData[i][askExists] && AskData[i][askPlayer] == playerid)
              Ask_Remove(i);

      for(new i = 0; i < MAX_REPORTS; i++)
          if(ReportData[i][rExists] && ReportData[i][rPlayer] == playerid)
              Report_Remove(i);

      AskCooldown[playerid]    = 0;
      ReportCooldown[playerid] = 0;
      return 1;
  }

  // ======================================
  // ASK COMMANDS (pemain tanya ke admin)
  // ======================================

  CMD:ask(playerid, params[])
  {
      if(!pInfo[playerid][pLoggedIn])
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Kamu harus login terlebih dahulu.");

      if(isnull(params))
          return SendClientMessage(playerid, COLOR_HELP_YELLOW, "USAGE: /ask [pertanyaan]");

      if(Ask_GetCount(playerid) >= 1)
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Kamu sudah punya pertanyaan aktif, tunggu dijawab terlebih dahulu!");

      if(AskCooldown[playerid] >= gettime())
      {
          new msg[128];
          format(msg, sizeof(msg), "ERROR: Tunggu %d detik lagi sebelum mengajukan pertanyaan.", AskCooldown[playerid] - gettime());
          return SendClientMessage(playerid, COLOR_ERROR, msg);
      }

      new askid = Ask_Add(playerid, params);
      if(askid == -1)
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Slot pertanyaan penuh, coba lagi nanti.");

      new notif[192];
      format(notif, sizeof(notif), "[Ask #%d] %s (%d): %s", askid, pInfo[playerid][pName], playerid, params);
      SendToAdmins(COLOR_HELP_YELLOW, notif);

      AskCooldown[playerid] = gettime() + HELP_COOLDOWN_SECS;
      SendClientMessage(playerid, COLOR_HELP_GREEN, "Pertanyaanmu berhasil dikirim, tunggu admin menjawab.");
      return 1;
  }

  CMD:asks(playerid, params[])
  {
      if(!IsAdmin(playerid))
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Hanya admin yang bisa menggunakan perintah ini.");

      new count = Ask_Count();
      if(count == 0)
          return SendClientMessage(playerid, COLOR_ERROR, "Tidak ada pertanyaan aktif saat ini.");

      new list[4096], buf[192], preview[36], idx = 0;
      format(list, sizeof(list), "#ID\tPlayer\tPertanyaan\n");
      for(new i = 0; i < MAX_ASKS; i++)
      {
          if(!AskData[i][askExists]) continue;
          strmid(preview, AskData[i][askText], 0, 32, sizeof(preview));
          format(buf, sizeof(buf), "#%d\t%s (%d)\t%s...\n",
              i, pInfo[AskData[i][askPlayer]][pName], AskData[i][askPlayer], preview);
          strcat(list, buf, sizeof(list));
          ListAsks[playerid][idx++] = i;
      }

      new title[64];
      format(title, sizeof(title), "Daftar Pertanyaan (%d Aktif)", count);
      ShowPlayerDialog(playerid, DIALOG_HELP_ASKS, DIALOG_STYLE_TABLIST_HEADERS, title, list, "Jawab", "Tutup");
      return 1;
  }

  CMD:ans(playerid, params[])
  {
      if(!IsAdmin(playerid))
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Hanya admin yang bisa menggunakan perintah ini.");

      new askid, text[128];
      if(sscanf(params, "ds[128]", askid, text))
          return SendClientMessage(playerid, COLOR_HELP_YELLOW, "USAGE: /ans [#Ask ID] [jawaban]");

      if(askid < 0 || askid >= MAX_ASKS || !AskData[askid][askExists])
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: #ID Ask tidak valid. Gunakan /asks untuk melihat daftar.");

      if(AskData[askid][askPlayer] == INVALID_PLAYER_ID)
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Pemain tersebut sudah offline.");

      new targetid = AskData[askid][askPlayer];
      new reply[192];
      format(reply, sizeof(reply), "[Ask Answer] %s: %s", pInfo[playerid][pName], text);
      SendClientMessage(targetid, COLOR_HELP_YELLOW, reply);

      new staffMsg[192];
      format(staffMsg, sizeof(staffMsg), "[Ask] %s menjawab pertanyaan dari %s (%d).", pInfo[playerid][pName], pInfo[targetid][pName], targetid);
      SendToAdmins(COLOR_HELP_YELLOW, staffMsg);

      Ask_Remove(askid);
      SendClientMessage(playerid, COLOR_HELP_GREEN, "Pertanyaan berhasil dijawab.");
      return 1;
  }

  CMD:clearask(playerid, params[])
  {
      if(!IsAdmin(playerid, ADMIN_ADMIN))
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Hanya Administrator (level 3) ke atas.");

      new count = 0;
      for(new i = 0; i < MAX_ASKS; i++)
          if(AskData[i][askExists]) { Ask_Remove(i); count++; }

      if(count == 0)
          return SendClientMessage(playerid, COLOR_ERROR, "Tidak ada pertanyaan untuk dihapus.");

      new msg[96];
      format(msg, sizeof(msg), "[Ask] %s menghapus semua pertanyaan (%d entri).", pInfo[playerid][pName], count);
      SendToAdmins(COLOR_HELP_YELLOW, msg);
      return 1;
  }

  // ======================================
  // REPORT COMMANDS (pemain laporkan masalah)
  // ======================================

  CMD:report(playerid, params[])
  {
      if(!pInfo[playerid][pLoggedIn])
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Kamu harus login terlebih dahulu.");

      if(isnull(params))
          return SendClientMessage(playerid, COLOR_HELP_YELLOW, "USAGE: /report [laporan]");

      if(Report_GetCount(playerid) >= 1)
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Kamu sudah punya laporan aktif, tunggu diproses terlebih dahulu!");

      if(ReportCooldown[playerid] >= gettime())
      {
          new msg[128];
          format(msg, sizeof(msg), "ERROR: Tunggu %d detik lagi sebelum mengirim laporan.", ReportCooldown[playerid] - gettime());
          return SendClientMessage(playerid, COLOR_ERROR, msg);
      }

      new repid = Report_Add(playerid, params);
      if(repid == -1)
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Slot laporan penuh, coba lagi nanti.");

      new notif[192];
      format(notif, sizeof(notif), "[Report #%d] %s (%d): %s", repid, pInfo[playerid][pName], playerid, params);
      SendToAdmins(COLOR_ADMIN, notif);

      ReportCooldown[playerid] = gettime() + HELP_COOLDOWN_SECS;
      SendClientMessage(playerid, COLOR_HELP_GREEN, "Laporanmu berhasil dikirim, tunggu admin memproses laporanmu.");
      return 1;
  }

  CMD:reports(playerid, params[])
  {
      if(!IsAdmin(playerid))
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Hanya admin yang bisa menggunakan perintah ini.");

      new count = Report_Count();
      if(count == 0)
          return SendClientMessage(playerid, COLOR_ERROR, "Tidak ada laporan aktif saat ini.");

      new list[4096], buf[192], preview[36], idx = 0;
      format(list, sizeof(list), "#ID\tPlayer\tLaporan\n");
      for(new i = 0; i < MAX_REPORTS; i++)
      {
          if(!ReportData[i][rExists]) continue;
          strmid(preview, ReportData[i][rText], 0, 32, sizeof(preview));
          format(buf, sizeof(buf), "#%d\t%s (%d)\t%s...\n",
              i, pInfo[ReportData[i][rPlayer]][pName], ReportData[i][rPlayer], preview);
          strcat(list, buf, sizeof(list));
          ListReports[playerid][idx++] = i;
      }

      new title[64];
      format(title, sizeof(title), "Daftar Laporan (%d Aktif)", count);
      ShowPlayerDialog(playerid, DIALOG_HELP_REPORTS, DIALOG_STYLE_TABLIST_HEADERS, title, list, "Balas", "Tutup");
      return 1;
  }

  CMD:ar(playerid, params[])
  {
      if(!IsAdmin(playerid))
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Hanya admin yang bisa menggunakan perintah ini.");

      new repid, text[128];
      if(sscanf(params, "ds[128]", repid, text))
          return SendClientMessage(playerid, COLOR_HELP_YELLOW, "USAGE: /ar [#Report ID] [jawaban]");

      if(repid < 0 || repid >= MAX_REPORTS || !ReportData[repid][rExists])
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: #ID Report tidak valid. Gunakan /reports untuk melihat daftar.");

      if(ReportData[repid][rPlayer] == INVALID_PLAYER_ID)
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Pemain tersebut sudah offline.");

      new targetid = ReportData[repid][rPlayer];
      new reply[192];
      format(reply, sizeof(reply), "[Report Answer] %s: %s", pInfo[playerid][pName], text);
      SendClientMessage(targetid, COLOR_ADMIN, reply);

      new staffMsg[192];
      format(staffMsg, sizeof(staffMsg), "[Report] %s membalas laporan dari %s (%d).", pInfo[playerid][pName], pInfo[targetid][pName], targetid);
      SendToAdmins(COLOR_ADMIN, staffMsg);

      Report_Remove(repid);
      SendClientMessage(playerid, COLOR_HELP_GREEN, "Laporan berhasil dibalas.");
      return 1;
  }

  CMD:clearreports(playerid, params[])
  {
      if(!IsAdmin(playerid, ADMIN_ADMIN))
          return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Hanya Administrator (level 3) ke atas.");

      new count = 0;
      for(new i = 0; i < MAX_REPORTS; i++)
          if(ReportData[i][rExists]) { Report_Remove(i); count++; }

      if(count == 0)
          return SendClientMessage(playerid, COLOR_ERROR, "Tidak ada laporan untuk dihapus.");

      new msg[96];
      format(msg, sizeof(msg), "[Report] %s menghapus semua laporan (%d entri).", pInfo[playerid][pName], count);
      SendToAdmins(COLOR_ADMIN, msg);
      return 1;
  }

  // ======================================
  // DIALOG RESPONSES
  // ======================================

  hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
  {
      switch(dialogid)
      {
          case DIALOG_HELP_ASKS:
          {
              if(!response) return 1;
              new id = ListAsks[playerid][listitem];
              if(!AskData[id][askExists])
              {
                  SendClientMessage(playerid, COLOR_ERROR, "ERROR: Pertanyaan sudah tidak ada, gunakan /asks untuk refresh.");
                  return 1;
              }
              new body[512];
              format(body, sizeof(body),
                  "Player: {FFFF00}%s (%d){FFFFFF}\nPertanyaan: {FFFF00}%s{FFFFFF}\n\nJawaban:",
                  pInfo[AskData[id][askPlayer]][pName], AskData[id][askPlayer], AskData[id][askText]);
              SetPVarInt(playerid, "HelpAskID", id);
              ShowPlayerDialog(playerid, DIALOG_HELP_ASKS_REPLY, DIALOG_STYLE_INPUT, "Jawab Pertanyaan", body, "Kirim", "Batal");
              return 1;
          }
          case DIALOG_HELP_ASKS_REPLY:
          {
              new id = GetPVarInt(playerid, "HelpAskID");
              if(!response) { DeletePVar(playerid, "HelpAskID"); return 1; }
              if(!AskData[id][askExists])
              {
                  SendClientMessage(playerid, COLOR_ERROR, "ERROR: Pertanyaan sudah tidak aktif.");
                  return 1;
              }
              if(isnull(inputtext))
              {
                  new body[512];
                  format(body, sizeof(body),
                      "{FF0000}Jawaban tidak boleh kosong!{FFFFFF}\nPlayer: {FFFF00}%s (%d){FFFFFF}\nPertanyaan: {FFFF00}%s{FFFFFF}\n\nJawaban:",
                      pInfo[AskData[id][askPlayer]][pName], AskData[id][askPlayer], AskData[id][askText]);
                  ShowPlayerDialog(playerid, DIALOG_HELP_ASKS_REPLY, DIALOG_STYLE_INPUT, "Jawab Pertanyaan", body, "Kirim", "Batal");
                  return 1;
              }
              new targetid = AskData[id][askPlayer];
              new reply[192];
              format(reply, sizeof(reply), "[Ask Answer] %s: %s", pInfo[playerid][pName], inputtext);
              SendClientMessage(targetid, COLOR_HELP_YELLOW, reply);
              new staffMsg[192];
              format(staffMsg, sizeof(staffMsg), "[Ask] %s menjawab pertanyaan dari %s (%d).", pInfo[playerid][pName], pInfo[targetid][pName], targetid);
              SendToAdmins(COLOR_HELP_YELLOW, staffMsg);
              Ask_Remove(id);
              DeletePVar(playerid, "HelpAskID");
              SendClientMessage(playerid, COLOR_HELP_GREEN, "Pertanyaan berhasil dijawab.");
              return 1;
          }
          case DIALOG_HELP_REPORTS:
          {
              if(!response) return 1;
              new id = ListReports[playerid][listitem];
              if(!ReportData[id][rExists])
              {
                  SendClientMessage(playerid, COLOR_ERROR, "ERROR: Laporan sudah tidak ada, gunakan /reports untuk refresh.");
                  return 1;
              }
              new body[512];
              format(body, sizeof(body),
                  "Player: {FF5555}%s (%d){FFFFFF}\nLaporan: {FF5555}%s{FFFFFF}\n\nBalasan:",
                  pInfo[ReportData[id][rPlayer]][pName], ReportData[id][rPlayer], ReportData[id][rText]);
              SetPVarInt(playerid, "HelpReportID", id);
              ShowPlayerDialog(playerid, DIALOG_HELP_REPORTS_REPLY, DIALOG_STYLE_INPUT, "Balas Laporan", body, "Kirim", "Batal");
              return 1;
          }
          case DIALOG_HELP_REPORTS_REPLY:
          {
              new id = GetPVarInt(playerid, "HelpReportID");
              if(!response) { DeletePVar(playerid, "HelpReportID"); return 1; }
              if(!ReportData[id][rExists])
              {
                  SendClientMessage(playerid, COLOR_ERROR, "ERROR: Laporan sudah tidak aktif.");
                  return 1;
              }
              if(isnull(inputtext))
              {
                  new body[512];
                  format(body, sizeof(body),
                      "{FF0000}Balasan tidak boleh kosong!{FFFFFF}\nPlayer: {FF5555}%s (%d){FFFFFF}\nLaporan: {FF5555}%s{FFFFFF}\n\nBalasan:",
                      pInfo[ReportData[id][rPlayer]][pName], ReportData[id][rPlayer], ReportData[id][rText]);
                  ShowPlayerDialog(playerid, DIALOG_HELP_REPORTS_REPLY, DIALOG_STYLE_INPUT, "Balas Laporan", body, "Kirim", "Batal");
                  return 1;
              }
              new targetid = ReportData[id][rPlayer];
              new reply[192];
              format(reply, sizeof(reply), "[Report Answer] %s: %s", pInfo[playerid][pName], inputtext);
              SendClientMessage(targetid, COLOR_ADMIN, reply);
              new staffMsg[192];
              format(staffMsg, sizeof(staffMsg), "[Report] %s membalas laporan dari %s (%d).", pInfo[playerid][pName], pInfo[targetid][pName], targetid);
              SendToAdmins(COLOR_ADMIN, staffMsg);
              Report_Remove(id);
              DeletePVar(playerid, "HelpReportID");
              SendClientMessage(playerid, COLOR_HELP_GREEN, "Laporan berhasil dibalas.");
              return 1;
          }
      }
      return 1;
  }
  