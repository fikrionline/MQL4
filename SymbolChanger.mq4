#property indicator_separate_window
#property indicator_buffers 0
#property strict

extern string UniqueID = "SymbolChanger"; // Indicator unique ID
extern bool DisplayTimeFrame = 1;
extern int ButtonsInARow = 20; // Buttons in a horizontal row
extern int XShift = 2; // Horizontal shift
extern int YShift = 2; // Vertical shift
extern int XSize = 60; // Width of buttons
extern int YSize = 20; // Height of buttons
extern int FSize = 10; // Fort size
extern color Bcolor = clrGainsboro; // Button color
extern color Dcolor = clrDarkGray; // Button border color
extern color Tncolor = clrBlack; // Text color - normal
extern color Sncolor = clrRed; // Text color - selected
extern bool Transparent = false; // Transparent buttons?


int OnInit() {
   IndicatorShortName(UniqueID);
   int xpos = 0, ypos = 0, maxx = 0, maxy = 0;

   string IndicatorSymbol[29];
   IndicatorSymbol[0] = "XAUUSD";
   IndicatorSymbol[1] = "AUDCAD";
   IndicatorSymbol[2] = "AUDCHF";
   IndicatorSymbol[3] = "AUDJPY";
   IndicatorSymbol[4] = "AUDNZD";
   IndicatorSymbol[5] = "AUDUSD";
   IndicatorSymbol[6] = "CADCHF";
   IndicatorSymbol[7] = "CADJPY";
   IndicatorSymbol[8] = "CHFJPY";
   IndicatorSymbol[9] = "EURAUD";
   IndicatorSymbol[10] = "EURCAD";
   IndicatorSymbol[11] = "EURCHF";
   IndicatorSymbol[12] = "EURGBP";
   IndicatorSymbol[13] = "EURJPY";
   IndicatorSymbol[14] = "EURNZD";
   IndicatorSymbol[15] = "EURUSD";
   IndicatorSymbol[16] = "GBPAUD";
   IndicatorSymbol[17] = "GBPCAD";
   IndicatorSymbol[18] = "GBPCHF";
   IndicatorSymbol[19] = "GBPJPY";
   IndicatorSymbol[20] = "GBPNZD";
   IndicatorSymbol[21] = "GBPUSD";
   IndicatorSymbol[22] = "NZDCAD";
   IndicatorSymbol[23] = "NZDCHF";
   IndicatorSymbol[24] = "NZDJPY";
   IndicatorSymbol[25] = "NZDUSD";
   IndicatorSymbol[26] = "USDCAD";
   IndicatorSymbol[27] = "USDCHF";
   IndicatorSymbol[28] = "USDJPY";
   
   string ButtonSymbolUniqueID[29];
   string ButtonSymbolString[29];
   string ButtonSymbolSymbolName[29];

   for (int i = 0; i < SymbolsTotal(true); i++) {      
      for(int is = 0; is < ArraySize(IndicatorSymbol); is++){
         if(IndicatorSymbol[is] == SymbolName(i, true)){
         
            if (i > 0 && MathMod(i, ButtonsInARow) == 0) {
               //xpos = 0;
               //ypos += YSize + 1;
            }
            //createButton(UniqueID + ":symbol:" + string(i), SymbolName(i, true), XShift + xpos, YShift + ypos);
            //xpos += XSize + 1;
            
            for(int s=0; s<ArraySize(IndicatorSymbol); s++){
               if(IndicatorSymbol[s] == SymbolName(i, true)){
                  ButtonSymbolUniqueID[s] = UniqueID;
                  ButtonSymbolString[s] = string(i);
                  ButtonSymbolSymbolName[s] = SymbolName(i, true);
               }
            }
            
         }
      }
   }
   
   for(int b=0; b<ArraySize(IndicatorSymbol); b++){
      if (b > 0 && MathMod(b, ButtonsInARow) == 0) {
         xpos = 0;
         ypos += YSize + 1;
      }
      createButton(ButtonSymbolUniqueID[b] + ":symbol:" + ButtonSymbolString[b], ButtonSymbolSymbolName[b], XShift + xpos, YShift + ypos);
      xpos += XSize + 1;
   }
   
   if(DisplayTimeFrame == 1){
      xpos = 0;
      ypos += YSize + 3;
      for (int i = 0; i < ArraySize(sTfTable); i++) {
         if (i > 0 && MathMod(i, ButtonsInARow) == 0) {
            xpos = 0;
            ypos += YSize + 1;
         }
         createButton(UniqueID + ":time:" + string(i), sTfTable[i], XShift + xpos, YShift + ypos);
         xpos += XSize + 1;
      }
   }

   setSymbolButtonColor();
   setTimeFrameButtonColor();
   return (0);
}

