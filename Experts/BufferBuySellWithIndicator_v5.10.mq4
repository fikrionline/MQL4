//+------------------------------------------------------------------+
//|                     BufferBuySellMartingaleNoIndicator_v5.10.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "5.10"

enum BuySellChoose {
   BuySell,
   BuyOnly,
   SellOnly
};

extern BuySellChoose BuyOrSell = BuySell;

enum MagicNumberPartList {
   One,
   Two,
   Three,
   Four,
   Five,
   Six,
   Seven,
   Eight,
   Nine
};

extern MagicNumberPartList MagicNumberPart = One;
extern double EquityMinStopEA = 9600.00;
extern double EquityMaxStopEA = 10808.00;
extern double MaxDailyDrawDown = 400;
extern int StartHour = 8;
extern int EndHour = 22;
extern double StartingLots = 0.01;
extern double LotsMultiplier = 1.1;
extern double PipStepDevideADR = 10;
extern double PipStepMultiplier = 1.1;
extern int RealOrderLayerStart = 1;
extern double RealOrderLotStart = 0.01;
extern double TakeProfitDevideADR = 10;
extern double TakeProfitPlus = 5;
extern double SlipPage = 5;
extern int MaxTrades = 33;
extern double StopHighPrice = 0;
extern double StopLowPrice = 0;
extern int SetZeroAfterSomeTP = 1;
extern int BEPHunterOnLayer = 3;
extern double BEPHunterProfit = 3;

int TicketOrderSend, TicketOrderSelect, TicketOrderModify, TicketOrderClose, TicketOrderDelete, TotalOrderBuy, TotalOrderSell, LastTicket, LastTicketTemp, NumOfTradesSell, NumOfTradesBuy, MagicNumberBuy, MagicNumberSell, cnt;
double PriceTargetBuy, PriceTargetSell, AveragePriceBuy, AveragePriceSell, LastBuyPrice, LastSellPrice, iLotsBuy, iLotsSell, MaxLotsBuy, MaxLotsSell, ADRs, PipStep, TakeProfit, FirstTPOrderBuy, FirstTPOrderSell, StartEquityBuySell, Count, LastPipStepMultiplierBuy, LastPipStepMultiplierSell, PNL, PNLMax, PNLMin, PNLBuy, PNLBuyMax, PNLBuyMin, PNLSell, PNLSellMax, PNLSellMin, EquityMin, EquityMax;
bool NewOrdersPlacedBuy = FALSE, NewOrdersPlacedSell = FALSE, FirstOrderBuy = FALSE, FirstOrderSell = FALSE;

double BufferBuyPrice[], BufferBuyLots[], BufferLastBuyPrice, BufferBuyTP, BufferLastPipStepMultiplierBuy, BufferiLotsBuy, BufferAveragePriceBuy;
int BufferBuyCounter, BufferTotalOrderBuy, SetZeroAfterSomeTPBuy;
bool BufferNewOrderBuy = FALSE;

double BufferSellPrice[], BufferSellLots[], BufferLastSellPrice, BufferSellTP, BufferLastPipStepMultiplierSell, BufferiLotsSell, BufferAveragePriceSell;
int BufferSellCounter, BufferTotalOrderSell, SetZeroAfterSomeTPSell;
bool BufferNewOrderSell = FALSE;

double RealPriceMaxBuy, RealPriceMinSell, iLotsBuyReal, iLotsSellReal;
bool RealStartBuy = FALSE, RealStartSell = FALSE;

static datetime LastTradeBarTime;

int init() {
   LastTradeBarTime = Time[1];
   return (0);
}

int deinit() {
   //Comment("");
   return (0);
}

