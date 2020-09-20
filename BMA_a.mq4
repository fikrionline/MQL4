//+------------------------------------------------------------------+
//|                                            Basic_MA_Template.mq4 |
//|                             Copyright 2020, DKP Sweden,CS Robots |
//|                             https://www.mql5.com/en/users/kenpar |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int    MagicNumber = 5758;
extern int    Slippage    = 3;
extern double Lots        = 1;
extern double TakeProfit  = 107;
extern double StopLoss    = 93;

int    Ticket_open = 0;
int    Ticket_close = 0;

//Check previous order
int PosSelect()
{
   int posi = 0;
   for(int k = OrdersTotal() - 1; k >= 0; k--)
   {
      if(!OrderSelect(k, SELECT_BY_POS))
      {
         break;
      }
      
      if((OrderSymbol() != Symbol()) && (OrderMagicNumber() != MagicNumber))
      {
         continue;
      }
      
      if((OrderCloseTime() == 0) && (OrderSymbol() == Symbol()) && (OrderMagicNumber() == MagicNumber))
      {
         if(OrderType() == OP_BUY)
         {
            posi = 1; //Long position
         }
         if(OrderType() == OP_SELL)
         {
            posi = -1; //Short positon
         }
      }
   }
   return(posi);
}

//Signal
int Signal()
{
   double iStdDev_16_0 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iStdDev_16_3 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 3);
   int iStdDev_checker = 0;
   
   if((iStdDev_16_0 - iStdDev_16_3) >= 0.0004)
   {
      iStdDev_checker = 1;
   }
   
   double iMA_4_0 = iMA(NULL, PERIOD_CURRENT, 4, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iMA_4_1 = iMA(NULL, PERIOD_CURRENT, 4, 0, MODE_SMA, PRICE_CLOSE, 1);
   double iMA_16 = iMA(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iMA_96 = iMA(NULL, PERIOD_CURRENT, 96, 0, MODE_SMA, PRICE_CLOSE, 0);
   int iMA_checker = 0;
   
   if((iMA_4_0 > iMA_16) && (iMA_16 > iMA_96))
   {
      iMA_checker = 1;
   }
   
   if((iMA_4_0 < iMA_16) && (iMA_16 < iMA_96))
   {
      iMA_checker = -1;
   }
   
   //Get signal from MA and StdDev
   int signal = 0;
   
   if((iStdDev_checker == 1) && (iMA_checker == 1))
   {
      signal = 1;
   }
   
   if((iStdDev_checker == 1) && (iMA_checker == -1))
   {
      signal = -1;
   }
   
   return(signal);
}

void OnTick()
{
   int type;
   double price;
   double sl;
   double tp;
   
   if(PosSelect() == 0)
   {
      if(Signal() == 1)//Buy signal and no current chart positions exists
      {
         type = OP_BUY;
         price = Ask;
         sl = StopLoss > 0 ? NormalizeDouble(price - (double)StopLoss*_Point,_Digits):0.0;
         tp = TakeProfit > 0 ? NormalizeDouble(price + (double)TakeProfit*_Point,_Digits):0.0;
         Ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, 0, 0, "Timed Trade", MagicNumber, 0, CLR_NONE);
      }
      
      if(Signal() == -1)//Sell signal and no current chart positions exists
      {
         type = OP_SELL;
         price = Bid;
         sl = StopLoss > 0 ? NormalizeDouble(price + (double)StopLoss*_Point,_Digits):0.0;
         tp = TakeProfit > 0 ? NormalizeDouble(price - (double)TakeProfit*_Point,_Digits):0.0;
         Ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, 0, 0, "Timed Trade", MagicNumber, 0, CLR_NONE);
      }
   }
   else
   {
      for (int i=OrdersTotal()-1; i>=0; i--)
      {
         if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
         if(OrderSymbol() != Symbol()) continue;
         if (OrderMagicNumber() != MagicNumber) continue;
         if ((TimeCurrent() - OrderOpenTime()) >= (3 * 900))
         {
            if (OrderType() == OP_BUY)
            {
               Ticket_close = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 0, CLR_NONE);
            }
            if (OrderType() == OP_SELL)
            {
               Ticket_close = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 0, CLR_NONE);
            }
         }
      }
   }
   return;
}
