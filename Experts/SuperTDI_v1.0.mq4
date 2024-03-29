//+------------------------------------------------------------------+
//|                                                SuperTDI_v1.0.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.1"

extern int MagicNumber = 5758;
extern int StartHour = 3;
extern int EndHour = 20;
extern double Lots = 0.1;
extern double TakeProfit = 0;
extern double StopLoss = 0;
extern int SlipPage = 5;
extern bool OrderReverse = FALSE;
extern bool UseTrailStopPoint = FALSE;
extern double TrailingStopPoint = 500;
extern double TrailingStopPointLock = 250;

datetime NextCandle;
int SelectOrder, type, TicketOpen = 0, TicketClose = 0, TotalOrderBuy, TotalOrderSell, MagicNumberBuy, MagicNumberSell;
double price, sl, tp, slCandle, tpCandle, StartEquityBuySell, EquityMin, EquityMax;

//Init
int init() {

   NextCandle = Time[0] + Period();
   return (0);

}

//Deinit
int deinit() {

   return (0);

}

//Start
void OnTick() {

   if(UseTrailStopPoint == TRUE) {
      RunTrailStop(MagicNumber, TrailingStopPoint, TrailingStopPointLock);
   }

   if(CloseOrder() == 1) {
      //CloseOrderBuy(MagicNumber);
   } else if(CloseOrder() == -1) {
      //CloseOrderSell(MagicNumber);
   }
   
   TotalOrderBuy = GetTotalOrderBuy();
   TotalOrderSell = GetTotalOrderSell();
   
   if(TotalOrderBuy == 0 && TotalOrderSell == 0) {
      StartEquityBuySell = DoubleToString(AccountEquity(), 2);
   }
   
   if(EquityMin == 0) {
      EquityMin = AccountEquity();
   }
   
   if(AccountEquity() < EquityMin) {
      EquityMin = AccountEquity();
   }
   
   if(EquityMax == 0) {
      EquityMax = AccountEquity();
   }
   
   if(AccountEquity() > EquityMax) {
      EquityMax = AccountEquity();
   }

   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      // New candle, your trading functions here
      
      if((Hour() >= StartHour && Hour() < EndHour)) {

         //Order when there are no order
         if (PosSelect(MagicNumber) == 0) {
   
            if (GetSignal() == 1) {
            
               slCandle = (iHigh(Symbol(), PERIOD_CURRENT, 1) - iLow(Symbol(), PERIOD_CURRENT, 1)) / Point(); //Print(slCandle);
               tpCandle = slCandle * 2;
               
               StopLoss = slCandle;
               TakeProfit = tpCandle;
   
               type = OP_BUY;
               price = Ask;
               sl = StopLoss > 0 ? NormalizeDouble(price - (double) StopLoss * Point(), Digits()) : 0.0;
               tp = TakeProfit > 0 ? NormalizeDouble(price + (double) TakeProfit * Point(), Digits()) : 0.0;
               TicketOpen = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);
   
            } else if (GetSignal() == -1) {
            
               slCandle = (iHigh(Symbol(), PERIOD_CURRENT, 1) - iLow(Symbol(), PERIOD_CURRENT, 1)) / Point(); //Print(slCandle);
               tpCandle = slCandle * 2;
               
               StopLoss = slCandle;
               TakeProfit = tpCandle;
   
               type = OP_SELL;
               price = Bid;
               sl = StopLoss > 0 ? NormalizeDouble(price + (double) StopLoss * Point(), Digits()) : 0.0;
               tp = TakeProfit > 0 ? NormalizeDouble(price - (double) TakeProfit * Point(), Digits()) : 0.0;
               TicketClose = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);
   
            }
   
         }
         
      }

   }
   
   Info();

}

int GetTotalOrderBuy() {
   int countOrderBuy = 0, TicketOrderSelect, cnt;
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
   int countOrderSell = 0, TicketOrderSelect, cnt;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {         
         countOrderSell++;         
      }
      
   }
   return (countOrderSell);
}

void Info() {

   Comment("",
      "Super TDI",
      //"\nStartEquityBuySell = ", StartEquityBuySell,
      "\nEquity = ", DoubleToString(AccountEquity(), 2),
      "\nEquity Min = ", DoubleToString(EquityMin, 2) + " (" + DoubleToString((EquityMin - StartEquityBuySell), 2) + ")",
      "\nEquity Max = ", DoubleToString(EquityMax, 2) + " (+" + DoubleToString((EquityMax - StartEquityBuySell), 2) + ")",
      //"\nPnL = ", DoubleToString(PNL, 2),
      //"\nPnL Min = ", DoubleToString(PNLMin, 2),
      //"\nPnL Max = ", DoubleToString(PNLMax, 2),
      //"\nPnL Buy = ", DoubleToString(PNLBuy, 2),
      //"\nPnL Buy Min = ", DoubleToString(PNLBuyMin, 2),
      //"\nPnL Buy Max = ", DoubleToString(PNLBuyMax, 2),
      //"\nPnL Sell = ", DoubleToString(PNLSell, 2),
      //"\nPnL Sell Min = ", DoubleToString(PNLSellMin, 2),
      //"\nPnL Sell Max = ", DoubleToString(PNLSellMax, 2),
      //"\nStarting Lot = ", StartingLots,
      //"\nLot Multiplier = ", LotsMultiplier,
      //"\nMax Lot Buy = ", MaxLotsBuy,
      //"\nMax Lot Sell = ", MaxLotsSell,
      //"\nMax Layer Buy = ", MaxLayerBuy,
      //"\nMax Layer Sell = ", MaxLayerSell,
      //"\nAverage Daily Range = ", GetADRs(PERIOD_D1, 20, 1),
      //"\nPipStepBuy = ", LastPipStepMultiplierBuy,
      //"\nPipStepSell = ", LastPipStepMultiplierSell,
      "\nTakeProfit = ", TakeProfit
   );
   
}

