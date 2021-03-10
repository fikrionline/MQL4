//+------------------------------------------------------------------+
//|                                               SNRD.mq4 by Habeeb |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property indicator_chart_window

enum TheBaseSNR {
TheBaseSNRA = 1, //1.003
TheBaseSNRB = 2, //1.00351748471
TheBaseSNRC = 3, //1.007
TheBaseSNRD = 4 //1.00701748471
};
input TheBaseSNR BaseSNR = 2;

enum TheBaseDeviasi {
TheBaseDeviasiA = 1, //1.0017
TheBaseDeviasiB = 2 //1.00175623
};
input TheBaseDeviasi BaseDeviasi = 2;

enum TheBaseHHLL {
Today = 0, //Today
Yesterday = 1 //Yesterday
};
input TheBaseHHLL BaseHHLL = 0;

extern color Daily_Pivot = Red;
extern color Daily_S_Levels = Orange;
extern color Daily_R_Levels = Yellow;

double YesterdayOpen;
double YesterdayHigh;
double YesterdayLow;
double YesterdayClose;
double Day_Price[][6];
double Pivot, S1, S2, S3, R1, R2, R3, RDeviasi, SDeviasi, ResultBaseSNR, ResultBaseDeviasi;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init() {
    return (0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit() {
    ObjectDelete("PivotLine");

    ObjectDelete("R1_Line");
    ObjectDelete("R2_Line");
    ObjectDelete("R3_Line");

    ObjectDelete("RDeviasi_Line");

    ObjectDelete("S1_Line");
    ObjectDelete("S2_Line");
    ObjectDelete("S3_Line");

    ObjectDelete("SDeviasi_Line");

    //--------------------------------

    ObjectDelete("PivotLabel");

    ObjectDelete("R1_Label");
    ObjectDelete("R2_Label");
    ObjectDelete("R3_Label");

    ObjectDelete("RDeviasi_Label");

    ObjectDelete("S1_Label");
    ObjectDelete("S2_Label");
    ObjectDelete("S3_Label");

    ObjectDelete("SDeviasi_Label");

    return (0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start() {
    ArrayCopyRates(Day_Price, (Symbol()), 1440);

    if (BaseHHLL == 1) {
        YesterdayOpen = Day_Price[1][1];
        YesterdayHigh = Day_Price[1][3];
        YesterdayLow = Day_Price[1][2];
        YesterdayClose = Day_Price[1][4];
    } else
    if (BaseHHLL == 0) {
        YesterdayOpen = Day_Price[0][1];
        YesterdayHigh = Day_Price[0][3];
        YesterdayLow = Day_Price[0][2];
        YesterdayClose = Day_Price[0][4];
    }

    if (BaseSNR == 1) {
        ResultBaseSNR = 1.003;
    } else
    if (BaseSNR == 2) {
        ResultBaseSNR = 1.00351748471;
    } else
    if (BaseSNR == 3) {
        ResultBaseSNR = 1.007;
    } else
    if (BaseSNR == 4) {
        ResultBaseSNR = 1.00701748471;
    }

    R1 = YesterdayLow * ResultBaseSNR;
    S1 = YesterdayHigh / ResultBaseSNR;

    R2 = R1 * ResultBaseSNR;
    S2 = S1 / ResultBaseSNR;

    R3 = R2 * ResultBaseSNR;
    S3 = S2 / ResultBaseSNR;

    if (BaseDeviasi == 1) {
        ResultBaseDeviasi = 1.0017;
    } else
    if (BaseDeviasi == 2) {
        ResultBaseDeviasi = 1.00175623;
    }

    RDeviasi = R3 * ResultBaseDeviasi;
    SDeviasi = S3 / ResultBaseDeviasi;

    //Pivot = R1 + ((S1 - R1) / 2);

    //--------------------------------------------------------

    TimeToStr(CurTime());

    if (ObjectFind("PivotLine") != 0) {
        ObjectCreate("PivotLine", OBJ_HLINE, 0, CurTime(), Pivot);
        ObjectSet("PivotLine", OBJPROP_COLOR, Daily_Pivot);
        ObjectSet("PivotLine", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("PivotLine", 0, Time[20], Pivot);
    }

    if (ObjectFind("PivotLabel") != 0) {
        ObjectCreate("PivotLabel", OBJ_TEXT, 0, Time[20], Pivot);
        ObjectSetText("PivotLabel", ("Daily Pivot"), 8, "Arial", Daily_Pivot);
    } else {
        ObjectMove("PivotLabel", 0, Time[20], Pivot);
    }
    ObjectsRedraw();

    //--------------------------------------------------------
    if (ObjectFind("R1_Line") != 0) {
        ObjectCreate("R1_Line", OBJ_HLINE, 0, CurTime(), R1);
        ObjectSet("R1_Line", OBJPROP_COLOR, Daily_R_Levels);
        ObjectSet("R1_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R1_Line", 0, Time[20], R1);
    }

    if (ObjectFind("R1_Label") != 0) {
        ObjectCreate("R1_Label", OBJ_TEXT, 0, Time[20], R1);
        ObjectSetText("R1_Label", "Daily R1", 8, "Arial", Daily_R_Levels);
    } else {
        ObjectMove("R1_Label", 0, Time[20], R1);
    }

    //--------------------------------------------------------

    if (ObjectFind("R2_Line") != 0) {
        ObjectCreate("R2_Line", OBJ_HLINE, 0, CurTime(), R2);
        ObjectSet("R2_Line", OBJPROP_COLOR, Daily_R_Levels);
        ObjectSet("R2_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R2_Line", 0, Time[20], R2);
    }

    if (ObjectFind("R2_Label") != 0) {
        ObjectCreate("R2_Label", OBJ_TEXT, 0, Time[20], R2);
        ObjectSetText("R2_Label", "Daily R2", 8, "Arial", Daily_R_Levels);
    } else {
        ObjectMove("R2_Label", 0, Time[20], R2);
    }

    //---------------------------------------------------------

    if (ObjectFind("R3_Line") != 0) {
        ObjectCreate("R3_Line", OBJ_HLINE, 0, CurTime(), R3);
        ObjectSet("R3_Line", OBJPROP_COLOR, Daily_R_Levels);
        ObjectSet("R3_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R3_Line", 0, Time[20], R3);
    }

    if (ObjectFind("R3_Label") != 0) {
        ObjectCreate("R3_Label", OBJ_TEXT, 0, Time[20], R3);
        ObjectSetText("R3_Label", "Daily R3", 8, "Arial", Daily_R_Levels);
    } else {
        ObjectMove("R3_Label", 0, Time[20], R3);
    }

    //---------------------------------------------------------

    if (ObjectFind("S1_Line") != 0) {
        ObjectCreate("S1_Line", OBJ_HLINE, 0, CurTime(), S1);
        ObjectSet("S1_Line", OBJPROP_COLOR, Daily_S_Levels);
        ObjectSet("S1_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S1_Line", 0, Time[20], S1);
    }

    if (ObjectFind("S1_Label") != 0) {
        ObjectCreate("S1_Label", OBJ_TEXT, 0, Time[20], S1);
        ObjectSetText("S1_Label", "Daily S1", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("S1_Label", 0, Time[20], S1);
    }

    //---------------------------------------------------------

    if (ObjectFind("S2_Line") != 0) {
        ObjectCreate("S2_Line", OBJ_HLINE, 0, CurTime(), S2);
        ObjectSet("S2_Line", OBJPROP_COLOR, Daily_S_Levels);
        ObjectSet("S2_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S2_Line", 0, Time[20], S2);
    }

    if (ObjectFind("S2_Label") != 0) {
        ObjectCreate("S2_Label", OBJ_TEXT, 0, Time[20], S2);
        ObjectSetText("S2_Label", "Daily S2", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("S2_Label", 0, Time[20], S2);
    }

    //---------------------------------------------------------

    if (ObjectFind("S3_Line") != 0) {
        ObjectCreate("S3_Line", OBJ_HLINE, 0, CurTime(), S3);
        ObjectSet("S3_Line", OBJPROP_COLOR, Daily_S_Levels);
        ObjectSet("S3_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S3_Line", 0, Time[20], S3);
    }

    if (ObjectFind("S3_Label") != 0) {
        ObjectCreate("S3_Label", OBJ_TEXT, 0, Time[20], S3);
        ObjectSetText("S3_Label", "Daily S3", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("S3_Label", 0, Time[20], S3);
    }

    //---------------------------------------------------------

    if (ObjectFind("RDeviasi_Line") != 0) {
        ObjectCreate("RDeviasi_Line", OBJ_HLINE, 0, CurTime(), RDeviasi);
        ObjectSet("RDeviasi_Line", OBJPROP_COLOR, Daily_R_Levels);
        ObjectSet("RDeviasi_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("RDeviasi_Line", 0, Time[20], RDeviasi);
    }

    if (ObjectFind("RDeviasi_Label") != 0) {
        ObjectCreate("RDeviasi_Label", OBJ_TEXT, 0, Time[20], RDeviasi);
        ObjectSetText("RDeviasi_Label", "Daily RDeviasi", 8, "Arial", Daily_R_Levels);
    } else {
        ObjectMove("RDeviasi_Label", 0, Time[20], RDeviasi);
    }

    //---------------------------------------------------------

    if (ObjectFind("SDeviasi_Line") != 0) {
        ObjectCreate("SDeviasi_Line", OBJ_HLINE, 0, CurTime(), SDeviasi);
        ObjectSet("SDeviasi_Line", OBJPROP_COLOR, Daily_S_Levels);
        ObjectSet("SDeviasi_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("SDeviasi_Line", 0, Time[20], SDeviasi);
    }

    if (ObjectFind("SDeviasi_Label") != 0) {
        ObjectCreate("SDeviasi_Label", OBJ_TEXT, 0, Time[20], SDeviasi);
        ObjectSetText("SDeviasi_Label", "Daily SDeviasi", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("SDeviasi_Label", 0, Time[20], SDeviasi);
    }

    ObjectsRedraw();

    return (0);
}