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
extern double TakeProfit  = 58;
extern double StopLoss    = 42;

int    Ticket_open = 0;
int    Ticket_close = 0;

//Signal
int Signal() {

   //Signal variable
   int signal = 0;
   
   //iMA variable
   double iMA_1_0 = iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iMA_1_1 = iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_SMA, PRICE_CLOSE, 1);
   double iMA_1_2 = iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_SMA, PRICE_CLOSE, 2);
   double iMA_1_3 = iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_SMA, PRICE_CLOSE, 3);
   double iMA_1_4 = iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_SMA, PRICE_CLOSE, 4);
   double iMA_1_5 = iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_SMA, PRICE_CLOSE, 5);
   
   double iMA_2_0 = iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iMA_2_1 = iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_SMA, PRICE_CLOSE, 1);
   double iMA_2_2 = iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_SMA, PRICE_CLOSE, 2);
   double iMA_2_3 = iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_SMA, PRICE_CLOSE, 3);
   double iMA_2_4 = iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_SMA, PRICE_CLOSE, 4);
   double iMA_2_5 = iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_SMA, PRICE_CLOSE, 5);
   
   int iMA_checker = 0;
   
   if(iMA_1_0 > iMA_1_1) {
      iMA_checker = 1;
   }
   
   if(iMA_1_0 < iMA_1_1) {
      iMA_checker = -1;
   }
   
   //iStdDev variable
   double iStdDev_16_0 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iStdDev_16_1 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 1);
   double iStdDev_16_2 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 2);
   double iStdDev_16_3 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 3);
   double iStdDev_16_4 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 4);
   double iStdDev_16_5 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 5);
   
   int iStdDev_checker = 0;
   
   if(iStdDev_16_0 - iStdDev_16_1 > 0.00002){
      iStdDev_checker = 1;
   }
   
   //Compare all signals
   if(iMA_checker == 1 && iStdDev_checker == 1){
      signal = 1;
   }
   
   if(iMA_checker == -1 && iStdDev_checker == 1){
      signal = -1;
   }
  
   return(signal);
   
}

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

//On Tick
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
         Ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, CLR_NONE);
      }
      
      if(Signal() == -1)//Sell signal and no current chart positions exists
      {
         type = OP_SELL;
         price = Bid;
         sl = StopLoss > 0 ? NormalizeDouble(price + (double)StopLoss*_Point,_Digits):0.0;
         tp = TakeProfit > 0 ? NormalizeDouble(price - (double)TakeProfit*_Point,_Digits):0.0;
         Ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, CLR_NONE);
      }
   }
   else
   {
      for (int i=OrdersTotal()-1; i>=0; i--)
      {
         if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
         if(OrderSymbol() != Symbol()) continue;
         if (OrderMagicNumber() != MagicNumber) continue;
         if ((TimeCurrent() - OrderOpenTime()) >= (1 * 900))
         {
            int close_position = 0;
            if (OrderType() == OP_BUY){

            }
            if (OrderType() == OP_SELL){

            }
         }
      }
   }
   return;
}