int start() {

   if(Hour() > EndHour) {
      //RemoveAllOrders();
   }

   if (LastTradeBarTime == Time[0]) {

      return (0);

   } else {

      LastTradeBarTime = Time[0];

      MinRemoveExpertNow(EquityMinStopEA);
      MaxRemoveExpertNow(EquityMaxStopEA);
      MaxDailyDrawDownRemoveExpertNow(MaxDailyDrawDown);
      
      if(GetTotalOrderBuy() >= BEPHunterOnLayer) {
         if((AccountEquity() - AccountBalance()) > BEPHunterProfit) {
            RemoveAllOrders();
         }
      }
      
      if(GetTotalOrderSell() >= BEPHunterOnLayer) {
         if((AccountEquity() - AccountBalance()) > BEPHunterProfit) {
            RemoveAllOrders();
         }
      }

      if (StopHighPrice > 0 && Ask > StopHighPrice) {
         RemoveAllOrders();
         ExpertRemove();
      }

      if (StopLowPrice > 0 && Bid < StopLowPrice) {
         RemoveAllOrders();
         ExpertRemove();
      }

      PipStep = NormalizeDouble(GetADRs(PERIOD_D1, 20, 1) / PipStepDevideADR, 2);

      PNL = PNLBuy + PNLSell;

      if (PNL > 0) {
         if (PNL > PNLMax) {
            PNLMax = PNL;
         }
      }

      if (PNL < 0) {
         if (PNL < PNLMin) {
            PNLMin = PNL;
         }
      }

      if (TotalOrderBuy == 0 && TotalOrderSell == 0) {
         StartEquityBuySell = DoubleToString(AccountEquity(), 2);
      }

      if (EquityMin == 0) {
         EquityMin = AccountEquity();
      }

      if (AccountEquity() < EquityMin) {
         EquityMin = AccountEquity();
      }

      if (EquityMax == 0) {
         EquityMax = AccountEquity();
      }

      if (AccountEquity() > EquityMax) {
         EquityMax = AccountEquity();
      }

      if (BuyOrSell == BuySell || BuyOrSell == BuyOnly) {

         //------ Only for BUY -------------------------------------------------------------------------------------------
         if(GetSignal() == 1) {
         MagicNumberBuy = GetMagicNumber("BUY");

         TakeProfit = NormalizeDouble((GetADRs(PERIOD_D1, 20, 1) / TakeProfitDevideADR) + TakeProfitPlus, 0);

         ArrayResize(BufferBuyPrice, MaxTrades);
         ArrayResize(BufferBuyLots, MaxTrades);

         if (RealStartBuy == FALSE) {

            if (BufferTotalOrderBuy < 1) {
               BufferBuyCounter = 0;
               if ((Hour() >= StartHour || Hour() < EndHour)) {
                  BufferiLotsBuy = NormalizeDouble(StartingLots * MathPow(LotsMultiplier, BufferBuyCounter), 2);
                  RefreshRates();
                  BufferBuyTP = NormalizeDouble(Ask + ((double) TakeProfit * Point), Digits);
                  BufferBuyLots[BufferBuyCounter] = BufferiLotsBuy;
                  BufferBuyPrice[BufferBuyCounter] = Ask;
                  BufferTotalOrderBuy = 1;
                  BufferLastPipStepMultiplierBuy = 0;

                  ObjectCreate("BufferBuy_" + BufferBuyCounter, OBJ_HLINE, 0, CurTime(), BufferBuyPrice[BufferBuyCounter]);
                  ObjectSet("BufferBuy_" + BufferBuyCounter, OBJPROP_COLOR, Blue);
                  ObjectSet("BufferBuy_" + BufferBuyCounter, OBJPROP_STYLE, STYLE_SOLID);
                  ObjectSet("BufferBuy_" + BufferBuyCounter, OBJPROP_BACK, true);

                  ObjectCreate("BufferBuyTP", OBJ_HLINE, 0, CurTime(), BufferBuyTP);
                  ObjectSet("BufferBuyTP", OBJPROP_COLOR, White);
                  ObjectSet("BufferBuyTP", OBJPROP_STYLE, STYLE_SOLID);
                  ObjectSet("BufferBuyTP", OBJPROP_BACK, true);
               }
            }

            if (BufferLastPipStepMultiplierBuy <= 0) {
               BufferLastPipStepMultiplierBuy = PipStep;
            }

            if (BufferTotalOrderBuy > 0 && BufferTotalOrderBuy < MaxTrades) {
               BufferLastBuyPrice = BufferBuyPrice[BufferTotalOrderBuy - 1];
               if ((BufferLastBuyPrice - Ask) >= (BufferLastPipStepMultiplierBuy * Point)) {
                  BufferBuyCounter = BufferTotalOrderBuy;
                  BufferiLotsBuy = NormalizeDouble(StartingLots * MathPow(LotsMultiplier, BufferTotalOrderBuy), 2);
                  BufferBuyLots[BufferBuyCounter] = BufferiLotsBuy;
                  BufferBuyPrice[BufferBuyCounter] = Ask;
                  BufferTotalOrderBuy = BufferTotalOrderBuy + 1;
                  BufferLastPipStepMultiplierBuy = NormalizeDouble((BufferLastPipStepMultiplierBuy * PipStepMultiplier), 2);
                  BufferNewOrderBuy = TRUE;

                  ObjectCreate("BufferBuy_" + BufferBuyCounter, OBJ_HLINE, 0, CurTime(), BufferBuyPrice[BufferBuyCounter]);
                  ObjectSet("BufferBuy_" + BufferBuyCounter, OBJPROP_COLOR, Blue);
                  ObjectSet("BufferBuy_" + BufferBuyCounter, OBJPROP_STYLE, STYLE_SOLID);
                  ObjectSet("BufferBuy_" + BufferBuyCounter, OBJPROP_BACK, true);

               }
            }

            if (BufferiLotsBuy > MaxLotsBuy) {
               MaxLotsBuy = BufferiLotsBuy;
            }

            if (BufferTotalOrderBuy > 0) {
               BufferAveragePriceBuy = 0;
               Count = 0;
               for (BufferBuyCounter = 0; BufferBuyCounter < BufferTotalOrderBuy; BufferBuyCounter++) {
                  BufferAveragePriceBuy += BufferBuyPrice[BufferBuyCounter] * BufferBuyLots[BufferBuyCounter];
                  Count += BufferBuyLots[BufferBuyCounter];
               }
               BufferAveragePriceBuy = NormalizeDouble(BufferAveragePriceBuy / Count, Digits);

               if (BufferTotalOrderBuy >= RealOrderLayerStart && BufferiLotsBuy >= RealOrderLotStart) {
                  RealStartBuy = TRUE;
                  RealPriceMaxBuy = BufferAveragePriceBuy;
               }

            }

            if (BufferNewOrderBuy == TRUE) {
               BufferBuyTP = NormalizeDouble(BufferAveragePriceBuy, Digits);
               BufferNewOrderBuy = FALSE;

               ObjectDelete("BufferBuyTP");

               ObjectCreate("BufferBuyTP", OBJ_HLINE, 0, CurTime(), BufferBuyTP);
               ObjectSet("BufferBuyTP", OBJPROP_COLOR, White);
               ObjectSet("BufferBuyTP", OBJPROP_STYLE, STYLE_SOLID);
               ObjectSet("BufferBuyTP", OBJPROP_BACK, true);
            }

            if (Ask > BufferBuyTP) {

               ObjectDelete("BufferBuyTP");
               BufferLastBuyPrice = 0;
               BufferBuyTP = 0;
               BufferBuyCounter = 0;
               BufferTotalOrderBuy = 0;

               for (BufferBuyCounter = 0; BufferBuyCounter < MaxTrades; BufferBuyCounter++) {
                  BufferBuyPrice[BufferBuyCounter] = NULL;
                  BufferBuyLots[BufferBuyCounter] = NULL;
                  ObjectDelete("BufferBuy_" + BufferBuyCounter);
               }

            }

         }

         if (RealStartBuy == TRUE) {

            ObjectDelete("BufferBuyTP");
            for (BufferBuyCounter = 0; BufferBuyCounter < MaxTrades; BufferBuyCounter++) {
               BufferBuyPrice[BufferBuyCounter] = NULL;
               BufferBuyLots[BufferBuyCounter] = NULL;
               ObjectDelete("BufferBuy_" + BufferBuyCounter);
            }

            ObjectCreate("RealPriceMaxBuy", OBJ_HLINE, 0, CurTime(), RealPriceMaxBuy);
            ObjectSet("RealPriceMaxBuy", OBJPROP_COLOR, Lime);
            ObjectSet("RealPriceMaxBuy", OBJPROP_STYLE, STYLE_SOLID);
            ObjectSet("RealPriceMaxBuy", OBJPROP_BACK, true);

            RefreshRates();

            if (Bid < RealPriceMaxBuy) {

               TotalOrderBuy = GetTotalOrderBuy();

               if (TotalOrderBuy < 1) {

                  if (SetZeroAfterSomeTPBuy > 0) {
                     SetZeroAfterSomeTPBuy = SetZeroAfterSomeTPBuy + 1;
                  }

                  if (SetZeroAfterSomeTPBuy == 0) {
                     SetZeroAfterSomeTPBuy = 1;
                  }

                  if (SetZeroAfterSomeTPBuy <= SetZeroAfterSomeTP) {
                     NumOfTradesBuy = 0;
                     iLotsBuy = NormalizeDouble(StartingLots * MathPow(LotsMultiplier, NumOfTradesBuy), 2);
                     if ((Hour() >= StartHour || Hour() <= EndHour)) {
                        FirstTPOrderBuy = NormalizeDouble(Ask + (double) TakeProfit * Point, Digits);
                        RefreshRates();
                        TicketOrderSend = OrderSend(Symbol(), OP_BUY, iLotsBuy, Ask, SlipPage, 0, FirstTPOrderBuy, Symbol() + "-" + MagicNumberBuy + NumOfTradesBuy, MagicNumberBuy, 0, Lime); //Print(Symbol() + "-" + NumOfTradesBuy + "_MN-" + MagicNumberBuy + "_FirstTP");
                        if (TicketOrderSend < 0) {
                           Print("Error: ", GetLastError());
                        }
                        NewOrdersPlacedBuy = TRUE;
                        FirstOrderBuy = TRUE;
                        TotalOrderBuy = 1;
                        LastPipStepMultiplierBuy = 0;
                     }
                  }

               }

               if (LastPipStepMultiplierBuy <= 0) {
                  LastPipStepMultiplierBuy = PipStep;
               }

               if (TotalOrderBuy > 0 && TotalOrderBuy < MaxTrades) {
                  LastBuyPrice = FindLastBuyPrice();
                  if ((LastBuyPrice - Ask) >= (LastPipStepMultiplierBuy * Point)) {
                     NumOfTradesBuy = TotalOrderBuy;
                     iLotsBuy = NormalizeDouble(StartingLots * MathPow(LotsMultiplier, NumOfTradesBuy), 2);
                     RefreshRates();
                     TicketOrderSend = OrderSend(Symbol(), OP_BUY, iLotsBuy, Ask, SlipPage, 0, 0, Symbol() + "-" + MagicNumberBuy + NumOfTradesBuy, MagicNumberBuy, 0, Lime); //Print(Symbol() + "-" + NumOfTradesBuy + "_MN-" + MagicNumberBuy);
                     if (TicketOrderSend < 0) {
                        Print("Error: ", GetLastError());
                     }
                     NewOrdersPlacedBuy = TRUE;
                     LastPipStepMultiplierBuy = NormalizeDouble((LastPipStepMultiplierBuy * PipStepMultiplier), 2);
                  }
               }

               if (iLotsBuy > MaxLotsBuy) {
                  MaxLotsBuy = iLotsBuy;
               }

               if (TotalOrderBuy > 0) {
                  AveragePriceBuy = 0;
                  Count = 0;
                  for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
                     TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
                     if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberBuy) continue;
                     if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {
                        AveragePriceBuy += OrderOpenPrice() * OrderLots();
                        Count += OrderLots();
                     }
                  }
                  AveragePriceBuy = NormalizeDouble(AveragePriceBuy / Count, Digits);
               }

               if (NewOrdersPlacedBuy == TRUE) {
                  if (TotalOrderBuy > 1) {
                     for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
                        TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
                        if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberBuy) continue;
                        if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {
                           if (FirstOrderBuy == TRUE) {
                              PriceTargetBuy = NormalizeDouble(AveragePriceBuy + (TakeProfit * Point), Digits);
                           } else {
                              PriceTargetBuy = NormalizeDouble(AveragePriceBuy, Digits);
                           }
                        }
                        TicketOrderModify = OrderModify(OrderTicket(), AveragePriceBuy, 0, PriceTargetBuy, 0, Yellow);
                     }
                     NewOrdersPlacedBuy = FALSE;
                  }
               }

            }

            if (Bid > RealPriceMaxBuy) {
               ObjectDelete("RealPriceMaxBuy");
               ObjectDelete("BufferBuyTP");
               RealStartBuy = FALSE;
               BufferTotalOrderBuy = 0;
               CloseOrderBuy(MagicNumberBuy);
            }

            if (SetZeroAfterSomeTPBuy > SetZeroAfterSomeTP) {
               ObjectDelete("RealPriceMaxBuy");
               ObjectDelete("BufferBuyTP");
               RealStartBuy = FALSE;
               BufferTotalOrderBuy = 0;
               CloseOrderBuy(MagicNumberBuy);
               SetZeroAfterSomeTPBuy = 0;
            }

         }
         }
         //----------------------------------------------------------------------------------------------------------------

      }

      if (BuyOrSell == BuySell || BuyOrSell == SellOnly) {

         //------ Only for SELL -------------------------------------------------------------------------------------------
         if(GetSignal() == -1) {
         MagicNumberSell = GetMagicNumber("SELL");

         TakeProfit = NormalizeDouble((GetADRs(PERIOD_D1, 20, 1) / TakeProfitDevideADR) + TakeProfitPlus, 0);

         ArrayResize(BufferSellPrice, MaxTrades);
         ArrayResize(BufferSellLots, MaxTrades);

         if (RealStartSell == FALSE) {

            if (BufferTotalOrderSell < 1) {
               BufferSellCounter = 0;
               BufferiLotsSell = NormalizeDouble(StartingLots * MathPow(LotsMultiplier, BufferSellCounter), 2);
               RefreshRates();
               BufferSellTP = NormalizeDouble(Bid - ((double) TakeProfit * Point), Digits);
               BufferSellLots[BufferSellCounter] = BufferiLotsSell;
               BufferSellPrice[BufferSellCounter] = Bid;
               BufferTotalOrderSell = 1; //Print("BufferTotalOrderSell --> " + BufferTotalOrderSell + " | " +BufferSellPrice[BufferSellCounter]);
               BufferLastPipStepMultiplierSell = 0;

               ObjectCreate("BufferSell_" + BufferSellCounter, OBJ_HLINE, 0, CurTime(), BufferSellPrice[BufferSellCounter]);
               ObjectSet("BufferSell_" + BufferSellCounter, OBJPROP_COLOR, Red);
               ObjectSet("BufferSell_" + BufferSellCounter, OBJPROP_STYLE, STYLE_SOLID);
               ObjectSet("BufferSell_" + BufferSellCounter, OBJPROP_BACK, true);

               ObjectCreate("BufferSellTP", OBJ_HLINE, 0, CurTime(), BufferSellTP);
               ObjectSet("BufferSellTP", OBJPROP_COLOR, White);
               ObjectSet("BufferSellTP", OBJPROP_STYLE, STYLE_SOLID);
               ObjectSet("BufferSellTP", OBJPROP_BACK, true);
            }

            if (BufferLastPipStepMultiplierSell <= 0) {
               BufferLastPipStepMultiplierSell = PipStep;
            }

            if (BufferTotalOrderSell > 0 && BufferTotalOrderSell < MaxTrades) {
               BufferLastSellPrice = BufferSellPrice[BufferTotalOrderSell - 1];
               if ((Bid - BufferLastSellPrice) >= (BufferLastPipStepMultiplierSell * Point)) {
                  BufferSellCounter = BufferTotalOrderSell;
                  BufferiLotsSell = NormalizeDouble(StartingLots * MathPow(LotsMultiplier, BufferTotalOrderSell), 2);
                  BufferSellLots[BufferSellCounter] = BufferiLotsSell;
                  BufferSellPrice[BufferSellCounter] = Bid;
                  BufferTotalOrderSell = BufferTotalOrderSell + 1; //Print("BufferTotalOrderSell --> " + BufferTotalOrderSell + " | " + BufferSellPrice[BufferSellCounter]);
                  BufferLastPipStepMultiplierSell = NormalizeDouble((BufferLastPipStepMultiplierSell * PipStepMultiplier), 2);
                  BufferNewOrderSell = TRUE;

                  ObjectCreate("BufferSell_" + BufferSellCounter, OBJ_HLINE, 0, CurTime(), BufferSellPrice[BufferSellCounter]);
                  ObjectSet("BufferSell_" + BufferSellCounter, OBJPROP_COLOR, Red);
                  ObjectSet("BufferSell_" + BufferSellCounter, OBJPROP_STYLE, STYLE_SOLID);
                  ObjectSet("BufferSell_" + BufferSellCounter, OBJPROP_BACK, true);
               }
            }

            if (BufferiLotsSell > MaxLotsSell) {
               MaxLotsSell = BufferiLotsSell;
            }

            if (BufferTotalOrderSell > 0) {
               BufferAveragePriceSell = 0;
               Count = 0;
               for (BufferSellCounter = 0; BufferSellCounter < BufferTotalOrderSell; BufferSellCounter++) {
                  BufferAveragePriceSell += BufferSellPrice[BufferSellCounter] * BufferSellLots[BufferSellCounter];
                  Count += BufferSellLots[BufferSellCounter];
               }
               BufferAveragePriceSell = NormalizeDouble(BufferAveragePriceSell / Count, Digits);

               if (BufferTotalOrderSell >= RealOrderLayerStart && BufferiLotsSell >= RealOrderLotStart) {
                  RealStartSell = TRUE;
                  RealPriceMinSell = BufferAveragePriceSell;
               }

            }

            if (BufferNewOrderSell == TRUE) {
               BufferSellTP = NormalizeDouble(BufferAveragePriceSell, Digits);
               BufferNewOrderSell = FALSE;

               ObjectDelete("BufferSellTP");

               ObjectCreate("BufferSellTP", OBJ_HLINE, 0, CurTime(), BufferSellTP);
               ObjectSet("BufferSellTP", OBJPROP_COLOR, White);
               ObjectSet("BufferSellTP", OBJPROP_STYLE, STYLE_SOLID);
               ObjectSet("BufferSellTP", OBJPROP_BACK, true);
            }

            if (Bid < BufferSellTP) {

               ObjectDelete("BufferSellTP");
               BufferLastSellPrice = 0;
               BufferSellTP = 0;
               BufferSellCounter = 0;
               BufferTotalOrderSell = 0;

               for (BufferSellCounter = 0; BufferSellCounter < MaxTrades; BufferSellCounter++) {
                  BufferSellPrice[BufferSellCounter] = NULL;
                  BufferSellLots[BufferSellCounter] = NULL;
                  ObjectDelete("BufferSell_" + BufferSellCounter);
               }

            }

         }

         if (RealStartSell == TRUE) {

            ObjectDelete("BufferSellTP");
            for (BufferSellCounter = 0; BufferSellCounter < MaxTrades; BufferSellCounter++) {
               BufferSellPrice[BufferSellCounter] = NULL;
               BufferSellLots[BufferSellCounter] = NULL;
               ObjectDelete("BufferSell_" + BufferSellCounter);
            }

            ObjectCreate("RealPriceMinSell", OBJ_HLINE, 0, CurTime(), RealPriceMinSell);
            ObjectSet("RealPriceMinSell", OBJPROP_COLOR, Brown);
            ObjectSet("RealPriceMinSell", OBJPROP_STYLE, STYLE_SOLID);
            ObjectSet("RealPriceMinSell", OBJPROP_BACK, true);

            RefreshRates();

            if (Ask > RealPriceMinSell) {

               TotalOrderSell = GetTotalOrderSell();

               if (TotalOrderSell < 1) {

                  if (SetZeroAfterSomeTPSell > 0) {
                     SetZeroAfterSomeTPSell = SetZeroAfterSomeTPSell + 1;
                  }

                  if (SetZeroAfterSomeTPSell == 0) {
                     SetZeroAfterSomeTPSell = 1;
                  }

                  if (SetZeroAfterSomeTPSell <= SetZeroAfterSomeTP) {

                     NumOfTradesSell = 0;
                     iLotsSell = NormalizeDouble(StartingLots * MathPow(LotsMultiplier, NumOfTradesSell), 2);
                     if ((Hour() >= StartHour || Hour() <= EndHour)) {
                        FirstTPOrderSell = NormalizeDouble(Bid - (double) TakeProfit * Point, Digits);
                        RefreshRates();
                        TicketOrderSend = OrderSend(Symbol(), OP_SELL, iLotsSell, Bid, SlipPage, 0, FirstTPOrderSell, Symbol() + "-" + MagicNumberSell + NumOfTradesSell, MagicNumberSell, 0, Lime); //Print(Symbol() + "-" + NumOfTradesSell + "_MN-" + MagicNumberSell + "_FirstTP");
                        if (TicketOrderSend < 0) {
                           Print("Error: ", GetLastError());
                        }
                        NewOrdersPlacedSell = TRUE;
                        FirstOrderSell = TRUE;
                        TotalOrderSell = 1;
                        LastPipStepMultiplierSell = 0;
                     }

                  }

               }

               if (LastPipStepMultiplierSell <= 0) {
                  LastPipStepMultiplierSell = PipStep;
               }

               if (TotalOrderSell > 0 && TotalOrderSell < MaxTrades) {
                  LastSellPrice = FindLastSellPrice();
                  if ((Bid - LastSellPrice) >= (LastPipStepMultiplierSell * Point)) {
                     NumOfTradesSell = TotalOrderSell;
                     iLotsSell = NormalizeDouble(StartingLots * MathPow(LotsMultiplier, NumOfTradesSell), 2);
                     RefreshRates();
                     TicketOrderSend = OrderSend(Symbol(), OP_SELL, iLotsSell, Bid, SlipPage, 0, 0, Symbol() + "-" + MagicNumberSell + NumOfTradesSell, MagicNumberSell, 0, Lime); //Print(Symbol() + "-" + NumOfTradesSell + "_MN-" + MagicNumberSell);
                     if (TicketOrderSend < 0) {
                        Print("Error: ", GetLastError());
                     }
                     NewOrdersPlacedSell = TRUE;
                     LastPipStepMultiplierSell = NormalizeDouble((LastPipStepMultiplierSell * PipStepMultiplier), 2);
                  }
               }

               if (iLotsSell > MaxLotsSell) {
                  MaxLotsSell = iLotsSell;
               }

               if (TotalOrderSell > 0) {
                  AveragePriceSell = 0;
                  Count = 0;
                  for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
                     TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
                     if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
                     if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {
                        AveragePriceSell += OrderOpenPrice() * OrderLots();
                        Count += OrderLots();
                     }
                  }
                  AveragePriceSell = NormalizeDouble(AveragePriceSell / Count, Digits);
               }

               if (NewOrdersPlacedSell == TRUE) {
                  if (TotalOrderSell > 1) {
                     for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
                        TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
                        if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
                        if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {
                           if (FirstOrderSell == TRUE) {
                              PriceTargetSell = NormalizeDouble(AveragePriceSell - (TakeProfit * Point), Digits);
                           } else {
                              PriceTargetSell = NormalizeDouble(AveragePriceSell, Digits);
                           }
                        }
                        TicketOrderModify = OrderModify(OrderTicket(), AveragePriceSell, 0, PriceTargetSell, 0, Yellow);
                     }
                     NewOrdersPlacedSell = FALSE;
                  }
               }

            }

            if (Ask < RealPriceMinSell) {
               ObjectDelete("RealPriceMinSell");
               ObjectDelete("BufferSellTP");
               RealStartSell = FALSE;
               BufferTotalOrderSell = 0;
               CloseOrderSell(MagicNumberSell);
            }

            if (SetZeroAfterSomeTPSell > SetZeroAfterSomeTP) {
               ObjectDelete("RealPriceMinSell");
               ObjectDelete("BufferSellTP");
               RealStartSell = FALSE;
               BufferTotalOrderSell = 0;
               CloseOrderSell(MagicNumberSell);
               SetZeroAfterSomeTPSell = 0;
            }

         }
         }
         //----------------------------------------------------------------------------------------------------------------

      }

      Info();

      return (0);

   }

}

