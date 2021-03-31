//|                                           RumusFractals_v1.0.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property indicator_chart_window

extern int BaseHHLL = 0;

enum TheBaseSNR {
TheBaseSNRA = 1, //1.00175623
TheBaseSNRB = 2, //1.00351748471
TheBaseSNRC = 3, //1.00551748471
TheBaseSNRD = 4, //1.00701748471
};
input TheBaseSNR BaseSNR = 3;

enum TheBaseDeviasi {
TheBaseDeviasiA = 1, //1.00175623
TheBaseDeviasiB = 2, //1.00351748471
TheBaseDeviasiC = 3, //1.00551748471
TheBaseDeviasiD = 4, //1.00701748471
};
input TheBaseDeviasi BaseDeviasi = 1;

extern color Basic_Pivot = Blue;
extern color Basic_S_Levels = Orange;
extern color Basic_S_LevelsDeviasi = DarkOrange;
extern color Basic_R_Levels = Green;
extern color Basic_R_LevelsDeviasi = DarkGreen;

double BasicOpen;
double BasicHigh;
double BasicLow;
double BasicClose;
double BasicPrice[][6];
double Pivot, S1, S2, S3, R1, R2, R3, R1A, R1B, R1C, R2A, R2B, R2C, R3A, R3B, R3C, S1A, S1B, S1C, S2A, S2B, S2C, S3A, S3B, S3C, RDeviasi, SDeviasi, ResultBaseSNR, ResultBaseDeviasi;
string comments = "";

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
    
    ObjectDelete("Pivot_Line");

    ObjectDelete("R1_Line");
    ObjectDelete("R2_Line");
    ObjectDelete("R3_Line");

    ObjectDelete("RDeviasi_Line");

    ObjectDelete("S1_Line");
    ObjectDelete("S2_Line");
    ObjectDelete("S3_Line");

    ObjectDelete("SDeviasi_Line");

    //--------------------------------

    ObjectDelete("Pivot_Label");

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

    ArrayCopyRates(BasicPrice, (Symbol()), 1440);
    
    if (BaseSNR == 1)
    {
        ResultBaseSNR = 1.00175623;
    } else
    if (BaseSNR == 2)
    {
        ResultBaseSNR = 1.00351748471;
    } else
    if (BaseSNR == 3)
    {
        ResultBaseSNR = 1.00551748471;
    } else
    if (BaseSNR == 4)
    {
        ResultBaseSNR = 1.00701748471;
    }
    
    if (BaseDeviasi == 1)
    {
        ResultBaseDeviasi = 1.00175623;
    } else
    if (BaseDeviasi == 2)
    {
        ResultBaseDeviasi = 1.00351748471;
    } else
    if (BaseDeviasi == 3)
    {
        ResultBaseDeviasi = 1.00551748471;
    } else
    if (BaseDeviasi == 4)
    {
        ResultBaseDeviasi = 1.00701748471;
    }
    
    //------------TODAY-----------------
    BasicOpen = BasicPrice[BaseHHLL][1]; //Alert(BasicOpen);
    BasicHigh = BasicPrice[BaseHHLL][3];
    BasicLow = BasicPrice[BaseHHLL][2];
    BasicClose = BasicPrice[BaseHHLL][4];

    R1A = BasicLow * ResultBaseSNR;
    S1A = BasicHigh / ResultBaseSNR;
    
    R2A = R1A * ResultBaseSNR;
    S2A = S1A / ResultBaseSNR;
    
    R3A = R2A * ResultBaseSNR;
    S3A = S2A / ResultBaseSNR;
    //--------END-TODAY-----------------
    
    //--------YESTERDAY-----------------
    BasicOpen = BasicPrice[BaseHHLL + 1][1]; //Alert(BasicOpen);
    BasicHigh = BasicPrice[BaseHHLL + 1][3];
    BasicLow = BasicPrice[BaseHHLL + 1][2];
    BasicClose = BasicPrice[BaseHHLL + 1][4];

    R1B = BasicLow * ResultBaseSNR;
    S1B = BasicHigh / ResultBaseSNR;
    
    R2B = R1B * ResultBaseSNR;
    S2B = S1B / ResultBaseSNR;
    
    R3B = R2B * ResultBaseSNR;
    S3B = S2B / ResultBaseSNR;
    //------END-YESTERDAY---------------
    
    //--------FRACTALS-----------------
    for (int i=1; i<=100; i++)
    {
        if (iFractals(Symbol(), PERIOD_CURRENT, MODE_UPPER, i) > 0)
        {
            BasicHigh = iHigh(Symbol(), PERIOD_CURRENT, i);
            break;
        }        
    } //Alert(i);
    
    for (int j=1; j<=100; j++)
    {
        if (iFractals(Symbol(), PERIOD_CURRENT, MODE_LOWER, j) > 0)
        {
            BasicLow = iLow(Symbol(), PERIOD_CURRENT, j);
            break;
        }        
    } //Alert(j);

    R1C = BasicLow * ResultBaseSNR; //Alert(BasicLow);
    S1C = BasicHigh / ResultBaseSNR; //Alert(BasicHigh);
    
    R2C = R1C * ResultBaseSNR;
    S2C = S1C / ResultBaseSNR;
    
    R3C = R2C * ResultBaseSNR;
    S3C = S2C / ResultBaseSNR;
    //------END-FRACTALS---------------
    
    R1 = (R1A + R1B + R1C) / 3;
    S1 = (S1A + S1B + S1C) / 3;

    RDeviasi = R1 * ResultBaseDeviasi;
    SDeviasi = S1 / ResultBaseDeviasi;

    Pivot = R1 + ((S1 - R1) / 2);    

    //RDeviasi = R1 * ResultBaseDeviasi;
    //SDeviasi = S1 / ResultBaseDeviasi;

    //Pivot = R1 + ((S1 - R1) / 2);
    
    comments = "Base Resitance " + BasicLow + " / " + "Base Support " + BasicHigh;
    
    Comment(comments);

    //--------------------------------------------------------

    TimeToStr(CurTime());

    if (ObjectFind("Pivot_Line") != 0) {
        ObjectCreate("Pivot_Line", OBJ_HLINE, 0, CurTime(), Pivot);
        ObjectSet("Pivot_Line", OBJPROP_COLOR, Basic_Pivot);
        ObjectSet("Pivot_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("Pivot_Line", 0, Time[20], Pivot);
    }

    if (ObjectFind("Pivot_Label") != 0) {
        ObjectCreate("Pivot_Label", OBJ_TEXT, 0, Time[20], Pivot);
        ObjectSetText("Pivot_Label", ("Pivot"), 8, "Arial", Basic_Pivot);
    } else {
        ObjectMove("Pivot_Label", 0, Time[20], Pivot);
    }
    ObjectsRedraw();

    //--------------------------------------------------------
    if (ObjectFind("R1_Line") != 0) {
        ObjectCreate("R1_Line", OBJ_HLINE, 0, CurTime(), R1);
        ObjectSet("R1_Line", OBJPROP_COLOR, Basic_R_Levels);
        ObjectSet("R1_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R1_Line", 0, Time[20], R1);
    }

    if (ObjectFind("R1_Label") != 0) {
        ObjectCreate("R1_Label", OBJ_TEXT, 0, Time[20], R1);
        ObjectSetText("R1_Label", "R1", 8, "Arial", Basic_R_Levels);
    } else {
        ObjectMove("R1_Label", 0, Time[20], R1);
    }

    //--------------------------------------------------------

    if (ObjectFind("R2_Line") != 0) {
        ObjectCreate("R2_Line", OBJ_HLINE, 0, CurTime(), R2);
        ObjectSet("R2_Line", OBJPROP_COLOR, Basic_R_Levels);
        ObjectSet("R2_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R2_Line", 0, Time[20], R2);
    }

    if (ObjectFind("R2_Label") != 0) {
        ObjectCreate("R2_Label", OBJ_TEXT, 0, Time[20], R2);
        ObjectSetText("R2_Label", "R2", 8, "Arial", Basic_R_Levels);
    } else {
        ObjectMove("R2_Label", 0, Time[20], R2);
    }

    //---------------------------------------------------------

    if (ObjectFind("R3_Line") != 0) {
        ObjectCreate("R3_Line", OBJ_HLINE, 0, CurTime(), R3);
        ObjectSet("R3_Line", OBJPROP_COLOR, Basic_R_Levels);
        ObjectSet("R3_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R3_Line", 0, Time[20], R3);
    }

    if (ObjectFind("R3_Label") != 0) {
        ObjectCreate("R3_Label", OBJ_TEXT, 0, Time[20], R3);
        ObjectSetText("R3_Label", "R3", 8, "Arial", Basic_R_Levels);
    } else {
        ObjectMove("R3_Label", 0, Time[20], R3);
    }

    //---------------------------------------------------------

    if (ObjectFind("S1_Line") != 0) {
        ObjectCreate("S1_Line", OBJ_HLINE, 0, CurTime(), S1);
        ObjectSet("S1_Line", OBJPROP_COLOR, Basic_S_Levels);
        ObjectSet("S1_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S1_Line", 0, Time[20], S1);
    }

    if (ObjectFind("S1_Label") != 0) {
        ObjectCreate("S1_Label", OBJ_TEXT, 0, Time[20], S1);
        ObjectSetText("S1_Label", "S1", 8, "Arial", Basic_S_Levels);
    } else {
        ObjectMove("S1_Label", 0, Time[20], S1);
    }

    //---------------------------------------------------------

    if (ObjectFind("S2_Line") != 0) {
        ObjectCreate("S2_Line", OBJ_HLINE, 0, CurTime(), S2);
        ObjectSet("S2_Line", OBJPROP_COLOR, Basic_S_Levels);
        ObjectSet("S2_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S2_Line", 0, Time[20], S2);
    }

    if (ObjectFind("S2_Label") != 0) {
        ObjectCreate("S2_Label", OBJ_TEXT, 0, Time[20], S2);
        ObjectSetText("S2_Label", "S2", 8, "Arial", Basic_S_Levels);
    } else {
        ObjectMove("S2_Label", 0, Time[20], S2);
    }

    //---------------------------------------------------------

    if (ObjectFind("S3_Line") != 0) {
        ObjectCreate("S3_Line", OBJ_HLINE, 0, CurTime(), S3);
        ObjectSet("S3_Line", OBJPROP_COLOR, Basic_S_Levels);
        ObjectSet("S3_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S3_Line", 0, Time[20], S3);
    }

    if (ObjectFind("S3_Label") != 0) {
        ObjectCreate("S3_Label", OBJ_TEXT, 0, Time[20], S3);
        ObjectSetText("S3_Label", "S3", 8, "Arial", Basic_S_Levels);
    } else {
        ObjectMove("S3_Label", 0, Time[20], S3);
    }

    //---------------------------------------------------------

    if (ObjectFind("RDeviasi_Line") != 0) {
        ObjectCreate("RDeviasi_Line", OBJ_HLINE, 0, CurTime(), RDeviasi);
        ObjectSet("RDeviasi_Line", OBJPROP_COLOR, Basic_R_LevelsDeviasi);
        ObjectSet("RDeviasi_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("RDeviasi_Line", 0, Time[20], RDeviasi);
    }

    if (ObjectFind("RDeviasi_Label") != 0) {
        ObjectCreate("RDeviasi_Label", OBJ_TEXT, 0, Time[20], RDeviasi);
        ObjectSetText("RDeviasi_Label", "RDeviasi", 8, "Arial", Basic_R_LevelsDeviasi);
    } else {
        ObjectMove("RDeviasi_Label", 0, Time[20], RDeviasi);
    }

    //---------------------------------------------------------

    if (ObjectFind("SDeviasi_Line") != 0) {
        ObjectCreate("SDeviasi_Line", OBJ_HLINE, 0, CurTime(), SDeviasi);
        ObjectSet("SDeviasi_Line", OBJPROP_COLOR, Basic_S_LevelsDeviasi);
        ObjectSet("SDeviasi_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("SDeviasi_Line", 0, Time[20], SDeviasi);
    }

    if (ObjectFind("SDeviasi_Label") != 0) {
        ObjectCreate("SDeviasi_Label", OBJ_TEXT, 0, Time[20], SDeviasi);
        ObjectSetText("SDeviasi_Label", "SDeviasi", 8, "Arial", Basic_S_LevelsDeviasi);
    } else {
        ObjectMove("SDeviasi_Label", 0, Time[20], SDeviasi);
    }

    ObjectsRedraw();

    return (0);
}
