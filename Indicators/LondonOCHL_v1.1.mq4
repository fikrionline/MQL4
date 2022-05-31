//
// Some code from http://www.forexfactory.com/showthread.php?t=247220
//
//+------------------------------------------------------------------+
//|                                              LondonOCHL_v1.1.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.10"
#property indicator_chart_window

extern string StartTime = "10:00";
extern int BackLimit = 33;
extern string IndicatorID = "LondonOCHL";
extern color BullishColor = clrBlue;
extern color BearishColor = clrRed;
extern int PositionLabel = 300;

color ColorActive;
int StartiBarShift, EndiBarShift;

int init() {
   Comment("LondonOCHL(" + StartTime + ")");
   IndicatorSetString(INDICATOR_SHORTNAME, IndicatorID);
   return (0);   
}

int deinit() {
   Comment("");
   for(int i=1; i<=BackLimit; i++) {
      ObjectDelete(IndicatorID + i);
      ObjectDelete(IndicatorID + i + "Label");
   }
   return (0);   
}

void start() {
   
   for(int i=1; i<=BackLimit; i++) {
   
      StartiBarShift = iBarShift(Symbol(), PERIOD_H1, StrToTime(TimeToString(StrToTime(StartTime) - (60 * 60 * 24) * (i - 1))));
      EndiBarShift = iBarShift(Symbol(), PERIOD_H1, StrToTime(TimeToString(StrToTime(StartTime) - (60 * 60 * 24) * i)));
      
      if(Open[EndiBarShift] < Open[StartiBarShift]) {
         ColorActive = BullishColor;
      } else if(Open[EndiBarShift] > Open[StartiBarShift]){
         ColorActive = BearishColor;
      }
      
      ObjectCreate(IndicatorID + i, IndicatorID + i, OBJ_TREND, 0, iTime(Symbol(), PERIOD_H1, EndiBarShift), iOpen(Symbol(), PERIOD_H1, EndiBarShift), iTime(Symbol(), PERIOD_H1, StartiBarShift), iOpen(Symbol(), PERIOD_H1, StartiBarShift));
      ObjectSetInteger(IndicatorID + i, IndicatorID + i, OBJPROP_RAY, false);
      ObjectSetInteger(IndicatorID + i, IndicatorID + i, OBJPROP_COLOR, ColorActive);
      ObjectSetInteger(IndicatorID + i, IndicatorID + i, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(IndicatorID + i, IndicatorID + i, OBJPROP_WIDTH, 1);
      ObjectSetInteger(IndicatorID + i, IndicatorID + i, OBJPROP_BACK, true);
      
      ObjectCreate(IndicatorID + i + "Label", OBJ_TEXT, 0, iTime(Symbol(), PERIOD_H1, EndiBarShift), iOpen(Symbol(), PERIOD_H1, EndiBarShift) + PositionLabel * Point());
      ObjectSetText(IndicatorID + i + "Label", iOpen(Symbol(), PERIOD_H1, EndiBarShift), 8, "Courier New", ColorActive);
      
   }

}