int GetTotalOrderBuy() {
   int countOrderBuy = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {
         countOrderBuy++;
      }

   }
   return (countOrderBuy);
}

int GetTotalOrderSell() {
   int countOrderSell = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {
         countOrderSell++;
      }

   }
   return (countOrderSell);
}

double FindLastBuyPrice() {
   int LastOrderTicketBuy;
   int TemporaryLastOrderTicketBuy;
   double LastOrderOpenPriceBuy;
   PNLBuy = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {
         TemporaryLastOrderTicketBuy = OrderTicket();
         if (TemporaryLastOrderTicketBuy > LastOrderTicketBuy) {
            LastOrderTicketBuy = TemporaryLastOrderTicketBuy;
            LastOrderOpenPriceBuy = OrderOpenPrice();
         }
         PNLBuy = PNLBuy + OrderProfit() + OrderCommission() + OrderSwap();
      }
   }
   if (PNLBuy > 0) {
      if (PNLBuyMax < PNLBuy) {
         PNLBuyMax = PNLBuy;
      }
   }
   if (PNLBuy < 0) {
      if (PNLBuyMin > PNLBuy) {
         PNLBuyMin = PNLBuy;
      }
   }
   return (LastOrderOpenPriceBuy);
}

double FindLastSellPrice() {
   int LastOrderTicketSell;
   int TemporaryLastOrderTicketSell;
   double LastOrderOpenPriceSell;
   PNLSell = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {
         TemporaryLastOrderTicketSell = OrderTicket();
         if (TemporaryLastOrderTicketSell > LastOrderTicketSell) {
            LastOrderTicketSell = TemporaryLastOrderTicketSell;
            LastOrderOpenPriceSell = OrderOpenPrice();
         }
         PNLSell = PNLSell + OrderProfit() + OrderCommission() + OrderSwap();
      }
   }
   if (PNLSell > 0) {
      if (PNLSellMax < PNLSell) {
         PNLSellMax = PNLSell;
      }
   }
   if (PNLBuy < 0) {
      if (PNLSellMin > PNLSell) {
         PNLSellMin = PNLSell;
      }
   }
   return (LastOrderOpenPriceSell);
}

