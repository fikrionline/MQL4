//+------------------------------------------------------------------+
//|                                                    PairPrice.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

void OnStart() {
   
   string IndicatorSymbol[28];
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
   
   string FileName = "PairPrice.csv";
   int FileHandle = FileOpen(FileName, FILE_WRITE | FILE_CSV);
   FileWrite(FileHandle, "SYMBOL", "PRICE");
   
   for(int i=0; i<ArraySize(IndicatorSymbol); i++) {
      FileWrite(FileHandle, IndicatorSymbol[i], DoubleToString(MarketInfo(IndicatorSymbol[i], MODE_BID), (int)MarketInfo(IndicatorSymbol[i], MODE_DIGITS)));
   }
   
   FileFlush(FileHandle);
   FileClose(FileHandle);
   
}
