//+------------------------------------------------------------------+
//|                                                      spike_d.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int    MagicNumber = 5758;
extern int    Slippage    = 3;
extern double Lots        = 1;
extern double TakeProfit  = 10;
extern double StopLoss    = 10;


//Run EA every new candle open
datetime date_time_now;

void start(){

   //if(date_time_now != Time[0]){
      
      int type, ticket_open, ticket_close;
      double price, sl, tp;
      
      if(PosSelect() == 0)
      {
         if(Signal() == 1)//Buy signal and no current chart positions exists
         {
            type = OP_BUY;
            price = Ask;
            sl = StopLoss > 0 ? NormalizeDouble(price - (double)StopLoss*_Point,_Digits):0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price + (double)TakeProfit*_Point,_Digits):0.0;
            ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, CLR_NONE);
         }
         
         if(Signal() == -1)//Sell signal and no current chart positions exists
         {
            type = OP_SELL;
            price = Bid;
            sl = StopLoss > 0 ? NormalizeDouble(price + (double)StopLoss*_Point,_Digits):0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price - (double)TakeProfit*_Point,_Digits):0.0;
            ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, CLR_NONE);
         }
      }
      else
      {
         for (int i=OrdersTotal()-1; i>=0; i--)
         {
            if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
            if(OrderSymbol() != Symbol()) continue;
            if (OrderMagicNumber() != MagicNumber) continue;
            if ((TimeCurrent() - OrderOpenTime()) >= 60)
            {
               
               if (OrderType() == OP_BUY){
                  ticket_close = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 0, CLR_NONE);
               }
               
               if (OrderType() == OP_SELL){
                  ticket_close = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 0, CLR_NONE);
               }
            }
         }
      }     
            
      //Set date time for now
      date_time_now = Time[0];
      
   //}
      
}

//Check previous order
int PosSelect()
{
   int previous_position = 0;
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
            previous_position = 1; //Long position
         }
         if(OrderType() == OP_SELL)
         {
            previous_position = -1; //Short positon
         }
      }
   }
   
   return(previous_position);

}

//Signal
int Signal() {

   //Signal variable
   int signal = 0;
   
   //iMA variable
   double iMA_M1_0 = iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iMA_M1_1 = iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_SMA, PRICE_CLOSE, 1);
   double iMA_M1_2 = iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_SMA, PRICE_CLOSE, 2);
   double iMA_M1_3 = iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_SMA, PRICE_CLOSE, 3);
   double iMA_M1_4 = iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_SMA, PRICE_CLOSE, 4);
   double iMA_M1_5 = iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_SMA, PRICE_CLOSE, 5);
   
   double iMA_M2_0 = iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iMA_M2_1 = iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_SMA, PRICE_CLOSE, 1);
   double iMA_M2_2 = iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_SMA, PRICE_CLOSE, 2);
   double iMA_M2_3 = iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_SMA, PRICE_CLOSE, 3);
   double iMA_M2_4 = iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_SMA, PRICE_CLOSE, 4);
   double iMA_M2_5 = iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_SMA, PRICE_CLOSE, 5);
   
   //Candle variable
   double candle_open_0 = iOpen(NULL, PERIOD_CURRENT, 0);
   double candle_open_1 = iOpen(NULL, PERIOD_CURRENT, 1);
   double candle_open_2 = iOpen(NULL, PERIOD_CURRENT, 2);
   double candle_open_3 = iOpen(NULL, PERIOD_CURRENT, 3);
   double candle_open_4 = iOpen(NULL, PERIOD_CURRENT, 4);
   double candle_open_5 = iOpen(NULL, PERIOD_CURRENT, 5);
   
   double candle_close_0 = iClose(NULL, PERIOD_CURRENT, 0);
   double candle_close_1 = iClose(NULL, PERIOD_CURRENT, 1);
   double candle_close_2 = iClose(NULL, PERIOD_CURRENT, 2);
   double candle_close_3 = iClose(NULL, PERIOD_CURRENT, 3);
   double candle_close_4 = iClose(NULL, PERIOD_CURRENT, 4);
   double candle_close_5 = iClose(NULL, PERIOD_CURRENT, 5);
   
   int iMA_checker = 0;
   
   if(candle_close_1 > candle_open_1 && candle_close_2 > candle_open_2){
      iMA_checker = 1;
   }
   
   if(candle_close_1 < candle_open_1 && candle_close_2 < candle_open_2){
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
   
   if(iStdDev_16_0 - iStdDev_16_1 > 0.00001){
      iStdDev_checker = 1;
   }
   
   if(iMA_checker == 1 && iStdDev_checker == 1){
      signal = 1;
   }
   
   if(iMA_checker == -1 && iStdDev_checker == 1){
      signal = -1;
   }
   
   return(signal);
   
}