int CloseOrderBuy(int CheckMagicNumberBuy) {
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberBuy && OrderType() == OP_BUY) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), SlipPage, clrNONE);
      }
   }
   return (0);
}

int CloseOrderSell(int CheckMagicNumberSell) {
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberSell && OrderType() == OP_SELL) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), SlipPage, clrNONE);
      }
   }
   return (0);
}

void Info() {

   Comment("",
      "----------------------------------------------------------------",
      "\nMartingale EA",
      "\nStartEquityBuySell = ", StartEquityBuySell,
      "\nEquity = ", DoubleToString(AccountEquity(), 2),
      "\nEquity Min = ", DoubleToString(EquityMin, 2) + " (" + DoubleToString((EquityMin - StartEquityBuySell), 2) + ")",
      "\nEquity Max = ", DoubleToString(EquityMax, 2) + " (+" + DoubleToString((EquityMax - StartEquityBuySell), 2) + ")",
      "\nPnL = ", DoubleToString(PNL, 2),
      "\nPnL Min = ", DoubleToString(PNLMin, 2),
      "\nPnL Max = ", DoubleToString(PNLMax, 2),
      "\nPnL Buy = ", DoubleToString(PNLBuy, 2),
      "\nPnL Buy Min = ", DoubleToString(PNLBuyMin, 2),
      "\nPnL Buy Max = ", DoubleToString(PNLBuyMax, 2),
      "\nPnL Sell = ", DoubleToString(PNLSell, 2),
      "\nPnL Sell Min = ", DoubleToString(PNLSellMin, 2),
      "\nPnL Sell Max = ", DoubleToString(PNLSellMax, 2),
      "\nStarting Lot = ", StartingLots,
      "\nLot Multiplier = ", LotsMultiplier,
      "\nMax Lot Buy = ", MaxLotsBuy,
      "\nMax Lot Sell = ", MaxLotsSell,
      "\nAverage Daily Range = ", GetADRs(PERIOD_D1, 20, 1),
      "\nPipStepBuy = ", LastPipStepMultiplierBuy,
      "\nPipStepSell = ", LastPipStepMultiplierSell,
      "\nTakeProfit = ", TakeProfit,
      "\nSpread = ", DoubleToString(MarketInfo(Symbol(), MODE_SPREAD), 0),
      "\n----------------------------------------------------------------"
   );

}