int PosSelect(int CheckMagicNumber) {

   int posi = 0;
   for (int k = OrdersTotal() - 1; k >= 0; k--) {
      if (!OrderSelect(k, SELECT_BY_POS)) {
         break;
      }

      if ((OrderSymbol() != Symbol()) && (OrderMagicNumber() != CheckMagicNumber)) {
         continue;
      }

      if ((OrderCloseTime() == 0) && (OrderSymbol() == Symbol()) && (OrderMagicNumber() == CheckMagicNumber)) {
         if (OrderType() == OP_BUY) {
            posi = 1; //Long position
         }
         if (OrderType() == OP_SELL) {
            posi = -1; //Short positon
         }
      }
   }

   return (posi);

}

int CloseOrderBuy(int CheckMagicNumberBuy) {
   int TicketOrderSelect, TicketOrderClose;
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
   int TicketOrderSelect, TicketOrderClose;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberSell && OrderType() == OP_SELL) {         
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), SlipPage, clrNONE);
      }      
   }   
   return (0);
}

//GetSignal
int GetSignal() {

   int SignalResult = 0, iStochasticResult = 0, TDIResult = 0;
   
   double iStochastic_1433_main_2 = iStochastic(Symbol(), PERIOD_CURRENT, 14, 3, 3, MODE_SMA, 0, MODE_MAIN, 2);
   double iStochastic_1433_signal_2 = iStochastic(Symbol(), PERIOD_CURRENT, 14, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 2);
   
   double iStochastic_1433_main_1 = iStochastic(Symbol(), PERIOD_CURRENT, 14, 3, 3, MODE_SMA, 0, MODE_MAIN, 1);
   double iStochastic_1433_signal_1 = iStochastic(Symbol(), PERIOD_CURRENT, 14, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 1);
   
   if(iStochastic_1433_main_1 > 80 && iStochastic_1433_signal_1 > 80) {
      iStochasticResult = 1;
   }
   
   if(iStochastic_1433_main_1 < 20 && iStochastic_1433_signal_1 < 20) {
      iStochasticResult = -1;
   }
   
   double TDI_main_2 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT_Alerts_Divergence", 3, 2);
   double TDI_signal_2 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT_Alerts_Divergence", 4, 2);
   
   double TDI_main_1 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT_Alerts_Divergence", 3, 1);
   double TDI_signal_1 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT_Alerts_Divergence", 4, 1);
   
   if(TDI_main_1 > TDI_signal_1 && TDI_main_2 < TDI_signal_2) {
      TDIResult = 1;
   } else if(TDI_main_1 < TDI_signal_1 && TDI_main_2 > TDI_signal_2) {
      TDIResult = -1;
   }
   
   if(iStochasticResult == 1 && TDIResult == 1) {
      SignalResult = 1;
   }
   
   if(iStochasticResult == -1 && TDIResult == -1) {
      SignalResult = -1;
   }
   
   if(OrderReverse == TRUE) {
   
      if(SignalResult == 1) {
         SignalResult = -1;
      } else if(SignalResult == -1) {
         SignalResult = 1;
      }
   
   }
   
   return SignalResult;

}

//CloseOrder
int CloseOrder() {
   
   int CloseResult = 0;
   
   double iStochastic_1433_main = iStochastic(Symbol(), PERIOD_CURRENT, 14, 3, 3, MODE_SMA, 0, MODE_MAIN, 1);
   double iStochastic_1433_signal = iStochastic(Symbol(), PERIOD_CURRENT, 14, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 1);
   
   double TDI_main = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT_Alerts_Divergence", 3, 1);
   double TDI_signal = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT_Alerts_Divergence", 4, 1);
   
   if(TDI_main > TDI_signal) {
      CloseResult = -1;
   } else if(TDI_signal < TDI_main) {
      CloseResult = 1;
   }
   
   /*if(iStochastic_1433_main < iStochastic_1433_signal && iStochastic_1433_main < 20 && iStochastic_1433_signal < 20) {
      CloseResult = 1;
   }
   
   if(iStochastic_1433_main > iStochastic_1433_signal && iStochastic_1433_main > 80 && iStochastic_1433_signal > 80) {
      CloseResult = -1;
   }*/
   
   return CloseResult;
   
}

void RunTrailStop(int CheckMagicNumber, double TheTrailingStopPoint, double TheTrailingStopPointLock) {
   int TicketTrail;
   for (int i = 0; i < OrdersTotal(); i++) {
      TicketTrail = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumber) {
         continue;
      }
      if (OrderSymbol() == Symbol()) {
         if (OrderType() == OP_BUY && OrderMagicNumber() == CheckMagicNumber) {
            if (Bid - OrderOpenPrice() > TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT)) {
               if (OrderStopLoss() < Bid - TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT)) {
                  TicketTrail = OrderModify(OrderTicket(), OrderOpenPrice(), Bid - TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT), OrderTakeProfit(), Red);
               }
            }
         } else if (OrderType() == OP_SELL && OrderMagicNumber() == CheckMagicNumber) {
            if (OrderOpenPrice() - Ask > TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT)) {
               if ((OrderStopLoss() > Ask + TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT)) || (OrderStopLoss() == 0)) {
                  TicketTrail = OrderModify(OrderTicket(), OrderOpenPrice(), Ask + TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT), OrderTakeProfit(), Red);
               }
            }
         }
      }
   }
}
