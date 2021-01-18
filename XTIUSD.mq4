//+------------------------------------------------------------------+
//|                                                       XTIUSD.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, MetaQuotes Software Corp"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict
#include <stdlib.mqh>
#define MAGIC 5758

enum TRADE_TYPE {
    BUY,
    SELL,
    FollowTrend
};

//--- input parameters
input string TimeToOpen = "02:00:02";
input TRADE_TYPE TradeType = FollowTrend;
input double Lots = 1;
input int Slippage = 3;
input int StopLoss = 30;
input int TakeProfit = 45;

MqlDateTime time_to_open;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    //---
    TimeToStruct(StringToTime(TimeToOpen), time_to_open);
    //---
    return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    //---
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    //---
    MqlDateTime time;
    TimeCurrent(time);
    time.hour = time_to_open.hour;
    time.min = time_to_open.min;
    time.sec = time_to_open.sec;
    datetime time_current = TimeCurrent();
    datetime time_trade = StructToTime(time);
    if (time_current >= time_trade && time_current < time_trade + (15 * PeriodSeconds(PERIOD_M1)) && CanTrade())
        if (!OpenTrade())
            Print(__FUNCTION__, " <!!!> ", ErrorDescription(GetLastError()));
}
//+------------------------------------------------------------------+

bool CanTrade()
{
    datetime last_trade = 0;
    for (int i = OrdersHistoryTotal() - 1; i >= 0; i--)
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == _Symbol && OrderMagicNumber() == MAGIC)
            if (OrderOpenTime() > last_trade)
                last_trade = OrderOpenTime();

    if (TimeCurrent() - last_trade < 12 * PeriodSeconds(PERIOD_H1))
        return false;

    for (int i = OrdersTotal() - 1; i >= 0; i--)
        if (OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == _Symbol && OrderMagicNumber() == MAGIC)
            return false;

    return true;
}

bool OpenTrade()
{
    int type;
    double price;
    double sl;
    double tp;
    if (TradeType == BUY) {
        type = OP_BUY;
        price = Ask;
        sl = StopLoss > 0 ? NormalizeDouble(price - (double)StopLoss * _Point, _Digits) : 0.0;
        tp = TakeProfit > 0 ? NormalizeDouble(price + (double)TakeProfit * _Point, _Digits) : 0.0;
    }
    else if (TradeType == SELL) {
        type = OP_SELL;
        price = Bid;
        sl = StopLoss > 0 ? NormalizeDouble(price + (double)StopLoss * _Point, _Digits) : 0.0;
        tp = TakeProfit > 0 ? NormalizeDouble(price - (double)TakeProfit * _Point, _Digits) : 0.0;
    }
    else {
        if (signals() == 1) {
            type = OP_BUY;
            price = Ask;
            sl = StopLoss > 0 ? NormalizeDouble(price - (double)StopLoss * _Point, _Digits) : 0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price + (double)TakeProfit * _Point, _Digits) : 0.0;
        }
        else {
            type = OP_SELL;
            price = Bid;
            sl = StopLoss > 0 ? NormalizeDouble(price + (double)StopLoss * _Point, _Digits) : 0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price - (double)TakeProfit * _Point, _Digits) : 0.0;
        }
    }
    return OrderSend(_Symbol, type, Lots, price, Slippage, sl, tp, "Timed Trade", MAGIC, 0, clrLime) >= 0;
}

int signals()
{

    int signal = 0;

    if (iClose(NULL, PERIOD_H1, 1) > iOpen(NULL, PERIOD_H1, 1)) {
        signal = 1;
    }
    else {
        signal = 0;
    }

    return signal;
}
