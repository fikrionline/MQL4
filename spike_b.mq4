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
   
   //iStochastic variable
   /*
   double iStochastic_16_4_4_mode_main_0 = iStochastic(NULL, PERIOD_CURRENT, 16, 4, 4, MODE_SMA, 0, MODE_MAIN, 0);
   double iStochastic_16_4_4_mode_main_1 = iStochastic(NULL, PERIOD_CURRENT, 16, 4, 4, MODE_SMA, 0, MODE_MAIN, 1);
   double iStochastic_16_4_4_mode_main_2 = iStochastic(NULL, PERIOD_CURRENT, 16, 4, 4, MODE_SMA, 0, MODE_MAIN, 2);
   double iStochastic_16_4_4_mode_main_3 = iStochastic(NULL, PERIOD_CURRENT, 16, 4, 4, MODE_SMA, 0, MODE_MAIN, 3);
   double iStochastic_16_4_4_mode_main_4 = iStochastic(NULL, PERIOD_CURRENT, 16, 4, 4, MODE_SMA, 0, MODE_MAIN, 4);
   double iStochastic_16_4_4_mode_main_5 = iStochastic(NULL, PERIOD_CURRENT, 16, 4, 4, MODE_SMA, 0, MODE_MAIN, 5);
   
   double iStochastic_16_4_4_mode_signal_0 = iStochastic(NULL, PERIOD_CURRENT, 16, 4, 4, MODE_SMA, 0, MODE_SIGNAL, 0);
   double iStochastic_16_4_4_mode_signal_1 = iStochastic(NULL, PERIOD_CURRENT, 16, 4, 4, MODE_SMA, 0, MODE_SIGNAL, 1);
   double iStochastic_16_4_4_mode_signal_2 = iStochastic(NULL, PERIOD_CURRENT, 16, 4, 4, MODE_SMA, 0, MODE_SIGNAL, 2);
   double iStochastic_16_4_4_mode_signal_3 = iStochastic(NULL, PERIOD_CURRENT, 16, 4, 4, MODE_SMA, 0, MODE_SIGNAL, 3);
   double iStochastic_16_4_4_mode_signal_4 = iStochastic(NULL, PERIOD_CURRENT, 16, 4, 4, MODE_SMA, 0, MODE_SIGNAL, 4);
   double iStochastic_16_4_4_mode_signal_5 = iStochastic(NULL, PERIOD_CURRENT, 16, 4, 4, MODE_SMA, 0, MODE_SIGNAL, 5);
   
   int iStochastic_checker = 0;
   
   if(iStochastic_16_4_4_mode_main_0 > iStochastic_16_4_4_mode_signal_0 && iStochastic_16_4_4_mode_main_1 > iStochastic_16_4_4_mode_signal_1 && iStochastic_16_4_4_mode_main_2 < iStochastic_16_4_4_mode_signal_2) {
      iStochastic_checker = 1;
   }
   
   if(iStochastic_16_4_4_mode_main_0 < iStochastic_16_4_4_mode_signal_0 && iStochastic_16_4_4_mode_main_1 < iStochastic_16_4_4_mode_signal_1 && iStochastic_16_4_4_mode_main_2 > iStochastic_16_4_4_mode_signal_2) {
      iStochastic_checker = -1;
   }
   
   //Compare indicator variable
   if(iStochastic_checker == 1) {
      signal = 1;
   }
   
   if(iStochastic_checker == -1) {
      signal = -1;
   }*/
   
   //iMA variable
   /*
   double iMA_4_0 = iMA(NULL, PERIOD_CURRENT, 4, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iMA_4_1 = iMA(NULL, PERIOD_CURRENT, 4, 0, MODE_SMA, PRICE_CLOSE, 1);
   double iMA_4_2 = iMA(NULL, PERIOD_CURRENT, 4, 0, MODE_SMA, PRICE_CLOSE, 2);
   double iMA_4_3 = iMA(NULL, PERIOD_CURRENT, 4, 0, MODE_SMA, PRICE_CLOSE, 3);
   double iMA_4_4 = iMA(NULL, PERIOD_CURRENT, 4, 0, MODE_SMA, PRICE_CLOSE, 4);
   double iMA_4_5 = iMA(NULL, PERIOD_CURRENT, 4, 0, MODE_SMA, PRICE_CLOSE, 5);
   
   double iMA_16_0 = iMA(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iMA_16_1 = iMA(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 1);
   double iMA_16_2 = iMA(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 2);
   double iMA_16_3 = iMA(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 3);
   double iMA_16_4 = iMA(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 4);
   double iMA_16_5 = iMA(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 5);
   
   double iMA_96_0 = iMA(NULL, PERIOD_CURRENT, 96, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iMA_96_1 = iMA(NULL, PERIOD_CURRENT, 96, 0, MODE_SMA, PRICE_CLOSE, 1);
   double iMA_96_2 = iMA(NULL, PERIOD_CURRENT, 96, 0, MODE_SMA, PRICE_CLOSE, 2);
   double iMA_96_3 = iMA(NULL, PERIOD_CURRENT, 96, 0, MODE_SMA, PRICE_CLOSE, 3);
   double iMA_96_4 = iMA(NULL, PERIOD_CURRENT, 96, 0, MODE_SMA, PRICE_CLOSE, 4);
   double iMA_96_5 = iMA(NULL, PERIOD_CURRENT, 96, 0, MODE_SMA, PRICE_CLOSE, 5);
   
   int iMA_checker = 0;
   
   if(iMA_4_0 > iMA_16_0 && iMA_16_0 > iMA_96_0) {
      iMA_checker = 1;
   }
   
   if(iMA_4_0 < iMA_16_0 && iMA_16_0 < iMA_96_0) {
      iMA_checker = -1;
   }
   
   //Compare indicator variable
   if(iMA_checker == 1) {
      signal = 1;
   }
   
   if(iMA_checker == -1) {
      signal = -1;
   }*/
   
   //iMomentum variable
   /*
   double iMomentum_16_0 = iMomentum(NULL, PERIOD_CURRENT, 16, PRICE_CLOSE, 0);
   double iMomentum_16_1 = iMomentum(NULL, PERIOD_CURRENT, 16, PRICE_CLOSE, 1);
   double iMomentum_16_2 = iMomentum(NULL, PERIOD_CURRENT, 16, PRICE_CLOSE, 2);
   double iMomentum_16_3 = iMomentum(NULL, PERIOD_CURRENT, 16, PRICE_CLOSE, 3);
   double iMomentum_16_4 = iMomentum(NULL, PERIOD_CURRENT, 16, PRICE_CLOSE, 4);
   double iMomentum_16_5 = iMomentum(NULL, PERIOD_CURRENT, 16, PRICE_CLOSE, 5);
   
   int iMomentum_checker = 0;
   
   if(iMomentum_16_0 > iMomentum_16_1 && iMomentum_16_1 > iMomentum_16_2 && iMomentum_16_2 < iMomentum_16_3){
      iMomentum_checker = 1;
   }
   
   if(iMomentum_16_0 < iMomentum_16_1 && iMomentum_16_1 < iMomentum_16_2 && iMomentum_16_2 > iMomentum_16_3){
      iMomentum_checker = -1;
   }
   
   if(iMomentum_checker == 1) {
      signal = 1;
   }
   
   if(iMomentum_checker == -1) {
      signal = -1;
   }*/
   
   //iStdDev variable
   /*
   double iStdDev_16_0 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 0);
   double iStdDev_16_1 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 1);
   double iStdDev_16_2 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 2);
   double iStdDev_16_3 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 3);
   double iStdDev_16_4 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 4);
   double iStdDev_16_5 = iStdDev(NULL, PERIOD_CURRENT, 16, 0, MODE_SMA, PRICE_CLOSE, 5);
   
   int iStdDev_checker = 0;
   int iStdDev_buy_sell_checker = 0;
   
   if(iStdDev_16_0 - iStdDev_16_2 > 0.0001){
      iStdDev_checker = 1;
   }
   
   if(iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_EMA, PRICE_CLOSE, 0) > iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_EMA, PRICE_CLOSE, 0)) {
      iStdDev_buy_sell_checker = 1;
   }
   
   if(iMA(NULL, PERIOD_CURRENT, 1, 0, MODE_EMA, PRICE_CLOSE, 0) < iMA(NULL, PERIOD_CURRENT, 2, 0, MODE_EMA, PRICE_CLOSE, 0)) {
      iStdDev_buy_sell_checker = -1;
   }
   
   if(iOpen(NULL, PERIOD_CURRENT, 1) < iClose(NULL, PERIOD_CURRENT, 1)){
      iStdDev_buy_sell_checker = 1;
   }
   
   if(iOpen(NULL, PERIOD_CURRENT, 1) > iClose(NULL, PERIOD_CURRENT, 1)){
      iStdDev_buy_sell_checker = -1;
   }
   
   if(iStdDev_checker == 1 && iStdDev_buy_sell_checker == 1){
      signal = 1;
   }
   
   if(iStdDev_checker == 1 && iStdDev_buy_sell_checker == -1){
      signal = -1;
   }*/
   
   //iMACD variable
   /*
   double iMACD_16_96_4_main_0 = iMACD(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, MODE_MAIN, 0);
   double iMACD_16_96_4_main_1 = iMACD(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, MODE_MAIN, 1);
   double iMACD_16_96_4_main_2 = iMACD(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, MODE_MAIN, 2);
   double iMACD_16_96_4_main_3 = iMACD(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, MODE_MAIN, 3);
   double iMACD_16_96_4_main_4 = iMACD(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, MODE_MAIN, 4);
   double iMACD_16_96_4_main_5 = iMACD(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, MODE_MAIN, 5);
   
   double iMACD_16_96_4_signal_0 = iMACD(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, MODE_SIGNAL, 0);
   double iMACD_16_96_4_signal_1 = iMACD(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, MODE_SIGNAL, 1);
   double iMACD_16_96_4_signal_2 = iMACD(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, MODE_SIGNAL, 2);
   double iMACD_16_96_4_signal_3 = iMACD(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, MODE_SIGNAL, 3);
   double iMACD_16_96_4_signal_4 = iMACD(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, MODE_SIGNAL, 4);
   double iMACD_16_96_4_signal_5 = iMACD(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, MODE_SIGNAL, 5);
   
   int iMACD_checker = 0;
   if(iMACD_16_96_4_main_0 - iMACD_16_96_4_signal_0 >= 0.0001){
      iMACD_checker = 1;
   }
   
   if(iMACD_16_96_4_signal_0 - iMACD_16_96_4_main_0 >= 0.0001){
      iMACD_checker = -1;
   }
   
   if(iMACD_checker == 1) {
      signal = 1;
   }
   
   if(iMACD_checker == -1) {
      signal = -1;
   }*/
   
   //iOsMA variable
   /*
   double iOsMA_16_96_4_0 = iOsMA(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, 0);
   double iOsMA_16_96_4_1 = iOsMA(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, 1);
   double iOsMA_16_96_4_2 = iOsMA(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, 2);
   double iOsMA_16_96_4_3 = iOsMA(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, 3);
   double iOsMA_16_96_4_4 = iOsMA(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, 4);
   double iOsMA_16_96_4_5 = iOsMA(NULL, PERIOD_CURRENT, 16, 96, 4, PRICE_CLOSE, 5);
   
   int iOsMA_checker = 0;
   
   if(iOsMA_16_96_4_0 > iOsMA_16_96_4_1 && iOsMA_16_96_4_1 > iOsMA_16_96_4_2 && iOsMA_16_96_4_4 > 0.0){
      iOsMA_checker = 1;
   }
   
   if(iOsMA_16_96_4_0 < iOsMA_16_96_4_1 && iOsMA_16_96_4_1 < iOsMA_16_96_4_2 && iOsMA_16_96_4_4 < 0.0){
      iOsMA_checker = -1;
   }
   
   if(iOsMA_checker == 1) {
      signal = 1;
   }
   
   if(iOsMA_checker == -1) {
      signal = -1;
   }*/
  
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
