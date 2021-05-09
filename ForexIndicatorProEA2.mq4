//+------------------------------------------------------------------+
//|                                         ForexIndicatorProEA2.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.1"
#property strict

extern int MagicNumber = 5758;
extern double Lots = 0.1;
extern double TakeProfit = 307;
extern double StopLoss = 293;
extern int SlipPage = 5;

datetime NextCandle;
int SelectOrder, type, TicketOpen, TicketClose;
double price, sl, tp;

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
int start() {

   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      // New candle, your trading functions here
      
      int CheckPosSelect = PosSelect(MagicNumber);
      
      if (CheckPosSelect == 1) {
      
         if (Signal() == -1) {
            TicketClose = CloseLastOrder(MagicNumber);
         }
      
      } else if(CheckPosSelect == -1) {
         
         if (Signal() == 1) {
            TicketClose = CloseLastOrder(MagicNumber);
         }
         
      }
      
      //Order when there are no order
      if (PosSelect(MagicNumber) == 0) {
      
         int ChekLastClosedOrder = LastClosedOrder(MagicNumber);

         if (Signal() == 1) {
         
            if(ChekLastClosedOrder == -1 || ChekLastClosedOrder == 0) {

               type = OP_BUY;
               price = Ask;
               sl = StopLoss > 0 ? NormalizeDouble(price - (double) StopLoss * Point(), Digits()) : 0.0;
               tp = TakeProfit > 0 ? NormalizeDouble(price + (double) TakeProfit * Point(), Digits()) : 0.0;
               TicketOpen = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);
            
            }

         } else if (Signal() == -1) {

            if(ChekLastClosedOrder == 1 || ChekLastClosedOrder == 0) {
            
               type = OP_SELL;
               price = Bid;
               sl = StopLoss > 0 ? NormalizeDouble(price + (double) StopLoss * Point(), Digits()) : 0.0;
               tp = TakeProfit > 0 ? NormalizeDouble(price - (double) TakeProfit * Point(), Digits()) : 0.0;
               TicketClose = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);
               
            }

         }

      }

   }

   return (0);

}

//Signal
int Signal() {

   int signal = 0;
   double ArrowUp, ArrowDown;

   ArrowUp   = iCustom(Symbol(), PERIOD_CURRENT, "ForexIndicatorPro", 0, 1);
   ArrowDown = iCustom(Symbol(), PERIOD_CURRENT, "ForexIndicatorPro", 1, 1);
   
   if(ArrowUp > 0 && ArrowDown < 0)
   {
      signal = 1;
   }
   
   if(ArrowDown > 0 && ArrowUp < 0)
   {
      signal = -1;
   }

   return signal;

}

//Check Previous Order
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

//CloseLastOrder
int CloseLastOrder(int CheckMagicNumber){

   int i_ticket = OrdersTotal()-1;
   
   if (i_ticket > -1 && OrderSelect (i_ticket, SELECT_BY_POS)){
      
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumber){ 
         
         if(OrderType() == OP_BUY){
            if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(MarketInfo(Symbol(), MODE_BID), (int)MarketInfo(Symbol(), MODE_DIGITS)), SlipPage, Yellow)) {
               return(1);//close ok
            }
         }
         
         if(OrderType() == OP_SELL){
            if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(MarketInfo(Symbol(), MODE_ASK), (int)MarketInfo(Symbol(), MODE_DIGITS)), SlipPage, Yellow)) {
               return(1); //close ok
            }
         }
         
      }
      
   }
   
   return(-1); //error while closing
   
}

//LastClosedOrder
int LastClosedOrder(int CheckMagicNumber) {

   int LastOrderType = 0;

   for(int i=OrdersHistoryTotal()-1;i>=0;i--) {
   
      SelectOrder = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);  //error was here
      
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==CheckMagicNumber) {
      
         if(OrderType()==OP_BUY) {
         
            LastOrderType = 1;
            return LastOrderType;
            
         } else if(OrderType() == OP_SELL) {
         
            LastOrderType = -1;
            return LastOrderType;
            
         }
         
      }
      
   }

   return LastOrderType;

}