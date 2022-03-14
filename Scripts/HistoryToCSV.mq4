#property copyright "MLADEN"
#property link "mladenfx@gmail.com"
#property show_inputs
#property strict

input string FileToSaveTo = "HistoryCSV"; // File name to use to save the history data

void OnStart()
{

    int handle = FileOpen(FileToSaveTo + ".csv", FILE_CSV | FILE_WRITE);
    if (handle != INVALID_HANDLE)
    {
        int saved = 0;
        for (int i = OrdersHistoryTotal() - 1; i >= 0; i--)
        {
            if (!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
                continue;
            int type = OrderType();
            switch (type)
            {
                case OP_BUY:
                case OP_SELL:
                     #define _dts(_arg) TimeToString(_arg, TIME_DATE | TIME_MINUTES)
                     #define _prs(_arg) DoubleToString(_arg, (int)MarketInfo(OrderSymbol(), MODE_DIGITS))
                     #define _lts(_arg) DoubleToString(_arg, 2)
                     #define _del ";"
                     saved++;
                     FileWrite(handle, (string)OrderTicket() + _del + _dts(OrderOpenTime()) + _del
                            + (type == OP_SELL ? "Sell" : "Buy") + _del + _lts(OrderLots()) + _del
                            + OrderSymbol() + _del + _prs(OrderOpenPrice()) + _del
                            + _prs(OrderStopLoss()) + _del + _prs(OrderTakeProfit()) + _del
                            + _dts(OrderCloseTime()) + _del + _prs(OrderClosePrice()) + _del
                            + _prs(OrderCommission()) + _del + _prs(OrderSwap()) + _del
                            + _prs(OrderProfit()) + _del + OrderComment());
            }
        }
        FileClose(handle);
        Comment((string)saved + " records saved to " + FileToSaveTo + ".csv file");
    }
    return;
}
