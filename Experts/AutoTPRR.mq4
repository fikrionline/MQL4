//+------------------------------------------------------------------+
//|                                                  TPSL-Insert.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link ""

//---- input parameters
enum TheRiskReward {
   RRZeroPointFive, //1:0.5
   RROne, //1:1
   RRTwo, //1:2
   RRThree, //1:3
   RRFour //1:4
};
extern TheRiskReward RiskReward = RROne;
extern bool RemoveTPFirst = false;
extern double TakeProfitPoint = 1000;
extern double StopLossPoint = 1000;
int Faktor, Digt, cnt, TicketOrder;
double TPp, SLp;
bool RemoveTPFirstChecker = false;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() { return(0); }

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() { return(0); }

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {

   if (Close[0] > 10) {
      Faktor = 1000;
      Digt = 3;
   } else
   if (Close[0] < 10) {
      Faktor = 100000;
      Digt = 5;
   }
   
   if(RemoveTPFirstChecker == false) {
   
      if(RemoveTPFirst == true) {
         for (cnt = 0; cnt < OrdersTotal(); cnt++) {
            TicketOrder = OrderSelect(cnt, SELECT_BY_POS);
            if(OrderTakeProfit() != 0) {
               TicketOrder = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), 0, clrNONE);
               Sleep(500);
            }
         }
            
      }

      if (OrdersTotal() != 0) {
         for (cnt = 0; cnt < OrdersTotal(); cnt++) {
            TicketOrder = OrderSelect(cnt, SELECT_BY_POS);
            
            if (OrderTakeProfit() == 0 && OrderStopLoss() != 0) {
            
               //if (OrderType() == OP_BUY  && OrderSymbol() == Symbol()) {
               if (OrderType() == OP_BUY) {
                  SLp = (OrderOpenPrice() - OrderStopLoss()) / Faktor;               
                  if(RiskReward == RRZeroPointFive) {
                     TPp = OrderOpenPrice() + ((SLp / 2) * Faktor);
                  } else if(RiskReward == RROne) {
                     TPp = OrderOpenPrice() + ((SLp * 1) * Faktor);
                  } else if(RiskReward == RRTwo) {
                     TPp = OrderOpenPrice() + ((SLp * 2) * Faktor);
                  } else if(RiskReward == RRThree) {
                     TPp = OrderOpenPrice() + ((SLp * 3) * Faktor);
                  } else if(RiskReward == RRFour) {
                     TPp = OrderOpenPrice() + ((SLp * 4) * Faktor);
                  } else { //Other is 1:1
                     TPp = OrderOpenPrice() + ((SLp * 1) * Faktor);
                  }
                  TicketOrder = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), TPp, clrNONE);
               }
               
               //if (OrderType() == OP_SELL  && OrderSymbol() == Symbol()) {
               if (OrderType() == OP_SELL) {
                  SLp = (OrderStopLoss() - OrderOpenPrice()) / Faktor;               
                  if(RiskReward == RRZeroPointFive) {
                     TPp = OrderOpenPrice() - ((SLp / 2) * Faktor);
                  } else if(RiskReward == RROne) {
                     TPp = OrderOpenPrice() - ((SLp * 1) * Faktor);
                  } else if(RiskReward == RRTwo) {
                     TPp = OrderOpenPrice() - ((SLp * 2) * Faktor);
                  } else if(RiskReward == RRThree) {
                     TPp = OrderOpenPrice() - ((SLp * 3) * Faktor);
                  } else if(RiskReward == RRFour) {
                     TPp = OrderOpenPrice() - ((SLp * 4) * Faktor);
                  } else { //Other is 1:1
                     TPp = OrderOpenPrice() - ((SLp * 1) * Faktor);
                  }
                  TicketOrder = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), TPp, clrNONE);
               }
               
            }
   
         }
         
      }
      
      RemoveTPFirstChecker = true;
      
   }
   
   return (0);
      
}
