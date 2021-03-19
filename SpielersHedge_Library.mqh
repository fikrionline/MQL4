//+------------------------------------------------------------------+
//|                                        SpielersHedge_Library.mq4 |
//|                                            © 2008.07.12 SwingMan |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "© 2008.07.12 SwingMan"
#property link      ""

#include <stdlib.mqh>

//####################################################################
//+------------------------------------------------------------------+
//    Get Threshold Value
//+------------------------------------------------------------------+
void Get_MedRange_DevRange(double RangeUp[], double RangeDn[],
                          int lastBar, int firstBar, int ma_shift,
                          double& MedRange, double& DevRange)
{
   double MaxRange[1000];
   ArraySetAsSeries(MaxRange,true);
   
   int Period_Statistic = firstBar - lastBar + 1;
   int i = -1;
   
   for (int iBar=lastBar; iBar < firstBar; iBar++) {
      i++;
      MaxRange[i] = MathMax(MathAbs(RangeUp[iBar]), MathAbs(RangeDn[iBar]));
   }

   // ma_shift = 1, one bar ago ...?
   //-- take only the minim differences
   int total = 0; // whole array
   int shift = 0; // is for MaxRange array!
   MedRange = iMAOnArray(    MaxRange,total, Period_Statistic, ma_shift, MODE_SMA, shift);
   DevRange = iStdDevOnArray(MaxRange,total, Period_Statistic, ma_shift, MODE_SMA, shift);
} 


//####################################################################
//+------------------------------------------------------------------+
//    Write Label
//+------------------------------------------------------------------+
void Write_Label(int iWindow, int iLabelCorner, string sObject, 
                 string text1, string text2, int fontSize_Text, color dColor, int xx1, int xx2, int yy)
{
   string name1 = sObject + "1" + yy;
   string name2 = sObject + "2" + yy;
   SetLabelObject(iWindow, iLabelCorner, name1, text1, fontSize_Text, dColor, xx1, yy);
   SetLabelObject(iWindow, iLabelCorner, name2, text2, fontSize_Text, dColor, xx2, yy);
   return;
}

//+------------------------------------------------------------------+
//    Set Label Object
//+------------------------------------------------------------------+
void SetLabelObject(int iWindow, int iLabelCorner, string sName, string sText, 
                    int fontSize_Text, color dColor, int xx, int yy)
{
   ObjectCreate(sName, OBJ_LABEL, iWindow, 0, 0);
        ObjectSetText(sName,sText,fontSize_Text, "Arial Bold", dColor);
        ObjectSet(sName, OBJPROP_CORNER, iLabelCorner);
        ObjectSet(sName, OBJPROP_XDISTANCE, xx);
        ObjectSet(sName, OBJPROP_YDISTANCE, yy);
   return;     
}

//+------------------------------------------------------------------+
//| Set Arrow Object
//+------------------------------------------------------------------+
void SetArrowObject(int iWindow, int iLabelCorner, string sName, int ArrowCode, 
                    int iHeight, color dColor, int xx, int yy)
{
   ObjectCreate(sName, OBJ_LABEL, iWindow, 0, 0);
   ObjectSetText(sName,CharToStr(ArrowCode),iHeight, "Wingdings", dColor);
        ObjectSet(sName, OBJPROP_CORNER, iLabelCorner);
        ObjectSet(sName, OBJPROP_XDISTANCE, xx);
        ObjectSet(sName, OBJPROP_YDISTANCE, yy);
}


//+------------------------------------------------------------------+
//    Write Text
//+------------------------------------------------------------------+
void Write_Text(string sName, string text, int iWindow, int iTextCorner, datetime xx, double yy, 
                int fontSize_Text, color TextColor)
{
   ObjectCreate(sName, OBJ_TEXT, iWindow, xx, yy);
	ObjectSetText(sName, text, fontSize_Text, "Arial Bold", TextColor);
	ObjectSet(sName, OBJPROP_CORNER, iTextCorner);
	ObjectSet(sName, OBJPROP_TIME1, xx);
	ObjectSet(sName, OBJPROP_PRICE1, yy);
	//ObjectSet(sName, OBJPROP_XDISTANCE, xx);
	//ObjectSet(sName, OBJPROP_YDISTANCE, yy);
}


//+------------------------------------------------------------------+
//    Delete Own Objects
//+------------------------------------------------------------------+
void DeleteOwnObjects(string sObject)
{
   int i=0;
   while (i <= ObjectsTotal()) {
      if (StringFind(ObjectName(i), sObject) >= 0) ObjectDelete(ObjectName(i));
      else
      i++;
   }
   return;
}


