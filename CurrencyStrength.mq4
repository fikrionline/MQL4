#property copyright ""
#property link ""
#property version "1.01"

#property indicator_chart_window
#property indicator_buffers 8

enum CurrNames
{
    USD,
    EUR,
    GBP,
    CHF,
    CAD,
    AUD,
    JPY,
    NZD
};
enum IndAlerts
{
    Disabled,
    Enabled,
    IncludeReverse
};

input string CurrencyPairs
    = "GU,UF,EU,UJ,UC,NU,AU,AN,AC,AF,AJ,CJ,FJ,EG,EA,EF,EJ,EN,EC,GF,GA,GC,GJ,GN,NJ";
input CurrNames StrongCurrency = EUR;
input double StrengthLimit = 7;
input CurrNames WeakCurrency = USD;
input double WeaknessLimit = 2;
input IndAlerts SendEmail = 0;
input IndAlerts SendNotifications = 0;
input IndAlerts Alerts = 0;
input string AlertSound = "alert.wav";
input IndAlerts ScreenShots = 0;
input int AlertsIntervalMinutes = 5;
input ENUM_BASE_CORNER PanelCorner = CORNER_RIGHT_LOWER;
input int FontSize = 15;
input string FontType = "Courier New";
input int HorizPos = 105;
input int VertPos = 25;
input int VertSpacing = 25;
input int RefreshEveryXMins = 0;
input color Color1 = clrRed;
input double Level1 = 7.0;
input color Color2 = clrOrange;
input double Level2 = 5.0;
input color Color3 = clrYellow;
input double Level3 = 2.0;
input color Color4 = clrDodgerBlue;
input double Level4 = 0.0;

double spr, pnt, tickval, ccy_strength[8];
int dig, tifr, ccy_count[8], ccCP, RefreshEveryXMins0;
string IndiName, ccy, CP[40], CurrencyPairs0;
datetime prev_time;

int tf;
double SCurr, WCurr;
ENUM_TIMEFRAMES TF[] = { PERIOD_CURRENT, PERIOD_M1, PERIOD_M2, PERIOD_M3, PERIOD_M4, PERIOD_M5,
    PERIOD_M6, PERIOD_M10, PERIOD_M12, PERIOD_M15, PERIOD_M20, PERIOD_M30, PERIOD_H1, PERIOD_H2,
    PERIOD_H3, PERIOD_H4, PERIOD_H6, PERIOD_H8, PERIOD_H12, PERIOD_D1, PERIOD_W1, PERIOD_MN1 };
string TimeFr[] = { "0", "M1", "M2", "M3", "M4", "M5", "M6", "M10", "M12", "M15", "M20", "M30",
    "H1", "H2", "H3", "H4", "H6", "H8", "H12", "D1", "W1", "MN" };
string Currency[] = { "USD", "EUR", "GBP", "CHF", "CAD", "AUD", "JPY", "NZD" };
string Prefix, Suffix, TradeComment, Vs[100][100];

double USD[], EUR[], GBP[], CHF[], CAD[], AUD[], JPY[], NZD[];

