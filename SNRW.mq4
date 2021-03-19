//+------------------------------------------------------------------+
//|                                               SNRD.mq4 by Habeeb |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property indicator_chart_window

enum TheBaseSNR {
TheBaseSNRA = 1, //1.00351748471
TheBaseSNRB = 2, //1.0035
};
input TheBaseSNR BaseSNR = 1;

enum TheBaseDeviasi {
TheBaseDeviasiA = 1, //1.00175623
TheBaseDeviasiB = 2 //1.0017
};
input TheBaseDeviasi BaseDeviasi = 1;

enum TheBaseHHLL {
ThisWeek = 0, //ThisWeek
LastWeek = 1, //LastWeek
W2 = 2, //2
W3 = 3, //3
W4 = 4, //4
W5 = 5, //5
W6 = 6, //6
W7 = 7, //7
W8 = 8, //8
W9 = 9, //9
W10 = 10, //10
W11 = 11, //11
W12 = 12, //12
W13 = 13, //13
W14 = 14, //14
W15 = 15, //15
W16 = 16 //16
};
input TheBaseHHLL BaseHHLL = 0;

extern color Daily_Pivot = Aqua;
extern color Daily_S_Levels = Orange;
extern color Daily_R_Levels = Green;

double TheOpen;
double TheHigh;
double TheLow;
double TheClose;
double ThePrice[][6];
double Pivot, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, RDeviasi, SDeviasi, ResultBaseSNR, ResultBaseDeviasi;

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
    ObjectDelete("R4_Line");
    ObjectDelete("R5_Line");
    ObjectDelete("R6_Line");
    ObjectDelete("R7_Line");
    ObjectDelete("R8_Line");
    ObjectDelete("R9_Line");
    ObjectDelete("R10_Line");

    ObjectDelete("RDeviasi_Line");

    ObjectDelete("S1_Line");
    ObjectDelete("S2_Line");
    ObjectDelete("S3_Line");
    ObjectDelete("S4_Line");
    ObjectDelete("S5_Line");
    ObjectDelete("S6_Line");
    ObjectDelete("S7_Line");
    ObjectDelete("S8_Line");
    ObjectDelete("S9_Line");
    ObjectDelete("S10_Line");

    ObjectDelete("SDeviasi_Line");

    //--------------------------------

    ObjectDelete("PivotLabel");

    ObjectDelete("R1_Label");
    ObjectDelete("R2_Label");
    ObjectDelete("R3_Label");
    ObjectDelete("R4_Label");
    ObjectDelete("R5_Label");
    ObjectDelete("R6_Label");
    ObjectDelete("R7_Label");
    ObjectDelete("R8_Label");
    ObjectDelete("R9_Label");
    ObjectDelete("R10_Label");

    ObjectDelete("RDeviasi_Label");

    ObjectDelete("S1_Label");
    ObjectDelete("S2_Label");
    ObjectDelete("S3_Label");
    ObjectDelete("S4_Label");
    ObjectDelete("S5_Label");
    ObjectDelete("S6_Label");
    ObjectDelete("S7_Label");
    ObjectDelete("S8_Label");
    ObjectDelete("S9_Label");
    ObjectDelete("S10_Label");

    ObjectDelete("SDeviasi_Label");

    return (0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start() {

    ArrayCopyRates(ThePrice, (Symbol()), 10080);
    
    TheOpen = ThePrice[BaseHHLL][1];
    TheHigh = ThePrice[BaseHHLL][3];
    TheLow = ThePrice[BaseHHLL][2];
    TheClose = ThePrice[BaseHHLL][4];

    if (BaseSNR == 1) {
        ResultBaseSNR = 1.00351748471;
    } else
    if (BaseSNR == 2) {
        ResultBaseSNR = 1.0035;
    }
    
    for(int i=0; i<10; i++)
    {
        
    }

    R1  = TheLow * ResultBaseSNR;
    S1  = TheHigh / ResultBaseSNR;

    R2  = R1 * ResultBaseSNR;
    S2  = S1 / ResultBaseSNR;

    R3  = R2 * ResultBaseSNR;
    S3  = S2 / ResultBaseSNR;
    
    R4  = R3 * ResultBaseSNR;
    S4  = S3 / ResultBaseSNR;
    
    R5  = R4 * ResultBaseSNR;
    S5  = S4 / ResultBaseSNR;
    
    R6  = R5 * ResultBaseSNR;
    S6  = S5 / ResultBaseSNR;
    
    R7  = R6 * ResultBaseSNR;
    S7  = S6 / ResultBaseSNR;
    
    R8  = R7 * ResultBaseSNR;
    S8  = S7 / ResultBaseSNR;
    
    R9  = R8 * ResultBaseSNR;
    S9  = S8 / ResultBaseSNR;
    
    R10 = R9 * ResultBaseSNR;
    S10 = S9 / ResultBaseSNR;

    if (BaseDeviasi == 1) {
        ResultBaseDeviasi = 1.00175623;
    } else
    if (BaseDeviasi == 2) {
        ResultBaseDeviasi = 1.0017;
    }

    RDeviasi = R10 * ResultBaseDeviasi;
    SDeviasi = S10 / ResultBaseDeviasi;

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
        ObjectSetText("PivotLabel", ("Weekly Pivot"), 8, "Arial", Daily_Pivot);
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
        ObjectSetText("R1_Label", "Weekly R1", 8, "Arial", Daily_R_Levels);
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
        ObjectSetText("R2_Label", "Weekly R2", 8, "Arial", Daily_R_Levels);
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
        ObjectSetText("R3_Label", "Weekly R3", 8, "Arial", Daily_R_Levels);
    } else {
        ObjectMove("R3_Label", 0, Time[20], R3);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("R4_Line") != 0) {
        ObjectCreate("R4_Line", OBJ_HLINE, 0, CurTime(), R4);
        ObjectSet("R4_Line", OBJPROP_COLOR, Daily_R_Levels);
        ObjectSet("R4_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R4_Line", 0, Time[20], R4);
    }

    if (ObjectFind("R4_Label") != 0) {
        ObjectCreate("R4_Label", OBJ_TEXT, 0, Time[20], R4);
        ObjectSetText("R4_Label", "Weekly R4", 8, "Arial", Daily_R_Levels);
    } else {
        ObjectMove("R4_Label", 0, Time[20], R4);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("R5_Line") != 0) {
        ObjectCreate("R5_Line", OBJ_HLINE, 0, CurTime(), R5);
        ObjectSet("R5_Line", OBJPROP_COLOR, Daily_R_Levels);
        ObjectSet("R5_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R5_Line", 0, Time[20], R5);
    }

    if (ObjectFind("R5_Label") != 0) {
        ObjectCreate("R5_Label", OBJ_TEXT, 0, Time[20], R5);
        ObjectSetText("R5_Label", "Weekly R5", 8, "Arial", Daily_R_Levels);
    } else {
        ObjectMove("R5_Label", 0, Time[20], R5);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("R6_Line") != 0) {
        ObjectCreate("R6_Line", OBJ_HLINE, 0, CurTime(), R6);
        ObjectSet("R6_Line", OBJPROP_COLOR, Daily_R_Levels);
        ObjectSet("R6_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R6_Line", 0, Time[20], R6);
    }

    if (ObjectFind("R6_Label") != 0) {
        ObjectCreate("R6_Label", OBJ_TEXT, 0, Time[20], R6);
        ObjectSetText("R6_Label", "Weekly R6", 8, "Arial", Daily_R_Levels);
    } else {
        ObjectMove("R6_Label", 0, Time[20], R6);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("R7_Line") != 0) {
        ObjectCreate("R7_Line", OBJ_HLINE, 0, CurTime(), R7);
        ObjectSet("R7_Line", OBJPROP_COLOR, Daily_R_Levels);
        ObjectSet("R7_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R7_Line", 0, Time[20], R7);
    }

    if (ObjectFind("R7_Label") != 0) {
        ObjectCreate("R7_Label", OBJ_TEXT, 0, Time[20], R7);
        ObjectSetText("R7_Label", "Weekly R7", 8, "Arial", Daily_R_Levels);
    } else {
        ObjectMove("R7_Label", 0, Time[20], R7);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("R8_Line") != 0) {
        ObjectCreate("R8_Line", OBJ_HLINE, 0, CurTime(), R8);
        ObjectSet("R8_Line", OBJPROP_COLOR, Daily_R_Levels);
        ObjectSet("R8_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R8_Line", 0, Time[20], R8);
    }

    if (ObjectFind("R8_Label") != 0) {
        ObjectCreate("R8_Label", OBJ_TEXT, 0, Time[20], R8);
        ObjectSetText("R8_Label", "Weekly R8", 8, "Arial", Daily_R_Levels);
    } else {
        ObjectMove("R8_Label", 0, Time[20], R8);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("R9_Line") != 0) {
        ObjectCreate("R9_Line", OBJ_HLINE, 0, CurTime(), R9);
        ObjectSet("R9_Line", OBJPROP_COLOR, Daily_R_Levels);
        ObjectSet("R9_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R9_Line", 0, Time[20], R9);
    }

    if (ObjectFind("R9_Label") != 0) {
        ObjectCreate("R9_Label", OBJ_TEXT, 0, Time[20], R9);
        ObjectSetText("R9_Label", "Weekly R9", 8, "Arial", Daily_R_Levels);
    } else {
        ObjectMove("R9_Label", 0, Time[20], R9);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("R10_Line") != 0) {
        ObjectCreate("R10_Line", OBJ_HLINE, 0, CurTime(), R10);
        ObjectSet("R10_Line", OBJPROP_COLOR, Daily_R_Levels);
        ObjectSet("R10_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("R10_Line", 0, Time[20], R10);
    }

    if (ObjectFind("R10_Label") != 0) {
        ObjectCreate("R10_Label", OBJ_TEXT, 0, Time[20], R10);
        ObjectSetText("R10_Label", "Weekly R10", 8, "Arial", Daily_R_Levels);
    } else {
        ObjectMove("R10_Label", 0, Time[20], R10);
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
        ObjectSetText("S1_Label", "Weekly S1", 8, "Arial", Daily_S_Levels);
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
        ObjectSetText("S2_Label", "Weekly S2", 8, "Arial", Daily_S_Levels);
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
        ObjectSetText("S3_Label", "Weekly S3", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("S3_Label", 0, Time[20], S3);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("S4_Line") != 0) {
        ObjectCreate("S4_Line", OBJ_HLINE, 0, CurTime(), S4);
        ObjectSet("S4_Line", OBJPROP_COLOR, Daily_S_Levels);
        ObjectSet("S4_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S4_Line", 0, Time[20], S4);
    }

    if (ObjectFind("S4_Label") != 0) {
        ObjectCreate("S4_Label", OBJ_TEXT, 0, Time[20], S4);
        ObjectSetText("S4_Label", "Weekly S4", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("S4_Label", 0, Time[20], S4);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("S5_Line") != 0) {
        ObjectCreate("S5_Line", OBJ_HLINE, 0, CurTime(), S5);
        ObjectSet("S5_Line", OBJPROP_COLOR, Daily_S_Levels);
        ObjectSet("S5_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S5_Line", 0, Time[20], S5);
    }

    if (ObjectFind("S5_Label") != 0) {
        ObjectCreate("S5_Label", OBJ_TEXT, 0, Time[20], S5);
        ObjectSetText("S5_Label", "Weekly S5", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("S5_Label", 0, Time[20], S5);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("S6_Line") != 0) {
        ObjectCreate("S6_Line", OBJ_HLINE, 0, CurTime(), S6);
        ObjectSet("S6_Line", OBJPROP_COLOR, Daily_S_Levels);
        ObjectSet("S6_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S6_Line", 0, Time[20], S6);
    }

    if (ObjectFind("S6_Label") != 0) {
        ObjectCreate("S6_Label", OBJ_TEXT, 0, Time[20], S6);
        ObjectSetText("S6_Label", "Weekly S6", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("S6_Label", 0, Time[20], S6);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("S7_Line") != 0) {
        ObjectCreate("S7_Line", OBJ_HLINE, 0, CurTime(), S7);
        ObjectSet("S7_Line", OBJPROP_COLOR, Daily_S_Levels);
        ObjectSet("S7_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S7_Line", 0, Time[20], S7);
    }

    if (ObjectFind("S7_Label") != 0) {
        ObjectCreate("S7_Label", OBJ_TEXT, 0, Time[20], S7);
        ObjectSetText("S7_Label", "Weekly S7", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("S7_Label", 0, Time[20], S7);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("S8_Line") != 0) {
        ObjectCreate("S8_Line", OBJ_HLINE, 0, CurTime(), S8);
        ObjectSet("S8_Line", OBJPROP_COLOR, Daily_S_Levels);
        ObjectSet("S8_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S8_Line", 0, Time[20], S8);
    }

    if (ObjectFind("S8_Label") != 0) {
        ObjectCreate("S8_Label", OBJ_TEXT, 0, Time[20], S8);
        ObjectSetText("S8_Label", "Weekly S8", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("S8_Label", 0, Time[20], S8);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("S9_Line") != 0) {
        ObjectCreate("S9_Line", OBJ_HLINE, 0, CurTime(), S9);
        ObjectSet("S9_Line", OBJPROP_COLOR, Daily_S_Levels);
        ObjectSet("S9_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S9_Line", 0, Time[20], S9);
    }

    if (ObjectFind("S9_Label") != 0) {
        ObjectCreate("S9_Label", OBJ_TEXT, 0, Time[20], S9);
        ObjectSetText("S9_Label", "Weekly S9", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("S9_Label", 0, Time[20], S9);
    }
    
    //---------------------------------------------------------

    if (ObjectFind("S10_Line") != 0) {
        ObjectCreate("S10_Line", OBJ_HLINE, 0, CurTime(), S10);
        ObjectSet("S10_Line", OBJPROP_COLOR, Daily_S_Levels);
        ObjectSet("S10_Line", OBJPROP_STYLE, STYLE_DASHDOT);
    } else {
        ObjectMove("S10_Line", 0, Time[20], S10);
    }

    if (ObjectFind("S10_Label") != 0) {
        ObjectCreate("S10_Label", OBJ_TEXT, 0, Time[20], S10);
        ObjectSetText("S10_Label", "Weekly S10", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("S10_Label", 0, Time[20], S10);
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
        ObjectSetText("RDeviasi_Label", "Weekly RDeviasi", 8, "Arial", Daily_R_Levels);
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
        ObjectSetText("SDeviasi_Label", "Weekly SDeviasi", 8, "Arial", Daily_S_Levels);
    } else {
        ObjectMove("SDeviasi_Label", 0, Time[20], SDeviasi);
    }

    ObjectsRedraw();

    return (0);
}
