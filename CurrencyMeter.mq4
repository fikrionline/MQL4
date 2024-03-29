#property copyright "Copyright © 2012, MetaQuotes Software Corp."
#property link "http://www.metaquotes.net"

#property indicator_chart_window

extern bool CurrenciesWindowBelowTable = FALSE;
extern bool ShowCurrencies = TRUE;
extern bool ShowCurrenciesSorted = TRUE;
extern bool ShowSymbolsSorted = FALSE;
extern string SymbolPrefix = "";
extern string DontShowThisPairs = "";
extern color HandleBackGroundColor = LightSlateGray;
extern color DataTableBackGroundColor_1 = LightSteelBlue;
extern color DataTableBackGroundColor_2 = Lavender;
extern color CurrencysBackGroundColor = LightSlateGray;
extern color HandleTextColor = White;
extern color DataTableTextColor = Black;
extern color CurrencysTextColor = White;
extern color TrendUpArrowsColor = MediumBlue;
extern color TrendDownArrowsColor = Red;
int emmo_144[] = { 255, 17919, 5275647, 65535, 3145645, 65280 };
string sg_148;
int emmo_156[10];
int emmo_unused_160[100];
string wer_unused_164[100];
int emmo_168[10];
int emmo_172[21]
    = { 15, 23, 31, 35, 43, 47, 55, 67, 75, 83, 87, 91, 95, 99, 119, 123, 127, 143, 148, 156, 164 };
int emmo_176[21]
    = { 11, 17, 23, 26, 32, 35, 41, 50, 56, 62, 65, 68, 71, 74, 89, 92, 95, 107, 110, 116, 122 };
int emmo_180[21]
    = { 4, 5, 6, 7, 9, 10, 12, 15, 17, 19, 20, 21, 22, 23, 28, 29, 30, 34, 36, 38, 40 };
