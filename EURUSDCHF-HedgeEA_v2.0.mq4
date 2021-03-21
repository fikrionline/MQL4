//+------------------------------------------------------------------+
//|                                                 SpreadsHedge.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//Choose Pair
extern string Pair1 = "EURCHF";
extern string Pair2 = "EURUSD";
extern string Pair3 = "USDCHF";
extern int GetDay = 5;
extern double BasicLot = 0.5;
extern bool SendNotif = false;
extern double Level1 = 0.30;
extern double Level2 = 0.50;
extern double Level3 = 0.70;
extern double Level4 = 0.90;
extern double Level5 = 1.10;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{

   string SendNotifComment;
   if(SendNotif == true)
   {
      SendNotifComment = "Yes";
   }else
   if(SendNotif == false)
   {
      SendNotifComment = "No";
   }
   
   string ShowComment = "GetDay " + IntegerToString(GetDay) + " :: BasicLot " + DoubleToStr(BasicLot, 2) + " :: SendNotif " + SendNotifComment + " :: Level " + DoubleToStr(Level1, 2) + " " + DoubleToStr(Level2, 2) + " "+ DoubleToStr(Level3, 2) + " "+ DoubleToStr(Level4, 2) + " "+ DoubleToStr(Level5, 2);
   
   double YesterdayClose1 = iClose(Pair1, PERIOD_D1, 1);
   double YesterdayClose2 = iClose(Pair2, PERIOD_D1, 1);
   double YesterdayClose3 = iClose(Pair3, PERIOD_D1, 1);
   
   double PriceBid1 = MarketInfo(Pair1, MODE_BID);
   double PriceBid2 = MarketInfo(Pair2, MODE_BID);
   double PriceBid3 = MarketInfo(Pair3, MODE_BID);
   
   /*
   double Lot1 = BasicLot * (PriceBid2 * PriceBid3);
   double Lot2 = BasicLot * (PriceBid1 / PriceBid3);
   double Lot3 = BasicLot * (PriceBid1 / PriceBid2);
   */
   
   double Lot1 = BasicLot * (PriceBid2 * PriceBid3);
   double Lot2 = BasicLot * (PriceBid3 / PriceBid1);
   double Lot3 = BasicLot * (PriceBid2 / PriceBid1);
   
   double PriceAsk1 = MarketInfo(Pair1, MODE_ASK);
   double PriceAsk2 = MarketInfo(Pair2, MODE_ASK);
   double PriceAsk3 = MarketInfo(Pair3, MODE_ASK);
   
   double DayClose1, DayClose2, DayClose3, Change1, Change2, Change3, Prosentase1, Prosentase2, Prosentase3;
   string PlusMinus1, PlusMinus2, PlusMinus3;
   string DayComment1 = Pair1;
   string DayComment2 = Pair2;
   string DayComment3 = Pair3;
   
   for(int d=GetDay; d>0; d--)
   {
      
      //Pair1
      DayClose1 = iClose(Pair1, PERIOD_D1, d);
      if(DayClose1 < PriceBid1)
      {
         Change1 = PriceBid1 - DayClose1;
         PlusMinus1 = "+";
      }   
      if(DayClose1 > PriceBid1)
      {
         Change1 = DayClose1 - PriceBid1;
         PlusMinus1 = "-";
      }
      Prosentase1 = (Change1/DayClose1) * 100;
      DayComment1 = DayComment1 + " | " + PlusMinus1 + DoubleToStr(Prosentase1, 3) + "%"; 
      
      
      //pair2
      DayClose2 = iClose(Pair2, PERIOD_D1, d);
      if(DayClose2 < PriceBid2)
      {
         Change2 = PriceBid2 - DayClose2;
         PlusMinus2 = "+";
      }   
      if(DayClose2 > PriceBid2)
      {
         Change2 = DayClose2 - PriceBid2;
         PlusMinus2 = "-";
      }
      Prosentase2 = (Change2/DayClose2) * 100;
      DayComment2 = DayComment2 + " | " + PlusMinus2 + DoubleToStr(Prosentase2, 3) + "%";
      
      
      //Pair3
      DayClose3 = iClose(Pair3, PERIOD_D1, d);
      if(DayClose3 < PriceBid3)
      {
         Change3 = PriceBid3 - DayClose3;
         PlusMinus3 = "+";
      }   
      if(DayClose3 > PriceBid3)
      {
         Change3 = DayClose3 - PriceBid3;
         PlusMinus3 = "-";
      }
      Prosentase3 = (Change3/DayClose3) * 100;
      DayComment3 = DayComment3 + " | " + PlusMinus3 + DoubleToStr(Prosentase3, 3) + "% ";
      
      
   }
   
   DayComment1 = DayComment1 + " | Lot " + DoubleToStr(Lot1, 2);
   DayComment2 = DayComment2 + " | Lot " + DoubleToStr(Lot2, 2);
   DayComment3 = DayComment3 + " | Lot " + DoubleToStr(Lot3, 2);
   
   ShowComment = ShowComment + "\n" + DayComment1 + "\n" + DayComment2 + "\n" + DayComment3;
   Comment(ShowComment);
   
   if(SendNotif == true)
   {
      if(Prosentase1 > Level1 && Prosentase1 < Level2)
      {
         static datetime TimeStamp;
         int NotifCount = 0;
         if(TimeStamp != Time[0])
         {
            SendNotification(Pair1 + " " + DoubleToStr(Prosentase1, 3) + "%\nLevel1");
            NotifCount = 1;
            TimeStamp = Time[0];
         }
      }
      
      if(Prosentase1 > Level2 && Prosentase1 < Level3)
      {
         static datetime TimeStamp;
         int NotifCount = 0;
         if(TimeStamp != Time[0])
         {
            SendNotification(Pair1 + " " + DoubleToStr(Prosentase1, 3) + "%\nLevel2");
            NotifCount = 1;
            TimeStamp = Time[0];
         }
      }
      
      if(Prosentase1 > Level3 && Prosentase1 < Level4)
      {
         static datetime TimeStamp;
         int NotifCount = 0;
         if(TimeStamp != Time[0])
         {
            SendNotification(Pair1 + " " + DoubleToStr(Prosentase1, 3) + "%\nLevel3");
            NotifCount = 1;
            TimeStamp = Time[0];
         }
      }
      
      if(Prosentase1 > Level4 && Prosentase1 < Level5)
      {
         static datetime TimeStamp;
         int NotifCount = 0;
         if(TimeStamp != Time[0])
         {
            SendNotification(Pair1 + " " + DoubleToStr(Prosentase1, 3) + "%\nLevel4");
            NotifCount = 1;
            TimeStamp = Time[0];
         }
      }
      
      if(Prosentase1 > Level5)
      {
         static datetime TimeStamp;
         int NotifCount = 0;
         if(TimeStamp != Time[0])
         {
            SendNotification(Pair1 + " " + DoubleToStr(Prosentase1, 3) + "%\nLevel5");
            NotifCount = 1;
            TimeStamp = Time[0];
         }
      }
   }
  
}
//+------------------------------------------------------------------+