void OnInit()
{
    int t1, t2, t3, t4;
    uchar Char[];
    double Td[50];
    string s7;

    IndicatorBuffers(8);

    SetIndexBuffer(0, USD);
    SetIndexBuffer(1, EUR);
    SetIndexBuffer(2, GBP);
    SetIndexBuffer(3, CHF);
    SetIndexBuffer(4, CAD);
    SetIndexBuffer(5, AUD);
    SetIndexBuffer(6, JPY);
    SetIndexBuffer(7, NZD);

    t1 = 0;
    while (t1 <= 7)
    {
        SetIndexEmptyValue(t1, 0);
        SetIndexStyle(t1, DRAW_NONE);
        t1++;
    }

    tf = 0;
    t1 = 1;
    while (t1 <= 21 && tf == 0)
    {
        tf = (PeriodSeconds(PERIOD_CURRENT) == PeriodSeconds(TF[t1])) * t1;
        t1++;
    }

    TradeComment = "CurrencyStrength";
    t2 = StringToCharArray(Symbol(), Char, 0, -1, CP_UTF8) - 2;
    t3 = -1;
    t4 = -1;
    t1 = 0;
    while (t1 <= t2)
    {
        if (t3 == -1 && Char[t1] >= 65 && Char[t1] <= 90)
        {
            t3 = t1;
        }
        if (t3 != -1 && t4 == -1 && (Char[t1] < 65 || Char[t1] > 90))
        {
            t4 = t1;
        }
        t1++;
    }
    Prefix = "";
    if (t3 > 0)
    {
        Prefix = StringSubstr(Symbol(), 0, t3);
    }
    Suffix = "";
    if (t4 > 0)
    {
        Suffix = StringSubstr(Symbol(), t4, 0);
    }
    t1 = StringLen(Symbol()) - StringLen(Prefix) - StringLen(Suffix);
    Vs[30][1] = StringSubstr(Symbol(), StringLen(Prefix), t1);
    s7 = StringConcatenate(" ", Vs[30][1], " ", TimeFr[tf]);
    Vs[30][4] = StringConcatenate(StringSubstr(TradeComment, 0, 27 - StringLen(s7)), s7);

    RefreshEveryXMins0 = RefreshEveryXMins;
    if (RefreshEveryXMins0 > 240)
        RefreshEveryXMins0 = 240;
    if (RefreshEveryXMins0 > 60 && RefreshEveryXMins0 < 240)
        RefreshEveryXMins0 = 60;
    if (RefreshEveryXMins0 > 30 && RefreshEveryXMins0 < 60)
        RefreshEveryXMins0 = 30;
    if (RefreshEveryXMins0 > 15 && RefreshEveryXMins0 < 30)
        RefreshEveryXMins0 = 15;
    if (RefreshEveryXMins0 > 5 && RefreshEveryXMins0 < 15)
        RefreshEveryXMins0 = 5;
    if (RefreshEveryXMins0 > 1 && RefreshEveryXMins0 < 5)
        RefreshEveryXMins0 = 1;

    CurrencyPairs0 = StringUpper(CurrencyPairs);
    if (CurrencyPairs0 == "")
    {
        CurrencyPairs0 = Symbol();
    }
    if (StringSubstr(CurrencyPairs0, StringLen(CurrencyPairs0) - 1, 1) != ",")
        CurrencyPairs0 = CurrencyPairs0 + ",";
    ccCP = StringFindCount(CurrencyPairs0, ",");
    for (int i = 0; i < 40; i++)
        CP[i] = "";
    int comma1 = -1;
    for (i = 0; i < 40; i++)
    {
        int comma2 = StringFind(CurrencyPairs0, ",", comma1 + 1);
        string temp = StringSubstr(CurrencyPairs0, comma1 + 1, comma2 - comma1 - 1);
        CP[i] = ExpandCcy(temp);
        if (comma2 >= StringLen(CurrencyPairs0) - 1)
            break;
        comma1 = comma2;
    }

    int checksum = 0;
    string str = "0";
    for (i = 0; i < StringLen(str); i++)
        checksum += i * StringGetChar(str, i);
    IndiName = "CurrencyStrength-" + checksum;
    IndicatorShortName(IndiName);

    ccy = Symbol();
    tifr = Period();
    pnt = MarketInfo(ccy, MODE_POINT);
    dig = MarketInfo(ccy, MODE_DIGITS);
    spr = MarketInfo(ccy, MODE_SPREAD);
    tickval = MarketInfo(ccy, MODE_TICKVALUE);
    if (dig == 3 || dig == 5)
    {
        pnt *= 10;
        spr /= 10;
        tickval *= 10;
    }

    RemoveObjects(IndiName);
    plot_obj();
    prev_time = -9999;
}

void OnDeinit(const int reason)
{
    if (!IsTesting())
    {
        RemoveObjects(IndiName);
    }
}