int emmo_184[21] = { -3, -2, -1, -1, -2, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0 };
string wer_188[8] = { "USD", "EUR", "GBP", "CHF", "JPY", "CAD", "AUD", "NZD" };
int emmo_192[8] = { 9639167, 16711680, 16711680, 65535, 65535, 9639167, 16711680, 16711680 };
string wer_196[28] = { "AUDCAD", "AUDCHF", "AUDJPY", "AUDNZD", "AUDUSD", "CADCHF", "CADJPY", "CHFJPY", "EURAUD", "EURCAD", "EURCHF", "EURGBP", "EURJPY", "EURNZD", "EURUSD", "GBPAUD", "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "GBPUSD", "NZDCAD", "NZDCHF", "NZDJPY", "NZDUSD", "USDCAD", "USDCHF", "USDJPY" };
string wer_unused_200[6][5];
string wer_204[28];
int emmo_208[6];
double dag_212[28][3];
int germ_color_216;
int germ_color_220;
int germ_color_224;
int germ_color_228;
int germ_color_236;
int germ_color_240;
int germ_color_244;
int germ_color_248;
int germ_color_252;
string sg_256 = "";
bool egg_264 = FALSE;
int egg_268;

int ggg_6(string as_0, int io_8, int io_12, int io_16, int io_20 = 1, int io_24 = 1, int io_28 = 0,
    int io_32 = 0, int io_36 = 0, int io_40 = 0, int io_44 = 0, string as_48 = "",
    int io_56 = 16777215)
{
    int el_60;
    int el_80;
    string bs_112;
    int el_120;
    if (io_40 != 0 && io_40 != 1)
        io_40 = 0;
    if (io_44 < 0)
        io_44 = 0;
    if (as_48 != "")
    {
        if (ggg_9(as_48))
        {
            io_12 += emmo_156[0];
            io_16 += emmo_156[1];
            io_40 = emmo_156[6];
            io_44 = emmo_156[8];
            io_32 += emmo_156[4];
            el_60 = emmo_156[9] + 1;
        }
    }
    emmo_168[0] = io_12;
    emmo_168[1] = io_16;
    emmo_168[2] = io_12 + io_20 * emmo_172[io_28] - 1;
    emmo_168[3] = io_16 + io_24 * emmo_172[io_28] - (io_24 * 2 - 1);
    emmo_168[6] = io_32;
    emmo_168[9] = io_8;
    int el_84 = 1;
    int el_88 = emmo_172[io_28] - 2;
    int el_92 = emmo_176[io_28];
    string bs_96 = "";
    string bs_104 = "g";
    if (io_20 == 1 && io_24 == 1)
    {
        emmo_168[4] = 0;
        emmo_168[5] = 0;
        emmo_168[7] = el_60;
        emmo_168[8] = el_60;
        bs_96 = ggg_7(as_0, emmo_168, as_48);
        if (!ggg_4(bs_96, emmo_168[0], emmo_168[1] + emmo_184[io_28], bs_104, el_92, io_40, io_56,
                io_44))
            Print(GetLastError());
        if (io_36 == io_56)
            return (0);
        emmo_168[4] = 0;
        emmo_168[5] = 1;
        emmo_168[7] = el_60;
        emmo_168[8] = el_60 + 1;
        bs_96 = ggg_7(as_0, emmo_168, as_48);
        if (!ggg_4(bs_96, emmo_168[0] + el_84, emmo_168[1] + el_84 + emmo_184[io_28], bs_104,
                el_92 - el_84, io_40, io_36, io_44))
            Print(GetLastError());
    }
    else
    {
        for (int el_64 = 1; el_64 < io_20; el_64++)
            bs_104 = bs_104 + "g";
        for (int count_68 = 0; count_68 < io_24; count_68++)
        {
            emmo_168[4] = el_80 / 10;
            emmo_168[5] = el_80 % 10;
            emmo_168[7] = el_60;
            emmo_168[8] = el_60;
            bs_96 = ggg_7(as_0, emmo_168, as_48);
            if (!ggg_4(bs_96, emmo_168[0], emmo_168[1] + el_88 * count_68 + emmo_184[io_28], bs_104,
                    el_92, io_40, io_56, io_44))
                Print(GetLastError());
            el_80++;
        }
        if (io_36 == io_56)
            return (0);
        emmo_168[7] = el_60;
        emmo_168[8] = el_60 + 1;
        for (count_68 = 0; count_68 < io_24; count_68++)
        {
            if (io_20 > 1)
            {
                emmo_168[4] = el_80 / 10;
                emmo_168[5] = el_80 % 10;
                bs_96 = ggg_7(as_0, emmo_168, as_48);
                bs_112 = "g";
                el_120 = io_20 / 10 + 1;
                for (int count_72 = 0; count_72 < el_120; count_72++)
                    bs_112 = bs_112 + "g";
                if (!ggg_4(bs_96, emmo_168[0] + el_84,
                        emmo_168[1] + (el_88 * count_68 - count_68) + emmo_184[io_28] + io_24,
                        bs_112, el_92 - el_84, io_40, io_36, io_44))
                    Print(GetLastError());
                el_80++;
            }
            emmo_168[4] = el_80 / 10;
            emmo_168[5] = el_80 % 10;
            bs_96 = ggg_7(as_0, emmo_168, as_48);
            if (!ggg_4(bs_96, emmo_168[0] + (io_20 * 2 - el_84),
                    emmo_168[1] + (el_88 * count_68 - count_68) + emmo_184[io_28] + io_24, bs_104,
                    el_92 - el_84, io_40, io_36, io_44))
                Print(GetLastError());
            el_80++;
        }
        if (io_24 < 2)
            return (0);
        for (count_72 = 0; count_72 <= io_24 / el_88; count_72++)
        {
            emmo_168[4] = el_80 / 10;
            emmo_168[5] = el_80 % 10;
            bs_96 = ggg_7(as_0, emmo_168, as_48);
            if (!ggg_4(bs_96, emmo_168[0] + io_20 * 2 - el_84,
                    emmo_168[1] + el_84 + emmo_184[io_28] + (el_88 - 1) * count_72, bs_104,
                    el_92 - el_84, io_40, io_36, io_44))
                Print(GetLastError());
            el_80++;
            if (io_20 > 1)
            {
                emmo_168[4] = el_80 / 10;
                emmo_168[5] = el_80 % 10;
                bs_96 = ggg_7(as_0, emmo_168, as_48);
                bs_112 = "g";
                el_120 = io_20 / 10 + 1;
                for (int count_76 = 0; count_76 < el_120; count_76++)
                    bs_112 = bs_112 + "g";
                if (!ggg_4(bs_96, emmo_168[0] + el_84,
                        emmo_168[1] + el_84 + emmo_184[io_28] + (el_88 - 1) * count_72, bs_112,
                        el_92 - el_84, io_40, io_36, io_44))
                    Print(GetLastError());
                el_80++;
            }
        }
    }
    return (0);
}

int ggg_2(string as_0, string as_8, int io_16, string as_20, string as_28, int io_36,
    bool io_40 = TRUE, int io_44 = 0, int io_48 = 0, int io_52 = 0, int io_56 = 0, int io_60 = 0,
    int io_64 = 0, int io_68 = 0)
{
    int el_unused_108;
    double dl_112;
    double dl_120;
    int lia_72[19] = { 10, 14, 20, 26, 32, 35, 41, 50, 56, 62, 65, 68, 71, 74, 77, 86, 89, 92, 95 };
    int lia_76[7] = { 0, 3, 2, 3, 2, 3, 4 };
    int el_80 = 0;
    int el_84 = 0;
    int el_88 = 0;
    int el_unused_92 = 0;
    int el_96 = 0;
    int el_100 = 0;
    int el_unused_104 = 0;
    if (as_8 != "")
    {
        if (ggg_9(as_8))
        {
            io_60 = emmo_156[6];
            io_64 = emmo_156[8];
            el_80 = emmo_156[0];
            el_84 = emmo_156[1];
            el_88 = emmo_156[2];
            el_96 += emmo_156[4] + 1;
            el_100 = emmo_156[9] + 1;
            io_60 = emmo_156[6];
            io_64 = emmo_156[8];
            el_unused_108 = emmo_156[5];
            if (io_56 == 0)
                io_56 = lia_72[io_52];
            if (io_40)
            {
                dl_112 = StringLen(as_20) * io_56 / 1.6;
                dl_120 = el_88 - el_80;
                io_44 = el_80 + (dl_120 - dl_112) / 2.0 + io_44;
                io_48 = el_84 + lia_76[io_52];
                if (as_28 == "Webdings")
                {
                    if (io_52 == 0)
                    {
                        io_56 = 11;
                        io_44 = el_80;
                        io_48 = el_84 - 3;
                    }
                    else
                    {
                        io_56 = 20;
                        io_44 = el_80 - 2;
                        io_48 = el_84 - 4;
                    }
                }
                else
                {
                    if (as_28 == "Wingdings")
                    {
                        io_56 = 11;
                        io_44 = el_80 + 1;
                        io_48 = el_84 + 2;
                    }
                }
            }
            else
            {
                io_44 += el_80;
                io_48 += el_84;
            }
        }
    }
    emmo_168[0] = io_44;
    emmo_168[1] = io_48;
    emmo_168[6] = el_96;
    emmo_168[7] = el_100;
    emmo_168[8] = el_100;
    emmo_168[9] = io_16;
    as_0 = ggg_7(as_0, emmo_168, as_8);
    if (!ggg_4(as_0, io_44, io_48, as_20, io_56, io_60, io_36, io_64, as_28, io_68))
        return (GetLastError());
    return (0);
}

int ggg_10(string as_0, int io_8, int io_12, int io_16, int io_20 = 3, int io_24 = 1, int io_28 = 1,
    int io_32 = 0, int io_36 = 7346457, int io_40 = 0, int io_44 = 0, string as_48 = "",
    int io_56 = 16777215)
{
    string bs_60;
    string bs_unused_68;
    int el_76;
    int el_80;
    int el_84;
    if (io_8 < 70 || io_8 > 75)
        return (1);
    if (io_36 == 0)
        io_36 = 9109504;
    if (io_28 <= 1)
        io_28 = 1;
    switch (io_8)
    {
        case 70:
            if (io_20 < 3)
                io_20 = 3;
            ggg_6(as_0, io_8, io_12, io_16, io_20, io_24, io_28, io_32, io_36, io_40, io_44, as_48,
                io_56);
            break;
        case 71:
            if (io_20 < 3)
                io_20 = 3;
            ggg_6(as_0, io_8, io_12, io_16, io_20, io_24, io_28, io_32, io_36, io_40, io_44, as_48,
                io_56);
            if (io_40 == 0)
                el_76 = emmo_168[2] - emmo_168[0] - (7 * (io_28 - 1) + 19);
            else
                el_76 = 4;
            bs_60 = StringSubstr(as_0, 0, 2) + "CL" + StringSubstr(as_0, 2);
            ggg_6(
                bs_60, 52, el_76, 4, 1, 1, io_28 - 1, io_32 + 1, io_36, io_40, io_44, as_0, io_56);
            ggg_2(
                "Clt", bs_60, 69, StringSetChar("", 0, 'r'), "Webdings", io_56, 1, 4, 4, io_28 - 1);
            break;
        case 72:
            if (io_20 < 3)
                io_20 = 3;
            ggg_6(as_0, io_8, io_12, io_16, io_20, io_24, io_28, io_32, io_36, io_40, io_44, as_48,
                io_56);
            if (io_40 == 0)
                el_76 = emmo_168[2] - emmo_168[0] - (7 * (io_28 - 1) + 19);
            else
                el_76 = 4;
            bs_60 = StringSubstr(as_0, 0, 2) + "HD" + StringSubstr(as_0, 2);
            ggg_6(
                bs_60, 53, el_80, 4, 1, 1, io_28 - 1, io_32 + 1, io_36, io_40, io_44, as_0, io_56);
            ggg_2(
                "Hdt", bs_60, 69, StringSetChar("", 0, '0'), "Webdings", io_56, 1, 4, 4, io_28 - 1);
            break;
        case 73:
            if (io_20 < 3)
                io_20 = 3;
            ggg_6(as_0, io_8, io_12, io_16, io_20, io_24, io_28, io_32, io_36, io_40, io_44, as_48,
                io_56);
            if (io_40 == 0)
            {
                el_76 = emmo_168[2] - emmo_168[0] - (7 * (io_28 - 1) + 19);
                el_80 = emmo_168[2] - emmo_168[0] - (15 * (io_28 - 1) + 37);
            }
            else
            {
                el_76 = 4;
                el_80 = 7 * (io_28 - 1) + 23;
            }
            bs_60 = StringSubstr(as_0, 0, 2) + "CL" + StringSubstr(as_0, 2);
            ggg_6(
                bs_60, 52, el_76, 4, 1, 1, io_28 - 1, io_32 + 1, io_36, io_40, io_44, as_0, io_56);
            ggg_2(
                "Clt", bs_60, 69, StringSetChar("", 0, 'r'), "Webdings", io_56, 1, 4, 4, io_28 - 1);
            bs_60 = StringSubstr(as_0, 0, 2) + "HD" + StringSubstr(as_0, 2);
            ggg_6(
                bs_60, 53, el_80, 4, 1, 1, io_28 - 1, io_32 + 1, io_36, io_40, io_44, as_0, io_56);
            ggg_2(
                "Hdt", bs_60, 69, StringSetChar("", 0, '0'), "Webdings", io_56, 1, 4, 4, io_28 - 1);
            break;
        case 74:
            if (io_20 < 3)
                io_20 = 3;
            ggg_6(as_0, io_8, io_12, io_16, io_20, io_24, io_28, io_32, io_36, io_40, io_44, as_48,
                io_56);
            if (io_40 == 0)
            {
                el_76 = emmo_168[2] - emmo_168[0] - (7 * (io_28 - 1) + 19);
                el_80 = emmo_168[2] - emmo_168[0] - (15 * (io_28 - 1) + 37);
                el_84 = emmo_168[2] - emmo_168[0] - (23 * (io_28 - 1) + 55);
            }
            else
            {
                el_76 = 4;
                el_80 = 7 * (io_28 - 1) + 23;
                el_84 = 14 * (io_28 - 1) + 42;
            }
            bs_60 = StringSubstr(as_0, 0, 2) + "CL" + StringSubstr(as_0, 2);
            ggg_6(
                bs_60, 52, el_76, 4, 1, 1, io_28 - 1, io_32 + 1, io_36, io_40, io_44, as_0, io_56);
            ggg_2(
                "Clt", bs_60, 69, StringSetChar("", 0, 'r'), "Webdings", io_56, 1, 4, 4, io_28 - 1);
            bs_60 = StringSubstr(as_0, 0, 2) + "HD" + StringSubstr(as_0, 2);
            ggg_6(
                bs_60, 53, el_80, 4, 1, 1, io_28 - 1, io_32 + 1, io_36, io_40, io_44, as_0, io_56);
            ggg_2(
                "Hdt", bs_60, 69, StringSetChar("", 0, '0'), "Webdings", io_56, 1, 4, 4, io_28 - 1);
            bs_60 = StringSubstr(as_0, 0, 2) + "ST" + StringSubstr(as_0, 2);
            ggg_6(
                bs_60, 55, el_84, 4, 1, 1, io_28 - 1, io_32 + 1, io_36, io_40, io_44, as_0, io_56);
            ggg_2(
                "Stt", bs_60, 69, StringSetChar("", 0, '@'), "Webdings", io_56, 1, 4, 4, io_28 - 1);
            break;
        default:
            return (1);
    }
    return (0);
}

int ggg_1(string as_0, string as_8, int io_16, int io_20, int io_24 = 1, int io_28 = 1,
    int io_32 = 0, double ad_36 = 0.0, double ad_44 = 1.0, double ad_52 = 1.0, int io_60 = -1,
    int io_64 = -1, int io_68 = -1)
{
    int el_80;
    int el_84;
    int el_88;
    int el_92;
    int el_96;
    int el_100;
    int el_104;
    int el_112;
    int el_116;
    string bs_unused_124;
    string bs_unused_132;
    int el_188;
    int el_192;
    if (as_8 == "")
    {
        if (io_64 < 0)
            io_64 = 0;
        if (io_68 < 0)
            io_68 = 16777215;
    }
    else
    {
        if (!ggg_9(as_8))
            return (-1);
        if (io_64 < 0)
            io_64 = 0;
        if (io_68 < 0)
            io_68 = 16777215;
        el_92 = emmo_156[4] + 1;
    }
    if (io_28 > 2)
        io_28 = 2;
    if (io_24 > 8)
        io_24 = 8;
    if (io_32 > 3)
        io_32 = 3;
    if (io_32 < 0)
        io_32 = 0;
    switch (io_32)
    {
        case 0:
            el_80 = io_24;
            el_84 = 1;
            break;
        case 1:
            el_80 = 1;
            el_84 = io_24;
            break;
        case 2:
            el_80 = io_24;
            el_84 = 1;
            break;
        case 3:
            el_80 = 1;
            el_84 = io_24;
    }
    ggg_11(as_0, as_8, 30, io_16, io_20, el_80, el_84, io_28, io_64, io_68, el_92);
    ggg_9(as_0);
    int el_120 = emmo_156[6];
    if (io_32 % 2 == 0)
    {
        switch (el_80)
        {
            case 1:
                el_88 = 1;
                break;
            case 2:
                el_88 = 2;
                break;
            case 3:
                el_88 = 2;
                break;
            case 4:
                el_88 = 2;
                break;
            case 5:
                el_88 = 3;
                break;
            case 6:
                el_88 = 3;
                break;
            case 7:
                el_88 = 3;
                break;
            case 8:
                el_88 = 4;
        }
    }
    else
    {
        switch (el_84)
        {
            case 1:
                el_88 = 1;
                break;
            case 2:
                el_88 = 2;
                break;
            case 3:
                el_88 = 3;
                break;
            case 4:
                el_88 = 3;
                break;
            case 5:
                el_88 = 4;
                break;
            case 6:
                el_88 = 5;
                break;
            case 7:
                el_88 = 4;
                break;
            case 8:
                el_88 = 4;
        }
    }
    switch (io_32)
    {
        case 0:
            switch (io_28)
            {
                case 0:
                    if (el_120 == 0)
                    {
                        el_96 = 1;
                        el_100 = -2;
                        el_104 = 9;
                        el_112 = 5 * el_80 - 1;
                        el_116 = 0;
                    }
                    if (el_120 != 1)
                        break;
                    el_96 = emmo_156[2] - emmo_156[0] - 1;
                    el_100 = 17;
                    el_104 = 9;
                    el_112 = 5 * el_80 - 1;
                    el_116 = 180;
                    break;
                case 1:
                    if (el_120 == 0)
                    {
                        el_96 = 1;
                        el_100 = -2;
                        el_104 = 9;
                        el_112 = el_80 * 8 - el_88;
                        el_116 = 0;
                    }
                    if (el_120 != 1)
                        break;
                    el_96 = emmo_156[2] - emmo_156[0] - 1;
                    el_100 = 17;
                    el_104 = 9;
                    el_112 = el_80 * 8 - el_88;
                    el_116 = 180;
                    break;
                case 2:
                    if (el_120 == 0)
                    {
                        el_96 = 1;
                        el_100 = -5;
                        el_104 = 15;
                        el_112 = 5 * el_80;
                        el_116 = 0;
                    }
                    if (el_120 != 1)
                        break;
                    el_96 = emmo_156[2] - emmo_156[0] - 1;
                    el_100 = 28;
                    el_104 = 15;
                    el_112 = 5 * el_80;
                    el_116 = 180;
            }
            break;
        case 1:
            switch (io_28)
            {
                case 0:
                    if (el_84 > 6)
                        el_88++;
                    if (el_120 == 0)
                    {
                        el_96 = -3;
                        el_100 = emmo_156[3] - emmo_156[1];
                        el_104 = 9;
                        el_112 = 5 * el_84 - el_88;
                        el_116 = 90;
                    }
                    if (el_120 != 1)
                        break;
                    el_96 = -3;
                    el_100 = emmo_156[3] - emmo_156[1] - 1;
                    el_104 = 9;
                    el_112 = 5 * el_84 - el_88;
                    el_116 = 270;
                    break;
                case 1:
                    if (el_120 == 0)
                    {
                        el_96 = -3;
                        el_100 = emmo_156[3] - emmo_156[1];
                        el_104 = 9;
                        el_112 = 7 * el_84 - 1;
                        el_116 = 90;
                    }
                    if (el_120 != 1)
                        break;
                    el_96 = -3;
                    el_100 = emmo_156[3] - emmo_156[1] - 1;
                    el_104 = 9;
                    el_112 = 7 * el_84 - 1;
                    el_116 = 270;
                    break;
                case 2:
                    if (el_120 == 0)
                    {
                        el_96 = -6;
                        el_100 = emmo_156[3] - emmo_156[1];
                        el_104 = 14;
                        el_112 = 7 * el_84 - (el_84 + el_84 / 4);
                        el_116 = 90;
                    }
                    if (el_120 != 1)
                        break;
                    el_96 = -6;
                    el_100 = emmo_156[3] - emmo_156[1] + 1;
                    el_104 = 14;
                    el_112 = 7 * el_84 - (el_84 + el_84 / 4);
                    el_116 = 270;
            }
            break;
        case 2:
            switch (io_28)
            {
                case 0:
                    if (el_120 == 1)
                    {
                        el_96 = 2;
                        el_100 = -2;
                        el_104 = 9;
                        el_112 = 5 * el_80 - 1;
                        el_116 = 0;
                    }
                    if (el_120 != 0)
                        break;
                    el_96 = emmo_156[2] - emmo_156[0];
                    el_100 = 17;
                    el_104 = 9;
                    el_112 = 5 * el_80 - 1;
                    el_116 = 180;
                    break;
                case 1:
                    if (el_120 == 1)
                    {
                        el_96 = 2;
                        el_100 = -2;
                        el_104 = 9;
                        el_112 = el_80 * 8 - el_88;
                        el_116 = 0;
                    }
                    if (el_120 != 0)
                        break;
                    el_96 = emmo_156[2] - emmo_156[0];
                    el_100 = 17;
                    el_104 = 9;
                    el_112 = el_80 * 8 - el_88;
                    el_116 = 180;
                    break;
                case 2:
                    if (el_120 == 1)
                    {
                        el_96 = 1;
                        el_100 = -5;
                        el_104 = 15;
                        el_112 = 5 * el_80;
                        el_116 = 0;
                    }
                    if (el_120 != 0)
                        break;
                    el_96 = emmo_156[2] - emmo_156[0] - 1;
                    el_100 = 28;
                    el_104 = 15;
                    el_112 = 5 * el_80;
                    el_116 = 180;
            }
            break;
        case 3:
            switch (io_28)
            {
                case 0:
                    if (el_120 == 0)
                    {
                        el_96 = 18;
                        el_100 = 1;
                        el_104 = 9;
                        el_112 = 5 * el_84 - el_88;
                        el_116 = 270;
                    }
                    if (el_120 != 1)
                        break;
                    el_96 = 18;
                    el_100 = 1;
                    el_104 = 9;
                    el_112 = 5 * el_84 - el_88;
                    el_116 = 90;
                    break;
                case 1:
                    if (el_120 == 0)
                    {
                        el_96 = 18;
                        el_100 = 1;
                        el_104 = 9;
                        el_112 = 7 * el_84 - 1;
                        el_116 = 270;
                    }
                    if (el_120 != 1)
                        break;
                    el_96 = 18;
                    el_100 = 2;
                    el_104 = 9;
                    el_112 = 7 * el_84 - 1;
                    el_116 = 90;
                    break;
                case 2:
                    if (el_120 == 0)
                    {
                        el_96 = 28;
                        el_100 = 1;
                        el_104 = 14;
                        el_112 = 7 * el_84 - (el_84 + el_84 / 4);
                        el_116 = 270;
                    }
                    if (el_120 != 1)
                        break;
                    el_96 = 28;
                    el_100 = 1;
                    el_104 = 14;
                    el_112 = 7 * el_84 - (el_84 + el_84 / 4);
                    el_116 = 90;
            }
    }
    double dl_172 = (ad_44 - ad_36) / MathAbs(el_112);
    string bs_180 = "";
    for (int count_72 = 0; count_72 < el_112; count_72++)
    {
        if (ad_52 <= ad_36 + dl_172 * count_72)
            break;
        bs_180 = bs_180 + "|";
    }
    if (io_60 < 0)
    {
        el_188 = ArraySize(emmo_144) - 1;
        el_192 = count_72 / (el_112 / el_188);
        if (el_192 > el_188)
            el_192 = el_188;
        io_60 = emmo_144[el_192];
    }
    ggg_2(
        "LedIn", as_0, 69, bs_180, "Arial black", io_60, 0, el_96, el_100, 0, el_104, 0, 0, el_116);
    if (io_28 > 0)
    {
        if (io_32 == 1 || io_32 == 3)
            el_96 += io_28 - 1 + 8;
        else
            el_100 += 8;
        ggg_2("LedIn", as_0, 69, bs_180, "Arial black", io_60, 0, el_96, el_100, 0, el_104, 0, 0,
            el_116);
    }
    return (0);
}

string ggg_7(string as_0, int aia_8[10], string as_12 = "chart")
{
    string bs_unused_20 = "";
    if (as_12 == "")
        as_12 = "chart";
    return (StringConcatenate("wnd:", "z_", aia_8[6], StringSetChar("", 0, aia_8[7] + 97),
        StringSetChar("", 0, aia_8[8] + 97), ":", "c_", aia_8[9], ":", "lu_", aia_8[0], "_",
        aia_8[1], ":", "rd_", aia_8[2], "_", aia_8[3], ":", "id", aia_8[4], "", aia_8[5], ":", "#",
        as_0, "|", as_12));
}

int ggg_11(string as_0, string as_8, int io_16, int io_20 = 0, int io_24 = 0, int io_28 = 1,
    int io_32 = 1, int io_36 = 1, int io_40 = 0, int io_44 = 16777215, int io_48 = 0, int io_52 = 0,
    int io_56 = 0)
{
    string bs_60;
    string bs_68;
    switch (io_16)
    {
        case 30:
            ggg_6(as_0, io_16, io_20, io_24, io_28, io_32, io_36, io_48, io_40, io_52, io_56, as_8,
                io_44);
            break;
        case 40:
            ggg_6(as_0, io_16, io_20, io_24, io_28, io_32, io_36, io_48, io_40, io_52, io_56, as_8,
                io_44);
            break;
        case 70:
            ggg_10(as_0, io_16, io_20, io_24, io_28, io_32, io_36, io_48, io_40, io_52, io_56, as_8,
                io_44);
            break;
        case 71:
            ggg_10(as_0, io_16, io_20, io_24, io_28, io_32, io_36, io_48, io_40, io_52, io_56, as_8,
                io_44);
            break;
        case 72:
            ggg_10(as_0, io_16, io_20, io_24, io_28, io_32, io_36, io_48, io_40, io_52, io_56, as_8,
                io_44);
            break;
        case 73:
            ggg_10(as_0, io_16, io_20, io_24, io_28, io_32, io_36, io_48, io_40, io_52, io_56, as_8,
                io_44);
            break;
        case 74:
            ggg_10(as_0, io_16, io_20, io_24, io_28, io_32, io_36, io_48, io_40, io_52, io_56, as_8,
                io_44);
            break;
        case 44:
            bs_60 = "RevBb";
            bs_68 = "Revtt";
            ggg_6(bs_60, 44, io_20, io_24, 4, 1, 0, io_48 + 1, 16711935, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 69, "Revers", "Tahoma", io_44);
            break;
        case 43:
            bs_60 = "ClBb";
            bs_68 = "Clott";
            ggg_6(bs_60, 43, io_20, io_24, 4, 1, 0, io_48 + 1, 65535, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 69, "Close", "Tahoma", 0);
            break;
        case 42:
            bs_60 = "Sbb";
            bs_68 = "Seltt";
            ggg_6(bs_60, 42, io_20, io_24, 4, 1, 0, io_48 + 1, 4678655, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 69, "Sell", "Tahoma", io_44);
            break;
        case 41:
            bs_60 = "Bbb";
            bs_68 = "Buytt";
            ggg_6(bs_60, 41, io_20, io_24, 4, 1, 0, io_48 + 1, 16748574, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 69, "Buy", "Tahoma", io_44);
            break;
        case 52:
            bs_60 = "Cls";
            bs_68 = "Clt";
            ggg_6(bs_60, 52, io_20, 4, 1, 1, 0, io_48 + 1, io_40, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 69, StringSetChar("", 0, 'r'), "Webdings", io_44);
            break;
        case 53:
            bs_60 = "Hid";
            bs_68 = "Hdt";
            ggg_6(bs_60, 53, io_20, 4, 1, 1, 0, io_48 + 1, io_40, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 69, StringSetChar("", 0, '0'), "Webdings", io_44);
            break;
        case 54:
            bs_60 = "Shw";
            bs_68 = "Sht";
            ggg_6(bs_60, 54, io_20, 4, 1, 1, 0, io_48 + 1, io_40, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 69, StringSetChar("", 0, '2'), "Webdings", io_44);
            break;
        case 55:
            bs_60 = "Set";
            bs_68 = "Stt";
            ggg_6(bs_60, 55, io_20, 4, 1, 1, 0, io_48 + 1, io_40, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 69, StringSetChar("", 0, '@'), "Webdings", io_44);
            break;
        case 56:
            bs_60 = "Alr";
            bs_68 = "Altx";
            ggg_6(bs_60, 56, io_20, 4, 1, 1, 0, io_48 + 1, io_40, io_52, io_56, as_8, 12632256);
            ggg_2(bs_68, bs_60, 69, StringSetChar("", 0, ']'), "Webdings", 12632256);
            break;
        case 57:
            bs_60 = "Snd";
            bs_68 = "Sndtx";
            ggg_6(bs_60, 57, io_20, 4, 1, 1, 0, io_48 + 1, io_40, io_52, io_56, as_8, 12632256);
            ggg_2(bs_68, bs_60, 57, StringSetChar("", 0, '¯'), "Webdings", 12632256);
            break;
        case 58:
            bs_60 = "Mil";
            bs_68 = "Mltx";
            ggg_6(bs_60, 58, io_20, 4, 1, 1, 0, io_48 + 1, io_40, io_52, io_56, as_8, 12632256);
            ggg_2(bs_68, bs_60, 58, StringSetChar("", 0, '*'), "Wingdings", 12632256);
            break;
        case 60:
            bs_60 = as_0;
            bs_68 = "Lftx";
            ggg_6(bs_60, 60, io_20, io_24, 1, 1, 0, io_48 + 1, io_40, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 60, StringSetChar("", 0, '3'), "Webdings", io_44);
            break;
        case 61:
            bs_60 = as_0;
            bs_68 = "Rttx";
            ggg_6(bs_60, 61, io_20, io_24, 1, 1, 0, io_48 + 1, io_40, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 61, StringSetChar("", 0, '4'), "Webdings", io_44);
            break;
        case 62:
            bs_60 = as_0;
            bs_68 = "Uptx";
            ggg_6(bs_60, 62, io_20, io_24, 1, 1, 0, io_48 + 1, io_40, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 62, StringSetChar("", 0, '5'), "Webdings", io_44);
            break;
        case 63:
            bs_60 = as_0;
            bs_68 = "Dntx";
            ggg_6(bs_60, 63, io_20, io_24, 1, 1, 0, io_48 + 1, io_40, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 63, StringSetChar("", 0, '6'), "Webdings", io_44);
            break;
        case 59:
            bs_60 = as_0;
            bs_68 = "Sltx";
            ggg_6(bs_60, 59, io_20, io_24, 1, 1, 0, io_48 + 1, io_40, io_52, io_56, as_8, io_44);
            ggg_2(bs_68, bs_60, 59, StringSetChar("", 0, 'a'), "Webdings", io_44);
            break;
        default:
            return (0);
    }
    return (1);
}

bool ggg_9(string as_0)
{
    int el_12;
    int el_16;
    string name_20;
    int el_28;
    for (int objs_total_8 = ObjectsTotal(); objs_total_8 >= 0; objs_total_8--)
    {
        name_20 = ObjectName(objs_total_8);
        el_28 = StringFind(name_20, as_0);
        if (el_28 >= 0)
        {
            if (el_28 != StringFind(name_20, "|") + 1)
            {
                el_12 = StringFind(name_20, "z_") + 2;
                emmo_156[4] = StrToInteger(StringSubstr(name_20, el_12, 1));
                emmo_156[9] = StrToInteger(StringGetChar(StringSubstr(name_20, el_12 + 3, 1), 0));
                el_12 = StringFind(name_20, ":c_") + 3;
                emmo_156[5] = StrToInteger(StringSubstr(name_20, el_12, 2));
                el_12 = StringFind(name_20, "lu_") + 3;
                el_16 = StringFind(name_20, "_", el_12);
                emmo_156[0] = StrToInteger(StringSubstr(name_20, el_12, el_16 - el_12));
                el_12 = StringFind(name_20, ":", el_16);
                emmo_156[1] = StrToInteger(StringSubstr(name_20, el_16 + 1, el_12 - el_16 + 1));
                el_12 = StringFind(name_20, "rd_") + 3;
                el_16 = StringFind(name_20, "_", el_12);
                emmo_156[2] = StrToInteger(StringSubstr(name_20, el_12, el_16 - el_12));
                el_12 = StringFind(name_20, ":", el_16);
                emmo_156[3] = StrToInteger(StringSubstr(name_20, el_16 + 1, el_12 - el_16 + 1));
                emmo_156[6] = ObjectGet(name_20, OBJPROP_CORNER);
                emmo_156[7] = ObjectGet(name_20, OBJPROP_COLOR);
                emmo_156[8] = ObjectFind(name_20);
                sg_148 = StringSubstr(name_20, StringFind(name_20, "|") + 1);
                return (1);
            }
        }
    }
    ArrayInitialize(emmo_156, -1);
    sg_148 = 0;
    return (0);
}

void ggg_3(string as_0)
{
    int el_12;
    int el_16;
    string name_28;
    string bs_unused_36;
    string bs_44;
    string esl_52[5000];
    string esl_56[5000];
    int el_64;
    int el_68;
    string bs_72;
    string bs_80;
    int el_60 = GetTickCount();
    for (int el_8 = ObjectsTotal() - 1; el_8 >= 0; el_8--)
    {
        name_28 = ObjectName(el_8);
        if (StringFind(name_28, "wnd:") >= 0)
        {
            if (StringFind(name_28, "#" + as_0) > 0)
            {
                ObjectDelete(name_28);
                continue;
            }
            if (StringFind(name_28, "|" + as_0) > 0)
            {
                el_64 = StringFind(name_28, "#") + 1;
                el_68 = StringFind(name_28, "|" + as_0) - el_64;
                esl_52[el_12] = StringSubstr(name_28, el_64, el_68);
                el_12++;
                ObjectDelete(name_28);
                continue;
            }
            esl_56[el_16] = name_28;
            el_16++;
        }
    }
    ArrayResize(esl_56, el_16);
    for (el_8 = 0; el_8 < el_12; el_8++)
    {
        bs_72 = "|" + esl_52[el_8];
        for (int index_20 = 0; index_20 < el_16; index_20++)
        {
            name_28 = esl_56[index_20];
            if (name_28 != "")
            {
                if (StringFind(name_28, bs_72) >= 0)
                {
                    el_64 = StringFind(name_28, "#") + 1;
                    el_68 = StringFind(name_28, bs_72) - el_64;
                    bs_80 = StringSubstr(name_28, el_64, el_68);
                    if (bs_44 != bs_80)
                    {
                        bs_44 = bs_80;
                        esl_52[el_12] = bs_44;
                        el_12++;
                    }
                    esl_56[index_20] = "";
                    ObjectDelete(name_28);
                }
            }
        }
    }
}

void ggg_8(string as_0, bool io_8 = TRUE)
{
    int objs_total_12 = 0;
    string name_16 = "";
    if (io_8)
    {
        for (objs_total_12 = ObjectsTotal(); objs_total_12 >= 0; objs_total_12--)
        {
            name_16 = ObjectName(objs_total_12);
            if (StringFind(name_16, as_0) >= 0)
                ObjectDelete(name_16);
        }
    }
    else
    {
        for (objs_total_12 = ObjectsTotal(); objs_total_12 >= 0; objs_total_12--)
        {
            name_16 = ObjectName(objs_total_12);
            if (StringFind(name_16, "#" + as_0) >= 0)
                ObjectDelete(name_16);
        }
    }
}

bool ggg_4(string as_0, int a_x_8, int a_y_12, string a_text_16 = "c", int a_fontsize_24 = 14,
    int a_corner_28 = 0, color a_color_32 = 0, int a_window_36 = 0,
    string a_fontname_40 = "Webdings", int a_angle_48 = FALSE)
{
    if (a_window_36 > WindowsTotal() - 1)
        a_window_36 = WindowsTotal() - 1;
    if (StringLen(as_0) < 1)
        return (FALSE);
    ObjectDelete(as_0);
    ObjectCreate(as_0, OBJ_LABEL, a_window_36, 0, 0);
    ObjectSet(as_0, OBJPROP_XDISTANCE, a_x_8);
    ObjectSet(as_0, OBJPROP_YDISTANCE, a_y_12);
    ObjectSet(as_0, OBJPROP_CORNER, a_corner_28);
    ObjectSet(as_0, OBJPROP_BACK, FALSE);
    ObjectSet(as_0, OBJPROP_ANGLE, a_angle_48);
    ObjectSetText(as_0, a_text_16, a_fontsize_24, a_fontname_40, a_color_32);
    return (TRUE);
}

void init()
{
    int el_4;
    string symbol_8;
    string bs_unused_16;
    string bs_24 = "";
    germ_color_216 = HandleBackGroundColor;
    germ_color_220 = DataTableBackGroundColor_1;
    germ_color_224 = DataTableBackGroundColor_2;
    germ_color_228 = CurrencysBackGroundColor;
    germ_color_236 = HandleTextColor;
    germ_color_240 = DataTableTextColor;
    germ_color_244 = CurrencysTextColor;
    germ_color_248 = TrendUpArrowsColor;
    germ_color_252 = TrendDownArrowsColor;
    for (int index_0 = 0; index_0 < 28; index_0++)
    {
        symbol_8 = wer_196[index_0];
        if (StringLen(SymbolPrefix) > 1)
        {
            egg_264 = TRUE;
            if (StringFind(SymbolPrefix, "|") == 0)
            {
                sg_256 = StringSubstr(SymbolPrefix, 1);
                symbol_8 = symbol_8 + sg_256;
                egg_268 = -StringLen(wer_196[index_0]);
            }
            if (StringFind(SymbolPrefix, "|") == StringLen(SymbolPrefix) - 1)
            {
                sg_256 = StringSubstr(SymbolPrefix, 0, StringFind(SymbolPrefix, "|"));
                symbol_8 = sg_256 + symbol_8;
                egg_268 = StringLen(sg_256) - 1;
            }
        }
        if (MarketInfo(symbol_8, MODE_POINT) == 0.0)
            bs_24 = bs_24 + ":" + wer_196[index_0];
        else
        {
            wer_204[el_4] = symbol_8;
            el_4++;
        }
    }
    ArrayResize(wer_204, el_4);
    if (UninitializeReason() != REASON_CHARTCHANGE)
    {
        if (bs_24 != "")
        {
            bs_24
                = "Some currency pairs are not available\n for calculating the indices.\n" + bs_24;
            bs_24 = bs_24 + "\nCalculation formula will be changed.";
            Alert(bs_24);
        }
    }
}

void deinit()
{
    string bs_unused_16;
    string bs_0 = "Curs";
    string bs_8 = "Pows";
    ggg_3("Header");
    ggg_3("Window");
    ggg_3(bs_0);
    ggg_3(bs_8);
}

void start()
{
    int el_20;
    int el_28;
    int color_32;
    int color_36;
    int el_40;
    double dll_44[8][2];
    string bs_unused_64;
    string bs_84;
    int el_unused_92;
    double dl_96;
    int el_24 = 4;
    string bs_48 = "Curs";
    string bs_unused_56 = "Pows";
    int el_unused_72 = 0;
    if (ShowCurrencies && (!CurrenciesWindowBelowTable))
    {
        ggg_11("Window", "", 30, 4, 18, 18, 1, 0, germ_color_216, germ_color_216, 0, 0, 0);
        ggg_11("Header", "", 30, 260, 18, 1, 1, 0, germ_color_216, germ_color_216, 0, 0, 0);
        ggg_2("hdTxt", "Window", 69, "Currency Meter Pro", "Courier new", germ_color_236, 0, 34, -2,
            0, 11);
    }
    else
    {
        ggg_11("Window", "", 30, 4, 18, 11, 1, 0, germ_color_216, germ_color_216, 0, 0, 0);
        ggg_2("hdTxt", "Window", 69, "Currency Meter Pro", "Courier new", germ_color_236, 0, 1, -2,
            0, 11);
    }
    int el_16 = 14;
    el_24 = 2;
    ArrayInitialize(dag_212, 0);
    int index_4 = ggg_0();
    if (ShowSymbolsSorted)
        ArraySort(dag_212, WHOLE_ARRAY, 0, MODE_DESCEND);
    int count_8 = 0;
    string bs_76 = "";
    for (int index_0 = 0; index_0 < index_4; index_0++)
    {
        el_40 = dag_212[index_0][1];
        if (StringFind(DontShowThisPairs, wer_196[index_0]) < 0)
        {
            if (count_8 % 2 != 0)
                color_36 = germ_color_220;
            else
                color_36 = germ_color_224;
            ggg_8("cWnd" + index_0);
            ggg_11("cWnd" + index_0, "Window", 30, 0, el_16 + el_24, 11, 1, 0, color_36, color_36,
                0, 0, 0);
            if (el_40 >= 0)
            {
                if (egg_264)
                {
                    if (egg_268 < 0)
                        bs_76 = StringSubstr(wer_204[el_40], 0, -egg_268);
                    else
                        bs_76 = StringSubstr(wer_204[el_40], egg_268);
                }
                else
                    bs_76 = wer_204[el_40];
            }
            else
                bs_76 = "LOADING";
            ggg_2(bs_76 + "wnd", "cWnd" + index_0, 69, bs_76, "Courier new", germ_color_240, 0, 4,
                -2, 0, 11);
            if (el_40 >= 0)
            {
                ggg_8(index_0 + "sLED");
                if (dag_212[index_0][0] < 0.0)
                {
                    el_28 = 2;
                    el_20 = -14;
                    color_32 = germ_color_252;
                    ggg_1(index_0 + "sLED", "Window", el_20 + 75, el_16 + 0 + el_24, 2, 0, el_28, 0,
                        100, -dag_212[index_0][0], color_32, color_36, color_36);
                    ggg_2(index_0 + "TrDn", "cWnd" + index_0, 69, StringSetChar("", 0, 'Ú'),
                        "Wingdings", color_32, 0, 99, -2, 0, 14);
                    if (dag_212[index_0][0] < -99.99)
                        ggg_2("strench", "cWnd" + index_0, 69, "-100", "Courier new",
                            germ_color_240, 0, 122, -1, 0, 10);
                    else
                        ggg_2("strench", "cWnd" + index_0, 69, DoubleToStr(dag_212[index_0][0], 1),
                            "Courier new", germ_color_240, 0, 122, -1, 0, 10);
                }
                else
                {
                    el_28 = 0;
                    el_20 = 14;
                    color_32 = germ_color_248;
                    ggg_1(index_0 + "sLED", "Window", el_20 + 75, el_16 + 0 + el_24, 2, 0, el_28, 0,
                        100, dag_212[index_0][0], color_32, color_36, color_36);
                    ggg_2(index_0 + "TrUp", "cWnd" + index_0, 69, StringSetChar("", 0, 'Ù'),
                        "Wingdings", color_32, 0, 65, -3, 0, 14);
                    if (dag_212[index_0][0] > 99.99)
                        ggg_2("strench", "cWnd" + index_0, 69, "100.0", "Courier new",
                            germ_color_240, 0, 122, -1, 0, 10);
                    else
                        ggg_2("strench", "cWnd" + index_0, 69, DoubleToStr(dag_212[index_0][0], 1),
                            "Courier new", germ_color_240, 0, 130, -1, 0, 10);
                }
            }
            el_24 += 16;
            count_8++;
        }
    }
    if (ShowCurrencies)
    {
        if (!CurrenciesWindowBelowTable)
        {
            el_20 = el_24;
            ggg_11(bs_48, "Window", 30, 166, 16, 7, 9, 0, germ_color_228, germ_color_228, 0, 0, 0);
            bs_84 = "Led" + index_0;
            el_unused_92 = emmo_208[index_0];
            el_24 = 0;
            for (index_4 = 0; index_4 < 8; index_4++)
            {
                dl_96 = ggg_5(wer_188[index_4]);
                dll_44[index_4][0] = dl_96;
                dll_44[index_4][1] = index_4;
            }
            if (ShowCurrenciesSorted)
                ArraySort(dll_44, WHOLE_ARRAY, 0, MODE_DESCEND);
            for (index_4 = 0; index_4 < 8; index_4++)
            {
                dl_96 = dll_44[index_4][0];
                el_40 = dll_44[index_4][1];
                ggg_2("CuCur" + index_4, bs_48, 69, wer_188[el_40], "Courier new", germ_color_244,
                    0, 5, el_24 + 0, 0, 11);
                ggg_2("CuDig" + index_4, bs_48, 69, DoubleToStr(dll_44[index_4][0], 1),
                    "Courier new", germ_color_244, 0, 78, el_24 + 1, 0, 10);
                ggg_1("sLED" + index_4, bs_48, 32, el_24 + 2, 3, 0, 0, 0, 10, dl_96, -1,
                    germ_color_228, germ_color_228);
                el_24 += 14;
            }
        }
        else
        {
            ggg_11(bs_48, "Window", 30, 0, el_24 + 14, 11, 6, 0, germ_color_228, germ_color_228, 0,
                0, 0);
            bs_84 = "Led" + index_0;
            el_unused_92 = emmo_208[index_0];
            el_24 = 0;
            for (index_4 = 0; index_4 < 8; index_4++)
            {
                dl_96 = ggg_5(wer_188[index_4]);
                dll_44[index_4][0] = dl_96;
                dll_44[index_4][1] = index_4;
            }
            if (ShowCurrenciesSorted)
                ArraySort(dll_44, WHOLE_ARRAY, 0, MODE_DESCEND);
            for (index_4 = 0; index_4 < 8; index_4++)
            {
                dl_96 = dll_44[index_4][0];
                el_40 = dll_44[index_4][1];
                ggg_2("CuCur" + index_4, bs_48, 69, wer_188[el_40], "Courier new", germ_color_244,
                    0, el_24 + 3, 76, 0, 12, 0, 0, 90);
                ggg_1("sLED" + index_4, bs_48, el_24 + 1, 0, 2, 1, 1, 0, 10, dl_96, -1,
                    germ_color_228, germ_color_228);
                el_24 += 20;
            }
        }
    }
    WindowRedraw();
}

int ggg_0()
{
    double ihigh_24;
    double ilow_32;
    double iopen_40;
    double iclose_48;
    double point_56;
    double dl_64;
    double dl_72;
    int el_unused_4 = 0;
    int timeframe_12 = 1440;
    string symbol_16 = "";
    int arr_size_8 = ArraySize(wer_204);
    ArrayResize(dag_212, arr_size_8);
    for (int index_0 = 0; index_0 < arr_size_8; index_0++)
    {
        symbol_16 = wer_204[index_0];
        point_56 = MarketInfo(symbol_16, MODE_POINT);
        if (point_56 == 0.0)
        {
            init();
            dag_212[index_0][1] = -1;
        }
        else
        {
            ihigh_24 = iHigh(symbol_16, timeframe_12, 0);
            ilow_32 = iLow(symbol_16, timeframe_12, 0);
            iopen_40 = iOpen(symbol_16, timeframe_12, 0);
            iclose_48 = iClose(symbol_16, timeframe_12, 0);
            if (iopen_40 > iclose_48)
            {
                dl_64 = (ihigh_24 - ilow_32) * point_56;
                if (dl_64 == 0.0)
                {
                    init();
                    dag_212[index_0][1] = -1;
                    continue;
                }
                dl_72 = (ihigh_24 - iclose_48) / dl_64 * point_56 / (-0.01);
            }
            else
            {
                dl_64 = (ihigh_24 - ilow_32) * point_56;
                if (dl_64 == 0.0)
                {
                    init();
                    dag_212[index_0][1] = -1;
                    continue;
                }
                dl_72 = 100.0 * ((iclose_48 - ilow_32) / dl_64 * point_56);
            }
            dag_212[index_0][0] = dl_72;
            dag_212[index_0][1] = index_0;
            dag_212[index_0][2] = 1;
        }
    }
    return (arr_size_8);
}

double ggg_5(string as_0)
{
    double point_20;
    int el_36;
    string bs_40;
    double dl_48;
    double dl_56;
    int count_8 = 0;
    double dl_ret_12 = 0;
    int timeframe_28 = 1440;
    for (int index_32 = 0; index_32 < ArraySize(wer_204); index_32++)
    {
        el_36 = 0;
        bs_40 = wer_204[index_32];
        if (as_0 == StringSubstr(bs_40, 0, 3) || as_0 == StringSubstr(bs_40, 3, 3))
        {
            point_20 = MarketInfo(bs_40, MODE_POINT);
            if (point_20 == 0.0)
            {
                init();
                continue;
            }
            dl_48 = (iHigh(bs_40, timeframe_28, 0) - iLow(bs_40, timeframe_28, 0)) * point_20;
            if (dl_48 == 0.0)
            {
                init();
                continue;
            }
            dl_56 = 100.0
                * ((MarketInfo(bs_40, MODE_BID) - iLow(bs_40, timeframe_28, 0)) / dl_48 * point_20);
            if (dl_56 > 3.0)
                el_36 = 1;
            if (dl_56 > 10.0)
                el_36 = 2;
            if (dl_56 > 25.0)
                el_36 = 3;
            if (dl_56 > 40.0)
                el_36 = 4;
            if (dl_56 > 50.0)
                el_36 = 5;
            if (dl_56 > 60.0)
                el_36 = 6;
            if (dl_56 > 75.0)
                el_36 = 7;
            if (dl_56 > 90.0)
                el_36 = 8;
            if (dl_56 > 97.0)
                el_36 = 9;
            count_8++;
            if (as_0 == StringSubstr(bs_40, 3, 3))
                el_36 = 9 - el_36;
            dl_ret_12 += el_36;
        }
    }
    if (count_8 > 0)
        dl_ret_12 /= count_8;
    else
        dl_ret_12 = 0;
    return (dl_ret_12);
}