int MinRemoveExpertNow(double MinimumEquity = 0) {

   if (MinimumEquity > 0 && AccountEquity() < MinimumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return (0);

}

int MaxRemoveExpertNow(double MaximumEquity = 0) {

   if (MaximumEquity > 0 && AccountEquity() > MaximumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return (0);

}

int MaxDailyDrawDownRemoveExpertNow(double EquityMaxDailyDD = 0) {

   if ((AccountBalance() - AccountEquity()) > EquityMaxDailyDD) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return (0);

}

void RemoveAllOrders() {
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS);
      if (OrderType() == OP_BUY) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, clrNONE);
      } else if (OrderType() == OP_SELL) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, clrNONE);
      } else {
         TicketOrderDelete = OrderDelete(OrderTicket());
      }

      int MessageError = GetLastError();
      if (MessageError > 0) {
         //Print("Unanticipated error " + IntegerToString(MessageError));
      }

      Sleep(100);
      RefreshRates();

   }
}

double GetADRs(int ATR_TimeFrame = PERIOD_D1, int ATR_Counter = 20, int ATR_Shift = 1) {

   double ATR_PipStep;
   ATR_PipStep = iATR(Symbol(), ATR_TimeFrame, ATR_Counter, ATR_Shift);
   ATR_PipStep = MathRound(ATR_PipStep / _Point);
   return ATR_PipStep;

}

