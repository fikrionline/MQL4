//+------------------------------------------------------------------+
//|                                                SymbolChanger.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 0
#property strict

extern string UniqueID = "SymbolChanger"; // Indicator unique ID
extern bool DisplayTimeFrame = 0;
extern int ButtonsInARow = 20; // Buttons in a horizontal row
extern int XShift = 2; // Horizontal shift
extern int YShift = 2; // Vertical shift
extern int XSize = 55; // Width of buttons
extern int YSize = 18; // Height of buttons
extern int FSize = 9; // Font size
extern color Bcolor = clrGainsboro; // Button color
extern color Dcolor = clrDarkGray; // Button border color
extern color Tncolor = clrBlack; // Text color - normal
extern color Sncolor = clrRed; // Text color - selected
extern bool Transparent = false; // Transparent buttons?


int OnInit()
{
    IndicatorShortName(UniqueID);
    int xpos = 0, ypos = 0, maxx = 0, maxy = 0;

    string IndicatorSymbol[70];

IndicatorSymbol[0] = "AUDCAD";
IndicatorSymbol[1] = "AUDCHF";
IndicatorSymbol[2] = "AUDHUF";
IndicatorSymbol[3] = "AUDJPY";
IndicatorSymbol[4] = "AUDNOK";
IndicatorSymbol[5] = "AUDNZD";
IndicatorSymbol[6] = "AUDSEK";
IndicatorSymbol[7] = "AUDSGD";
IndicatorSymbol[8] = "AUDUSD";
IndicatorSymbol[9] = "CADCHF";
IndicatorSymbol[10] = "CADJPY";
IndicatorSymbol[11] = "CADSGD";
IndicatorSymbol[12] = "CHFHUF";
IndicatorSymbol[13] = "CHFJPY";
IndicatorSymbol[14] = "CHFNOK";
IndicatorSymbol[15] = "EURAUD";
IndicatorSymbol[16] = "EURCAD";
IndicatorSymbol[17] = "EURCHF";
IndicatorSymbol[18] = "EURCZK";
IndicatorSymbol[19] = "EURDKK";
IndicatorSymbol[20] = "EURGBP";
IndicatorSymbol[21] = "EURHUF";
IndicatorSymbol[22] = "EURILS";
IndicatorSymbol[23] = "EURJPY";
IndicatorSymbol[24] = "EURMXN";
IndicatorSymbol[25] = "EURNOK";
IndicatorSymbol[26] = "EURNZD";
IndicatorSymbol[27] = "EURPLN";
IndicatorSymbol[28] = "EURSEK";
IndicatorSymbol[29] = "EURSGD";
IndicatorSymbol[30] = "EURTRY";
IndicatorSymbol[31] = "EURUSD";
IndicatorSymbol[32] = "EURZAR";
IndicatorSymbol[33] = "GBPAUD";
IndicatorSymbol[34] = "GBPCAD";
IndicatorSymbol[35] = "GBPCHF";
IndicatorSymbol[36] = "GBPDKK";
IndicatorSymbol[37] = "GBPHUF";
IndicatorSymbol[38] = "GBPJPY";
IndicatorSymbol[39] = "GBPNOK";
IndicatorSymbol[40] = "GBPNZD";
IndicatorSymbol[41] = "GBPPLN";
IndicatorSymbol[42] = "GBPSEK";
IndicatorSymbol[43] = "GBPTRY";
IndicatorSymbol[44] = "GBPUSD";
IndicatorSymbol[45] = "GBPZAR";
IndicatorSymbol[46] = "NOKSEK";
IndicatorSymbol[47] = "NZDCAD";
IndicatorSymbol[48] = "NZDCHF";
IndicatorSymbol[49] = "NZDHUF";
IndicatorSymbol[50] = "NZDJPY";
IndicatorSymbol[51] = "NZDUSD";
IndicatorSymbol[52] = "SGDJPY";
IndicatorSymbol[53] = "USDCAD";
IndicatorSymbol[54] = "USDCHF";
IndicatorSymbol[55] = "USDCNH";
IndicatorSymbol[56] = "USDCZK";
IndicatorSymbol[57] = "USDDKK";
IndicatorSymbol[58] = "USDHKD";
IndicatorSymbol[59] = "USDHUF";
IndicatorSymbol[60] = "USDILS";
IndicatorSymbol[61] = "USDJPY";
IndicatorSymbol[62] = "USDMXN";
IndicatorSymbol[63] = "USDNOK";
IndicatorSymbol[64] = "USDPLN";
IndicatorSymbol[65] = "USDRUB";
IndicatorSymbol[66] = "USDSEK";
IndicatorSymbol[67] = "USDSGD";
IndicatorSymbol[68] = "USDTRY";
IndicatorSymbol[69] = "USDZAR";

    string ButtonSymbolUniqueID[70];
    string ButtonSymbolString[70];
    string ButtonSymbolSymbolName[70];

    for (int i = 0; i < SymbolsTotal(true); i++)
    {
        for (int is = 0; is < ArraySize(IndicatorSymbol); is++)
        {
            if (IndicatorSymbol[is] == SymbolName(i, true))
            {

                if (i > 0 && MathMod(i, ButtonsInARow) == 0)
                {
                    // xpos = 0;
                    // ypos += YSize + 1;
                }
                // createButton(UniqueID + ":symbol:" + string(i), SymbolName(i, true), XShift +
                // xpos, YShift + ypos);
                // xpos += XSize + 1;

                for (int s = 0; s < ArraySize(IndicatorSymbol); s++)
                {
                    if (IndicatorSymbol[s] == SymbolName(i, true))
                    {
                        ButtonSymbolUniqueID[s] = UniqueID;
                        ButtonSymbolString[s] = string(i);
                        ButtonSymbolSymbolName[s] = SymbolName(i, true);
                    }
                }
            }
        }
    }

    for (int b = 0; b < ArraySize(IndicatorSymbol); b++)
    {
        if (b > 0 && MathMod(b, ButtonsInARow) == 0)
        {
            xpos = 0;
            ypos += YSize + 1;
        }
        createButton(ButtonSymbolUniqueID[b] + ":symbol:" + ButtonSymbolString[b],
            ButtonSymbolSymbolName[b], XShift + xpos, YShift + ypos);
        xpos += XSize + 1;
    }

    if (DisplayTimeFrame == 1)
    {
        xpos = 0;
        ypos += YSize + 3;
        for (int i = 0; i < ArraySize(sTfTable); i++)
        {
            if (i > 0 && MathMod(i, ButtonsInARow) == 0)
            {
                xpos = 0;
                ypos += YSize + 1;
            }
            createButton(
                UniqueID + ":time:" + string(i), sTfTable[i], XShift + xpos, YShift + ypos);
            xpos += XSize + 1;
        }
    }

    setSymbolButtonColor();
    setTimeFrameButtonColor();
    return (0);
}

