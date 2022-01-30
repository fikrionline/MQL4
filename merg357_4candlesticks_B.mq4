//+------------------------------------------------------------------+
//|                                        merg357_4candlesticks.mq4 |
//|                                                          Averied |
//|                                                         Bogle.es |
//+------------------------------------------------------------------+
#property copyright "Averied"
#property link "Bogle.es"

extern int candlesticks = 3;
extern int SLpips = 93;
extern int TPpips = 107;
extern double Lots = 0.1;
extern bool multipletrades = false;
extern bool tradeopposite = true;
extern int InstantTradePips = 0;
extern int mode = 0;

static datetime tmp;
int ticketOrder;

int init() {
   tmp = Time[0];
   string bulltxt = "Consecutive bullish: 0 ";
   ObjectCreate("txtcbull", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("txtcbull", bulltxt, 9, "Verdana", Green);
   ObjectSet("txtcbull", OBJPROP_CORNER, 0);
   ObjectSet("txtcbull", OBJPROP_XDISTANCE, 20);
   ObjectSet("txtcbull", OBJPROP_YDISTANCE, 20);

   string beartxt = "Consecutive bearish: 0";
   ObjectCreate("txtcbear", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("txtcbear", beartxt, 9, "Verdana", Red);
   ObjectSet("txtcbear", OBJPROP_CORNER, 0);
   ObjectSet("txtcbear", OBJPROP_XDISTANCE, 20);
   ObjectSet("txtcbear", OBJPROP_YDISTANCE, 40);

   return (0);
}

int deinit() {
   return (0);
}

int start() {

   string beartxt, bulltxt;
   if (!multipletrades && OrdersTotal() != 0) {
      return (0);
   }
   
   int i, cbarsbull, cbarsbear;
   if (tmp != Time[0]) {
      tmp = Time[0];
      for (i = 4; i > 0; i--) {
         if (Close[i] < Open[i]) {
            cbarsbear++;
            beartxt = "Consecutive bearish: " + DoubleToStr(cbarsbear, 0);
            ObjectSetText("txtcbear", beartxt, 9, "Verdana", Red);
         } else {
            cbarsbear = 0;
            beartxt = "Consecutive bearish: " + DoubleToStr(cbarsbear, 0);
            ObjectSetText("txtcbear", beartxt, 9, "Verdana", Red);
         }
         if (Close[i] > Open[i]) {
            cbarsbull++;
            bulltxt = "Consecutive bullish: " + DoubleToStr(cbarsbull, 0);
            ObjectSetText("txtcbull", bulltxt, 9, "Verdana", Green);
         } else {
            cbarsbull = 0;
            bulltxt = "Consecutive bullish: " + DoubleToStr(cbarsbull, 0);
            ObjectSetText("txtcbull", bulltxt, 9, "Verdana", Green);
         }
      }
      if (mode == 0) {
         if (cbarsbear == candlesticks) {
            if (InstantTradePips == 0 || (High[1] - Low[1]) > InstantTradePips * Point) {
               if (!tradeopposite)
                  ticketOrder = OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, Ask - SLpips * Point, Ask + TPpips * Point, "4candlesticks", 16384, 0, Green);
               else
                  ticketOrder = OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, Bid + SLpips * Point, Bid - TPpips * Point, "4candlesticks", 16384, 0, Red);

            }
         }
         if (cbarsbull == candlesticks) {
            if (InstantTradePips == 0 || (High[1] - Low[1]) > InstantTradePips * Point) {
               if (!tradeopposite)
                  ticketOrder = OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, Bid + SLpips * Point, Bid - TPpips * Point, "4candlesticks", 16384, 0, Red);
               else
                  ticketOrder = OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, Ask - SLpips * Point, Ask + TPpips * Point, "4candlesticks", 16384, 0, Green);
            }
         }
      }
   }
   if (mode == 1) {
      if (!tradeopposite) {
         if (Ask - Low[0] > InstantTradePips * Point) {
            ticketOrder = OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, Ask - SLpips * Point, Ask + TPpips * Point, "4candlesticks", 16384, 0, Green);
         }
         if (High[0] - Bid > InstantTradePips * Point) {
            ticketOrder = OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, Bid + SLpips * Point, Bid - TPpips * Point, "4candlesticks", 16384, 0, Red);
         }
      } else {
         if (Ask - Low[0] > InstantTradePips * Point) {
            ticketOrder = OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, Bid + SLpips * Point, Bid - TPpips * Point, "4candlesticks", 16384, 0, Red);
         }
         if (High[0] - Bid > InstantTradePips * Point) {
            ticketOrder = OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, Ask - SLpips * Point, Ask + TPpips * Point, "4candlesticks", 16384, 0, Green);
         }
      }
   }

   return (0);
}