//+------------------------------------------------------------------+
int start()
{
    //+------------------------------------------------------------------+
    if (RefreshEveryXMins0 == 0)
    {
        RemoveObjects(IndiName);
        plot_obj();
    }
    else
    {
        if (prev_time != iTime(ccy, RefreshEveryXMins0, 0))
        {
            RemoveObjects(IndiName);
            plot_obj();
            prev_time = iTime(ccy, RefreshEveryXMins0, 0);
        }
    }
    return (0);
}

//+------------------------------------------------------------------+
void plot_obj()
//+------------------------------------------------------------------+
{
    int t1, t2, xp, yp;
    color FontColor;
    double Td[8][8];
    string s1, s2;

    ArrayInitialize(ccy_strength, 0.0);
    ArrayInitialize(ccy_count, 0);

    for (int i = 0; i < 40; i++)
    {
        double day_high = MarketInfo(CP[i], MODE_HIGH);
        double day_low = MarketInfo(CP[i], MODE_LOW);
        double curr_bid = MarketInfo(CP[i], MODE_BID);
        double bid_ratio = DivZero(curr_bid - day_low, day_high - day_low);

        double ind_strength = 0;
        if (bid_ratio >= 0.97)
            ind_strength = 9;
        else if (bid_ratio >= 0.90)
            ind_strength = 8;
        else if (bid_ratio >= 0.75)
            ind_strength = 7;
        else if (bid_ratio >= 0.60)
            ind_strength = 6;
        else if (bid_ratio >= 0.50)
            ind_strength = 5;
        else if (bid_ratio >= 0.40)
            ind_strength = 4;
        else if (bid_ratio >= 0.25)
            ind_strength = 3;
        else if (bid_ratio >= 0.10)
            ind_strength = 2;
        else if (bid_ratio >= 0.03)
            ind_strength = 1;

        string temp = StringSubstr(CP[i], 0, 3);
        for (int j = 0; j <= 7; j++)
        {
            if (Currency[j] == temp)
            {
                ccy_strength[j] += ind_strength;
                ccy_count[j] += 1;
                break;
            }
        }

        temp = StringSubstr(CP[i], 3, 3);
        for (j = 0; j <= 7; j++)
        {
            if (Currency[j] == temp)
            {
                ccy_strength[j] += 9 - ind_strength;
                ccy_count[j] += 1;
                break;
            }
        }
    }

    t1 = 0;
    while (t1 <= 7)
    {
        Td[t1][0] = DivZero(ccy_strength[t1], ccy_count[t1]);
        Td[t1][1] = t1;
        t1++;
    }
    USD[0] = Td[0][0];
    EUR[0] = Td[1][0];
    GBP[0] = Td[2][0];
    CHF[0] = Td[3][0];
    CAD[0] = Td[4][0];
    AUD[0] = Td[5][0];
    JPY[0] = Td[6][0];
    NZD[0] = Td[7][0];
    SCurr = Td[StrongCurrency][0];
    WCurr = Td[WeakCurrency][0];
    ArraySort(Td, 8, 0, MODE_DESCEND);
    xp = HorizPos;
    yp = VertPos;
    t1 = 0;
    while (t1 <= 7)
    {
        t2 = Td[t1][1];
        s1 = StringConcatenate(Currency[t2], "  ", StrDig(Td[t1][0]));
        s2 = StringConcatenate(IndiName, "-", t1);

        FontColor = clrWhite;
        if (Td[t1][0] > Level1)
            FontColor = Color1;
        else if (Td[t1][0] > Level2)
            FontColor = Color2;
        else if (Td[t1][0] > Level3)
            FontColor = Color3;
        else if (Td[t1][0] >= Level4)
            FontColor = Color4;

        if (FontSize > 0)
        {
            DrawLabel(s2, s1, PanelCorner, xp, yp, FontSize, FontType, FontColor, false);
        }
        yp += VertSpacing;
        t1++;
    }
    IndAlert();
}

