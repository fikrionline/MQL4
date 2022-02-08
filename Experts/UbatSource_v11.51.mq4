﻿#property copyright "Copyright © 2017, BuBat's Tradings"
#property link "https://t.me/EABudakUbatMasta"
#property description ""

enum TheMultiplier {
   a, //x2
   b, //x1.9
   c, //x1.8
   d, //x1.7
   e, //x1.6
   f, //x1.5
   g, //x1.4
   h, //x1.3 
   i, //x1.2
   j, //x1.1 
   k //x1
};

enum PipStepDevideADR {
   pa, //ADR/10
   pb, //ADR/9
   pc, //ADR/8
   pd, //ADR/7
   pe, //ADR/6
   pf, //ADR/5
   pg, //ADR/4
   ph, //ADR/3 
   pi, //ADR/2
   pj, //ADR/1 
};

enum TakeProfitDevideADR {
   ta, //ADR/20
   tb, //ADR/19
   tc, //ADR/18
   td, //ADR/17
   te, //ADR/16
   tf, //ADR/15
   tg, //ADR/14
   th, //ADR/13 
   ti, //ADR/12
   tj, //ADR/11
   tk, //ADR/10
   tl, //ADR/9
   tm, //ADR/8
   tn, //ADR/7
   to, //ADR/6
   tp, //ADR/5
   tq, //ADR/4
   tr, //ADR/3 
   ts, //ADR/2
   tt, //ADR/1
};

extern double EquityStopEA = 9600.00;
extern int StartHour = 2;
extern int EndHour = 22;
extern double StartingLots = 0.01;
extern TheMultiplier LayerMultiplier = k;
extern PipStepDevideADR PipStepDevide = ph;
extern TakeProfitDevideADR TakeProfitDevide = tk;
extern double TakeProfitPlus = 0;
extern int MagicNumber = 5758;
extern double SlipPage = 5.0;
extern int MaxTrades = 7;
extern string EAName = "v11.51";

int TicketOrder, expiration, total, ticket, timeprev = 0, NumOfTrades = 0, cnt = 0;
double PriceTarget, StartEquity, BuyTarget, SellTarget, AveragePrice, SellLimit, BuyLimit, LastBuyPrice, LastSellPrice, Spread, iLots, Multiplier, AccountEquityHighAmt, PrevEquity, ADRs, PipStep, PipStepDevideResult, TakeProfit, TakeProfitDevideResult;
bool flag, TradeNow = FALSE, LongTrade = FALSE, ShortTrade = FALSE, NewOrdersPlaced = FALSE;

int init() {
   return (0);
}

int deinit() {
   return (0);
}