int GetMagicNumber(string TheOrderType = "BUYSELL") {

   int TheMagicNumberPart;
   switch (MagicNumberPart) {
   case One:
      TheMagicNumberPart = 1;
   case Two:
      TheMagicNumberPart = 2;
      break;
   case Three:
      TheMagicNumberPart = 3;
      break;
   case Four:
      TheMagicNumberPart = 4;
      break;
   case Five:
      TheMagicNumberPart = 5;
      break;
   case Six:
      TheMagicNumberPart = 6;
      break;
   case Seven:
      TheMagicNumberPart = 7;
      break;
   case Eight:
      TheMagicNumberPart = 8;
      break;
   case Nine:
      TheMagicNumberPart = 9;
      break;
   }

   int MagicNumberResult = 987654321;
   string MagicNumberString;
   string StringSymbol[29];
   StringSymbol[0] = "AUDCAD";
   StringSymbol[1] = "AUDCHF";
   StringSymbol[2] = "AUDJPY";
   StringSymbol[3] = "AUDNZD";
   StringSymbol[4] = "AUDUSD";
   StringSymbol[5] = "CADCHF";
   StringSymbol[6] = "CADJPY";
   StringSymbol[7] = "CHFJPY";
   StringSymbol[8] = "EURAUD";
   StringSymbol[9] = "EURCAD";
   StringSymbol[10] = "EURCHF";
   StringSymbol[11] = "EURGBP";
   StringSymbol[12] = "EURJPY";
   StringSymbol[13] = "EURNZD";
   StringSymbol[14] = "EURUSD";
   StringSymbol[15] = "GBPAUD";
   StringSymbol[16] = "GBPCAD";
   StringSymbol[17] = "GBPCHF";
   StringSymbol[18] = "GBPJPY";
   StringSymbol[19] = "GBPNZD";
   StringSymbol[20] = "GBPUSD";
   StringSymbol[21] = "NZDCAD";
   StringSymbol[22] = "NZDCHF";
   StringSymbol[23] = "NZDJPY";
   StringSymbol[24] = "NZDUSD";
   StringSymbol[25] = "USDCAD";
   StringSymbol[26] = "USDCHF";
   StringSymbol[27] = "USDJPY";
   StringSymbol[28] = "XAUUSD";

   for (int i = 0; i < 29; i++) {
      if (StringSymbol[i] == Symbol()) {
         MagicNumberString = MagicNumberString + IntegerToString(i + 1);
      }
   }

   if (TheOrderType == "BUY") {
      MagicNumberString = MagicNumberString + "1" + IntegerToString(TheMagicNumberPart, 0);
      MagicNumberResult = StringToInteger(MagicNumberString);
   } else if (TheOrderType == "SELL") {
      MagicNumberString = MagicNumberString + "2" + IntegerToString(TheMagicNumberPart, 0);
      MagicNumberResult = StringToInteger(MagicNumberString);
   } else if (TheOrderType == "BUYSELL") {
      MagicNumberString = MagicNumberString + "3" + IntegerToString(TheMagicNumberPart, 0);
      MagicNumberResult = StringToInteger(MagicNumberString);
   } else {
      MagicNumberString = IntegerToString(MagicNumberResult, 0) + IntegerToString(TheMagicNumberPart, 0);
      MagicNumberResult = StringToInteger(MagicNumberString);
   }

   return MagicNumberResult;

}

int GetSignal() {

   int SignalResult = 0;
   if(iCustom(Symbol(), PERIOD_CURRENT, "FTC", 3, 0) != EMPTY_VALUE) {
      SignalResult = 1;
   }
   
   if(iCustom(Symbol(), PERIOD_CURRENT, "FTC", 4, 0) != EMPTY_VALUE) {
      SignalResult = -1;
   }
   
   return SignalResult;
   
}