void OnDeinit(const int reason)
{
    switch (reason)
    {
        case REASON_CHARTCHANGE:
        case REASON_RECOMPILE:
        case REASON_CLOSE:
            break;
        default:
        {
            string lookFor = UniqueID + ":";
            int lookForLength = StringLen(lookFor);
            for (int i = ObjectsTotal() - 1; i >= 0; i--)
            {
                string objectName = ObjectName(i);
                if (StringSubstr(objectName, 0, lookForLength) == lookFor)
                    ObjectDelete(objectName);
            }
        }
    }
}


void createButton(string name, string caption, int xpos, int ypos)
{
    int window = WindowFind(UniqueID);
    ObjectCreate(name, OBJ_BUTTON, window, 0, 0);
    ObjectSet(name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSet(name, OBJPROP_XDISTANCE, xpos);
    ObjectSet(name, OBJPROP_YDISTANCE, ypos);
    ObjectSet(name, OBJPROP_XSIZE, XSize);
    ObjectSet(name, OBJPROP_YSIZE, YSize);
    ObjectSetText(name, caption, FSize, "Arial", Tncolor);
    ObjectSet(name, OBJPROP_FONTSIZE, FSize);
    ObjectSet(name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
    ObjectSet(name, OBJPROP_COLOR, Tncolor);
    ObjectSet(name, OBJPROP_BGCOLOR, Bcolor);
    ObjectSet(name, OBJPROP_BACK, Transparent);
    ObjectSet(name, OBJPROP_BORDER_COLOR, Dcolor);
    ObjectSet(name, OBJPROP_STATE, false);
    ObjectSet(name, OBJPROP_HIDDEN, true);
}

void setSymbolButtonColor()
{
    string lookFor = UniqueID + ":symbol:";
    int lookForLength = StringLen(lookFor);
    for (int i = ObjectsTotal() - 1; i >= 0; i--)
    {
        string objectName = ObjectName(i);
        if (StringSubstr(objectName, 0, lookForLength) == lookFor)
        {
            string symbol = ObjectGetString(0, objectName, OBJPROP_TEXT);
            if (symbol != _Symbol)
                ObjectSet(objectName, OBJPROP_COLOR, Tncolor);
            else
                ObjectSet(objectName, OBJPROP_COLOR, Sncolor);
        }
    }
}

void setTimeFrameButtonColor()
{
    string lookFor = UniqueID + ":time:";
    int lookForLength = StringLen(lookFor);
    for (int i = ObjectsTotal() - 1; i >= 0; i--)
    {
        string objectName = ObjectName(i);
        if (StringSubstr(objectName, 0, lookForLength) == lookFor)
        {
            int time = stringToTimeFrame(ObjectGetString(0, objectName, OBJPROP_TEXT));
            if (time != _Period)
                ObjectSet(objectName, OBJPROP_COLOR, Tncolor);
            else
                ObjectSet(objectName, OBJPROP_COLOR, Sncolor);
        }
    }
}


string sTfTable[] = { "M1", "M5", "M15", "M30", "H1", "H4", "D1", "W1", "MN" };

int iTfTable[] = { 1, 5, 15, 30, 60, 240, 1440, 10080, 43200 };

string timeFrameToString(int tf)
{
    for (int i = ArraySize(iTfTable) - 1; i >= 0; i--)
        if (tf == iTfTable[i])
            return (sTfTable[i]);
    return ("");
}

int stringToTimeFrame(string tf)
{
    for (int i = ArraySize(sTfTable) - 1; i >= 0; i--)
        if (tf == sTfTable[i])
            return (iTfTable[i]);
    return (0);
}

void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
    if (id == CHARTEVENT_OBJECT_CLICK && ObjectGet(sparam, OBJPROP_TYPE) == OBJ_BUTTON)
    {
        if (StringFind(sparam, UniqueID + ":symbol:", 0) == 0)
            ChartSetSymbolPeriod(0, ObjectGetString(0, sparam, OBJPROP_TEXT), _Period);
        if (StringFind(sparam, UniqueID + ":time:", 0) == 0)
            ChartSetSymbolPeriod(
                0, _Symbol, stringToTimeFrame(ObjectGetString(0, sparam, OBJPROP_TEXT)));
        if (StringFind(sparam, UniqueID + ":back:", 0) == 0)
            ObjectSet(sparam, OBJPROP_STATE, false);
    }
}

int start()
{
    return (0);
}