int start() {

   RemoveExpertNow(EquityStopEA);
   
   double Lots = MarketInfo(Symbol(), MODE_MINLOT);
   
   switch (LayerMultiplier) {
   case a:
      Multiplier = 2;
      break;
   case b:
      Multiplier = 1.9;
      break;
   case c:
      Multiplier = 1.8;
      break;
   case d:
      Multiplier = 1.7;
      break;
   case e:
      Multiplier = 1.6;
      break;
   case f:
      Multiplier = 1.5;
      break;
   case g:
      Multiplier = 1.4;
      break;
   case h:
      Multiplier = 1.3;
      break;
   case i:
      Multiplier = 1.2;
      break;
   case j:
      Multiplier = 1.1;
      break;
   case k:
      Multiplier = 1;
      break;
   }
   
   switch (PipStepDevide) {
   case pa:
      PipStepDevideResult = 10;
      break;
   case pb:
      PipStepDevideResult = 9;
      break;
   case pc:
      PipStepDevideResult = 8;
      break;
   case pd:
      PipStepDevideResult = 7;
      break;
   case pe:
      PipStepDevideResult = 6;
      break;
   case pf:
      PipStepDevideResult = 5;
      break;
   case pg:
      PipStepDevideResult = 4;
      break;
   case ph:
      PipStepDevideResult = 3;
      break;
   case pi:
      PipStepDevideResult = 2;
      break;
   case pj:
      PipStepDevideResult = 1;
      break;
   }
   
   PipStep = NormalizeDouble(GetADRs() / PipStepDevideResult, 2);
   
   switch (TakeProfitDevide) {
   case ta:
      TakeProfitDevideResult = 20;
      break;
   case tb:
      TakeProfitDevideResult = 19;
      break;
   case tc:
      TakeProfitDevideResult = 18;
      break;
   case td:
      TakeProfitDevideResult = 17;
      break;
   case te:
      TakeProfitDevideResult = 16;
      break;
   case tf:
      TakeProfitDevideResult = 15;
      break;
   case tg:
      TakeProfitDevideResult = 14;
      break;
   case th:
      TakeProfitDevideResult = 13;
      break;
   case ti:
      TakeProfitDevideResult = 12;
      break;
   case tj:
      TakeProfitDevideResult = 11;
      break;
   case tk:
      TakeProfitDevideResult = 10;
      break;
   case tl:
      TakeProfitDevideResult = 9;
      break;
   case tm:
      TakeProfitDevideResult = 8;
      break;
   case tn:
      TakeProfitDevideResult = 7;
      break;
   case to:
      TakeProfitDevideResult = 6;
      break;
   case tp:
      TakeProfitDevideResult = 5;
      break;
   case tq:
      TakeProfitDevideResult = 4;
      break;
   case tr:
      TakeProfitDevideResult = 3;
      break;
   case ts:
      TakeProfitDevideResult = 2;
      break;
   case tt:
      TakeProfitDevideResult = 1;
      break;
   }
   
   TakeProfit = NormalizeDouble((GetADRs() / TakeProfitDevideResult) + TakeProfitPlus, 2);
   
   Info();

   total = CountTrades();
   if (total == 0) flag = FALSE;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY) {
            LongTrade = TRUE;
            ShortTrade = FALSE;
            break;
         }
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_SELL) {
            LongTrade = FALSE;
            ShortTrade = TRUE;
            break;
         }
      }
   }
   
   if (total > 0 && total <= MaxTrades) {
      RefreshRates();
      LastBuyPrice = FindLastBuyPrice();
      LastSellPrice = FindLastSellPrice();
      if (LongTrade && LastBuyPrice - Ask >= PipStep * Point) TradeNow = TRUE;
      if (ShortTrade && Bid - LastSellPrice >= PipStep * Point) TradeNow = TRUE;
   }
   
   if (total < 1) {
      ShortTrade = FALSE;
      LongTrade = FALSE;
      TradeNow = TRUE;
      StartEquity = AccountEquity();
   }
   
   if (TradeNow) {
      LastBuyPrice = FindLastBuyPrice();
      LastSellPrice = FindLastSellPrice();
      if (ShortTrade) {
         NumOfTrades = total;
         iLots = NormalizeDouble(StartingLots * MathPow(Multiplier, NumOfTrades), 2);
         RefreshRates();
         ticket = OpenPendingOrder(1, iLots, Bid, SlipPage, Ask, 0, 0, EAName + "-" + NumOfTrades, MagicNumber, 0, HotPink);
         if (ticket < 0) {
            Print("Error: ", GetLastError());
            return (0);
         }
         LastSellPrice = FindLastSellPrice();
         TradeNow = FALSE;
         NewOrdersPlaced = TRUE;
      } else {
         if (LongTrade) {
            NumOfTrades = total;
            iLots = NormalizeDouble(StartingLots * MathPow(Multiplier, NumOfTrades), 2);
            ticket = OpenPendingOrder(0, iLots, Ask, SlipPage, Bid, 0, 0, EAName + "-" + NumOfTrades, MagicNumber, 0, Lime);
            if (ticket < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            LastBuyPrice = FindLastBuyPrice();
            TradeNow = FALSE;
            NewOrdersPlaced = TRUE;
         }
      }
   }
   
   if (TradeNow && total < 1) {
      SellLimit = Bid;
      BuyLimit = Ask;
      if (!ShortTrade && !LongTrade) {
         NumOfTrades = total;
         iLots = NormalizeDouble(StartingLots * MathPow(Multiplier, NumOfTrades), 2);
         
         if((Hour() >= StartHour || Hour() <= EndHour)) {
         
            if(iCustom(Symbol(), PERIOD_CURRENT, "JurikFilter", 3, 1) != EMPTY_VALUE) {
               ticket = OpenPendingOrder(0, iLots, BuyLimit, SlipPage, BuyLimit, 0, 0, EAName + "-" + NumOfTrades, MagicNumber, 0, Lime);
               if (ticket < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               LastSellPrice = FindLastSellPrice();
               NewOrdersPlaced = TRUE;
            }
            
            if(iCustom(Symbol(), PERIOD_CURRENT, "JurikFilter", 4, 1) != EMPTY_VALUE) {
               ticket = OpenPendingOrder(1, iLots, SellLimit, SlipPage, SellLimit, 0, 0, EAName + "-" + NumOfTrades, MagicNumber, 0, HotPink);
               if (ticket < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               LastBuyPrice = FindLastBuyPrice();
               NewOrdersPlaced = TRUE;
            }
            
         }         
      }
   }
   
   total = CountTrades();
   AveragePrice = 0;
   double Count = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            AveragePrice += OrderOpenPrice() * OrderLots();
            Count += OrderLots();
         }
      }
   }
   
   if (total > 0) AveragePrice = NormalizeDouble(AveragePrice / Count, Digits);
   if (NewOrdersPlaced) {
      for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
         TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) {
               PriceTarget = AveragePrice + TakeProfit * Point;
               BuyTarget = PriceTarget;
               flag = TRUE;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_SELL) {
               PriceTarget = AveragePrice - TakeProfit * Point;
               SellTarget = PriceTarget;
               flag = TRUE;
            }
         }
      }
   }
   
   if (NewOrdersPlaced) {
      if (flag == TRUE) {
         for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
            TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) TicketOrder = OrderModify(OrderTicket(), AveragePrice, OrderStopLoss(), PriceTarget, 0, Yellow);
            NewOrdersPlaced = FALSE;
         }
      }
   }
   
   return (0);
}


