//+------------------------------------------------------------------+
//|                                                   i-Sessions.mq4 |
//|                                           Êèì Èãîðü Â. aka KimIV |
//|                                              http://www.kimiv.ru |
//|                                                                  |
//|  16.11.2005  Èíäèêàòîð òîðãîâûõ ñåññèé                           |
//+------------------------------------------------------------------+
#property copyright "Êèì Èãîðü Â. aka KimIV"
#property link      "http://www.kimiv.ru"

#property indicator_chart_window

//------- Âíåøíèå ïàðàìåòðû èíäèêàòîðà -------------------------------
extern int    NumberOfDays = 100;             // Êîëè÷åñòâî äíåé
extern bool   ShowAsia     = TRUE;
extern string AsiaBegin    = "00:00";        // Îòêðûòèå àçèàòñêîé ñåññèè
extern string AsiaEnd      = "09:00";        // Çàêðûòèå àçèàòñêîé ñåññèè
extern color  AsiaColor    = C'0,32,0';      // Öâåò àçèàòñêîé ñåññèè
extern bool   ShowEur      = FALSE;
extern string EurBegin     = "07:00";        // Îòêðûòèå åâðîïåéñêîé ñåññèè
extern string EurEnd       = "16:00";        // Çàêðûòèå åâðîïåéñêîé ñåññèè
extern color  EurColor     = C'48,0,0';      // Öâåò åâðîïåéñêîé ñåññèè
extern bool   ShowUSA      = FALSE;
extern string USABegin     = "12:00";        // Îòêðûòèå àìåðèêàíñêîé ñåññèè
extern string USAEnd       = "21:00";        // Çàêðûòèå àìåðèêàíñêîé ñåññèè
extern color  USAColor     = C'0,0,56';      // Öâåò àìåðèêàíñêîé ñåññèè
extern bool   ShowPrice    = TRUE;          // Ïîêàçûâàòü öåíîâûå óðîâíè
extern color  clFont       = Red;           // Öâåò øðèôòà
extern int    SizeFont     = 7;              // Ðàçìåð øðèôòà
extern int    OffSet       = 10;             // Ñìåùåíèå


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void init() {
  DeleteObjects();
  for (int i=0; i<NumberOfDays; i++) {
    CreateObjects("AS"+i, AsiaColor);
    CreateObjects("EU"+i, EurColor);
    CreateObjects("US"+i, USAColor);
  }
  Comment("");
}

//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void deinit() {
  DeleteObjects();
  Comment("");
}

//+------------------------------------------------------------------+
//| Ñîçäàíèå îáúåêòîâ èíäèêàòîðà                                     |
//| Ïàðàìåòðû:                                                       |
//|   no - íàèìåíîâàíèå îáúåêòà                                      |
//|   cl - öâåò îáúåêòà                                              |
//+------------------------------------------------------------------+
void CreateObjects(string no, color cl) {
  ObjectCreate(no, OBJ_RECTANGLE, 0, 0,0, 0,0);
  ObjectSet(no, OBJPROP_STYLE, STYLE_SOLID);
  ObjectSet(no, OBJPROP_COLOR, cl);
  ObjectSet(no, OBJPROP_BACK, True);
}

