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
extern bool RemoveSLFirst = false;
extern double TakeProfitPoint = 1000;
extern double StopLossPoint = 1000;
int Faktor, Digt, cnt, TicketOrder;
double TPp, SLp;
bool RemoveSLFirstChecker = false;

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
void OnTick() {

   if (Close[0] > 10) {
      Faktor = 1000;
      Digt = 3;
   } else
   if (Close[0] < 10) {
      Faktor = 100000;
      Digt = 5;
   }
   
   if(RemoveSLFirstChecker == false) {
   
      if(RemoveSLFirst == true) {
         for (cnt = 0; cnt < OrdersTotal(); cnt++) {
            TicketOrder = OrderSelect(cnt, SELECT_BY_POS);
            if(OrderStopLoss() != 0) {
               TicketOrder = OrderModify(OrderTicket(), OrderOpenPrice(), 0, OrderTakeProfit(), clrNONE);
               Sleep(500);
            }
         }
            
      }
   
      if (OrdersTotal() != 0) {
         for (cnt = 0; cnt < OrdersTotal(); cnt++) {
            TicketOrder = OrderSelect(cnt, SELECT_BY_POS);
            
            if (OrderTakeProfit() != 0 && OrderStopLoss() == 0) {
            
               //if (OrderType() == OP_BUY  && OrderSymbol() == Symbol()) {
               if (OrderType() == OP_BUY) {
                  TPp = (OrderTakeProfit() - OrderOpenPrice()) / Faktor;               
                  if(RiskReward == RRZeroPointFive) {
                     SLp = OrderOpenPrice() - ((TPp * 2) * Faktor);
                  } else if(RiskReward == RROne) {
                     SLp = OrderOpenPrice() - ((TPp * 1) * Faktor);
                  } else if(RiskReward == RRTwo) {
                     SLp = OrderOpenPrice() - ((TPp / 2) * Faktor);
                  } else if(RiskReward == RRThree) {
                     SLp = OrderOpenPrice() - ((TPp / 3) * Faktor);
                  } else if(RiskReward == RRFour) {
                     SLp = OrderOpenPrice() - ((TPp / 4) * Faktor);
                  } else { //Other is 1:1
                     SLp = OrderOpenPrice() - ((TPp * 1) * Faktor);
                  }
                  TicketOrder = OrderModify(OrderTicket(), OrderOpenPrice(), SLp, OrderTakeProfit(), clrNONE);
               }
               
               //if (OrderType() == OP_SELL  && OrderSymbol() == Symbol()) {
               if (OrderType() == OP_SELL) {
                  TPp = (OrderOpenPrice() - OrderTakeProfit()) / Faktor;               
                  if(RiskReward == RRZeroPointFive) {
                     SLp = OrderOpenPrice() + ((TPp * 2) * Faktor);
                  } else if(RiskReward == RROne) {
                     SLp = OrderOpenPrice() + ((TPp * 1) * Faktor);
                  } else if(RiskReward == RRTwo) {
                     SLp = OrderOpenPrice() + ((TPp / 2) * Faktor);
                  } else if(RiskReward == RRThree) {
                     SLp = OrderOpenPrice() + ((TPp / 3) * Faktor);
                  } else if(RiskReward == RRFour) {
                     SLp = OrderOpenPrice() + ((TPp / 4) * Faktor);
                  } else { //Other is 1:1
                     SLp = OrderOpenPrice() + ((TPp * 1) * Faktor);
                  }
                  TicketOrder = OrderModify(OrderTicket(), OrderOpenPrice(), SLp, OrderTakeProfit(), clrNONE);
               }
               
            }
            
            Sleep(500);
   
         }
         
      }
      
      RemoveSLFirstChecker = true;
      
   }
   
   //return (0);
      
}