void RemoveObjects(string r6)
{
    int t1;

    t1 = ObjectsTotal();
    while (t1 >= 0)
    {
        if (StringFind(ObjectName(t1), r6, 0) != -1)
        {
            ObjectDelete(0, ObjectName(t1));
        }
        t1--;
    }
}

string StrDig(double f1)
{
    double d1;
    string s7;

    d1 = NormalizeDouble(f1, 1);
    s7 = DoubleToString(d1, 1);
    return (s7);
}

void DrawLabel(
    string r6, string r7, ENUM_BASE_CORNER x4, int x1, int x2, int x5, string r8, color x3, bool b6)
{
    if (r7 == "" && ObjectFind(0, r6) != -1)
    {
        ObjectDelete(0, r6);
    }
    if (r7 != "")
    {
        if (ObjectFind(0, r6) == -1)
        {
            ObjectCreate(0, r6, OBJ_LABEL, 0, 0, 0);
        }
        ObjectSetInteger(0, r6, OBJPROP_CORNER, x4);
        ObjectSetString(0, r6, OBJPROP_TEXT, r7);
        ObjectSetInteger(0, r6, OBJPROP_FONTSIZE, x5);
        ObjectSetString(0, r6, OBJPROP_FONT, r8);
        ObjectSetInteger(0, r6, OBJPROP_COLOR, x3);
        ObjectSetInteger(0, r6, OBJPROP_BACK, b6);
        ObjectSetInteger(0, r6, OBJPROP_XDISTANCE, x1);
        ObjectSetInteger(0, r6, OBJPROP_YDISTANCE, x2);
    }
}

void IndAlert()
{
    int t3;
    bool b1, b2, b3;
    string Ts[10], s1;
    static datetime h1;

    if (h1 <= TimeCurrent())
    {
        b1 = (SCurr > StrengthLimit && WCurr < WeaknessLimit);
        b2 = (SCurr < WeaknessLimit && WCurr > StrengthLimit);
        t3 = b1 + b2 * 2;
        Ts[1] = Currency[StrongCurrency];
        Ts[3] = StrDig(SCurr);
        Ts[2] = Currency[WeakCurrency];
        Ts[4] = StrDig(WCurr);
        if (t3 > 0)
        {
            s1 = StringConcatenate(Ts[t3], " strength is ", Ts[t3 + 2], " and ", Ts[3 - t3],
                " weakness is ", Ts[5 - t3]);
            if (SendEmail == t3 || SendEmail == IncludeReverse)
            {
                SendMail(Vs[30][4], s1);
                b3 = true;
            }
            if (SendNotifications == t3 || SendNotifications == IncludeReverse)
            {
                SendNotification(StringConcatenate(s1, ", ", Vs[30][4]));
                b3 = true;
            }
            if (ScreenShots == t3 || ScreenShots == IncludeReverse)
            {
                ChartScreenShot(0, StringConcatenate(Ts[t3], Ts[3 - t3], TimeCurrent(), ".png"),
                    1920, 1080, ALIGN_RIGHT);
                b3 = true;
            }
            if (Alerts == t3 || Alerts == IncludeReverse)
            {
                Alert(StringConcatenate(s1, ", ", Vs[30][4]));
                if (AlertSound != "")
                {
                    PlaySound(AlertSound);
                }
                b3 = true;
            }
        }
        if (b3)
        {
            h1 = TimeCurrent() + AlertsIntervalMinutes * PeriodSeconds(PERIOD_M1);
        }
    }
}

//+------------------------------------------------------------------+
string StringUpper(string str)
//+------------------------------------------------------------------+
// Converts any lowercase characters in a string to uppercase
// Usage:    string x=StringUpper("The Quick Brown Fox")  returns x = "THE QUICK BROWN FOX"
{
    string outstr = "";
    string lower = "abcdefghijklmnopqrstuvwxyz";
    string upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (int i = 0; i < StringLen(str); i++)
    {
        int t1 = StringFind(lower, StringSubstr(str, i, 1), 0);
        if (t1 >= 0)
            outstr = outstr + StringSubstr(upper, t1, 1);
        else
            outstr = outstr + StringSubstr(str, i, 1);
    }
    return (outstr);
}

