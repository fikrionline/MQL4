//+------------------------------------------------------------------+
//|                                                     28PairEA.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

// بسم الله الرحمن الرحيم

// اَللَّهُمَّ صَلِّ عَلٰى سَيِّدِنَا مُحَمَّدٍ وَعَلٰى اٰلِ سَيِّدِنَا مُحَمَّدٍ

#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern string Pair1 = "GBPUSD";
extern double TargetPair1 = 1.37651;
extern string Pair2 = "USDJPY";
extern double TargetPair2 = 109.832;
extern double BasicLot = 1;

string IndicatorSymbol[28];
double LotAUDCAD, LotAUDCHF, LotAUDJPY, LotAUDNZD, LotAUDUSD, LotCADCHF, LotCADJPY, LotCHFJPY, LotEURAUD, LotEURCAD, LotEURCHF, LotEURGBP, LotEURJPY, LotEURNZD, LotEURUSD, LotGBPAUD, LotGBPCAD, LotGBPCHF, LotGBPJPY, LotGBPNZD, LotGBPUSD, LotNZDCAD, LotNZDCHF, LotNZDJPY, LotNZDUSD, LotUSDCAD, LotUSDCHF, LotUSDJPY;
double TargetAUDCAD, TargetAUDCHF, TargetAUDJPY, TargetAUDNZD, TargetAUDUSD, TargetCADCHF, TargetCADJPY, TargetCHFJPY, TargetEURAUD, TargetEURCAD, TargetEURCHF, TargetEURGBP, TargetEURJPY, TargetEURNZD, TargetEURUSD, TargetGBPAUD, TargetGBPCAD, TargetGBPCHF, TargetGBPJPY, TargetGBPNZD, TargetGBPUSD, TargetNZDCAD, TargetNZDCHF, TargetNZDJPY, TargetNZDUSD, TargetUSDCAD, TargetUSDCHF, TargetUSDJPY;
string CommentAUDCAD, CommentAUDCHF, CommentAUDJPY, CommentAUDNZD, CommentAUDUSD, CommentCADCHF, CommentCADJPY, CommentCHFJPY, CommentEURAUD, CommentEURCAD, CommentEURCHF, CommentEURGBP, CommentEURJPY, CommentEURNZD, CommentEURUSD, CommentGBPAUD, CommentGBPCAD, CommentGBPCHF, CommentGBPJPY, CommentGBPNZD, CommentGBPUSD, CommentNZDCAD, CommentNZDCHF, CommentNZDJPY, CommentNZDUSD, CommentUSDCAD, CommentUSDCHF, CommentUSDJPY;

//OnInit
int OnInit() {

   return (INIT_SUCCEEDED);
   
}

//OnTick
void OnTick() {

   string ShowComment = "";
   string BasicComment = "Basic Lot: " + DoubleToString(BasicLot, 2) + "\n";

   IndicatorSymbol[0] = "AUDCAD";
   IndicatorSymbol[1] = "AUDCHF";
   IndicatorSymbol[2] = "AUDJPY";
   IndicatorSymbol[3] = "AUDNZD";
   IndicatorSymbol[4] = "AUDUSD";
   IndicatorSymbol[5] = "CADCHF";
   IndicatorSymbol[6] = "CADJPY";
   IndicatorSymbol[7] = "CHFJPY";
   IndicatorSymbol[8] = "EURAUD";
   IndicatorSymbol[9] = "EURCAD";
   IndicatorSymbol[10] = "EURCHF";
   IndicatorSymbol[11] = "EURGBP";
   IndicatorSymbol[12] = "EURJPY";
   IndicatorSymbol[13] = "EURNZD";
   IndicatorSymbol[14] = "EURUSD";
   IndicatorSymbol[15] = "GBPAUD";
   IndicatorSymbol[16] = "GBPCAD";
   IndicatorSymbol[17] = "GBPCHF";
   IndicatorSymbol[18] = "GBPJPY";
   IndicatorSymbol[19] = "GBPNZD";
   IndicatorSymbol[20] = "GBPUSD";
   IndicatorSymbol[21] = "NZDCAD";
   IndicatorSymbol[22] = "NZDCHF";
   IndicatorSymbol[23] = "NZDJPY";
   IndicatorSymbol[24] = "NZDUSD";
   IndicatorSymbol[25] = "USDCAD";
   IndicatorSymbol[26] = "USDCHF";
   IndicatorSymbol[27] = "USDJPY";
   
   TargetGBPUSD = TargetPair1;
   TargetUSDJPY = TargetPair2;
   TargetGBPJPY = NormalizeDouble(TargetGBPUSD * TargetUSDJPY, (int)MarketInfo("GBPJPY", MODE_DIGITS));
   
   LotGBPUSD = NormalizeDouble(BasicLot * (TargetGBPJPY / TargetUSDJPY), 2);
   LotUSDJPY = NormalizeDouble(BasicLot * (TargetGBPJPY / TargetGBPUSD) / 100, 2);
   LotGBPJPY = NormalizeDouble(BasicLot * (TargetGBPUSD * TargetUSDJPY) / 100, 2);
   
   CommentGBPUSD = "GBPUSD target " + DoubleToString(TargetGBPUSD, (int)MarketInfo("GBPUSD", MODE_DIGITS)) + " lot " + DoubleToString(LotGBPUSD, 2) + "\n";
   CommentUSDJPY = "USDJPY target " + DoubleToString(TargetUSDJPY, (int)MarketInfo("USDJPY", MODE_DIGITS)) + " lot " + DoubleToString(LotUSDJPY, 2) + "\n";
   CommentGBPJPY = "GBPJPY target " + DoubleToString(TargetGBPJPY, (int)MarketInfo("GBPJPY", MODE_DIGITS)) + " lot " + DoubleToString(LotGBPJPY, 2) + "\n";
   
   ShowComment = BasicComment + CommentAUDCAD + CommentAUDCHF + CommentAUDJPY + CommentAUDNZD + CommentAUDUSD + CommentCADCHF + CommentCADJPY + CommentCHFJPY + CommentEURAUD + CommentEURCAD + CommentEURCHF + CommentEURGBP + CommentEURJPY + CommentEURNZD + CommentEURUSD + CommentGBPAUD + CommentGBPCAD + CommentGBPCHF + CommentGBPJPY + CommentGBPNZD + CommentGBPUSD + CommentNZDCAD + CommentNZDCHF + CommentNZDJPY + CommentNZDUSD + CommentUSDCAD + CommentUSDCHF + CommentUSDJPY;
   
   for(int i=0; i<ArraySize(IndicatorSymbol); i++) {
      
   }
   
   //string ShowComment = "";
   //ShowComment = ShowComment + Pair1 + " target " + DoubleToString(TargetPair1, (int)MarketInfo(Pair1, MODE_DIGITS)) + " / " + Pair2 + " target " + DoubleToString(TargetPair2, (int)MarketInfo(Pair2, MODE_DIGITS));
   
   Comment(ShowComment);

}
