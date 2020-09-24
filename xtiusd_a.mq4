//+------------------------------------------------------------------+
//|                                                     xtiusd_a.mq4 |
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
extern double TakeProfit  = 100;
extern double StopLoss    = 100;

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


datetime ZeroTime = 0;

void OnTick(){
   //if (ZeroTime != Time[0]){      
   
      int type, ticket_open;
      double price, sl, tp;
      
      if(PosSelect() == 0){
      
         if(Signal() == 1){//Buy signal and no current chart positions exists
            type = OP_BUY;
            price = Ask;
            sl = StopLoss > 0 ? NormalizeDouble(price - (double)StopLoss*_Point,_Digits):0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price + (double)TakeProfit*_Point,_Digits):0.0;
            ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, CLR_NONE);
         }
         
         if(Signal() == -1){//Sell signal and no current chart positions exists
            type = OP_SELL;
            price = Bid;
            sl = StopLoss > 0 ? NormalizeDouble(price + (double)StopLoss*_Point,_Digits):0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price - (double)TakeProfit*_Point,_Digits):0.0;
            ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, CLR_NONE);
         }
      }else{
         for (int i=OrdersTotal()-1; i>=0; i--)
         {
            if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
            if(OrderSymbol() != Symbol()) continue;
            if (OrderMagicNumber() != MagicNumber) continue;
            if ((TimeCurrent() - OrderOpenTime()) >= 3600)
            {
               
               if (OrderType() == OP_BUY){
                  //ticket_close = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 0, CLR_NONE);
               }
               
               if (OrderType() == OP_SELL){
                  //ticket_close = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 0, CLR_NONE);
               }
            }
         }
      }
      
      ZeroTime = Time[0];
   //}
}

int Signal() {

   int signal = 0;

   double iStochastic_533_main_0 = iStochastic(Symbol(), PERIOD_H1, 5, 3, 5, MODE_SMA, 0, MODE_MAIN, 0);
   double iStochastic_533_signal_0 = iStochastic(Symbol(), PERIOD_H1, 5, 3, 5, MODE_SMA, 0, MODE_SIGNAL, 0);
   
   double iStochastic_533_main_1 = iStochastic(Symbol(), PERIOD_H1, 5, 3, 5, MODE_SMA, 0, MODE_MAIN, 1);
   double iStochastic_533_signal_1 = iStochastic(Symbol(), PERIOD_H1, 5, 3, 5, MODE_SMA, 0, MODE_SIGNAL, 1);
   
   double iMA_M1_0 = iMA(NULL, PERIOD_H1, 1, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iMA_M1_1 = iMA(NULL, PERIOD_H1, 1, 0, MODE_SMA, PRICE_CLOSE, 1);
   double iMA_M1_2 = iMA(NULL, PERIOD_H1, 1, 0, MODE_SMA, PRICE_CLOSE, 2);
   double iMA_M1_3 = iMA(NULL, PERIOD_H1, 1, 0, MODE_SMA, PRICE_CLOSE, 3);
   double iMA_M1_4 = iMA(NULL, PERIOD_H1, 1, 0, MODE_SMA, PRICE_CLOSE, 4);
   double iMA_M1_5 = iMA(NULL, PERIOD_H1, 1, 0, MODE_SMA, PRICE_CLOSE, 5);
   
   double iMA_M2_0 = iMA(NULL, PERIOD_H1, 2, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iMA_M2_1 = iMA(NULL, PERIOD_H1, 2, 0, MODE_SMA, PRICE_CLOSE, 1);
   double iMA_M2_2 = iMA(NULL, PERIOD_H1, 2, 0, MODE_SMA, PRICE_CLOSE, 2);
   double iMA_M2_3 = iMA(NULL, PERIOD_H1, 2, 0, MODE_SMA, PRICE_CLOSE, 3);
   double iMA_M2_4 = iMA(NULL, PERIOD_H1, 2, 0, MODE_SMA, PRICE_CLOSE, 4);
   double iMA_M2_5 = iMA(NULL, PERIOD_H1, 2, 0, MODE_SMA, PRICE_CLOSE, 5);
   
   if(iStochastic_533_signal_0 < 20 && iStochastic_533_signal_1 > 20){
      signal = 1;
   }
   
   if(iStochastic_533_signal_0 > 80 && iStochastic_533_signal_1 < 80){
      signal = -1;
   }
   
   return (signal);
   
}


//Check previous order
int PosSelect(){
   int previous_position = 0;
   for(int k = OrdersTotal() - 1; k >= 0; k--){
      if(!OrderSelect(k, SELECT_BY_POS)){
         break;
      }
      
      if((OrderSymbol() != Symbol()) && (OrderMagicNumber() != MagicNumber)){
         continue;
      }
      
      if((OrderCloseTime() == 0) && (OrderSymbol() == Symbol()) && (OrderMagicNumber() == MagicNumber)){
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