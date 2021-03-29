//+------------------------------------------------------------------+
//|                                                   SignaToEA2.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <hash.mqh>

#include <json.mqh>

#include <JAson.mqh>

extern int SlipPage = 5;
extern double BasicLot = 0.1;
extern bool AutoOrder = TRUE;
extern int StartOrderHour = 1;
extern int StopOrderHour = 22;
extern int TimeInSeconds = 10;

int start() {

   static datetime LastTime = 0;

   if (TimeCurrent() > LastTime + TimeInSeconds) {
      LastTime = TimeCurrent();
      //Your function running every second here

      string cookie = NULL, headers;
      char post[], result[];
      int res;
      string resultString = NULL;
      int timeout = 5000;
      res = WebRequest("GET", "http://fx.fikrionline.com/signal2.php", cookie, NULL, timeout, post, 0, result, headers);
      resultString = CharArrayToString(result); //Alert(resultString);

      string j_TypeOrder, j_pair, j_status, MagicA, MagicB, ShowComment;
      double j_OpenPrice, j_TakeProfit, j_StopLoss, PriceBidAsk;
      int MagicNumber, SendOrder;

      CJAVal json;
      if (json.Deserialize(resultString)) {
         for (int i = 0; i < json.Size(); i++) {
            
            j_TypeOrder = json[i]["signal"].ToStr();
            j_pair = json[i]["pair"].ToStr();
            j_status = json[i]["status"].ToStr();
            j_OpenPrice = StringToDouble(json[i]["OpenPrice"].ToStr());
            j_TakeProfit = StringToDouble(json[i]["TakeProfit"].ToStr());
            j_StopLoss = StringToDouble(json[i]["StopLoss"].ToStr());

            MagicA = "2" + IntegerToString(DayOfYear());
            MagicB = json[i]["OpenPrice"].ToStr();
            StringReplace(MagicB, ".", "");
            MagicNumber = StrToInteger(MagicA + MagicB);

            ShowComment = ShowComment + j_pair + " " + json[i]["signal"].ToStr() + " OP " + json[i]["OpenPrice"].ToStr() + " SL " + json[i]["StopLoss"].ToStr() + " TP " + " " + json[i]["TakeProfit"].ToStr() + " " + IntegerToString(MagicNumber) + "\n";

            if (AutoOrder == TRUE) {
               if(Hour() >= StartOrderHour && Hour() <= StopOrderHour) {
                  if (PosSelect(MagicNumber, j_pair) == 0) {
                     if (j_TypeOrder == "buy") {
                        PriceBidAsk = MarketInfo(j_pair, MODE_ASK);
                        SendOrder = OrderSend(j_pair, OP_BUY, NormalizeDouble(BasicLot, 2), PriceBidAsk, SlipPage, j_StopLoss, j_TakeProfit, IntegerToString(MagicNumber), MagicNumber, 0, clrNONE);
                     } else if (j_TypeOrder == "sell") {
                        PriceBidAsk = MarketInfo(j_pair, MODE_BID);
                        SendOrder = OrderSend(j_pair, OP_SELL, NormalizeDouble(BasicLot, 2), PriceBidAsk, SlipPage, j_StopLoss, j_TakeProfit, IntegerToString(MagicNumber), MagicNumber, 0, clrNONE);
                     }
   
                  }
               }
            }

         }

      }

      Comment(ShowComment);

   }

   return (0);

}

//Check previous order
int PosSelect(int TheMagic, string ThePair) {

   int previous_position = 0;

   for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {

      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderMagicNumber() == TheMagic) {
         previous_position = -9;
      }

      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderComment() == IntegerToString(TheMagic)) {
         previous_position = -9;
      }
   }

   if (previous_position == 0) {

      for (int k = OrdersTotal() - 1; k >= 0; k--) {
         if (!OrderSelect(k, SELECT_BY_POS)) {
            break;
         }

         if (OrderMagicNumber() != TheMagic) {
            continue;
         }

         if ((OrderCloseTime() == 0) && OrderMagicNumber() == TheMagic && OrderSymbol() == ThePair) {
            if (OrderType() == OP_BUY) {
               previous_position = 1; //Still have BUY position
            }
            if (OrderType() == OP_SELL) {
               previous_position = -1; //Still have SELL positon
            }
         }
      }

   }

   return (previous_position);

}
