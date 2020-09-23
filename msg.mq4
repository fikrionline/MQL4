//+------------------------------------------------------------------+
//|                                                 Notification.mq5 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                              https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs;
//+------------------------------------------------------------------+
//| Text message to send                                             |
//+------------------------------------------------------------------+
input string message="Hello World";
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- Send the message
   int res;
   res=SendNotification(message);
   if(!res)
     {
      Print("Message sending failed");
     }
   else
     {
      Print("Message sent");
     }
//---
  }
//+------------------------------------------------------------------+