//####################################################################
//+------------------------------------------------------------------+
//|      Get PairList Names
//+------------------------------------------------------------------+
void Get_PairListNames(string Symbols, string SymbolSuffix, string& Pair[])
{
   int i,j,k;
   string CurSymbol;
   
   for (i=0, j=0, k=1; i<50 && k>0;)
   {
      k=StringFind(Symbols,",",j);
      if (k==0) CurSymbol=StringSubstr(Symbols,j,0);
      else CurSymbol=StringSubstr(Symbols,j,k-j);
      CurSymbol = CurSymbol + SymbolSuffix;
      //---- check if the pair is allowable
      double dClose = iClose(CurSymbol,Period(),0);      
      if (dClose > 0.0) {
         Pair[i]=CurSymbol;
         i++;
      }
     
      j=StringFind(Symbols,",",j)+1;
      if (j==0) break;
   }
   //NumberSymbols = i;
   return;
}

//####################################################################
//+------------------------------------------------------------------+
//    Draw Threshold Lines
//+------------------------------------------------------------------+
void Draw_ThresholdLines(string sObject, int iWindow, 
     double lastClose3, double LevelValue[], 
     double& EntryLongValue[], double& EntryShortValue[], datetime tLastClose3)
{
   if (tLastClose3 != 0)
      int firstThresholdBar = iBarShift(Symbol(), Period(), tLastClose3) + 20;
   else   firstThresholdBar = 0;   

//Print("tLastClose3=",TimeToStr(tLastClose3),"  firstThresholdBar=",tLastClose3);
   color colorClose  = Gold;
   color colorLineUp = Tomato;
   color colorLineDn = DeepSkyBlue;
   
   double Difference1 = lastClose3 * LevelValue[1]/100.0;
   double Difference2 = lastClose3 * LevelValue[2]/100.0;
   double Difference3 = lastClose3 * LevelValue[3]/100.0;
   double Difference4 = lastClose3 * LevelValue[4]/100.0;   
   
   double lineUp1 = lastClose3 + Difference1;   double lineDn1 = lastClose3 - Difference1;
   double lineUp2 = lastClose3 + Difference2;   double lineDn2 = lastClose3 - Difference2;
   double lineUp3 = lastClose3 + Difference3;   double lineDn3 = lastClose3 - Difference3;
   double lineUp4 = lastClose3 + Difference4;   double lineDn4 = lastClose3 - Difference4;
   
   EntryLongValue[1] = lineDn1;
   EntryLongValue[2] = lineDn2;
   EntryLongValue[3] = lineDn3;
   EntryLongValue[4] = lineDn4;
   EntryShortValue[1] = lineUp1;
   EntryShortValue[2] = lineUp2;
   EntryShortValue[3] = lineUp3;
   EntryShortValue[4] = lineUp4;


   Draw_HLine("lineClose"+sObject, iWindow, lastClose3, colorClose, firstThresholdBar);
   Draw_HLine("lineUp1"+sObject,   iWindow, lineUp1, colorLineUp, firstThresholdBar);
   Draw_HLine("lineDn1"+sObject,   iWindow, lineDn1, colorLineDn, firstThresholdBar);
   Draw_HLine("lineUp2"+sObject,   iWindow, lineUp2, colorLineUp, firstThresholdBar);
   Draw_HLine("lineDn2"+sObject,   iWindow, lineDn2, colorLineDn, firstThresholdBar);
   Draw_HLine("lineUp3"+sObject,   iWindow, lineUp3, colorLineUp, firstThresholdBar);
   Draw_HLine("lineDn3"+sObject,   iWindow, lineDn3, colorLineDn, firstThresholdBar);
   Draw_HLine("lineUp4"+sObject,   iWindow, lineUp4, colorLineUp, firstThresholdBar);
   Draw_HLine("lineDn4"+sObject,   iWindow, lineDn4, colorLineDn, firstThresholdBar);
   
   //-- labels
   color TextColor = colorLineUp;
   int iTextCorner = 1;
   int fontSize = 8;
   int xx = Time[12];

   //-- DRAW HORIZONTAL LINE   
   if (firstThresholdBar == 0) {
      //-- lines above close3
      Write_Text(sObject+"lineUp1", "+"+DoubleToStr(LevelValue[1],2)+"%", iWindow, iTextCorner, xx, lineUp1, fontSize, TextColor);
      Write_Text(sObject+"lineUp2", "+"+DoubleToStr(LevelValue[2],2)+"%", iWindow, iTextCorner, xx, lineUp2, fontSize, TextColor);
      Write_Text(sObject+"lineUp3", "+"+DoubleToStr(LevelValue[3],2)+"%", iWindow, iTextCorner, xx, lineUp3, fontSize, TextColor);
      Write_Text(sObject+"lineUp4", "+"+DoubleToStr(LevelValue[4],2)+"%", iWindow, iTextCorner, xx, lineUp4, fontSize, TextColor);

      //-- lines belove close3
      TextColor = colorLineDn;
      Write_Text(sObject+"lineDn1", DoubleToStr(-LevelValue[1],2)+"%", iWindow, iTextCorner, xx, lineDn1, fontSize, TextColor);
      Write_Text(sObject+"lineDn2", DoubleToStr(-LevelValue[2],2)+"%", iWindow, iTextCorner, xx, lineDn2, fontSize, TextColor);
      Write_Text(sObject+"lineDn3", DoubleToStr(-LevelValue[3],2)+"%", iWindow, iTextCorner, xx, lineDn3, fontSize, TextColor);
      Write_Text(sObject+"lineDn4", DoubleToStr(-LevelValue[4],2)+"%", iWindow, iTextCorner, xx, lineDn4, fontSize, TextColor);
   } else 
   //-- DRAW TREND LINE
   {
      Write_Text(sObject+"lineClose", DoubleToStr(lastClose3,Digits), 
         iWindow, iTextCorner, xx, lastClose3, fontSize, colorClose);
      //-- lines above close3
      Write_Text(sObject+"lineUp1", "+" + DoubleToStr(LevelValue[1],2)+"% = " + DoubleToStr(lineUp1,Digits), 
         iWindow, iTextCorner, xx, lineUp1, fontSize, TextColor);
      Write_Text(sObject+"lineUp2", "+" + DoubleToStr(LevelValue[2],2)+"% = " + DoubleToStr(lineUp2,Digits),
         iWindow, iTextCorner, xx, lineUp2, fontSize, TextColor);
      Write_Text(sObject+"lineUp3", "+" + DoubleToStr(LevelValue[3],2)+"% = " + DoubleToStr(lineUp3,Digits),
         iWindow, iTextCorner, xx, lineUp3, fontSize, TextColor);
      Write_Text(sObject+"lineUp4", "+" + DoubleToStr(LevelValue[4],2)+"% = " + DoubleToStr(lineUp4,Digits),
         iWindow, iTextCorner, xx, lineUp4, fontSize, TextColor);

      //-- lines belove close3
      TextColor = colorLineDn;
      Write_Text(sObject+"lineDn1", DoubleToStr(-LevelValue[1],2)+"% = " + DoubleToStr(lineDn1,Digits), 
         iWindow, iTextCorner, xx, lineDn1, fontSize, TextColor);
      Write_Text(sObject+"lineDn2", DoubleToStr(-LevelValue[2],2)+"% = " + DoubleToStr(lineDn2,Digits), 
         iWindow, iTextCorner, xx, lineDn2, fontSize, TextColor);
      Write_Text(sObject+"lineDn3", DoubleToStr(-LevelValue[3],2)+"% = " + DoubleToStr(lineDn3,Digits), 
         iWindow, iTextCorner, xx, lineDn3, fontSize, TextColor);
      Write_Text(sObject+"lineDn4", DoubleToStr(-LevelValue[4],2)+"% = " + DoubleToStr(lineDn4,Digits), 
         iWindow, iTextCorner, xx, lineDn4, fontSize, TextColor);   
   }
   return;
}

