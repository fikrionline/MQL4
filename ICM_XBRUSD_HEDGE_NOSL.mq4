//+------------------------------------------------------------------+
//|                                                TPSL-OilHedge.mq4 |
//|                         Copyright 2020, MetaQuotes Software Corp |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp"
#property link "https://www.mql5.com"
#property version "1.00"

//---- input parameters
extern string CommentOrder = "BISMILLAHIRROHMANIRROHIM";
extern double TakeProfitPips = 60;
extern double StopLossPips = 60;
extern int LayerOrder = 4;
extern double LayerPips = 63;
extern int MagicNumber = 5758;
int Faktor, Digt, cnt, lyr, multiplier;
double TPp, SLp, SelectOrder, ModifyOrder, NewOrder;

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
    if (Close[0] > 10)
    {
        Faktor = 100;
        Digt = 3;
    }
    else if (Close[0] < 10)
    {
        Faktor = 100000;
        Digt = 5;
    }

    if (OrdersTotal() != 0)
    {

        for (cnt = 0; cnt < OrdersTotal(); cnt++)
        {
            SelectOrder = OrderSelect(cnt, SELECT_BY_POS);

            //--------------Take Profit--------------------------------
            if (OrderTakeProfit() == 0 && TakeProfitPips != 0)
            {
                if (OrderType() == OP_BUY && OrderSymbol() == Symbol())
                {
                    TPp = OrderOpenPrice() + TakeProfitPips / Faktor;
                }
                if (OrderType() == OP_SELL && OrderSymbol() == Symbol())
                {
                    TPp = OrderOpenPrice() - TakeProfitPips / Faktor;
                }
            }
            else
            {
                TPp = OrderTakeProfit();
            }
            //--------------------------------------------------------

            //---------------Stop Loss--------------------------------
            if (OrderStopLoss() == 0 && StopLossPips != 0)
            {
                if (OrderType() == OP_BUY && OrderSymbol() == Symbol())
                {
                    SLp = OrderOpenPrice() - (StopLossPips + (LayerPips * LayerOrder)) / Faktor;
                }
                if (OrderType() == OP_SELL && OrderSymbol() == Symbol())
                {
                    SLp = OrderOpenPrice() + (StopLossPips + (LayerPips * LayerOrder)) / Faktor;
                }
            }
            else
            {
                SLp = OrderStopLoss();
            }
            //--------------------------------------------------------


            if (OrderTakeProfit() == 0 && TakeProfitPips != 0 && OrderStopLoss() == 0 && StopLossPips != 0)
            {

                //-----------------Modify Order---------------------------
                if (OrderType() == OP_BUY || OrderType() == OP_SELL)
                {
                    SelectOrder = OrderModify(OrderTicket(), OrderOpenPrice(), 0, TPp, 0);
                }
                //--------------------------------------------------------

                //--------------New Order for Averaging-------------------
                if (OrderType() == OP_BUY)
                {
                    for (lyr = 1; lyr <= LayerOrder; lyr++)
                    {
                        multiplier = lyr + 1;
                        NewOrder = OrderSend(Symbol(), OP_BUYLIMIT, OrderLots() * multiplier,
                            OrderOpenPrice() - ((LayerPips * lyr) / Faktor), 0, 0, TPp, CommentOrder,
                            MagicNumber + lyr, 0, clrNONE);
                    }
                }
                if (OrderType() == OP_SELL)
                {
                    for (lyr = 1; lyr <= LayerOrder; lyr++)
                    {
                        multiplier = lyr + 1;
                        NewOrder = OrderSend(Symbol(), OP_SELLLIMIT, OrderLots() * multiplier,
                            OrderOpenPrice() + ((LayerPips * lyr) / Faktor), 0, 0, TPp, CommentOrder,
                            MagicNumber - lyr, 0, clrNONE);
                    }
                }
                //--------------------------------------------------------
            }

        } // for cnt

    } // if OrdersTotal

    return (0);
}
//+------------------------------------------------------------------+