//+------------------------------------------------------------------+
string StringLower(string str)
//+------------------------------------------------------------------+
// Converts any uppercase characters in a string to lowercase
// Usage:    string x=StringUpper("The Quick Brown Fox")  returns x = "the quick brown fox"
{
    string outstr = "";
    string lower = "abcdefghijklmnopqrstuvwxyz";
    string upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (int i = 0; i < StringLen(str); i++)
    {
        int t1 = StringFind(upper, StringSubstr(str, i, 1), 0);
        if (t1 >= 0)
            outstr = outstr + StringSubstr(lower, t1, 1);
        else
            outstr = outstr + StringSubstr(str, i, 1);
    }
    return (outstr);
}

//+------------------------------------------------------------------+
string StringTrim(string str)
//+------------------------------------------------------------------+
// Removes all spaces (leading, traing embedded) from a string
// Usage:    string x=StringUpper("The Quick Brown Fox")  returns x = "TheQuickBrownFox"
{
    string outstr = "";
    for (int i = 0; i < StringLen(str); i++)
    {
        if (StringSubstr(str, i, 1) != " ")
            outstr = outstr + StringSubstr(str, i, 1);
    }
    return (outstr);
}

//+------------------------------------------------------------------+
double MathFix(double n, int d)
//+------------------------------------------------------------------+
// Returns N rounded to D decimals - works around a precision bug in MQL4
{
    return (MathRound(n * MathPow(10, d) + 0.000000000001 * MathSign(n)) / MathPow(10, d));
}

//+------------------------------------------------------------------+
double DivZero(double n, double d)
//+------------------------------------------------------------------+
// Divides N by D, and returns 0 if the denominator (D) = 0
// Usage:   double x = DivZero(y,z)  sets x = y/z
{
    if (d == 0)
        return (0);
    else
        return (n / d);
}

//+------------------------------------------------------------------+
int MathSign(double n)
//+------------------------------------------------------------------+
// Returns the sign of a number (i.e. -1, 0, +1)
// Usage:   int x=MathSign(-25)   returns x=-1
{
    if (n > 0)
        return (1);
    else if (n < 0)
        return (-1);
    else
        return (0);
}

//+------------------------------------------------------------------+
int StringFindCount(string str, string str2)
//+------------------------------------------------------------------+
// Returns the number of occurrences of STR2 in STR
// Usage:   int x = StringFindCount("ABCDEFGHIJKABACABB","AB")   returns x = 3
{
    int c = 0;
    for (int i = 0; i < StringLen(str); i++)
        if (StringSubstr(str, i, StringLen(str2)) == str2)
            c++;
    return (c);
}

//+------------------------------------------------------------------+
string ExpandCcy(string str)
//+------------------------------------------------------------------+
{
    str = StringTrim(StringUpper(str));
    if (StringLen(str) < 1 || StringLen(str) > 2)
        return (str);
    string str2 = "";
    for (int i = 0; i < StringLen(str); i++)
    {
        string s1 = StringSubstr(str, i, 1);
        if (s1 == "A")
            str2 = str2 + "AUD";
        else if (s1 == "C")
            str2 = str2 + "CAD";
        else if (s1 == "E")
            str2 = str2 + "EUR";
        else if (s1 == "F")
            str2 = str2 + "CHF";
        else if (s1 == "G")
            str2 = str2 + "GBP";
        else if (s1 == "J")
            str2 = str2 + "JPY";
        else if (s1 == "N")
            str2 = str2 + "NZD";
        else if (s1 == "U")
            str2 = str2 + "USD";
        else if (s1 == "H")
            str2 = str2 + "HKD";
        else if (s1 == "S")
            str2 = str2 + "SGD";
        else if (s1 == "Z")
            str2 = str2 + "ZAR";
    }
    return (str2);
}