void Draw_HLine(string sName, int iWindow, double value, color iColor, int firstThresholdBar)
{  
   //-- draw horizontal line
   if (firstThresholdBar == 0) {
      ObjectCreate(sName, OBJ_HLINE, iWindow, 0, value);
      ObjectSet(sName, OBJPROP_COLOR, iColor);
      ObjectSet(sName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(sName, OBJPROP_TIME1, 0);
      ObjectSet(sName, OBJPROP_PRICE1, value);
   } else 
   //-- draw trend line
   { 
      datetime myTime1 = iTime(Symbol(), Period(), firstThresholdBar);
      datetime myTime2 = iTime(Symbol(), Period(), 0);

      ObjectCreate(sName, OBJ_TREND, iWindow, myTime1, value, myTime2, value);
      ObjectSet(sName, OBJPROP_COLOR, iColor);
      ObjectSet(sName, OBJPROP_STYLE, STYLE_SOLID);      
      ObjectSet(sName, OBJPROP_RAY, false);
   }
   return;
}


//####################################################################
//+------------------------------------------------------------------+
//    Send_ErrorDescription
//+------------------------------------------------------------------+
void Send_ErrorDescription(string sSymbol, string sText)
{
   int err=GetLastError(); 
   if (sText != "")
   string st = sSymbol + " error(" + err + "): " + ErrorDescription(err)+ " -> " + sText; else
          st = sSymbol + " error(" + err + "): " + ErrorDescription(err);
   Alert(st);    
}

//+------------------------------------------------------------------+
//    Get sPeriod
//+------------------------------------------------------------------+
string Get_sPeriod(int timeframe)
{
   if (timeframe == PERIOD_M1) return("M1");
   if (timeframe == PERIOD_M5) return("M5");
   if (timeframe == PERIOD_M15) return("M15");
   if (timeframe == PERIOD_M30) return("M30");
   if (timeframe == PERIOD_H1) return("H1");
   if (timeframe == PERIOD_H4) return("H4");
   if (timeframe == PERIOD_D1) return("D1");
   if (timeframe == PERIOD_W1) return("W1");
   if (timeframe == PERIOD_MN1) return("MN1");   
}

