//+------------------------------------------------------------------+
//|                                SpielersHedge Divergence_v5.1.mq4 |
//|                                            © 2008.08.20 SwingMan |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "© 2008.08.20 SwingMan"
#property link ""
//+------------------------------------------------------------------+
//  v2 - write infos, like DivergenceStdDev v_1
//  v3 - shift days for basis
//     - Close or Open for reference    
//  v4 - fixe levels, alerts
//  v5 - 4 fixe levels
//  v5.1 - text size as parameter
//+------------------------------------------------------------------+

#property indicator_separate_window

#include <SpielersHedge_Library.mqh>

#property indicator_buffers 8
//---- colors
#property indicator_color1 DeepPink    // highs
#property indicator_color2 LimeGreen    // lows
#property indicator_color3 Tomato
#property indicator_color4 Tomato
#property indicator_color5 Tomato
#property indicator_color6 DeepSkyBlue
#property indicator_color7 DeepSkyBlue
#property indicator_color8 DeepSkyBlue
   
//---- Levels
#property indicator_level1 0
#property indicator_levelstyle STYLE_SOLID
#property indicator_levelcolor Gold


//---- input parameters --------------------------------------------
extern double DivergenceLimit1 = 0.25;
extern double DivergenceLimit2 = 0.50;
extern double DivergenceLimit3 = 0.75;
extern double DivergenceLimit4 = 1.00;
extern int ShiftDays_ForReference = 1;
extern bool Close_asReferencePrice = true;
extern int shiftPosition_Divergence = 5;
extern int fontSize_Divergence = 35;
extern int fontSize_Text = 10;
//------------------------------------------------------------------


//---- constants
string sWindow1 = "SpielersHedge Divergence_v5.1";
string sObject = "SHDiv_51_";

//---- Buffers
double RatioHighs[], RatioLows[];
double levelUp1[], levelUp2[], levelDn1[];
double levelDn2[], levelUp3[], levelDn3[];

//---- Arrays

//---- variables
string sWindowName;
double lastClose3, CurrentRange;
int iWindow, Trade_Direction;
double CurrentLastClose3;
double LevelValue[10];