//+------------------------------------------------------------------+
//| Óäàëåíèå îáúåêòîâ èíäèêàòîðà                                     |
//+------------------------------------------------------------------+
void DeleteObjects() {
  for (int i=0; i<NumberOfDays; i++) {
    ObjectDelete("AS"+i);
    ObjectDelete("EU"+i);
    ObjectDelete("US"+i);
  }
  ObjectDelete("ASup");
  ObjectDelete("ASdn");
  ObjectDelete("EUup");
  ObjectDelete("EUdn");
  ObjectDelete("USup");
  ObjectDelete("USdn");
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start() {
  datetime dt=CurTime();
  
  for (int i=0; i<NumberOfDays; i++) {
    if (ShowPrice && i==0) {
      if(ShowAsia == TRUE) {
         DrawPrices(dt, "AS", AsiaBegin, AsiaEnd);
      }
      if(ShowEur == TRUE) {
         DrawPrices(dt, "EU", EurBegin, EurEnd);
      }
      if(ShowUSA == TRUE) {
         DrawPrices(dt, "US", USABegin, USAEnd);
      }
    }
    if(ShowAsia == TRUE) {
      DrawObjects(dt, "AS"+i, AsiaBegin, AsiaEnd);
    }
    if(ShowEur == TRUE) {
      DrawObjects(dt, "EU"+i, EurBegin, EurEnd);
    }
    if(ShowUSA == TRUE) {
      DrawObjects(dt, "US"+i, USABegin, USAEnd);
    }
    dt=decDateTradeDay(dt);
    while (TimeDayOfWeek(dt)>5) dt=decDateTradeDay(dt);
  }
}

//+------------------------------------------------------------------+
//| Ïðîðèñîâêà îáúåêòîâ íà ãðàôèêå                                   |
//| Ïàðàìåòðû:                                                       |
//|   dt - äàòà òîðãîâîãî äíÿ                                        |
//|   no - íàèìåíîâàíèå îáúåêòà                                      |
//|   tb - âðåìÿ íà÷àëà ñåññèè                                       |
//|   te - âðåìÿ îêîí÷àíèÿ ñåññèè                                    |
//+------------------------------------------------------------------+
void DrawObjects(datetime dt, string no, string tb, string te) {
  datetime t1, t2;
  double   p1, p2;
  int      b1, b2;

  t1=StrToTime(TimeToStr(dt, TIME_DATE)+" "+tb);
  t2=StrToTime(TimeToStr(dt, TIME_DATE)+" "+te);
  b1=iBarShift(NULL, 0, t1);
  b2=iBarShift(NULL, 0, t2);
  p1=High[Highest(NULL, 0, MODE_HIGH, b1-b2, b2)];
  p2=Low [Lowest (NULL, 0, MODE_LOW , b1-b2, b2)];
  ObjectSet(no, OBJPROP_TIME1 , t1);
  ObjectSet(no, OBJPROP_PRICE1, p1);
  ObjectSet(no, OBJPROP_TIME2 , t2);
  ObjectSet(no, OBJPROP_PRICE2, p2);
}

//+------------------------------------------------------------------+
//| Ïðîðèñîâêà öåíîâûõ ìåòîê íà ãðàôèêå                              |
//| Ïàðàìåòðû:                                                       |
//|   dt - äàòà òîðãîâîãî äíÿ                                        |
//|   no - íàèìåíîâàíèå îáúåêòà                                      |
//|   tb - âðåìÿ íà÷àëà ñåññèè                                       |
//|   te - âðåìÿ îêîí÷àíèÿ ñåññèè                                    |
//+------------------------------------------------------------------+
void DrawPrices(datetime dt, string no, string tb, string te) {
  datetime t1, t2;
  double   p1, p2;
  int      b1, b2;

  t1=StrToTime(TimeToStr(dt, TIME_DATE)+" "+tb);
  t2=StrToTime(TimeToStr(dt, TIME_DATE)+" "+te);
  b1=iBarShift(NULL, 0, t1);
  b2=iBarShift(NULL, 0, t2);
  p1=High[Highest(NULL, 0, MODE_HIGH, b1-b2, b2)];
  p2=Low [Lowest (NULL, 0, MODE_LOW , b1-b2, b2)];

  if (ObjectFind(no+"up")<0) ObjectCreate(no+"up", OBJ_TEXT, 0, 0,0);
  ObjectSet(no+"up", OBJPROP_TIME1   , t2);
  ObjectSet(no+"up", OBJPROP_PRICE1  , p1+OffSet*Point);
  ObjectSet(no+"up", OBJPROP_COLOR   , clFont);
  ObjectSet(no+"up", OBJPROP_FONTSIZE, SizeFont);
  ObjectSetText(no+"up", DoubleToStr(p1+Ask-Bid, Digits));

  if (ObjectFind(no+"dn")<0) ObjectCreate(no+"dn", OBJ_TEXT, 0, 0,0);
  ObjectSet(no+"dn", OBJPROP_TIME1   , t2);
  ObjectSet(no+"dn", OBJPROP_PRICE1  , p2);
  ObjectSet(no+"dn", OBJPROP_COLOR   , clFont);
  ObjectSet(no+"dn", OBJPROP_FONTSIZE, SizeFont);
  ObjectSetText(no+"dn", DoubleToStr(p2, Digits));
}

//+------------------------------------------------------------------+
//| Óìåíüøåíèå äàòû íà îäèí òîðãîâûé äåíü                            |
//| Ïàðàìåòðû:                                                       |
//|   dt - äàòà òîðãîâîãî äíÿ                                        |
//+------------------------------------------------------------------+
datetime decDateTradeDay (datetime dt) {
  int ty=TimeYear(dt);
  int tm=TimeMonth(dt);
  int td=TimeDay(dt);
  int th=TimeHour(dt);
  int ti=TimeMinute(dt);

  td--;
  if (td==0) {
    tm--;
    if (tm==0) {
      ty--;
      tm=12;
    }
    if (tm==1 || tm==3 || tm==5 || tm==7 || tm==8 || tm==10 || tm==12) td=31;
    if (tm==2) if (MathMod(ty, 4)==0) td=29; else td=28;
    if (tm==4 || tm==6 || tm==9 || tm==11) td=30;
  }
  return(StrToTime(ty+"."+tm+"."+td+" "+th+":"+ti));
}
//+------------------------------------------------------------------+