int CountTrades() {
   int count = 0;
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
      TicketOrder = OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count++;
   }
   return (count);
}


void CloseThisSymbolAll() {
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
      TicketOrder = OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) TicketOrder = OrderClose(OrderTicket(), OrderLots(), Bid, SlipPage, Blue);
            if (OrderType() == OP_SELL) TicketOrder = OrderClose(OrderTicket(), OrderLots(), Ask, SlipPage, Red);
         }
         Sleep(7000);
      }
   }
}



int OpenPendingOrder(int pType, double pLots, double pPrice, int pSlippage, double ad_24, int ai_32, int ai_36, string a_comment_40, int a_magic_48, int a_datetime_52, color a_color_56) {
   int l_ticket_60 = 0;
   int l_error_64 = 0;
   int l_count_68 = 0;
   int li_72 = 100;
   switch (pType) {
   case 2:
      for (l_count_68 = 0; l_count_68 < li_72; l_count_68++) {
         l_ticket_60 = OrderSend(Symbol(), OP_BUYLIMIT, pLots, pPrice, pSlippage, StopLong(ad_24, ai_32), TakeLong(pPrice, ai_36), a_comment_40, a_magic_48, a_datetime_52, a_color_56);
         l_error_64 = GetLastError();
         if (l_error_64 == 0 /* NO_ERROR */ ) break;
         if (!(l_error_64 == 4 /* SERVER_BUSY */ || l_error_64 == 137 /* BROKER_BUSY */ || l_error_64 == 146 /* TRADE_CONTEXT_BUSY */ || l_error_64 == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 4:
      for (l_count_68 = 0; l_count_68 < li_72; l_count_68++) {
         l_ticket_60 = OrderSend(Symbol(), OP_BUYSTOP, pLots, pPrice, pSlippage, StopLong(ad_24, ai_32), TakeLong(pPrice, ai_36), a_comment_40, a_magic_48, a_datetime_52, a_color_56);
         l_error_64 = GetLastError();
         if (l_error_64 == 0 /* NO_ERROR */ ) break;
         if (!(l_error_64 == 4 /* SERVER_BUSY */ || l_error_64 == 137 /* BROKER_BUSY */ || l_error_64 == 146 /* TRADE_CONTEXT_BUSY */ || l_error_64 == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 0:
      for (l_count_68 = 0; l_count_68 < li_72; l_count_68++) {
         RefreshRates();
         l_ticket_60 = OrderSend(Symbol(), OP_BUY, pLots, Ask, pSlippage, StopLong(Bid, ai_32), TakeLong(Ask, ai_36), a_comment_40, a_magic_48, a_datetime_52, a_color_56);
         l_error_64 = GetLastError();
         if (l_error_64 == 0 /* NO_ERROR */ ) break;
         if (!(l_error_64 == 4 /* SERVER_BUSY */ || l_error_64 == 137 /* BROKER_BUSY */ || l_error_64 == 146 /* TRADE_CONTEXT_BUSY */ || l_error_64 == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 3:
      for (l_count_68 = 0; l_count_68 < li_72; l_count_68++) {
         l_ticket_60 = OrderSend(Symbol(), OP_SELLLIMIT, pLots, pPrice, pSlippage, StopShort(ad_24, ai_32), TakeShort(pPrice, ai_36), a_comment_40, a_magic_48, a_datetime_52, a_color_56);
         l_error_64 = GetLastError();
         if (l_error_64 == 0 /* NO_ERROR */ ) break;
         if (!(l_error_64 == 4 /* SERVER_BUSY */ || l_error_64 == 137 /* BROKER_BUSY */ || l_error_64 == 146 /* TRADE_CONTEXT_BUSY */ || l_error_64 == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 5:
      for (l_count_68 = 0; l_count_68 < li_72; l_count_68++) {
         l_ticket_60 = OrderSend(Symbol(), OP_SELLSTOP, pLots, pPrice, pSlippage, StopShort(ad_24, ai_32), TakeShort(pPrice, ai_36), a_comment_40, a_magic_48, a_datetime_52, a_color_56);
         l_error_64 = GetLastError();
         if (l_error_64 == 0 /* NO_ERROR */ ) break;
         if (!(l_error_64 == 4 /* SERVER_BUSY */ || l_error_64 == 137 /* BROKER_BUSY */ || l_error_64 == 146 /* TRADE_CONTEXT_BUSY */ || l_error_64 == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 1:
      for (l_count_68 = 0; l_count_68 < li_72; l_count_68++) {
         l_ticket_60 = OrderSend(Symbol(), OP_SELL, pLots, Bid, pSlippage, StopShort(Ask, ai_32), TakeShort(Bid, ai_36), a_comment_40, a_magic_48, a_datetime_52, a_color_56);
         l_error_64 = GetLastError();
         if (l_error_64 == 0 /* NO_ERROR */ ) break;
         if (!(l_error_64 == 4 /* SERVER_BUSY */ || l_error_64 == 137 /* BROKER_BUSY */ || l_error_64 == 146 /* TRADE_CONTEXT_BUSY */ || l_error_64 == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
   }
   return (l_ticket_60);
}

double StopLong(double ad_0, int ai_8) {
   if (ai_8 == 0) return (0);
   else return (ad_0 - ai_8 * Point);
}

double StopShort(double ad_0, int ai_8) {
   if (ai_8 == 0) return (0);
   else return (ad_0 + ai_8 * Point);
}

double TakeLong(double ad_0, int ai_8) {
   if (ai_8 == 0) return (0);
   else return (ad_0 + ai_8 * Point);
}

double TakeShort(double ad_0, int ai_8) {
   if (ai_8 == 0) return (0);
   else return (ad_0 - ai_8 * Point);
}

double CalculateProfit() {
   double ld_ret_0 = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) ld_ret_0 += OrderProfit();
   }
   return (ld_ret_0);
}

void TrailingAlls(int pType, int ai_4, double a_price_8) {
   int l_ticket_16;
   double l_ord_stoploss_20;
   double l_price_28;
   if (ai_4 != 0) {
      for (int l_pos_36 = OrdersTotal() - 1; l_pos_36 >= 0; l_pos_36--) {
         if (OrderSelect(l_pos_36, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() || OrderMagicNumber() == MagicNumber) {
               if (OrderType() == OP_BUY) {
                  l_ticket_16 = NormalizeDouble((Bid - a_price_8) / Point, 0);
                  if (l_ticket_16 < pType) continue;
                  l_ord_stoploss_20 = OrderStopLoss();
                  l_price_28 = Bid - ai_4 * Point;
                  if (l_ord_stoploss_20 == 0.0 || (l_ord_stoploss_20 != 0.0 && l_price_28 > l_ord_stoploss_20)) TicketOrder = OrderModify(OrderTicket(), a_price_8, l_price_28, OrderTakeProfit(), 0, Aqua);
               }
               if (OrderType() == OP_SELL) {
                  l_ticket_16 = NormalizeDouble((a_price_8 - Ask) / Point, 0);
                  if (l_ticket_16 < pType) continue;
                  l_ord_stoploss_20 = OrderStopLoss();
                  l_price_28 = Ask + ai_4 * Point;
                  if (l_ord_stoploss_20 == 0.0 || (l_ord_stoploss_20 != 0.0 && l_price_28 < l_ord_stoploss_20)) TicketOrder = OrderModify(OrderTicket(), a_price_8, l_price_28, OrderTakeProfit(), 0, Red);
               }
            }
            Sleep(7000);
         }
      }
   }
}

double AccountEquityHigh() {
   if (CountTrades() == 0) AccountEquityHighAmt = AccountEquity();
   if (AccountEquityHighAmt < PrevEquity) AccountEquityHighAmt = PrevEquity;
   else AccountEquityHighAmt = AccountEquity();
   PrevEquity = AccountEquity();
   return (AccountEquityHighAmt);
}

double FindLastBuyPrice() {
   double l_ord_open_price_8;
   int l_ticket_24;
   double ld_unused_0 = 0;
   int l_ticket_20 = 0;
   for (int l_pos_16 = OrdersTotal() - 1; l_pos_16 >= 0; l_pos_16--) {
      TicketOrder = OrderSelect(l_pos_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY) {
         l_ticket_24 = OrderTicket();
         if (l_ticket_24 > l_ticket_20) {
            l_ord_open_price_8 = OrderOpenPrice();
            ld_unused_0 = l_ord_open_price_8;
            l_ticket_20 = l_ticket_24;
         }
      }
   }
   return (l_ord_open_price_8);
}

double FindLastSellPrice() {
   double l_ord_open_price_8;
   int l_ticket_24;
   double ld_unused_0 = 0;
   int l_ticket_20 = 0;
   for (int l_pos_16 = OrdersTotal() - 1; l_pos_16 >= 0; l_pos_16--) {
      TicketOrder = OrderSelect(l_pos_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL) {
         l_ticket_24 = OrderTicket();
         if (l_ticket_24 > l_ticket_20) {
            l_ord_open_price_8 = OrderOpenPrice();
            ld_unused_0 = l_ord_open_price_8;
            l_ticket_20 = l_ticket_24;
         }
      }
   }
   return (l_ord_open_price_8);
}

void Info() {

   Comment("",
      "\n Copyright © 2017, BuBat's Tradings",
      "\n EA Budak Ubat-v.1.51",
      "\n Equity     = ", DoubleToString(AccountEquity(), 2),
      "\n Starting Lot = ", StartingLots,
      "\n Average Daily Range = ", GetADRs(),
      "\n PipStep = ", PipStep,
      "\n TakeProfit = ", TakeProfit
   );
   
}

int RemoveExpertNow(double MinimumEquity = 0) {
   
   if(MinimumEquity > 0 && AccountEquity() < MinimumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return(0);
   
}

void RemoveAllOrders() {
   for(int i = OrdersTotal() - 1; i >= 0 ; i--)    {
      TicketOrder = OrderSelect(i, SELECT_BY_POS);
      if(OrderType() == OP_BUY) {
         TicketOrder = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, clrNONE);
      } else if(OrderType() == OP_SELL) {
         TicketOrder = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, clrNONE);
      } else {
         TicketOrder = OrderDelete(OrderTicket());
      }
      
      int MessageError = GetLastError();
      if(MessageError > 0) {
         Print("Unanticipated error " + IntegerToString(MessageError));
      }
      
      Sleep(100);      
      RefreshRates();
      
   }
}

double GetADRs(int ATR_TimeFrame = PERIOD_D1, int ATR_Counter = 10, int ATR_Shift = 1) {

   double ATR_PipStep;
   ATR_PipStep = iATR(Symbol(), ATR_TimeFrame, ATR_Counter, ATR_Shift);
   ATR_PipStep = MathRound(ATR_PipStep / _Point);
   return ATR_PipStep;
   
}