//-- constants
int iLabelCorner = 1;
int xx1 = 80;
int xx2 = 2;
int xx3 = 60;
int xx4 = 30;
int yy0 = 5, yy;
int yStep;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{  
   yStep = fontSize_Text+2;
   if (DivergenceLimit1 == 0) DivergenceLimit1 = 0.25;
   //-- Trading levels
   LevelValue[1] = DivergenceLimit1;
   LevelValue[2] = DivergenceLimit2;
   LevelValue[3] = DivergenceLimit3;
   
   string st; 
   //-- Title
   if (Close_asReferencePrice == true) {
      st ="C,";
      st = st + ShiftDays_ForReference+", ";
   } else {
      st = "O,";
      st = st + ShiftDays_ForReference+", ";
   }   
   st = st + DoubleToStr(LevelValue[1],2);
   if (DivergenceLimit2 > 0)
      st = st + ", " + DoubleToStr(LevelValue[2],2);
   if (DivergenceLimit3 > 0)      
      st = st + ", " + DoubleToStr(LevelValue[3],2);   
   
   sWindowName = sWindow1 + " (" + st +") ";
   IndicatorShortName(sWindowName);   
   
        
//---- Moving Averages ----------------------------------  
   SetIndexBuffer(0, RatioHighs);
   SetIndexBuffer(1, RatioLows);
   SetIndexBuffer(2, levelUp1);
   SetIndexBuffer(3, levelUp2);
   SetIndexBuffer(4, levelUp3);
   SetIndexBuffer(5, levelDn1);
   SetIndexBuffer(6, levelDn2);
   SetIndexBuffer(7, levelDn3);
   
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(6,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(7,DRAW_LINE,STYLE_SOLID,1);
   
   SetIndexLabel(0,"Ratio SHORT trade");
   SetIndexLabel(1,"Ratio LONG trade");
   SetIndexLabel(2,NULL);
   SetIndexLabel(3,NULL);
   SetIndexLabel(4,NULL);
   SetIndexLabel(5,NULL);
   SetIndexLabel(6,NULL);
   SetIndexLabel(7,NULL);
   
//---- initialization done   
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{ 
   DeleteOwnObjects(sObject);
   return(0); 
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int i, y, limit;  
   datetime TimeArray[];   
   ArrayCopySeries(TimeArray,MODE_TIME,Symbol(),PERIOD_D1); 
   
   int counted_bars=IndicatorCounted();  
   if (counted_bars>0) counted_bars--;  
   limit=Bars - counted_bars;
        
//---- 1. Calculation ------------------------------------------------
   for(i=0,y=0;i<limit;i++)
   {
      if (Time[i]<TimeArray[y]) y++; 
      
      //-- Close as reference price
      if (Close_asReferencePrice == true) {      
         lastClose3 = iClose(Symbol(), PERIOD_D1, y+ShiftDays_ForReference);
      } else
      {
         lastClose3 = iOpen(Symbol(), PERIOD_D1, y+ShiftDays_ForReference-1);
      }     
      
      if (i==0) CurrentLastClose3 = lastClose3;
      
      double dHigh = iHigh(Symbol(), Period(), i);
      double dLow  = iLow(Symbol(), Period(), i);
      if (lastClose3 != 0) {
         RatioHighs[i] = 100*(dHigh - lastClose3) / lastClose3;
         RatioLows[i]  = 100*(dLow - lastClose3) / lastClose3;

         levelUp1[i] = LevelValue[1];
         if (DivergenceLimit2>0) levelUp2[i] = LevelValue[2];
         if (DivergenceLimit3>0) levelUp3[i] = LevelValue[3];
         levelDn1[i] = -LevelValue[1];
         if (DivergenceLimit2>0) levelDn2[i] = -LevelValue[2];
         if (DivergenceLimit3>0) levelDn3[i] = -LevelValue[3];
      }
   }
   
   double dClose = iClose(Symbol(), Period(), 0);
   CurrentRange = 100*(dClose - CurrentLastClose3) / CurrentLastClose3;
   
//-- write results   
   Write_TradingLevels();
   Write_CurrentRange();   
//----
   return(0);
}
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//    Write Trading Levels
//+------------------------------------------------------------------+
void Write_TradingLevels()
{
   string sLevel1, sLevel2, sLevel3, sPrices; 
   iWindow = WindowFind(sWindowName);
   int iBar = 0, iLevel;
     
   yy = yy0;
   iLabelCorner = 1;
   color dColor = Orange;
   color dColorArrow;
   int iHeight = 10;
   
   //-- prices   
   double dClose = iClose(Symbol(), Period(), 0);
   sPrices = "(" + DoubleToStr(CurrentLastClose3, Digits) + " / " + DoubleToStr(dClose, Digits) + ")";

   //-- get trade direction
   double dRatioHighs = RatioHighs[iBar];
   double dRatioLows  = RatioLows[iBar];
   
   double Diff_LongTrade  = MathAbs(dRatioLows  - levelDn1[iBar]);
   double Diff_ShortTrade = MathAbs(dRatioHighs - levelUp1[iBar]);
   
   if (CurrentRange < 0) Trade_Direction = 1; else Trade_Direction = -1;
   
//-- TEST values   
//CurrentRange = -0.525;
//Trade_Direction = 1;
   //-- Trade LONG ...................................................
   if (Trade_Direction == 1) {
      dColorArrow = Green;
      if (CurrentRange < levelDn1[iBar]) {
         string sTrend = "LONG";
         int ArrowCode = 233;
      }  else {        
         sTrend = "wait long";
         ArrowCode = 216;
      }
      //-- levels, CurrentRange < 0
      if (CurrentRange < levelDn1[iBar]) iLevel = 0;
      if (CurrentRange <= levelDn1[iBar] && CurrentRange > levelDn2[iBar]) iLevel = 1;
      if (DivergenceLimit2 > 0 && CurrentRange <= levelDn2[iBar]) iLevel = 2;
      if (DivergenceLimit3 > 0 && CurrentRange <= levelDn3[iBar]) iLevel = 3;

      sLevel1 = "1.= "  + DoubleToStr(levelDn1[iBar],2)+ "%";
      sLevel2 = "2.= "  + DoubleToStr(levelDn2[iBar],2)+ "%";
      sLevel3 = "3.= "  + DoubleToStr(levelDn3[iBar],2)+ "%";
   } else   
   
   //-- Trade SHORT ..................................................
   {
      dColorArrow = Red;
      if (CurrentRange >= levelUp1[iBar]) {
         sTrend = "SHORT";
         //sTrend = "SHORT trade";
         ArrowCode = 234;
      } else {
         sTrend = "wait short";
         ArrowCode = 216;
      }
      //-- levels, CurrentRange > 0
      if (CurrentRange > levelUp1[iBar]) iLevel = 0;
      if (CurrentRange >= levelUp1[iBar] && CurrentRange < levelUp2[iBar]) iLevel = 1;
      if (DivergenceLimit2 > 0 && CurrentRange >= levelUp2[iBar]) iLevel = 2;
      if (DivergenceLimit3 > 0 && CurrentRange >= levelUp3[iBar]) iLevel = 3;

      sLevel1 = "1.= "  + DoubleToStr(levelUp1[iBar],2)+ "%";
      sLevel2 = "2.= "  + DoubleToStr(levelUp2[iBar],2)+ "%";
      sLevel3 = "3.= "  + DoubleToStr(levelUp3[iBar],2)+ "%";      
   }
   
   //-- write text --------------------------------------------------
   //-- range and level
   string sRange = "Range: " + DoubleToStr(CurrentRange,2) + "%";
   string sLevel = "Level: " + iLevel;
   Write_Label(iWindow, iLabelCorner, sObject, sRange, "", fontSize_Text, dColor, xx2, xx2, yy); yy = yy + yStep;
   Write_Label(iWindow, iLabelCorner, sObject, sPrices, "", fontSize_Text, dColor, xx2, xx2, yy); yy = yy + yStep;
   Write_Label(iWindow, iLabelCorner, sObject, sLevel, "", fontSize_Text, dColor, xx2, xx2, yy); yy = yy + yStep;
   //-- trading levels
   yy = yy + 5;
   if (DivergenceLimit1>0)
      { Write_Label(iWindow, iLabelCorner, sObject, sLevel1, "", fontSize_Text, dColor, xx2, xx2, yy); yy = yy + yStep; }
   if (DivergenceLimit2>0)
      { Write_Label(iWindow, iLabelCorner, sObject, sLevel2, "", fontSize_Text, dColor, xx2, xx2, yy); yy = yy + yStep; }
   if (DivergenceLimit3>0)
      { Write_Label(iWindow, iLabelCorner, sObject, sLevel3, "", fontSize_Text, dColor, xx2, xx2, yy); yy = yy + yStep; }
  
   //-- trend
   dColor = Gold;
   yy = yy + 5;   
   Write_Label(iWindow, iLabelCorner, sObject, sTrend, "", fontSize_Text, dColor, xx2+20, xx2, yy);
   SetArrowObject(iWindow, iLabelCorner, sObject + "a", ArrowCode, 
                    iHeight, dColorArrow, xx2 + 5, yy);
}

//+------------------------------------------------------------------+
//    Write Current Range
//+------------------------------------------------------------------+
void Write_CurrentRange()
{
   //-- write CurrentRange
   int iTextCorner = 0;
   double fontFactor = 1.0;
   if (CurrentRange > 0) 
      color TextColor = Red ; else    // short trade
            TextColor = DeepSkyBlue;         // long trade
   datetime xx = Time[shiftPosition_Divergence];
   //-- y position
   if (CurrentRange>0) {
      //fontFactor = 0.5;
      string sign = "+";
   } else {
      //fontFactor = 1.5;
      sign = "";
   }   
   
   double yy = CurrentRange + (fontSize_Divergence*fontFactor) / 100.0;
   string text = "                " + sign + DoubleToStr(CurrentRange,2)+ "%";
   Write_Text(sObject+"Range", text, iWindow, iTextCorner, xx, yy, fontSize_Divergence, TextColor);
}   