void OnDeinit(const int reason) {
   switch (reason) {
   case REASON_CHARTCHANGE:
   case REASON_RECOMPILE:
   case REASON_CLOSE:
      break;
   default: {
      string lookFor = UniqueID + ":";
      int lookForLength = StringLen(lookFor);
      for (int i = ObjectsTotal() - 1; i >= 0; i--) {
         string objectName = ObjectName(i);
         if (StringSubstr(objectName, 0, lookForLength) == lookFor) ObjectDelete(objectName);
      }
   }
   }
}


void createButton(string name, string caption, int xpos, int ypos) {
   int window = WindowFind(UniqueID);
   ObjectCreate(name, OBJ_BUTTON, window, 0, 0);
   ObjectSet(name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSet(name, OBJPROP_XDISTANCE, xpos);
   ObjectSet(name, OBJPROP_YDISTANCE, ypos);
   ObjectSet(name, OBJPROP_XSIZE, XSize);
   ObjectSet(name, OBJPROP_YSIZE, YSize);
   ObjectSetText(name, caption, FSize, "Arial", Tncolor);
   ObjectSet(name, OBJPROP_FONTSIZE, FSize);
   ObjectSet(name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSet(name, OBJPROP_COLOR, Tncolor);
   ObjectSet(name, OBJPROP_BGCOLOR, Bcolor);
   ObjectSet(name, OBJPROP_BACK, Transparent);
   ObjectSet(name, OBJPROP_BORDER_COLOR, Dcolor);
   ObjectSet(name, OBJPROP_STATE, false);
   ObjectSet(name, OBJPROP_HIDDEN, true);
}

void setSymbolButtonColor() {
   string lookFor = UniqueID + ":symbol:";
   int lookForLength = StringLen(lookFor);
   for (int i = ObjectsTotal() - 1; i >= 0; i--) {
      string objectName = ObjectName(i);
      if (StringSubstr(objectName, 0, lookForLength) == lookFor) {
         string symbol = ObjectGetString(0, objectName, OBJPROP_TEXT);
         if (symbol != _Symbol)
            ObjectSet(objectName, OBJPROP_COLOR, Tncolor);
         else ObjectSet(objectName, OBJPROP_COLOR, Sncolor);
      }
   }
}

void setTimeFrameButtonColor() {
   string lookFor = UniqueID + ":time:";
   int lookForLength = StringLen(lookFor);
   for (int i = ObjectsTotal() - 1; i >= 0; i--) {
      string objectName = ObjectName(i);
      if (StringSubstr(objectName, 0, lookForLength) == lookFor) {
         int time = stringToTimeFrame(ObjectGetString(0, objectName, OBJPROP_TEXT));
         if (time != _Period)
            ObjectSet(objectName, OBJPROP_COLOR, Tncolor);
         else ObjectSet(objectName, OBJPROP_COLOR, Sncolor);
      }
   }
}


string sTfTable[] = {
   "M1",
   "M5",
   "M15",
   "M30",
   "H1",
   "H4",
   "D1",
   "W1",
   "MN"
};

int iTfTable[] = {
   1,
   5,
   15,
   30,
   60,
   240,
   1440,
   10080,
   43200
};

string timeFrameToString(int tf) {
   for (int i = ArraySize(iTfTable) - 1; i >= 0; i--)
      if (tf == iTfTable[i]) return (sTfTable[i]);
   return ("");
}

int stringToTimeFrame(string tf) {
   for (int i = ArraySize(sTfTable) - 1; i >= 0; i--)
      if (tf == sTfTable[i]) return (iTfTable[i]);
   return (0);
}

void OnChartEvent(const int id,
   const long & lparam,
      const double & dparam,
         const string & sparam) {
   if (id == CHARTEVENT_OBJECT_CLICK && ObjectGet(sparam, OBJPROP_TYPE) == OBJ_BUTTON) {
      if (StringFind(sparam, UniqueID + ":symbol:", 0) == 0) ChartSetSymbolPeriod(0, ObjectGetString(0, sparam, OBJPROP_TEXT), _Period);
      if (StringFind(sparam, UniqueID + ":time:", 0) == 0) ChartSetSymbolPeriod(0, _Symbol, stringToTimeFrame(ObjectGetString(0, sparam, OBJPROP_TEXT)));
      if (StringFind(sparam, UniqueID + ":back:", 0) == 0) ObjectSet(sparam, OBJPROP_STATE, false);
   }
}

int start() {
   return (0);
}
