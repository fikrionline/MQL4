//+---------------------------------------------------------------------------+
//|            ___  ___      _ _   _ _____             _                      |
//|            |  \/  |     | | | (_)_   _|           | |                     |
//|            | .  . |_   _| | |_ _  | |_ __ __ _  __| | ___ _ __            |
//|            | |\/| | | | | | __| | | | '__/ _` |/ _` |/ _ \ '__|           |
//|            | |  | | |_| | | |_| | | | | | (_| | (_| |  __/ |              |
//|            \_|  |_/\__,_|_|\__|_| \_/_|  \__,_|\__,_|\___|_|              |
//|                                                                           |
//| Open-source software (OSS)                                MultiTrader.mq4 |
//| Provided free of charge           Copyright © 2019, MhFx7 <> Mani Heshmat |
//| By MhFx7 <> Mani Heshmat              https://www.mql5.com/en/users/mhfx7 |
//+---------------------------------------------------------------------------+
#define Copyright          "Copyright © 2019, MhFx7 <> Mani Heshmat"
#property copyright        Copyright
#define Link               "https://www.mql5.com/en/users/mhfx7"
#property link             Link
#define Version            "1.00"
#property version          Version
#property strict
//---
#define ExpertName         "Bismillahirrohmanirrohim"
#define OBJPREFIX          "MT-"
//---
#property description      "Warning: The automatically generated lot size is an estimated value and should not be considered accurate, note that this feature always requires a stoploss distance.\n"
#property description      "Note: All displayed values symbolized with a \"p\" as well as all input distances are in points.\n"
#property description      "This software is provided free of charge and can be downloaded under the following link:"
#property description      "https://www.mql5.com/en/code/24786"
//---
#define CLIENT_BG_WIDTH    1190
#define INDENT_TOP         15
//---
#define OPENPRICE          0
#define CLOSEPRICE         1
//---
#define OP_ALL            -1
//---
#define KEY_UP             38 
#define KEY_DOWN           40 
//---
enum ENUM_TF{DAILY/*Daily*/,WEEKLY/*Weekly*/,MONTHLY/*Monthly*/};
enum ENUM_MODE{FULL/*Full*/,COMPACT/*Compact*/,MINI/*Mini*/};
//--- User inputs
input string  ="                    < - - -  General  - - - >";
input ENUM_MODE SelectedMode  = COMPACT;/*Dashboard (Size)*/
input ENUM_TF CalcPeriod      = DAILY;/*Time Frame*/
input int BuyLevel            = 90;//High Level %
input int SellLevel           = 10;//Low Level %
input string Prefix           = "";//Symbol Prefix
input string Suffix           = "";//Symbol Suffix
extern string TradeSymbols    = "AUDCAD;AUDCHF;AUDJPY;AUDNZD;AUDUSD;CADCHF;CADJPY;CHFJPY;EURAUD;EURCAD;EURCHF;EURGBP;EURJPY;EURNZD;EURUSD;GBPAUD;GBPCAD;GBPCHF;GBPNZD;GBPUSD;GBPJPY;NZDCHF;NZDCAD;NZDJPY;NZDUSD;USDCAD;USDCHF;USDJPY;XAUUSD;US30.cash;";/*Symbol List (separated by " ; ")*/
input string                  = "                    < - - -  Trading  - - - >";
input bool OneClickTrading    = true;/*One-Click Trading*/
input int MagicNumber         = 0;//Magic Number
input int Slippage            = 3;//Slippage
input bool KeyboardTrading    = true;/*Keyboard Trading*/
input string BuyKey           = "B";/*Buy Key*/
input string CloseKey         = "C";/*Close Key*/
input string SellKey          = "S";/*Sell Key*/
input string                  = "                    < - - -  AutoSL  - - - >";
input ENUM_TIMEFRAMES ATRTF   = PERIOD_H1;/*ATR Time Frame*/
input int ATRPeriod           = 14;/*ATR Period*/
extern double ATRMulti        = 1;/*ATR Multiplier*/
input string                  = "                    < - - -  Alerts  - - - >";
input bool PairSuggest        = true;/*Suggestions*/
input bool SmartAlert         = true;/*Smart Alerts*/
input bool _Alert             = true;/*Pop-ups*/
input bool Push               = false;/*Push*/
input bool Mail               = false;/*Email*/
input string                  = "                    < - - -  Graphics  - - - >";
input color COLOR_BORDER      = C'255,151,25';/*Panel Border*/
input color COLOR_CBG_LIGHT   = C'252,252,252';/*Chart Background (Light)*/
input color COLOR_CBG_DARK    = C'28,27,26';/*Chart Background (Dark)*/
//--- Global variables
string sTradeSymbols          = TradeSymbols;
string sFontType              = "";
//---
double RiskP                  = 0;
double RiskC                  = 0;
double RiskInpC               = 0;
double RiskInpP               = 0;
//---
int ResetAlertUp              = 0;
int ResetAlertDwn             = 0;
bool UserIsEditing            = false;
bool UserWasNotified          = false;
//---
double StopLossDist           = 0;
double RiskInp                = 0;
double RR                     = 0;
double _TP                    = 0;
//---
int SelectedTheme             = 0;
int PriceRowLeft              = 0;
int PriceRowRight             = 0;
bool ShowTradePanel           = true;
//---
int ErrorInterval             = 300;
int LastReason                = 0;
string ErrorSound             = "error.wav";
bool SoundIsEnabled           = false;
bool AlarmIsEnabled           = false;
int ProfitMode                = 0;
//---
bool AUDAlarm                 = true;
bool CADAlarm                 = true;
bool CHFAlarm                 = true;
bool EURAlarm                 = true;
bool GBPAlarm                 = true;
bool JPYAlarm                 = true;
bool NZDAlarm                 = true;
bool USDAlarm                 = true;
//---
bool AUDTrigger               = false;
bool CADTrigger               = false;
bool CHFTrigger               = false;
bool EURTrigger               = false;
bool GBPTrigger               = false;
bool JPYTrigger               = false;
bool NZDTrigger               = false;
bool USDTrigger               = false;
//----
string SuggestedPair          = "";
int LastTimeFrame             = 0;
int LastMode                  = -1;
//--- 
bool AutoSL                   = false;
bool AutoTP                   = false;
bool AutoLots                 = false;
bool ClearedTemplate          = false;
bool FirstRun                 = true;
//---
color COLOR_BG                = clrNONE;
color COLOR_FONT              = clrNONE;
//---
color COLOR_GREEN             = clrForestGreen;
color COLOR_RED               = clrFireBrick;
color COLOR_SELL              = C'225,68,29';
color COLOR_BUY               = C'3,95,172';
color COLOR_CLOSE             = clrNONE;
color COLOR_AUTO              = clrDodgerBlue;
color COLOR_LOW               = clrNONE;
color COLOR_MARKER            = clrNONE;
int FONTSIZE                  = 9;
//---
int _x1                       = 0;
int _y1                       = 0;
int ChartX                    = 0;
int ChartY                    = 0;
int Chart_XSize               = 0;
int Chart_YSize               = 0;
int CalcTF                    = 0;
datetime drop_time            = 0;
datetime stauts_time          = 0;
//---
color COLOR_REGBG             = C'27,27,27';
color COLOR_REGFONT           = clrSilver;
//---
int Bck_Win_X                 = 255;
int Bck_Win_Y                 = 150;
//---
string aSymbols[];
string UsedSymbols[];
//---
string MB_CAPTION=ExpertName+" v"+Version+" | "+Copyright;
//---
string PriceRowLeftArr[]={"Bid","Low","Open","Pivot"};
string PriceRowRightArr[]={"Ask","High","Open","Pivot"};
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---- CreateTimer
   EventSetMillisecondTimer(100);

//--- StrategyTester
   if(MQLInfoInteger(MQL_TESTER))
     {
      _OnTester();
      return(INIT_SUCCEEDED);
     }

//--- Disclaimer
   if(!GlobalVariableCheck(OBJPREFIX+"Disclaimer") || GlobalVariableGet(OBJPREFIX+"Disclaimer")!=1)
     {
      //---
      string message="DISCLAIMER:\n\nIf you trade with MultiTrader, you are doing so at your own discretion. Forex is a risky business. You may lose a substantial amount of money by taking the risk of live trading. The author of MultiTrader and/or MhFx7 <> Mani Heshmat will not be held responsible for your losses or problems of any kind if the EA is directly or indirectly responsible for any losses.";
      //---
      if(MessageBox(message,MB_CAPTION,MB_OKCANCEL|MB_ICONWARNING)==IDOK)
         GlobalVariableSet(OBJPREFIX+"Disclaimer",1);
      else
         return(INIT_FAILED);
     }

//---
   if(!GlobalVariableCheck(OBJPREFIX+"Theme"))
      SelectedTheme=1;
   else
      SelectedTheme=(int)GlobalVariableGet(OBJPREFIX+"Theme");

//---
   if(SelectedTheme==0)
     {
      COLOR_BG=C'240,240,240';
      COLOR_FONT=C'40,41,59';
      COLOR_GREEN=clrForestGreen;
      COLOR_RED=clrIndianRed;
      COLOR_LOW=clrGoldenrod;
      COLOR_MARKER=clrDarkOrange;
     }
   else
     {
      COLOR_BG=C'28,28,28';
      COLOR_FONT=clrSilver;
      COLOR_GREEN=clrLimeGreen;
      COLOR_RED=clrRed;
      COLOR_LOW=clrYellow;
      COLOR_MARKER=clrGold;
     }

//---
   if(LastReason==0)
     {

      //--- OfflineChart
      if(ChartGetInteger(0,CHART_IS_OFFLINE))
        {
         MessageBox("The currenct chart is offline, make sure to uncheck \"Offline chart\" under Properties(F8)->Common.",
                    MB_CAPTION,MB_OK|MB_ICONERROR);
         return(INIT_FAILED);
        }

      //--- CheckConnection
      if(!TerminalInfoInteger(TERMINAL_CONNECTED))
         MessageBox("Warning: No Internet connection found!\nPlease check your network connection.",
                    MB_CAPTION+" | "+"#"+IntegerToString(123),MB_OK|MB_ICONWARNING);

      //--- CheckTradingIsAllowed
      if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))//Terminal
        {
         MessageBox("Warning: Check if automated trading is allowed in the terminal settings!",
                    MB_CAPTION+" | "+"#"+IntegerToString(123),MB_OK|MB_ICONWARNING);
        }
      else
        {
         if(!MQLInfoInteger(MQL_TRADE_ALLOWED))//CheckBox
           {
            MessageBox("Warning: Automated trading is forbidden in the program settings for "+__FILE__,
                       MB_CAPTION+" | "+"#"+IntegerToString(123),MB_OK|MB_ICONWARNING);
           }
        }

      //---
      if(!AccountInfoInteger(ACCOUNT_TRADE_EXPERT))//Server
         MessageBox("Warning: Automated trading is forbidden for the account "+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+" at the trade server side.",
                    MB_CAPTION+" | "+"#"+IntegerToString(123),MB_OK|MB_ICONWARNING);

      //---
      if(!AccountInfoInteger(ACCOUNT_TRADE_ALLOWED))//Investor
         MessageBox("Warning: Trading is forbidden for the account "+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+"."+
                    "\n\nPerhaps an investor password has been used to connect to the trading account."+
                    "\n\nCheck the terminal journal for the following entry:"+
                    "\n\'"+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+"\': trading has been disabled - investor mode.",
                    MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_DISABLED),MB_OK|MB_ICONWARNING);

      //---
      if(!SymbolInfoInteger(_Symbol,SYMBOL_TRADE_MODE))//Symbol
         MessageBox("Warning: Trading is disabled for the symbol "+_Symbol+" at the trade server side.",
                    MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_DISABLED),MB_OK|MB_ICONWARNING);

      //--- CheckDotsPerInch
      if(TerminalInfoInteger(TERMINAL_SCREEN_DPI)!=96)
        {
         Comment("Warning: 96 DPI highly recommended !");
         Sleep(3000);
         Comment("");
        }

     }

//--- Check for Symbols (Analysis)
   for(int i=0; i<ArraySize(Symbols); i++)
     {
      //---
      if(!SymbolFind(Prefix+Symbols[i]+Suffix,true))
         if(SymbolFind(Prefix+Symbols[i]+Suffix,false))
            SymbolSelect(Prefix+Symbols[i]+Suffix,true);
     }

//--- Input Symbols Changed
   if(sTradeSymbols!=TradeSymbols || LastReason==0)
     {
      //---
      ArrayResize(aSymbols,0,0);
      ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
      //--- Get Trade Symobols
      if(StringFind(TradeSymbols,";",0)==-1)
        {
         //---
         string message="No separator found !\nMake sure to separate symbols with a semicolon \" ; \".";
         //---
         MessageBox(message,MB_CAPTION,MB_OK|MB_ICONERROR);
         Comment(message);
         //---
         ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
         return(INIT_FAILED);
        }

      //--- Semicolon at the first place
      if(StringFind(TradeSymbols,";",0)==0)
         TradeSymbols=StringSubstr(TradeSymbols,1,StringLen(TradeSymbols));

      //---
      TradeSymbols=StringTrimLeft(StringTrimRight(TradeSymbols));

      //---
      if(StringSubstr(TradeSymbols,StringLen(TradeSymbols)-1,1)!=";")
         TradeSymbols=StringConcatenate(TradeSymbols,";");

      //---
      int s=0,k=StringFind(TradeSymbols,";",s);
      string current;

      //---
      while(k>0)
        {
         //---
         current=StringSubstr(TradeSymbols,s,k-s);
         //---
         if(SymbolFind(Prefix+current+Suffix,false))
           {
            ArrayResize(aSymbols,ArraySize(aSymbols)+1);
            aSymbols[ArraySize(aSymbols)-1]=current;
           }
         //---
         s=k+1;
         k=StringFind(TradeSymbols,";",s);
        }

      //--- Check for Symbols (Trading)
      for(int i=0; i<ArraySize(aSymbols); i++)
        {
         //---
         if(!SymbolFind(Prefix+aSymbols[i]+Suffix,true))
            if(SymbolFind(Prefix+aSymbols[i]+Suffix,false))
               SymbolSelect(Prefix+aSymbols[i]+Suffix,true);
        }
      //---
      sTradeSymbols=TradeSymbols;
     }

//--- InitFullSymbs
   SetFull();

//--- Check for Currency Pairs
   for(int i=0; i<ArraySize(UsedSymbols); i++)
     {
      //---
      if(!SymbolFind(Prefix+UsedSymbols[i]+Suffix,true))
        {
         //---
         if(LastReason==0)
           {
            //---
            string message="All 28 currency pairs are not available !\nPerhaps the Prefix and/or Suffix were not set correctly.";
            //---
            MessageBox(message,MB_CAPTION,MB_OK|MB_ICONERROR);
           }
         //---
         ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
         break;
         return(INIT_FAILED);
        }
     }

//--- Calc Timeframe
   if(CalcPeriod==DAILY)
     {
      CalcTF=PERIOD_D1;
      ProfitMode=1;
      ResetAlertUp=BuyLevel-15;
      ResetAlertDwn=SellLevel+15;
     }
//---
   if(CalcPeriod==WEEKLY)
     {
      CalcTF=PERIOD_W1;
      ProfitMode=2;
      ResetAlertUp=BuyLevel-10;
      ResetAlertDwn=SellLevel+10;
     }
//---
   if(CalcPeriod==MONTHLY)
     {
      CalcTF=PERIOD_MN1;
      ProfitMode=3;
      ResetAlertUp=BuyLevel-5;
      ResetAlertDwn=SellLevel+5;
     }

//--- Reset Alarms
   if(CalcTF!=LastTimeFrame)
     {
      AUDAlarm=true;
      CADAlarm=true;
      CHFAlarm=true;
      EURAlarm=true;
      GBPAlarm=true;
      JPYAlarm=true;
      NZDAlarm=true;
      USDAlarm=true;
      LastTimeFrame=CalcTF;
     }

//--- CheckData
   if(TerminalInfoInteger(TERMINAL_CONNECTED) && (LastReason==0 || LastReason==REASON_PARAMETERS))
     {
      //---
      ResetLastError();
      //---
      for(int i=0; i<ArraySize(UsedSymbols); i++)
        {
         //---
         double test=iHigh(Prefix+UsedSymbols[i]+Suffix,CalcTF,0);
         //---
         if(test==0)
           {
            //---
            for(int a=0;a<10; a++)
              {
               //---
               Comment("Loading Data...");
               Sleep(1);
               //---
               double _High=iHigh(Prefix+UsedSymbols[i]+Suffix,CalcTF,0);
               double _Low=iLow(Prefix+UsedSymbols[i]+Suffix,CalcTF,0);
               double _Close=iClose(Prefix+UsedSymbols[i]+Suffix,CalcTF,0);
               //---
               double _Bid=SymbolInfoDouble(Prefix+UsedSymbols[i]+Suffix,SYMBOL_BID);
               double _Ask=SymbolInfoDouble(Prefix+UsedSymbols[i]+Suffix,SYMBOL_ASK);
               //---
               if(_High!=0 && _Low!=0 && _Close!=0 && _Bid!=0 && _Ask!=0)
                  break;
              }
           }
        }
      //---
      Comment("");
     }

//--- Init ChartSize
   Chart_XSize = (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
   Chart_YSize = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
   ChartX=Chart_XSize;
   ChartY=Chart_YSize;

//--- CheckSoundIsEnabled
   if(!GlobalVariableCheck(OBJPREFIX+"Sound"))
      SoundIsEnabled=true;
   else
      SoundIsEnabled=GlobalVariableGet(OBJPREFIX+"Sound");

//--- Alert
   if(!GlobalVariableCheck(OBJPREFIX+"Alarm"))
      AlarmIsEnabled=true;
   else
      AlarmIsEnabled=GlobalVariableGet(OBJPREFIX+"Alarm");

   if(!_Alert && !Push && !Mail)
     {
      //---
      AlarmIsEnabled=false;
      //---
      if(ObjectFind(0,OBJPREFIX+"ALARMIO")==0)
         if(ObjectGetInteger(0,OBJPREFIX+"ALARMIO",OBJPROP_COLOR)!=C'59,41,40')
            ObjectSetInteger(0,OBJPREFIX+"ALARMIO",OBJPROP_COLOR,C'59,41,40');
     }

//---
   if(!GlobalVariableCheck(OBJPREFIX+"Dashboard"))
      ShowTradePanel=true;
   else
      ShowTradePanel=GlobalVariableGet(OBJPREFIX+"Dashboard");

//--- Automated SL&TP&Lots
   if(!GlobalVariableCheck(OBJPREFIX+"AutoSL"))
      AutoSL=false;
   else
      AutoSL=GlobalVariableGet(OBJPREFIX+"AutoSL");

//---
   if(!GlobalVariableCheck(OBJPREFIX+"AutoTP"))
      AutoTP=false;
   else
      AutoTP=GlobalVariableGet(OBJPREFIX+"AutoTP");

//---
   if(!GlobalVariableCheck(OBJPREFIX+"AutoLots"))
      AutoLots=false;
   else
      AutoLots=GlobalVariableGet(OBJPREFIX+"AutoLots");

//---
   if(!GlobalVariableCheck(OBJPREFIX+"Risk"))
      RiskInp=0.25;
   else
      RiskInp=GlobalVariableGet(OBJPREFIX+"Risk");

//---
   if(!GlobalVariableCheck(OBJPREFIX+"RR"))
      RR=2;
   else
      RR=GlobalVariableGet(OBJPREFIX+"RR");

//---
   PriceRowLeft=(int)GlobalVariableGet(OBJPREFIX+"PRL");
   PriceRowRight=(int)GlobalVariableGet(OBJPREFIX+"PRR");

//---
   if(LastReason==0)
      ChartGetColor();

//--- Hide OneClick Arrow
   ChartSetInteger(0,CHART_SHOW_ONE_CLICK,true);
   ChartSetInteger(0,CHART_SHOW_ONE_CLICK,false);

//--- ChartChanged
   if(LastReason==REASON_CHARTCHANGE)
      _PlaySound("switch.wav");

//---
   if(ShowTradePanel)
      ChartMouseScrollSet(false);
   else
      ChartMouseScrollSet(true);

//---
   if(ATRMulti<=0)
      ATRMulti=0.01;

//---
   if(SelectedMode!=LastMode)
      ObjectsDeleteAll(0,OBJPREFIX,-1,-1);

//--- Init Speed Prices
   for(int i=ArraySize(aSymbols)-1; i>=0; i--)
      GlobalVariableSet(OBJPREFIX+Prefix+aSymbols[i]+Suffix+" - Price",(SymbolInfoDouble(Prefix+aSymbols[i]+Suffix,SYMBOL_ASK)+SymbolInfoDouble(Prefix+aSymbols[i]+Suffix,SYMBOL_BID))/2);

//--- Animation
   if(LastReason==0 && ShowTradePanel)
     {
      //---
      ObjectsCreateAll();
      ObjectSetInteger(0,OBJPREFIX+"PRICEROW_Lª",OBJPROP_COLOR,clrNONE);
      ObjectSetInteger(0,OBJPREFIX+"PRICEROW_Rª",OBJPROP_COLOR,clrNONE);
      //---
      SetStatus("6","Please wait...");
      //---
      for(int i=ArraySize(aSymbols)-1; i>=0; i--)
        {
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL§"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL%"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,OBJPREFIX+"RANGE₱"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,OBJPREFIX+"RANGE%"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,OBJPREFIX+"POINTS"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,OBJPREFIX+"PROFITS"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,OBJPREFIX+"RETURN"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,OBJPREFIX+"ASK"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,OBJPREFIX+"BID"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,OBJPREFIX+"OPENLOTS"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,OBJPREFIX+"SPREAD"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,clrNONE);
        }
      //---
      for(int i=ArraySize(aSymbols)-1; i>=0; i--)
        {
         //---
         for(int x=(10)-1; x>=0; x--)
           {
            //--- SetObjects
            ObjectSetInteger(0,OBJPREFIX+"SPEED#"+" - "+Prefix+aSymbols[i]+Suffix+IntegerToString(x,0,0),OBJPROP_COLOR,COLOR_FONT);
            ObjectSetInteger(0,OBJPREFIX+"SYMBOL%"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,COLOR_FONT);
            ObjectSetString(0,OBJPREFIX+"RANGE%"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT,IntegerToString(MathAbs((x-10)*10))+"%");
            ObjectSetInteger(0,OBJPREFIX+"RANGE%"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,COLOR_FONT);
            ObjectSetString(0,OBJPREFIX+"SYMBOL%"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT,"Loading...");
            ObjectSetInteger(0,OBJPREFIX+"POINTS"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,COLOR_FONT);
            ObjectSetInteger(0,OBJPREFIX+"PROFITS"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,COLOR_FONT);
            ObjectSetInteger(0,OBJPREFIX+"RETURN"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,COLOR_FONT);
            ObjectSetInteger(0,OBJPREFIX+"ASK"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,COLOR_FONT);
            ObjectSetString(0,OBJPREFIX+"ASK"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT,"Ready !");
            ObjectSetInteger(0,OBJPREFIX+"BID"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,COLOR_FONT);
            ObjectSetString(0,OBJPREFIX+"BID"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT,"Check");
            ObjectSetInteger(0,OBJPREFIX+"OPENLOTS"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,COLOR_FONT);
            ObjectSetInteger(0,OBJPREFIX+"SPREAD"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,COLOR_FONT);
            //---
            Comment("");
            Sleep(1);
           }
        }
      //---
      for(int i=1; i<11; i++)
        {
         ObjectSetInteger(0,OBJPREFIX+"PB#"+IntegerToString(i)+" - "+"AUD",OBJPROP_COLOR,COLOR_FONT);
         ObjectSetInteger(0,OBJPREFIX+"PB#"+IntegerToString(i)+" - "+"CAD",OBJPROP_COLOR,COLOR_FONT);
         ObjectSetInteger(0,OBJPREFIX+"PB#"+IntegerToString(i)+" - "+"CHF",OBJPROP_COLOR,COLOR_FONT);
         ObjectSetInteger(0,OBJPREFIX+"PB#"+IntegerToString(i)+" - "+"EUR",OBJPROP_COLOR,COLOR_FONT);
         ObjectSetInteger(0,OBJPREFIX+"PB#"+IntegerToString(i)+" - "+"GBP",OBJPROP_COLOR,COLOR_FONT);
         ObjectSetInteger(0,OBJPREFIX+"PB#"+IntegerToString(i)+" - "+"JPY",OBJPROP_COLOR,COLOR_FONT);
         ObjectSetInteger(0,OBJPREFIX+"PB#"+IntegerToString(i)+" - "+"NZD",OBJPROP_COLOR,COLOR_FONT);
         ObjectSetInteger(0,OBJPREFIX+"PB#"+IntegerToString(i)+" - "+"USD",OBJPROP_COLOR,COLOR_FONT);
         //---
         ObjectSetString(0,OBJPREFIX+"AUD%",OBJPROP_TEXT,IntegerToString(MathAbs((i)*10))+"%");
         ObjectSetString(0,OBJPREFIX+"CAD%",OBJPROP_TEXT,IntegerToString(MathAbs((i)*10))+"%");
         ObjectSetString(0,OBJPREFIX+"CHF%",OBJPROP_TEXT,IntegerToString(MathAbs((i)*10))+"%");
         ObjectSetString(0,OBJPREFIX+"EUR%",OBJPROP_TEXT,IntegerToString(MathAbs((i)*10))+"%");
         ObjectSetString(0,OBJPREFIX+"GBP%",OBJPROP_TEXT,IntegerToString(MathAbs((i)*10))+"%");
         ObjectSetString(0,OBJPREFIX+"JPY%",OBJPROP_TEXT,IntegerToString(MathAbs((i)*10))+"%");
         ObjectSetString(0,OBJPREFIX+"NZD%",OBJPROP_TEXT,IntegerToString(MathAbs((i)*10))+"%");
         ObjectSetString(0,OBJPREFIX+"USD%",OBJPROP_TEXT,IntegerToString(MathAbs((i)*10))+"%");
         //---
         Comment("");
         Sleep(50);
        }
      //---
      for(int i=0; i<ArraySize(aSymbols); i++)
        {
         //--- UpdateObjects
         ObjectsUpdateAll(Prefix+aSymbols[i]+Suffix);
         //--- Get Currencies
         double AUD=AUD(),CAD=CAD(),CHF=CHF(),EUR=EUR(),GBP=GBP(),JPY=JPY(),NZD=NZD(),USD=USD();
         //---
         UpdateProBar("AUD",AUD);
         UpdatePercent("AUD",AUD);
         UpdateProBar("CAD",CAD);
         UpdatePercent("CAD",CAD);
         UpdateProBar("CHF",CHF);
         UpdatePercent("CHF",CHF);
         UpdateProBar("EUR",EUR);
         UpdatePercent("EUR",EUR);
         UpdateProBar("GBP",GBP);
         UpdatePercent("GBP",GBP);
         UpdateProBar("JPY",JPY);
         UpdatePercent("JPY",JPY);
         UpdateProBar("NZD",NZD);
         UpdatePercent("NZD",NZD);
         UpdateProBar("USD",USD);
         UpdatePercent("USD",USD);
         //---
         GlobalVariableSet(OBJPREFIX+Prefix+aSymbols[i]+Suffix+" - Price",(SymbolInfoDouble(Prefix+aSymbols[i]+Suffix,SYMBOL_ASK)+SymbolInfoDouble(Prefix+aSymbols[i]+Suffix,SYMBOL_BID))/2);
         //---
         for(int x=0; x<(10); x++)
           {
            //---
            double percent=StringToDouble(ObjectGetString(0,OBJPREFIX+"SYMBOL%"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT));
            //---
            ObjectSetInteger(0,OBJPREFIX+"SPEED#"+" - "+Prefix+aSymbols[i]+Suffix+IntegerToString(x,0,0),OBJPROP_COLOR,±ClrBR(percent));
           }
         ObjectSetInteger(0,OBJPREFIX+"PRICEROW_Lª",OBJPROP_COLOR,COLOR_FONT);
         ObjectSetInteger(0,OBJPREFIX+"PRICEROW_Rª",OBJPROP_COLOR,COLOR_FONT);
         ObjectSetInteger(0,OBJPREFIX+"RANGE₱"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_COLOR,COLOR_FONT);
         //---
         Comment("");
         Sleep(50);
        }

      //---
      ResetStatus();
      //---
     }

//---
   FirstRun=false;

//--- Dropped Time
   drop_time=TimeLocal();

//--- Border Color
   if(ShowTradePanel)
     {
      //---
      if(ObjectFind(0,OBJPREFIX+"BORDER[]")==0 || ObjectFind(0,OBJPREFIX+"BCKGRND[]")==0)
        {
         //---
         if(ObjectGetInteger(0,OBJPREFIX+"BORDER[]",OBJPROP_COLOR)!=COLOR_BORDER)
           {
            ObjectSetInteger(0,OBJPREFIX+"BORDER[]",OBJPROP_COLOR,COLOR_BORDER);
            ObjectSetInteger(0,OBJPREFIX+"BORDER[]",OBJPROP_BGCOLOR,COLOR_BORDER);
            ObjectSetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_COLOR,COLOR_BORDER);
           }
        }
     }
//---
   if(!ShowTradePanel)
     {
      //---
      if(ObjectFind(0,OBJPREFIX+"MIN"+"BCKGRND[]")==0)
        {
         //---
         if(ObjectGetInteger(0,OBJPREFIX+"MIN"+"BCKGRND[]",OBJPROP_COLOR)!=COLOR_BORDER)
           {
            ObjectSetInteger(0,OBJPREFIX+"MIN"+"BCKGRND[]",OBJPROP_COLOR,COLOR_BORDER);
            ObjectSetInteger(0,OBJPREFIX+"MIN"+"BCKGRND[]",OBJPROP_BGCOLOR,COLOR_BORDER);
           }
        }
     }
//----
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---- DestroyTimer
   EventKillTimer();

//--- Save global variables
   if(reason!=REASON_INITFAILED && !MQLInfoInteger(MQL_TESTER))
     {
      //---
      for(int i=0; i<ArraySize(aSymbols); i++)
        {
         //---
         GlobalVariableDel(Prefix+aSymbols[i]+Suffix+" - Price");
         //---
         if(ShowTradePanel)
           {
            GlobalVariableSet(OBJPREFIX+Prefix+aSymbols[i]+Suffix+" - Stoploss",StringToDouble(ObjectGetString(0,OBJPREFIX+"SL<>"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT)));
            GlobalVariableSet(OBJPREFIX+Prefix+aSymbols[i]+Suffix+" - Takeprofit",StringToDouble(ObjectGetString(0,OBJPREFIX+"_TP<>"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT)));
            GlobalVariableSet(OBJPREFIX+Prefix+aSymbols[i]+Suffix+" - Lotsize",StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT)));
           }
        }
      //---
      if(ShowTradePanel)
        {
         GlobalVariableSet(OBJPREFIX+"Stoploss",StringToDouble(ObjectGetString(0,OBJPREFIX+"SL<>",OBJPROP_TEXT)));
         GlobalVariableSet(OBJPREFIX+"Takeprofit",StringToDouble(ObjectGetString(0,OBJPREFIX+"_TP<>",OBJPROP_TEXT)));
         GlobalVariableSet(OBJPREFIX+"Lotsize",StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT)));
        }
      //---
      GlobalVariableSet(OBJPREFIX+"Theme",SelectedTheme);
      //---
      GlobalVariableSet(OBJPREFIX+"Dashboard",ShowTradePanel);
      //---
      GlobalVariableSet(OBJPREFIX+"Sound",SoundIsEnabled);
      //---
      GlobalVariableSet(OBJPREFIX+"Alarm",AlarmIsEnabled);
      //---
      GlobalVariableSet(OBJPREFIX+"AutoSL",AutoSL);
      GlobalVariableSet(OBJPREFIX+"AutoTP",AutoTP);
      GlobalVariableSet(OBJPREFIX+"AutoLots",AutoLots);
      //---
      GlobalVariableSet(OBJPREFIX+"RR",RR);
      GlobalVariableSet(OBJPREFIX+"Risk",RiskInp);
      //---
      GlobalVariableSet(OBJPREFIX+"PRL",PriceRowLeft);
      GlobalVariableSet(OBJPREFIX+"PRR",PriceRowRight);
      //---
      GlobalVariablesFlush();
     }
//--- DeleteObjects
   if(reason<=REASON_REMOVE || reason==REASON_CLOSE || reason==REASON_RECOMPILE || reason==REASON_INITFAILED || reason==REASON_ACCOUNT)
     {
      ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
      DelteMinWindow();
     }

//---
   if(reason<=REASON_REMOVE || reason==REASON_CLOSE || reason==REASON_RECOMPILE)
     {
      //---
      if(ClearedTemplate)
         ChartSetColor(2);
     }

//--- UnblockScrolling
   ChartMouseScrollSet(true);

//--- UserIsRegistred
   if(!GlobalVariableCheck(OBJPREFIX+"Registred"))
      GlobalVariableSet(OBJPREFIX+"Registred",1);

//---
   LastMode=SelectedMode;

//--- StoreDeinitReason
   LastReason=reason;
//----
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//----
   if(PairSuggest)
      ResetTrigger();

//---
   if(ArraySize(aSymbols)>ArraySize(UsedSymbols))
     {
      //---
      for(int i=0; i<ArraySize(aSymbols); i++)
         SpeedOmeter(Prefix+aSymbols[i]+Suffix);
     }
   else
     {
      //---
      for(int i=0; i<ArraySize(UsedSymbols); i++)
         SpeedOmeter(Prefix+UsedSymbols[i]+Suffix);
     }

//--- Alert
   if(drop_time<TimeLocal()-15)
     {
      //---
      if((CalcPeriod==DAILY && Hour()>=4) || (CalcPeriod==WEEKLY && TimeDayOfWeek(TimeCurrent())>=2) || (CalcPeriod==MONTHLY && Day()>=4))
         Alert();
     }

//---
   if(ShowTradePanel)
     {
      //---
      ObjectsCreateAll();
      //---
      for(int i=0; i<ArraySize(aSymbols); i++)
        {
         ObjectsUpdateAll(Prefix+aSymbols[i]+Suffix);
         GetSetInputs(Prefix+aSymbols[i]+Suffix);
        }
      //---
      GetSetInputsA();
      //---
      OverAllInfo();
      //---
      CStrenghts();
      //--- MoveWindow
      if(LastReason==REASON_CHARTCHANGE)
        {
         Chart_XSize=(int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
         Chart_YSize=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
         //---
         ChartX=Chart_XSize;
         ChartY=Chart_YSize;
         //---
         LastReason=0;
        }
      //---
      if(ChartX!=Chart_XSize || ChartY!=Chart_YSize)
        {
         ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
         //---
         ObjectsCreateAll();
         //---
         ChartX=Chart_XSize;
         ChartY=Chart_YSize;
        }
      //---
      Chart_XSize=(int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
      Chart_YSize=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);

      //--- Connected
      if(TerminalInfoInteger(TERMINAL_CONNECTED))
        {
         //---
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT)!="ü")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT,"ü");//SetObject
         //---
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP)!="Connected")//GetObject
           {
            double Ping=TerminalInfoInteger(TERMINAL_PING_LAST);//SetPingToMs
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP,"Connected..."+"\nPing: "+DoubleToString(Ping/1000,2)+" ms");//SetObject
           }
        }
      //--- Disconnected
      else
        {
         //---
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT)!="ñ")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT,"ñ");//SetObject
         //---
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP)!="No connection!")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP,"No connection!");//SetObject
        }
      //--- ResetStatus
      if(stauts_time<TimeLocal()-1)
         ResetStatus();
      //---
      Comment("");
      ChartRedraw();
     }
   else
      CreateMinWindow();
//----
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//----
   if(id==CHARTEVENT_KEYDOWN)
     {

      //---
      if(KeyboardTrading)
        {
         //---
         if(lparam==StringGetChar(BuyKey,0))
           {
            //--- SendSellOrder
            OrderSend(_Symbol,OP_BUY);
            //--- ResetButton
            ObjectSetInteger(0,OBJPREFIX+"BUY"+" - "+_Symbol,OBJPROP_STATE,false);//SetObject
           }
         //---
         if(lparam==StringGetChar(SellKey,0))
           {
            //--- SendSellOrder
            OrderSend(_Symbol,OP_SELL);
            //--- ResetButton
            ObjectSetInteger(0,OBJPREFIX+"SELL"+" - "+_Symbol,OBJPROP_STATE,false);//SetObject
           }
         //---
         if(lparam==StringGetChar(CloseKey,0))
           {
            //--- NoOrders
            if(OpenPos(_Symbol,OP_ALL)==0)
              {
               //---
               SetStatus("ý","No open orders...");
               Sleep(100);
               //---
               ObjectSetInteger(0,OBJPREFIX+"CLOSE"+" - "+_Symbol,OBJPROP_STATE,false);//SetObject
              }
            //--- CloseOrder(s)
            OrderClose(_Symbol);
            //--- ResetButton
            ObjectSetInteger(0,OBJPREFIX+"CLOSE"+" - "+_Symbol,OBJPROP_STATE,false);//SetObject
           }

         //--- Switch Symbol (UP)
         if(lparam==KEY_UP)
           {
            //---
            int index=0;
            //---
            for(int i=0; i<ArraySize(aSymbols); i++)
              {
               if(_Symbol==Prefix+aSymbols[i]+Suffix)
                 {
                  //---
                  index=i-1;
                  //---
                  if(index<0)
                     index=ArraySize(aSymbols)-1;
                  //---                     
                  if(SymbolFind(Prefix+aSymbols[index]+Suffix,false))
                    {
                     ChartSetSymbolPeriod(0,Prefix+aSymbols[index]+Suffix,PERIOD_CURRENT);
                     SetStatus("ÿ","Switched to "+aSymbols[index]);
                     break;
                    }
                 }
              }
           }

         //--- Switch Symbol (DOWN)
         if(lparam==KEY_DOWN)
           {
            //---
            int index=0;
            //---
            for(int i=0; i<ArraySize(aSymbols); i++)
              {
               //---
               if(_Symbol==Prefix+aSymbols[i]+Suffix)
                 {
                  //---
                  index=i+1;
                  //---
                  if(index>=ArraySize(aSymbols))
                     index=0;
                  //---
                  if(SymbolFind(Prefix+aSymbols[index]+Suffix,false))
                    {
                     ChartSetSymbolPeriod(0,Prefix+aSymbols[index]+Suffix,PERIOD_CURRENT);
                     SetStatus("ÿ","Switched to "+aSymbols[index]);
                     break;
                    }
                 }
              }
           }
        }
     }

//--- OBJ_CLICKS
   if(id==CHARTEVENT_OBJECT_CLICK)
     {

      //---
      for(int i=0; i<ArraySize(Currenies); i++)
        {
         //--- DetectEdit
         if(sparam==OBJPREFIX+"SL<>"+" - "+Currenies[i] || sparam==OBJPREFIX+"LOTSIZE<>"+" - "+Currenies[i] || sparam==OBJPREFIX+"_TP<>"+" - "+Currenies[i] || sparam==OBJPREFIX+"RISK%<>" || sparam==OBJPREFIX+"RISK$<>" || sparam==OBJPREFIX+"RR<>")
            UserIsEditing=true;

         //--- BasketBuy
         if(sparam==OBJPREFIX+"BUY"+" - "+Currenies[i])
           {
            //--- SendBuyOrder
            BuyBasket(Currenies[i]);
            //--- ResetButton
            ObjectSetInteger(0,OBJPREFIX+"BUY"+" - "+Currenies[i],OBJPROP_STATE,false);//SetObject
           }

         //--- BasketClose
         if(sparam==OBJPREFIX+"CLOSE"+" - "+Currenies[i])
           {
            //--- SendBuyOrder
            CloseBasket(Currenies[i]);
            //--- ResetButton
            ObjectSetInteger(0,OBJPREFIX+"CLOSE"+" - "+Currenies[i],OBJPROP_STATE,false);//SetObject
           }

         //--- BasketSell
         if(sparam==OBJPREFIX+"SELL"+" - "+Currenies[i])
           {
            //--- SendBuyOrder
            SellBasket(Currenies[i]);
            //--- ResetButton
            ObjectSetInteger(0,OBJPREFIX+"SELL"+" - "+Currenies[i],OBJPROP_STATE,false);//SetObject
           }
         //---
        }

      //---
      for(int i=0; i<ArraySize(aSymbols); i++)
        {

         //--- SellClick
         if(sparam==OBJPREFIX+"SELL"+" - "+Prefix+aSymbols[i]+Suffix)
           {
            //--- SendSellOrder
            OrderSend(Prefix+aSymbols[i]+Suffix,OP_SELL);
            //--- ResetButton
            ObjectSetInteger(0,OBJPREFIX+"SELL"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_STATE,false);//SetObject
            break;
           }

         //--- BuyClick
         if(sparam==OBJPREFIX+"BUY"+" - "+Prefix+aSymbols[i]+Suffix)
           {
            //--- SendBuyOrder
            OrderSend(Prefix+aSymbols[i]+Suffix,OP_BUY);
            //--- ResetButton
            ObjectSetInteger(0,OBJPREFIX+"BUY"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_STATE,false);//SetObject
            break;
           }

         //--- CloseClick
         if(sparam==OBJPREFIX+"CLOSE"+" - "+Prefix+aSymbols[i]+Suffix)
           {
            //--- NoOrders
            if(OpenPos(Prefix+aSymbols[i]+Suffix,OP_ALL)==0)
              {
               SetStatus("ý","No open orders...");
               Sleep(100);
               ObjectSetInteger(0,OBJPREFIX+"CLOSE"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_STATE,false);//SetObject
               break;
              }
            //--- CloseOrder(s)
            OrderClose(Prefix+aSymbols[i]+Suffix);
            //--- ResetButton
            ObjectSetInteger(0,OBJPREFIX+"CLOSE"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_STATE,false);//SetObject
            break;
           }

         //--- DecLotSize
         if(sparam==OBJPREFIX+"LOTSIZE<"+" - "+Prefix+aSymbols[i]+Suffix)
           {
            if(!AutoLots)
              {
               //---
               double LotSize=StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT));
               //---
               if(!UserIsEditing)
                  ObjectSetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT,0,DoubleToString(LotSize-=LotStep(Prefix+aSymbols[i]+Suffix),2));//SetObject
              }
           }

         //--- IncLotSize
         if(sparam==OBJPREFIX+"LOTSIZE>"+" - "+Prefix+aSymbols[i]+Suffix)
           {
            if(!AutoLots)
              {
               //---
               double LotSize=StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT));
               //---
               if(!UserIsEditing)
                  ObjectSetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT,0,DoubleToString(LotSize+=LotStep(Prefix+aSymbols[i]+Suffix),2));//SetObject
              }
           }

         //---SetSL
         if(sparam==OBJPREFIX+"SETSL<>")
           {
            if(!AutoSL)
              {
               //---
               double StopLoss=StringToDouble(ObjectGetString(0,OBJPREFIX+"SL<>",OBJPROP_TEXT));
               //---
               if(!UserIsEditing)
                  ObjectSetString(0,OBJPREFIX+"SL<>"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT,0,DoubleToString(StopLoss,0));//SetObject
              }
            else
              {
               SetStatus("ý","Disable auto sl first...");
               _PlaySound(ErrorSound);
               Sleep(100);
               ObjectSetInteger(0,OBJPREFIX+"SETSL<>",OBJPROP_STATE,false);//SetObject
               break;
              }
            //--- ResetButton
            ObjectSetInteger(0,OBJPREFIX+"SETSL<>",OBJPROP_STATE,false);//SetObject
           }

         //--- SetTP
         if(sparam==OBJPREFIX+"SETTP<>")
           {
            if(!AutoTP)
              {
               //---
               double TakeProfit=StringToDouble(ObjectGetString(0,OBJPREFIX+"_TP<>",OBJPROP_TEXT));
               //---
               if(!UserIsEditing)
                  ObjectSetString(0,OBJPREFIX+"_TP<>"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT,0,DoubleToString(TakeProfit,0));//SetObject
              }
            else
              {
               SetStatus("ý","Disable auto tp first...");
               _PlaySound(ErrorSound);
               Sleep(100);
               ObjectSetInteger(0,OBJPREFIX+"SETTP<>",OBJPROP_STATE,false);//SetObject
               break;
              }
            //--- ResetButton
            ObjectSetInteger(0,OBJPREFIX+"SETTP<>",OBJPROP_STATE,false);//SetObject
           }

         //--- SetLots
         if(sparam==OBJPREFIX+"SETLOTS<>")
           {
            //---
            if(!AutoLots)
              {
               //---
               double LotSize=StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT));
               //---
               if(!UserIsEditing)
                  ObjectSetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_TEXT,0,DoubleToString(LotSize,2));//SetObject
              }
            else
              {
               SetStatus("ý","Disable auto lots first...");
               _PlaySound(ErrorSound);
               Sleep(100);
               ObjectSetInteger(0,OBJPREFIX+"SETLOTS<>",OBJPROP_STATE,false);//SetObject
               break;
              }
            //--- ResetButton
            ObjectSetInteger(0,OBJPREFIX+"SETLOTS<>",OBJPROP_STATE,false);//SetObject
           }

         //--- SymoblSwitcher
         if(sparam==OBJPREFIX+Prefix+aSymbols[i]+Suffix)
           {
            ChartSetSymbolPeriod(0,Prefix+aSymbols[i]+Suffix,PERIOD_CURRENT);
            SetStatus("ÿ","Switched to "+aSymbols[i]);
            break;
           }
        }

      //--- RemoveExpert
      if(sparam==OBJPREFIX+"EXIT")
        {
         //---
         if(MessageBox("Are you sure you want to exit?",MB_CAPTION,MB_ICONQUESTION|MB_YESNO)==IDYES)
            ExpertRemove();//Exit
        }

      //--- Minimize
      if(sparam==OBJPREFIX+"MINIMIZE")
        {
         ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
         CreateMinWindow();
         ShowTradePanel=false;
         ChartMouseScrollSet(true);
         ChartSetColor(2);
         ClearedTemplate=false;
        }

      //--- Maximize
      if(sparam==OBJPREFIX+"MIN"+"MAXIMIZE")
        {
         DelteMinWindow();
         ObjectsCreateAll();
         ShowTradePanel=true;
         ChartMouseScrollSet(false);
        }

      //--- Ping
      if(sparam==OBJPREFIX+"CONNECTION")
        {
         //---
         double Ping=TerminalInfoInteger(TERMINAL_PING_LAST);//SetPingToMs
         //---
         if(TerminalInfoInteger(TERMINAL_CONNECTED))
            SetStatus("\n","Ping: "+DoubleToString(Ping/1000,2)+" ms");
         else
            SetStatus("ý","No Internet connection...");
        }

      //--- Date
      if(sparam==OBJPREFIX+"TIME" || sparam==OBJPREFIX+"TIME§")
         SetStatus("\n",_DayOfWeek()+", "+IntegerToString(TimeDay(TimeLocal()))+" "+_Month()+" "+IntegerToString(TimeDayOfYear(TimeLocal())));

      //--- SwitchTheme
      if(sparam==OBJPREFIX+"THEME")
        {
         //---
         if(SelectedTheme==0)
           {
            ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
            COLOR_BG=C'28,28,28';
            COLOR_FONT=clrSilver;
            COLOR_GREEN=clrLimeGreen;
            COLOR_RED=clrRed;
            COLOR_LOW=clrYellow;
            COLOR_MARKER=clrGold;
            ObjectsCreateAll();
            SelectedTheme=1;
            //---
            SetStatus("ÿ","Dark theme selected...");
            Sleep(250);
            ResetStatus();
           }
         else
           {
            ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
            COLOR_BG=C'240,240,240';
            COLOR_FONT=C'40,41,59';
            COLOR_GREEN=clrForestGreen;
            COLOR_RED=clrIndianRed;
            COLOR_LOW=clrGoldenrod;
            COLOR_MARKER=clrDarkOrange;
            ObjectsCreateAll();
            SelectedTheme=0;
            //---
            SetStatus("ÿ","Light theme selected...");
            Sleep(250);
            ResetStatus();
           }
        }

      //--- SwitchTheme
      if(sparam==OBJPREFIX+"TEMPLATE")
        {
         //---
         if(!ClearedTemplate)
           {
            //---
            if(SelectedTheme==0)
              {
               ChartSetColor(0);
               ClearedTemplate=true;
               SetStatus("ÿ","Chart color cleared...");
              }
            else
              {
               ChartSetColor(1);
               ClearedTemplate=true;
               SetStatus("ÿ","Chart color cleared...");
              }
           }
         else
           {
            ChartSetColor(2);
            ClearedTemplate=false;
            SetStatus("ÿ","Original chart color applied...");
           }
        }

      //--- GetParameters
      GetParam(sparam);

      //--- SoundManagement
      if(sparam==OBJPREFIX+"SOUND" || sparam==OBJPREFIX+"SOUNDIO")
        {
         //--- EnableSound
         if(!SoundIsEnabled)
           {
            SoundIsEnabled=true;
            ObjectSetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR,C'59,41,40');//SetObject
            SetStatus("þ","Sounds enabled...");
            PlaySound("sound.wav");
           }
         //--- DisableSound
         else
           {
            SoundIsEnabled=false;
            ObjectSetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR,clrNONE);//SetObject
            SetStatus("ý","Sounds disabled...");
           }
        }
      //--- AlarmManagement
      if(sparam==OBJPREFIX+"ALARM" || sparam==OBJPREFIX+"ALARMIO")
        {
         //--- EnableSound
         if(!AlarmIsEnabled)
           {
            //---
            AlarmIsEnabled=true;
            //---
            ObjectSetInteger(0,OBJPREFIX+"ALARMIO",OBJPROP_COLOR,clrNONE);
            //---
            string message="\n";
            //---
            if(_Alert)
               message="[Pop-up]";
            //---
            if(Push)
               StringAdd(message,"[Push]");
            //---
            if(Mail)
               StringAdd(message,"[Email]");
            //---
            if(!_Alert && !Push && !Mail)
              {
               Alert(OBJPREFIX+"No alert method selected!");
               return;
              }
            //---
            Alert("Alerts enabled "+message);
            SetStatus("þ","Alerts enabled...");
           }
         //--- DisableSound
         else
           {
            //---
            AlarmIsEnabled=false;
            ObjectSetInteger(0,OBJPREFIX+"ALARMIO",OBJPROP_COLOR,C'59,41,40');
            //---
            SetStatus("ý","Alerts disabled...");
           }
        }

      //--- Balance
      if(sparam==OBJPREFIX+"BALANCE«")
        {
         //---
         string text="";
         //---
         if(_AccountCurrency()=="$" || _AccountCurrency()=="£")
            text=_AccountCurrency()+DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2);
         else
            text=DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2)+_AccountCurrency();
         //---
         SetStatus("","Equity: "+text);
        }

      //--- AutoSLManagement
      if(sparam==OBJPREFIX+"AUTOSL")
        {
         //--- EnableAutoSL
         if(!AutoSL)
           {
            AutoSL=true;
            ObjectSetInteger(0,OBJPREFIX+"AUTOSL",OBJPROP_COLOR,COLOR_AUTO);//SetObject
            SetStatus("þ","Auto sl enabled...");
           }
         //--- DisableAutoSL
         else
           {
            AutoSL=false;
            ObjectSetInteger(0,OBJPREFIX+"AUTOSL",OBJPROP_COLOR,COLOR_FONT);//SetObject
            SetStatus("ý","Auto sl disabled...");
           }
        }

      //--- AutoTPManagement
      if(sparam==OBJPREFIX+"AUTOTP")
        {
         //--- EnableAutoTP
         if(!AutoTP)
           {
            AutoTP=true;
            ObjectSetInteger(0,OBJPREFIX+"AUTOTP",OBJPROP_COLOR,COLOR_AUTO);//SetObject
            SetStatus("þ","Auto tp enabled...");
           }
         //--- DisableAutoTP
         else
           {
            AutoTP=false;
            ObjectSetInteger(0,OBJPREFIX+"AUTOTP",OBJPROP_COLOR,COLOR_FONT);//SetObject
            SetStatus("ý","Auto tp disabled...");
           }
        }

      //--- AutoLotsManagement
      if(sparam==OBJPREFIX+"AUTOLOTS")
        {
         //--- EnableAutoLots
         if(!AutoLots)
           {
            AutoLots=true;
            ObjectSetInteger(0,OBJPREFIX+"AUTOLOTS",OBJPROP_COLOR,COLOR_AUTO);//SetObject
            SetStatus("þ","Auto lots enabled...");
           }
         //--- DisableAutoLots
         else
           {
            AutoLots=false;
            ObjectSetInteger(0,OBJPREFIX+"AUTOLOTS",OBJPROP_COLOR,COLOR_FONT);//SetObject
            SetStatus("ý","Auto lots disabled...");
           }
        }

      //--- Switch PriceRow Left
      if(sparam==OBJPREFIX+"PRICEROW_Lª")
        {
         //---
         PriceRowLeft++;
         //---
         if(PriceRowLeft>=ArraySize(PriceRowLeftArr))//Reset
            PriceRowLeft=0;
         //---
         ObjectSetString(0,OBJPREFIX+"PRICEROW_Lª",OBJPROP_TEXT,0,PriceRowLeftArr[PriceRowLeft]);/*SetObject*/
         //---
         SetStatus("É","Switched to "+PriceRowLeftArr[PriceRowLeft]+" mode...");
         //---
         for(int i=0; i<ArraySize(aSymbols); i++)
            ObjectSetString(0,OBJPREFIX+"PRICEROW_L"+" - "+aSymbols[i],OBJPROP_TOOLTIP,PriceRowLeftArr[PriceRowLeft]+" "+aSymbols[i]);
        }

      //--- Switch PriceRow Right
      if(sparam==OBJPREFIX+"PRICEROW_Rª")
        {
         //---
         PriceRowRight++;
         //---         
         if(PriceRowRight>=ArraySize(PriceRowRightArr))//Reset
            PriceRowRight=0;
         //---
         ObjectSetString(0,OBJPREFIX+"PRICEROW_Rª",OBJPROP_TEXT,0,PriceRowRightArr[PriceRowRight]);/*SetObject*/
         //---
         SetStatus("Ê","Switched to "+PriceRowRightArr[PriceRowRight]+" mode...");
         //---
         for(int i=0; i<ArraySize(aSymbols); i++)
            ObjectSetString(0,OBJPREFIX+"PRICEROW_R"+" - "+aSymbols[i],OBJPROP_TOOLTIP,PriceRowRightArr[PriceRowRight]+" "+aSymbols[i]);
        }

      //--- DecLotSize ALL
      if(sparam==OBJPREFIX+"LOTSIZE<")
        {
         //---
         double LotSize=StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT));
         //---
         if(!UserIsEditing)
            ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotSize-=0.01,2));//SetObject
        }

      //--- IncLotSize ALL
      if(sparam==OBJPREFIX+"LOTSIZE>")
        {
         //---
         double LotSize=StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT));
         //---
         if(!UserIsEditing)
            ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotSize+=0.01,2));//SetObject
        }

      //---
      if(sparam==OBJPREFIX+"CLOSE")
        {
         //--- NoOrders
         int openpos=0;
         //---
         for(int x=0; x<ArraySize(aSymbols); x++)
            openpos+=OpenPos(aSymbols[x],OP_ALL);
         //---
         if(openpos==0)
           {
            SetStatus("ý","No open orders...");
            Sleep(100);
            ObjectSetInteger(0,OBJPREFIX+"CLOSE",OBJPROP_STATE,false);//SetObject
            return;
           }
         //--- CloseOrder(s)
         for(int x=0; x<ArraySize(aSymbols); x++)
            OrderClose(aSymbols[x]);
         //--- ResetButton
         Sleep(50);
         ObjectSetInteger(0,OBJPREFIX+"CLOSE",OBJPROP_STATE,false);//SetObject
        }
     }

//--- OnEdit
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {

      //--- LotsizeA
      double LotsizeAInp=StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT));
      //---
      if(LotsizeAInp<0.01)
        {
         ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(0.01,2));/*SetObject*/
         LotsizeAInp=0.01;
        }
      //---
      ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotsizeAInp,2));/*SetObject*/

      //--- RRInpA
      double RRInpA=StringToDouble(ObjectGetString(0,OBJPREFIX+"RR<>",OBJPROP_TEXT));
      //---
      if(RRInpA<0.1)
        {
         ObjectSetString(0,OBJPREFIX+"RR<>",OBJPROP_TEXT,0,DoubleToString(0.1,2));/*SetObject*/
         RRInpA=0.1;
        }
      //---
      ObjectSetString(0,OBJPREFIX+"RR<>",OBJPROP_TEXT,0,DoubleToString(RRInpA,2));/*SetObject*/

      //---
      GlobalVariableSet(OBJPREFIX+"Stoploss",StringToDouble(ObjectGetString(0,OBJPREFIX+"SL<>",OBJPROP_TEXT)));
      GlobalVariableSet(OBJPREFIX+"Takeprofit",StringToDouble(ObjectGetString(0,OBJPREFIX+"_TP<>",OBJPROP_TEXT)));
      GlobalVariableSet(OBJPREFIX+"Lotsize",StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT)));

      //---     
      UserIsEditing=false;
     }
//----
  }
//+------------------------------------------------------------------+
//| _OnTester                                                        |
//+------------------------------------------------------------------+
void _OnTester()
  {
//---
   if(AccountFreeMarginCheck(_Symbol,OP_BUY,SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN))>=0)
     {
      double lots=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
      //---
      int tkt=OrderSend(_Symbol,OP_BUY,lots,SymbolInfoDouble(_Symbol,SYMBOL_ASK),0,0,0,NULL,0,0,clrNONE);
      //---
      if(tkt>0)
         int c_tkt=OrderClose(tkt,lots,SymbolInfoDouble(_Symbol,SYMBOL_BID),0,clrNONE);
     }
//---
  }
//+------------------------------------------------------------------+
//| ATR                                                              |
//+------------------------------------------------------------------+  
double ATR(string _Symb,int timeframe,int period)
  {
//----
   double sl=0,ml=0;
//---
   if(SymbolInfoInteger(_Symb,SYMBOL_DIGITS)==1)
      ml=10;
//---
   if(SymbolInfoInteger(_Symb,SYMBOL_DIGITS)==2)
      ml=100;
//---
   if(SymbolInfoInteger(_Symb,SYMBOL_DIGITS)==3)
      ml=1000;
//---
   if(SymbolInfoInteger(_Symb,SYMBOL_DIGITS)==4)
      ml=10000;
//---
   if(SymbolInfoInteger(_Symb,SYMBOL_DIGITS)==5)
      ml=100000;
//---
   if(Bars(_Symb,timeframe)<period)
      sl=0;
   else
      sl=iATR(_Symb,timeframe,period,1)*ml;
//---
   return(sl);
  }
//+------------------------------------------------------------------+
//| ADR                                                              |
//+------------------------------------------------------------------+
double ADR(string _Symb)
  {
//----
   double s=0,adr1=0,adr5=0,adr10=0,adr20=0,pts=SymbolInfoDouble(_Symb,SYMBOL_POINT);
//---
   for(int a=1;a<=20;a++)
     {
      //---
      if(pts!=0)
         s+=(iHigh(_Symb,CalcTF,a)-iLow(_Symb,CalcTF,a))/pts;
      //---
      if(a==1)
         adr1=MathRound(s);
      //---
      if(a==5)
         adr5=MathRound(s/5);
      //---
      if(a==10)
         adr10=MathRound(s/10);
      //---
      if(a==20)
         adr20=MathRound(s/20);
     }
//----
   return(MathRound((adr1+adr5+adr10+adr20)/4.0));
  }
//+------------------------------------------------------------------+
//| _Lots                                                            |
//+------------------------------------------------------------------+ 
double _Lots(string _Symb,double Risk,double SL)
  {
//---
   double lots=0,tickval=0,risk=0,sl=SL;
//---
   if(AccountInfoDouble(ACCOUNT_BALANCE)!=0)
     {
      //---
      tickval=SymbolInfoDouble(_Symb,SYMBOL_TRADE_TICK_VALUE);
      risk=(AccountInfoDouble(ACCOUNT_BALANCE)/100)*Risk;
      //---
      if((tickval*sl)!=0)
        {
         lots=risk/(tickval*sl);
        }
      //---
     }
//---
   double MinLot=SymbolInfoDouble(_Symb,SYMBOL_VOLUME_MIN),MaxLot=SymbolInfoDouble(_Symb,SYMBOL_VOLUME_MAX);
//---
   if(lots<=MinLot)
      lots=MinLot;
//---
   if(lots>=MaxLot)
      lots=MaxLot;
//---
   if(sl==0)
      lots=MinLot;
//---
   return(NormalizeDouble(lots,2));
  }
//+------------------------------------------------------------------+
//| Balance                                                          |
//+------------------------------------------------------------------+
string Balance()
  {
//---         
   string text="";
//---
   if(_AccountCurrency()=="$" || _AccountCurrency()=="£")
      text=_AccountCurrency()+DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE),2);
   else
      text=DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE),2)+_AccountCurrency();
//---
   string result="Balance: "+text;
//---
   if(OpenPos(IntegerToString(-1),OP_ALL)>0)
      StringAdd(result,"   Margin Level: "+DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL),2)+"%");
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| ObjectsCreateAll                                                 |
//+------------------------------------------------------------------+
void ObjectsCreateAll()
  {
//---
   int fr_y2=Dpi(140);
//---
   for(int i=0; i<ArraySize(aSymbols); i++)
     {
      //---
      if(SelectedMode==FULL)
         fr_y2+=Dpi(25);
      //---
      if(SelectedMode==COMPACT)
         fr_y2+=Dpi(21);
      //---
      if(SelectedMode==MINI)
         fr_y2+=Dpi(17);
     }
//---
   int x=ChartMiddleX()-(Dpi(CLIENT_BG_WIDTH)/2);
   int y=ChartMiddleY()-(fr_y2/2);
//---
   int height=fr_y2+Dpi(3);
//---
   RectLabelCreate(0,OBJPREFIX+"BCKGRND[]",0,x,y,Dpi(CLIENT_BG_WIDTH),height,COLOR_BG,BORDER_FLAT,CORNER_LEFT_UPPER,COLOR_BORDER,STYLE_SOLID,1,false,false,true,0,"\n");
//---
   _x1=(int)ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_XDISTANCE);
   _y1=(int)ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_YDISTANCE);
//---
   RectLabelCreate(0,OBJPREFIX+"BORDER[]",0,x,y,Dpi(CLIENT_BG_WIDTH),Dpi(INDENT_TOP),COLOR_BORDER,BORDER_FLAT,CORNER_LEFT_UPPER,COLOR_BORDER,STYLE_SOLID,1,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"CAPTION",0,_x1+(Dpi(CLIENT_BG_WIDTH)/2)-Dpi(16),_y1,CORNER_LEFT_UPPER,ExpertName,"Arial Black",9,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"EXIT",0,(_x1+Dpi(CLIENT_BG_WIDTH))-Dpi(10),_y1-Dpi(2),CORNER_LEFT_UPPER,"r","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+"MINIMIZE",0,(_x1+Dpi(CLIENT_BG_WIDTH))-Dpi(30),_y1-Dpi(2),CORNER_LEFT_UPPER,"2","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+" ",0,(_x1+Dpi(CLIENT_BG_WIDTH))-Dpi(50),_y1-Dpi(2),CORNER_LEFT_UPPER,"s","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+"TIME",0,(_x1+Dpi(CLIENT_BG_WIDTH))-Dpi(85),_y1+Dpi(1),CORNER_LEFT_UPPER,TimeToString(0,TIME_SECONDS),"Tahoma",8,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"Local Time",false);
   LabelCreate(0,OBJPREFIX+"TIME§",0,(_x1+Dpi(CLIENT_BG_WIDTH))-Dpi(120),_y1,CORNER_LEFT_UPPER,"Â","Wingdings",12,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"Local Time",false);
//---
   LabelCreate(0,OBJPREFIX+"CONNECTION",0,_x1+Dpi(15),_y1-Dpi(2),CORNER_LEFT_UPPER,"ü","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"Connection",false);
//---
   LabelCreate(0,OBJPREFIX+"THEME",0,_x1+Dpi(40),_y1-Dpi(4),CORNER_LEFT_UPPER,"N","Webdings",15,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"Theme",false);
//---
   LabelCreate(0,OBJPREFIX+"TEMPLATE",0,_x1+Dpi(65),_y1-Dpi(2),CORNER_LEFT_UPPER,"+","Webdings",12,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"Background",false);
//---
   int middle=Dpi(CLIENT_BG_WIDTH/2);
//---
   LabelCreate(0,OBJPREFIX+"STATUS",0,_x1+middle+(middle/2),_y1+Dpi(8),CORNER_LEFT_UPPER,"\n","Wingdings",10,C'59,41,40',0,ANCHOR_LEFT,false,false,true,1,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+"STATUS«",0,_x1+middle+(middle/2)+Dpi(15),_y1+Dpi(8),CORNER_LEFT_UPPER,"\n",sFontType,8,C'59,41,40',0,ANCHOR_LEFT,false,false,true,1,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+"SOUND",0,_x1+Dpi(90),_y1-Dpi(2),CORNER_LEFT_UPPER,"X","Webdings",12,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"Sounds",false);
//---
   color soundclr=SoundIsEnabled?C'59,41,40':clrNONE;
//---
   LabelCreate(0,OBJPREFIX+"SOUNDIO",0,_x1+Dpi(100),_y1-Dpi(1),CORNER_LEFT_UPPER,"ð","Webdings",10,soundclr,0,ANCHOR_UPPER,false,false,true,1,"Sounds",false);
//---
   LabelCreate(0,OBJPREFIX+"ALARM",0,_x1+Dpi(115),_y1-Dpi(1),CORNER_LEFT_UPPER,"%","Wingdings",12,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"Alerts",false);
//---
   color alarmclr=AlarmIsEnabled?clrNONE:C'59,41,40';
//---
   if(!_Alert && !Push && !Mail)
      alarmclr=C'59,41,40';
//---
   LabelCreate(0,OBJPREFIX+"ALARMIO",0,_x1+Dpi(115),_y1-Dpi(6),CORNER_LEFT_UPPER,"x",sFontType,16,alarmclr,0,ANCHOR_UPPER,false,false,true,1,"Alerts",false);
//---
   int csm_fr_x1=_x1+Dpi(50);
   int csm_fr_x2=_x1+Dpi(95);
   int csm_fr_x3=_x1+Dpi(137);
   int csm_dist_b=Dpi(150);
//---
   LabelCreate(0,OBJPREFIX+"AUD§",0,csm_fr_x1,_y1+Dpi(35),CORNER_LEFT_UPPER,"AUD","Arial Black",15,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"AUD%",0,csm_fr_x2,_y1+Dpi(55),CORNER_LEFT_UPPER,"0%","Arial Black",12,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
   CreateProBar("AUD",csm_fr_x3,_y1+Dpi(57));
   ButtonCreate(0,OBJPREFIX+"BUY"+" - "+"AUD",0,csm_fr_x1-Dpi(37),_y1+Dpi(27),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Buy","Trebuchet MS",6,C'59,41,40',C'160,192,255',C'144,176,239',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"CLOSE"+" - "+"AUD",0,csm_fr_x1-Dpi(37),_y1+Dpi(42),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Close","Trebuchet MS",6,C'59,41,40',C'255,255,160',C'239,239,144',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"SELL"+" - "+"AUD",0,csm_fr_x1-Dpi(37),_y1+Dpi(57),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Sell","Trebuchet MS",6,C'59,41,40',C'255,128,128',C'239,112,112',false,false,false,true,1,"\n");
//---
   LabelCreate(0,OBJPREFIX+"CAD§",0,csm_fr_x1+csm_dist_b,_y1+Dpi(35),CORNER_LEFT_UPPER,"CAD","Arial Black",15,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"CAD%",0,csm_fr_x2+csm_dist_b,_y1+Dpi(55),CORNER_LEFT_UPPER,"0%","Arial Black",12,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
   CreateProBar("CAD",csm_fr_x3+csm_dist_b,_y1+Dpi(57));
   ButtonCreate(0,OBJPREFIX+"BUY"+" - "+"CAD",0,csm_fr_x1+csm_dist_b-Dpi(37),_y1+Dpi(27),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Buy","Trebuchet MS",6,C'59,41,40',C'160,192,255',C'144,176,239',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"CLOSE"+" - "+"CAD",0,csm_fr_x1+csm_dist_b-Dpi(37),_y1+Dpi(42),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Close","Trebuchet MS",6,C'59,41,40',C'255,255,160',C'239,239,144',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"SELL"+" - "+"CAD",0,csm_fr_x1+csm_dist_b-Dpi(37),_y1+Dpi(57),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Sell","Trebuchet MS",6,C'59,41,40',C'255,128,128',C'239,112,112',false,false,false,true,1,"\n");
//---
   LabelCreate(0,OBJPREFIX+"CHF§",0,csm_fr_x1+(csm_dist_b*2),_y1+Dpi(35),CORNER_LEFT_UPPER,"CHF","Arial Black",15,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"CHF%",0,csm_fr_x2+(csm_dist_b*2),_y1+Dpi(55),CORNER_LEFT_UPPER,"0%","Arial Black",12,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
   CreateProBar("CHF",csm_fr_x3+(csm_dist_b*2),_y1+Dpi(57));
   ButtonCreate(0,OBJPREFIX+"BUY"+" - "+"CHF",0,csm_fr_x1+(csm_dist_b*2)-Dpi(37),_y1+Dpi(27),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Buy","Trebuchet MS",6,C'59,41,40',C'160,192,255',C'144,176,239',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"CLOSE"+" - "+"CHF",0,csm_fr_x1+(csm_dist_b*2)-Dpi(37),_y1+Dpi(42),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Close","Trebuchet MS",6,C'59,41,40',C'255,255,160',C'239,239,144',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"SELL"+" - "+"CHF",0,csm_fr_x1+(csm_dist_b*2)-Dpi(37),_y1+Dpi(57),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Sell","Trebuchet MS",6,C'59,41,40',C'255,128,128',C'239,112,112',false,false,false,true,1,"\n");
//---
   LabelCreate(0,OBJPREFIX+"EUR§",0,csm_fr_x1+(csm_dist_b*3),_y1+Dpi(35),CORNER_LEFT_UPPER,"EUR","Arial Black",15,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"EUR%",0,csm_fr_x2+(csm_dist_b*3),_y1+Dpi(55),CORNER_LEFT_UPPER,"0%","Arial Black",12,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
   CreateProBar("EUR",csm_fr_x3+(csm_dist_b*3),_y1+Dpi(57));
   ButtonCreate(0,OBJPREFIX+"BUY"+" - "+"EUR",0,csm_fr_x1+(csm_dist_b*3)-Dpi(37),_y1+Dpi(27),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Buy","Trebuchet MS",6,C'59,41,40',C'160,192,255',C'144,176,239',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"CLOSE"+" - "+"EUR",0,csm_fr_x1+(csm_dist_b*3)-Dpi(37),_y1+Dpi(42),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Close","Trebuchet MS",6,C'59,41,40',C'255,255,160',C'239,239,144',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"SELL"+" - "+"EUR",0,csm_fr_x1+(csm_dist_b*3)-Dpi(37),_y1+Dpi(57),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Sell","Trebuchet MS",6,C'59,41,40',C'255,128,128',C'239,112,112',false,false,false,true,1,"\n");
//---
   LabelCreate(0,OBJPREFIX+"GBP§",0,csm_fr_x1+(csm_dist_b*4),_y1+Dpi(35),CORNER_LEFT_UPPER,"GBP","Arial Black",15,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"GBP%",0,csm_fr_x2+(csm_dist_b*4),_y1+Dpi(55),CORNER_LEFT_UPPER,"0%","Arial Black",12,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
   CreateProBar("GBP",csm_fr_x3+(csm_dist_b*4),_y1+Dpi(57));
   ButtonCreate(0,OBJPREFIX+"BUY"+" - "+"GBP",0,csm_fr_x1+(csm_dist_b*4)-Dpi(37),_y1+Dpi(27),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Buy","Trebuchet MS",6,C'59,41,40',C'160,192,255',C'144,176,239',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"CLOSE"+" - "+"GBP",0,csm_fr_x1+(csm_dist_b*4)-Dpi(37),_y1+Dpi(42),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Close","Trebuchet MS",6,C'59,41,40',C'255,255,160',C'239,239,144',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"SELL"+" - "+"GBP",0,csm_fr_x1+(csm_dist_b*4)-Dpi(37),_y1+Dpi(57),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Sell","Trebuchet MS",6,C'59,41,40',C'255,128,128',C'239,112,112',false,false,false,true,1,"\n");
//---
   LabelCreate(0,OBJPREFIX+"JPY§",0,csm_fr_x1+(csm_dist_b*5),_y1+Dpi(35),CORNER_LEFT_UPPER,"JPY","Arial Black",15,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"JPY%",0,csm_fr_x2+(csm_dist_b*5),_y1+Dpi(55),CORNER_LEFT_UPPER,"0%","Arial Black",12,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
   CreateProBar("JPY",csm_fr_x3+(csm_dist_b*5),_y1+Dpi(57));
   ButtonCreate(0,OBJPREFIX+"BUY"+" - "+"JPY",0,csm_fr_x1+(csm_dist_b*5)-Dpi(37),_y1+Dpi(27),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Buy","Trebuchet MS",6,C'59,41,40',C'160,192,255',C'144,176,239',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"CLOSE"+" - "+"JPY",0,csm_fr_x1+(csm_dist_b*5)-Dpi(37),_y1+Dpi(42),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Close","Trebuchet MS",6,C'59,41,40',C'255,255,160',C'239,239,144',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"SELL"+" - "+"JPY",0,csm_fr_x1+(csm_dist_b*5)-Dpi(37),_y1+Dpi(57),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Sell","Trebuchet MS",6,C'59,41,40',C'255,128,128',C'239,112,112',false,false,false,true,1,"\n");
//---
   LabelCreate(0,OBJPREFIX+"NZD§",0,csm_fr_x1+(csm_dist_b*6),_y1+Dpi(35),CORNER_LEFT_UPPER,"NZD","Arial Black",15,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"NZD%",0,csm_fr_x2+(csm_dist_b*6),_y1+Dpi(55),CORNER_LEFT_UPPER,"0%","Arial Black",12,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
   CreateProBar("NZD",csm_fr_x3+(csm_dist_b*6),_y1+Dpi(57));
   ButtonCreate(0,OBJPREFIX+"BUY"+" - "+"NZD",0,csm_fr_x1+(csm_dist_b*6)-Dpi(37),_y1+Dpi(27),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Buy","Trebuchet MS",6,C'59,41,40',C'160,192,255',C'144,176,239',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"CLOSE"+" - "+"NZD",0,csm_fr_x1+(csm_dist_b*6)-Dpi(37),_y1+Dpi(42),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Close","Trebuchet MS",6,C'59,41,40',C'255,255,160',C'239,239,144',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"SELL"+" - "+"NZD",0,csm_fr_x1+(csm_dist_b*6)-Dpi(37),_y1+Dpi(57),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Sell","Trebuchet MS",6,C'59,41,40',C'255,128,128',C'239,112,112',false,false,false,true,1,"\n");
//---
   LabelCreate(0,OBJPREFIX+"USD§",0,csm_fr_x1+(csm_dist_b*7),_y1+Dpi(35),CORNER_LEFT_UPPER,"USD","Arial Black",15,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"USD%",0,csm_fr_x2+(csm_dist_b*7),_y1+Dpi(55),CORNER_LEFT_UPPER,"0%","Arial Black",12,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
   CreateProBar("USD",csm_fr_x3+(csm_dist_b*7),_y1+Dpi(57));
   ButtonCreate(0,OBJPREFIX+"BUY"+" - "+"USD",0,csm_fr_x1+(csm_dist_b*7)-Dpi(37),_y1+Dpi(27),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Buy","Trebuchet MS",6,C'59,41,40',C'160,192,255',C'144,176,239',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"CLOSE"+" - "+"USD",0,csm_fr_x1+(csm_dist_b*7)-Dpi(37),_y1+Dpi(42),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Close","Trebuchet MS",6,C'59,41,40',C'255,255,160',C'239,239,144',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"SELL"+" - "+"USD",0,csm_fr_x1+(csm_dist_b*7)-Dpi(37),_y1+Dpi(57),Dpi(25),Dpi(11),CORNER_LEFT_UPPER,"Sell","Trebuchet MS",6,C'59,41,40',C'255,128,128',C'239,112,112',false,false,false,true,1,"\n");
//---
   LabelCreate(0,OBJPREFIX+"BALANCE«",0,_x1+Dpi(300),_y1+Dpi(8),CORNER_LEFT_UPPER,Balance(),sFontType,8,C'59,41,40',0,ANCHOR_CENTER,false,false,true,0,"\n");
//---
   color autosl=AutoSL?COLOR_AUTO:COLOR_FONT;
   color autotp=AutoTP?COLOR_AUTO:COLOR_FONT;
   color autolots=AutoLots?COLOR_AUTO:COLOR_FONT;
//---
   LabelCreate(0,OBJPREFIX+"AUTOSL",0,_x1+Dpi(515),_y1+Dpi(81),CORNER_LEFT_UPPER,"Auto sl",sFontType,7,autosl,0,ANCHOR_CENTER,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"AUTOLOTS",0,_x1+Dpi(583),_y1+Dpi(81),CORNER_LEFT_UPPER,"Auto lots",sFontType,7,autolots,0,ANCHOR_CENTER,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"AUTOTP",0,_x1+Dpi(650),_y1+Dpi(81),CORNER_LEFT_UPPER,"Auto tp",sFontType,7,autotp,0,ANCHOR_CENTER,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"PRICEROW_Lª",0,_x1+Dpi(395),_y1+Dpi(81),CORNER_LEFT_UPPER,PriceRowLeftArr[PriceRowLeft],sFontType,7,FirstRun?clrNONE:COLOR_FONT,0,ANCHOR_CENTER,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"PRICEROW_Rª",0,_x1+Dpi(CLIENT_BG_WIDTH)-Dpi(355),_y1+Dpi(81),CORNER_LEFT_UPPER,PriceRowRightArr[PriceRowRight],sFontType,7,FirstRun?clrNONE:COLOR_FONT,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--- SymbolsGUI
   int fr_y=_y1+Dpi(95);
//---
   for(int i=0; i<ArraySize(aSymbols); i++)
     {
      //---
      CreateSymbGUI(Prefix+aSymbols[i]+Suffix,fr_y);
      //---
      if(SelectedMode==FULL)
         fr_y+=Dpi(25);
      //---
      if(SelectedMode==COMPACT)
         fr_y+=Dpi(21);
      //---
      if(SelectedMode==MINI)
         fr_y+=Dpi(17);
     }
//---
   LabelCreate(0,OBJPREFIX+"TOTALLOTS",0,_x1+Dpi(CLIENT_BG_WIDTH)-Dpi(220),fr_y+Dpi(5),CORNER_LEFT_UPPER,"0.00",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"Total Lots");
   LabelCreate(0,OBJPREFIX+"TOTAL«",0,_x1+Dpi(CLIENT_BG_WIDTH)-Dpi(155),fr_y+Dpi(5),CORNER_LEFT_UPPER,"0p",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"TOTAL««",0,_x1+Dpi(CLIENT_BG_WIDTH)-Dpi(73),fr_y+Dpi(5),CORNER_LEFT_UPPER,"0.00"+_AccountCurrency(),sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"TOTAL«««",0,_x1+Dpi(CLIENT_BG_WIDTH)-Dpi(10),fr_y+Dpi(5),CORNER_LEFT_UPPER,"0.00%",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"LEVERAGE",0,_x1+Dpi(CLIENT_BG_WIDTH)-Dpi(285),fr_y+Dpi(5),CORNER_LEFT_UPPER,"1:"+IntegerToString(AccountInfoInteger(ACCOUNT_LEVERAGE)),sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"Current Leverage");
//---
   EditCreate(0,OBJPREFIX+"SL<>",0,_x1+Dpi(490),fr_y,Dpi(50),Dpi(15),DoubleToString(GlobalVariableGet(OBJPREFIX+"Stoploss"),0),"Tahoma",10,ALIGN_RIGHT,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"SLª",0,_x1+Dpi(498),fr_y+Dpi(7),CORNER_LEFT_UPPER,"sl",sFontType,10,clrDarkGray,0,ANCHOR_CENTER,false,false,true,0,"\n");
//---
   EditCreate(0,OBJPREFIX+"LOTSIZE<>",0,_x1+Dpi(550),fr_y,Dpi(65),Dpi(15),DoubleToString(GlobalVariableGet(OBJPREFIX+"Lotsize"),2),"Tahoma",10,ALIGN_CENTER,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"LOTSIZE<",0,_x1+Dpi(555),fr_y+Dpi(5),CORNER_LEFT_UPPER,"6","Webdings",8,C'59,41,40',0,ANCHOR_CENTER,false,false,true,0,"\n",false);
   LabelCreate(0,OBJPREFIX+"LOTSIZE>",0,_x1+Dpi(610),fr_y+Dpi(5),CORNER_LEFT_UPPER,"5","Webdings",8,C'59,41,40',0,ANCHOR_CENTER,false,false,true,0,"\n",false);
//---
   EditCreate(0,OBJPREFIX+"_TP<>",0,_x1+Dpi(625),fr_y,Dpi(50),Dpi(15),DoubleToString(GlobalVariableGet(OBJPREFIX+"Takeprofit"),0),"Tahoma",10,ALIGN_RIGHT,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"TPª",0,_x1+Dpi(633),fr_y+Dpi(7),CORNER_LEFT_UPPER,"tp",sFontType,10,clrDarkGray,0,ANCHOR_CENTER,false,false,true,0,"\n");
//---
   ButtonCreate(0,OBJPREFIX+"SETSL<>",0,_x1+Dpi(490),fr_y+Dpi(20),Dpi(50),Dpi(15),CORNER_LEFT_UPPER,"Set sl","Trebuchet MS",10,C'59,41,40',C'220,220,220',C'220,220,220',false,false,false,true,1,"\n");
//---
   ButtonCreate(0,OBJPREFIX+"SETLOTS<>",0,_x1+Dpi(445)+Dpi(105),fr_y+Dpi(20),Dpi(65),Dpi(15),CORNER_LEFT_UPPER,"Set lots","Trebuchet MS",10,C'59,41,40',C'220,220,220',C'220,220,220',false,false,false,true,1,"\n");
//---
   ButtonCreate(0,OBJPREFIX+"SETTP<>",0,_x1+Dpi(625),fr_y+Dpi(20),Dpi(50),Dpi(15),CORNER_LEFT_UPPER,"Set tp","Trebuchet MS",10,C'59,41,40',C'220,220,220',C'220,220,220',false,false,false,true,1,"\n");
//---
   ButtonCreate(0,OBJPREFIX+"CLOSE",0,_x1+Dpi(740),fr_y,Dpi(40),Dpi(15),CORNER_LEFT_UPPER," Close","Trebuchet MS",10,C'59,41,40',C'255,255,160',C'239,239,144',false,false,false,true,1,"Close All");
//---
   LabelCreate(0,OBJPREFIX+"POSITIONS",0,_x1+Dpi(10),fr_y+Dpi(5),CORNER_LEFT_UPPER,"Floating:",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"SELLPOS",0,_x1+Dpi(90),fr_y+Dpi(5),CORNER_LEFT_UPPER,"Sell:",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"SELLPOS«",0,_x1+Dpi(150),fr_y+Dpi(5),CORNER_LEFT_UPPER,"0",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"BUYPOS",0,_x1+Dpi(185),fr_y+Dpi(5),CORNER_LEFT_UPPER,"Buy:",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"BUYPOS«",0,_x1+Dpi(245),fr_y+Dpi(5),CORNER_LEFT_UPPER,"0",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"TOTALPOS",0,_x1+Dpi(270),fr_y+Dpi(5),CORNER_LEFT_UPPER,"Total:",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"TOTALPOS«",0,_x1+Dpi(345),fr_y+Dpi(5),CORNER_LEFT_UPPER,"0",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"RISK",0,_x1+Dpi(10),fr_y+Dpi(27),CORNER_LEFT_UPPER,"Risk PT:",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"Risk Per Trade");
   EditCreate(0,OBJPREFIX+"RISK%<>",0,_x1+Dpi(90),fr_y+Dpi(20),Dpi(60),Dpi(15),DoubleToString(RiskInp,2),"Tahoma",10,ALIGN_RIGHT,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"RISK%ª",0,_x1+Dpi(98),fr_y+Dpi(27),CORNER_LEFT_UPPER,"%",sFontType,10,clrDarkGray,0,ANCHOR_CENTER,false,false,true,0,"\n");
//---
   EditCreate(0,OBJPREFIX+"RISK$<>",0,_x1+Dpi(175),fr_y+Dpi(20),Dpi(80),Dpi(15),DoubleToString((AccountInfoDouble(ACCOUNT_BALANCE)/100)*RiskInp,2),"Tahoma",10,ALIGN_RIGHT,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"RISK$ª",0,_x1+Dpi(182),fr_y+Dpi(27),CORNER_LEFT_UPPER,_AccountCurrency(),sFontType,10,clrDarkGray,0,ANCHOR_CENTER,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"RR",0,_x1+Dpi(270),fr_y+Dpi(27),CORNER_LEFT_UPPER,"Reward Ratio:",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"Risk/Reward Ratio");
   EditCreate(0,OBJPREFIX+"RR<>",0,_x1+Dpi(370),fr_y+Dpi(20),Dpi(50),Dpi(15),DoubleToString(RR,2),"Tahoma",10,ALIGN_CENTER,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
//---
  }
//+------------------------------------------------------------------+
//| CreateSymbGUI                                                    |
//+------------------------------------------------------------------+
void CreateSymbGUI(string _Symb,int Y)
  {
//---
   color startcolor=FirstRun?clrNONE:COLOR_FONT;
//---
   LabelCreate(0,OBJPREFIX+_Symb,0,_x1+Dpi(10),Y,CORNER_LEFT_UPPER,StringSubstr(_Symb,StringLen(Prefix),6)+":",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"SYMBOL§"+" - "+_Symb,0,_x1+Dpi(105),Y,CORNER_LEFT_UPPER,"à","Wingdings",12,startcolor,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"SYMBOL%"+" - "+_Symb,0,_x1+Dpi(145),Y,CORNER_LEFT_UPPER,"0.00%",sFontType,8,startcolor,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"RANGE₱"+" - "+_Symb,0,_x1+Dpi(205),Y,CORNER_LEFT_UPPER,"0p",sFontType,FONTSIZE,startcolor,0,ANCHOR_RIGHT,false,false,true,0,"Range "+_Symb);
//---
   LabelCreate(0,OBJPREFIX+"RANGE%"+" - "+_Symb,0,_x1+Dpi(255),Y,CORNER_LEFT_UPPER,"0%",sFontType,FONTSIZE,startcolor,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"SPEEDª"+" - "+_Symb,0,_x1+Dpi(355),Y,CORNER_LEFT_UPPER,"\n",sFontType,9,clrNONE,0.0,ANCHOR_RIGHT,false,false,true,0);
//---
   int fr_x=Dpi(330);
//---
   for(int i=0; i<10; i++)
     {
      LabelCreate(0,OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i),0,_x1+fr_x,Y,CORNER_LEFT_UPPER,"l","Arial Black",12,clrNONE,0.0,ANCHOR_RIGHT,false,false,true,0);
      fr_x-=Dpi(5);
     }
//---
   double bid=MarketInfo(_Symb,MODE_BID);
//---
   int digits=(int)MarketInfo(_Symb,MODE_DIGITS);
//---
   LabelCreate(0,OBJPREFIX+"PRICEROW_L"+" - "+_Symb,0,_x1+Dpi(417),Y,CORNER_LEFT_UPPER,DoubleToString(0,digits),sFontType,FONTSIZE,startcolor,0,ANCHOR_RIGHT,false,false,true,0,PriceRowLeftArr[PriceRowLeft]+" "+_Symb);
//---
   LabelCreate(0,OBJPREFIX+"OPENSELL"+" - "+_Symb,0,_x1+Dpi(445),Y+Dpi(2),CORNER_LEFT_UPPER,"\n",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"OPENBUY"+" - "+_Symb,0,_x1+Dpi(720),Y+Dpi(2),CORNER_LEFT_UPPER,"\n",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
//---
   ButtonCreate(0,OBJPREFIX+"SELL"+" - "+_Symb,0,_x1+Dpi(450),Y-Dpi(5),Dpi(30),Dpi(15),CORNER_LEFT_UPPER,"Sell","Trebuchet MS",10,C'59,41,40',C'255,128,128',C'239,112,112',false,false,false,true,1,"Sell "+_Symb);
//---
   EditCreate(0,OBJPREFIX+"SL<>"+" - "+_Symb,0,_x1+Dpi(490),Y-Dpi(5),Dpi(50),Dpi(15),DoubleToString(GlobalVariableGet(OBJPREFIX+_Symb+" - Stoploss"),0),"Tahoma",10,ALIGN_RIGHT,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"SLª"+" - "+_Symb,0,_x1+Dpi(498),Y+Dpi(2),CORNER_LEFT_UPPER,"sl",sFontType,10,clrDarkGray,0,ANCHOR_CENTER,false,false,true,0,"\n");
//---
   EditCreate(0,OBJPREFIX+"LOTSIZE<>"+" - "+_Symb,0,_x1+Dpi(550),Y-Dpi(5),Dpi(65),Dpi(15),DoubleToString(GlobalVariableGet(OBJPREFIX+_Symb+" - Lotsize"),2),"Tahoma",10,ALIGN_CENTER,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"LOTSIZE<"+" - "+_Symb,0,_x1+Dpi(555),Y,CORNER_LEFT_UPPER,"6","Webdings",8,C'59,41,40',0,ANCHOR_CENTER,false,false,true,0,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+"LOTSIZE>"+" - "+_Symb,0,_x1+Dpi(610),Y,CORNER_LEFT_UPPER,"5","Webdings",8,C'59,41,40',0,ANCHOR_CENTER,false,false,true,0,"\n",false);
//---
   EditCreate(0,OBJPREFIX+"_TP<>"+" - "+_Symb,0,_x1+Dpi(625),Y-Dpi(5),Dpi(50),Dpi(15),DoubleToString(GlobalVariableGet(OBJPREFIX+_Symb+" - Takeprofit"),0),"Tahoma",10,ALIGN_RIGHT,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"TPª"+" - "+_Symb,0,_x1+Dpi(633),Y+Dpi(2),CORNER_LEFT_UPPER,"tp",sFontType,10,clrDarkGray,0,ANCHOR_CENTER,false,false,true,0,"\n");
//---
   ButtonCreate(0,OBJPREFIX+"BUY"+" - "+_Symb,0,_x1+Dpi(685),Y-Dpi(5),Dpi(30),Dpi(15),CORNER_LEFT_UPPER,"Buy","Trebuchet MS",10,C'59,41,40',C'160,192,255',C'144,176,239',false,false,false,true,1,"Buy "+_Symb);
//---
   ButtonCreate(0,OBJPREFIX+"CLOSE"+" - "+_Symb,0,_x1+Dpi(740),Y-Dpi(5),Dpi(40),Dpi(15),CORNER_LEFT_UPPER," Close","Trebuchet MS",10,C'59,41,40',C'255,255,160',C'239,239,144',false,false,false,true,1,"Close "+_Symb);
//---
   LabelCreate(0,OBJPREFIX+"PRICEROW_R"+" - "+_Symb,0,_x1+Dpi(855),Y,CORNER_LEFT_UPPER,DoubleToString(0,digits),sFontType,FONTSIZE,startcolor,0,ANCHOR_RIGHT,false,false,true,0,PriceRowRightArr[PriceRowRight]+" "+_Symb);
//---
   LabelCreate(0,OBJPREFIX+"SPREAD"+" - "+_Symb,0,_x1+Dpi(905),Y,CORNER_LEFT_UPPER,"0p",sFontType,FONTSIZE,startcolor,0,ANCHOR_RIGHT,false,false,true,0,"Spread "+_Symb);
//---
   LabelCreate(0,OBJPREFIX+"OPENLOTS"+" - "+_Symb,0,_x1+Dpi(970),Y,CORNER_LEFT_UPPER,"0.00",sFontType,FONTSIZE,startcolor,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"POINTS"+" - "+_Symb,0,_x1+Dpi(CLIENT_BG_WIDTH)-Dpi(155),Y,CORNER_LEFT_UPPER,"0p",sFontType,FONTSIZE,startcolor,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"PROFITS"+" - "+_Symb,0,_x1+Dpi(CLIENT_BG_WIDTH)-Dpi(73),Y,CORNER_LEFT_UPPER,"0.00"+_AccountCurrency(),sFontType,FONTSIZE,startcolor,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"RETURN"+" - "+_Symb,0,_x1+Dpi(CLIENT_BG_WIDTH)-Dpi(10),Y,CORNER_LEFT_UPPER,"0.00%",sFontType,FONTSIZE,startcolor,0,ANCHOR_RIGHT,false,false,true,0,"\n");

//--- KeyboardTrading
   if(ShowTradePanel)
     {
      //---
      if(KeyboardTrading)
        {
         //---
         if(_Symb==_Symbol)
           {
            //---
            if(ObjectFind(0,OBJPREFIX+"MARKER")!=0)
               LabelCreate(0,OBJPREFIX+"MARKER",0,_x1+Dpi(10),Y+Dpi(5),CORNER_LEFT_UPPER,"_______",sFontType,FONTSIZE,COLOR_MARKER,0,ANCHOR_LEFT,false,false,true,0,"\n");
            else
              {
               //---
               if(ObjectGetInteger(0,OBJPREFIX+"MARKER",OBJPROP_YDISTANCE,0)!=Y+Dpi(5))
                  ObjectDelete(0,OBJPREFIX+"MARKER");
              }
           }
        }
      else
        {
         //---
         if(ObjectFind(0,OBJPREFIX+"MARKER")==0)
            ObjectDelete(0,OBJPREFIX+"MARKER");
        }
     }
//---
  }
//+------------------------------------------------------------------+
//| CreateProBar                                                     |
//+------------------------------------------------------------------+
void CreateProBar(string _Symb,int x,int y)
  {
//---
   int fr_y_pb=y;
//---
   for(int i=1; i<11; i++)
     {
      LabelCreate(0,OBJPREFIX+"PB#"+IntegerToString(i)+" - "+_Symb,0,x,fr_y_pb,CORNER_LEFT_UPPER,"0","Webdings",25,clrNONE,0,ANCHOR_RIGHT,false,false,true,0,"\n");
      fr_y_pb-=Dpi(5);
     }
//---
  }
//+------------------------------------------------------------------+
//| UpdateProBar                                                     |
//+------------------------------------------------------------------+
void UpdateProBar(string _Symb,double Percent)
  {
//---
   for(int i=1; i<11; i++)
      ObjectSetInteger(0,OBJPREFIX+"PB#"+IntegerToString(i)+" - "+_Symb,OBJPROP_COLOR,SelectedTheme==0?clrGainsboro:C'80,80,80');
//---
   if(Percent>=0)
      ObjectSetInteger(0,OBJPREFIX+"PB#"+"1"+" - "+_Symb,OBJPROP_COLOR,C'255,0,0');
//---   
   if(Percent>10)
      ObjectSetInteger(0,OBJPREFIX+"PB#"+"2"+" - "+_Symb,OBJPROP_COLOR,C'255,69,0');
//---
   if(Percent>20)
      ObjectSetInteger(0,OBJPREFIX+"PB#"+"3"+" - "+_Symb,OBJPROP_COLOR,C'255,150,0');
//---
   if(Percent>30)
      ObjectSetInteger(0,OBJPREFIX+"PB#"+"4"+" - "+_Symb,OBJPROP_COLOR,C'255,165,0');
//---
   if(Percent>40)
      ObjectSetInteger(0,OBJPREFIX+"PB#"+"5"+" - "+_Symb,OBJPROP_COLOR,C'255,215,0');
//---
   if(Percent>50)
      ObjectSetInteger(0,OBJPREFIX+"PB#"+"6"+" - "+_Symb,OBJPROP_COLOR,C'255,255,0');
//---
   if(Percent>60)
      ObjectSetInteger(0,OBJPREFIX+"PB#"+"7"+" - "+_Symb,OBJPROP_COLOR,C'173,255,47');
//---
   if(Percent>70)
      ObjectSetInteger(0,OBJPREFIX+"PB#"+"8"+" - "+_Symb,OBJPROP_COLOR,C'124,252,0');
//---
   if(Percent>80)
      ObjectSetInteger(0,OBJPREFIX+"PB#"+"9"+" - "+_Symb,OBJPROP_COLOR,C'0,255,0');
//---
   if(Percent>90)
      ObjectSetInteger(0,OBJPREFIX+"PB#"+"10"+" - "+_Symb,OBJPROP_COLOR,C'0,255,0');
//---
  }
//+------------------------------------------------------------------+
//| CreateMinWindow                                                  |
//+------------------------------------------------------------------+
void CreateMinWindow()
  {
//---  
   RectLabelCreate(0,OBJPREFIX+"MIN"+"BCKGRND[]",0,Dpi(1),Dpi(20),Dpi(163),Dpi(25),COLOR_BORDER,BORDER_FLAT,CORNER_LEFT_LOWER,COLOR_BORDER,STYLE_SOLID,1,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"MIN"+"CAPTION",0,Dpi(140)-Dpi(64),Dpi(18),CORNER_LEFT_LOWER,"MultiTrader","Arial Black",8,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+"MIN"+"MAXIMIZE",0,Dpi(156),Dpi(23),CORNER_LEFT_LOWER,"1","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//---
  }
//+------------------------------------------------------------------+
//| DelteMinWindow                                                   |
//+------------------------------------------------------------------+
void DelteMinWindow()
  {
//---
   ObjectDelete(0,OBJPREFIX+"MIN"+"BCKGRND[]");
   ObjectDelete(0,OBJPREFIX+"MIN"+"CAPTION");
   ObjectDelete(0,OBJPREFIX+"MIN"+"MAXIMIZE");
//---
  }
//+------------------------------------------------------------------+
//| TradeNum                                                         |
//+------------------------------------------------------------------+
int TradeNum(int Type)
  {
//---
   int count=0;
//---
   datetime starttime=0;
//---
   if(Type==1)
      starttime=iTime(_Symbol,PERIOD_D1,0);
//---
   if(Type==2)
      starttime=iTime(_Symbol,PERIOD_W1,0);
//---
   if(Type==3)
      starttime=iTime(_Symbol,PERIOD_MN1,0);
//---
   for(int i=0; i<OrdersHistoryTotal(); i++)
     {
      //---
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         //---
         if(OrderMagicNumber()==MagicNumber)
           {
            //---
            if(OrderType()<=1)
              {
               //---
               if(OrderCloseTime()>=starttime)
                  count++;
              }
           }
        }
     }
//---
   return(count);
  }
//+------------------------------------------------------------------+
//| UpdateSymbolGUI                                                  |
//+------------------------------------------------------------------+
void ObjectsUpdateAll(string _Symb)
  {
//--- Market info
   double bid=MarketInfo(_Symb,MODE_BID),ask=MarketInfo(_Symb,MODE_ASK),avg=(ask+bid)/2;
//---
   double TFHigh=iHigh(_Symb,CalcTF,0),TFLow=iLow(_Symb,CalcTF,0),TFOpen=iOpen(_Symb,CalcTF,0);
//---
   double TFLastHigh=iHigh(_Symb,CalcTF,1),TFLastLow=iLow(_Symb,CalcTF,1),TFLastClose=iClose(_Symb,CalcTF,1);
//---
   long Spread=SymbolInfoInteger(_Symb,SYMBOL_SPREAD);
   int digits = (int)MarketInfo(_Symb,MODE_DIGITS);

//--- OpenPosSell
   if(OpenPos(_Symb,OP_SELL)>0)
      ObjectSetString(0,OBJPREFIX+"OPENSELL"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(OpenPos(_Symb,OP_SELL),0));
   else
      ObjectSetString(0,OBJPREFIX+"OPENSELL"+" - "+_Symb,OBJPROP_TEXT,"\n");

//--- OpenPosBuy
   if(OpenPos(_Symb,OP_BUY)>0)
      ObjectSetString(0,OBJPREFIX+"OPENBUY"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(OpenPos(_Symb,OP_BUY),0));
   else
      ObjectSetString(0,OBJPREFIX+"OPENBUY"+" - "+_Symb,OBJPROP_TEXT,"\n");

//--- Range
   double pts=MarketInfo(_Symb,MODE_POINT);
//---
   double range=0;
//---
   if(pts!=0)
      range=(TFHigh-TFLow)/pts;

//--- SetRange
   ObjectSetString(0,OBJPREFIX+"RANGE₱"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(range,0)+"p");
   ObjectSetString(0,OBJPREFIX+"RANGE₱"+" - "+_Symb,OBJPROP_TOOLTIP,"Range "+_Symb+"\n"+"Average: "+DoubleToString(ADR(_Symb),0)+"p");
   ObjectSetInteger(0,OBJPREFIX+"RANGE₱"+" - "+_Symb,OBJPROP_COLOR,COLOR_FONT);

//--- Price Rows (L/R)
   double pp=(TFLastHigh+TFLastLow+TFLastClose)/3;

//---
   if(PriceRowLeft==0)//Bid
      ObjectSetString(0,OBJPREFIX+"PRICEROW_L"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(bid,digits));

//---
   if(PriceRowLeft==1)//Low
      ObjectSetString(0,OBJPREFIX+"PRICEROW_L"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(TFLow,digits));

//---
   if(PriceRowLeft==2)//Open
      ObjectSetString(0,OBJPREFIX+"PRICEROW_L"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(TFOpen,digits));

//---
   if(PriceRowLeft==3)//Pivot
      ObjectSetString(0,OBJPREFIX+"PRICEROW_L"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(pp,digits));

//---
   if(PriceRowRight==0)//Ask
      ObjectSetString(0,OBJPREFIX+"PRICEROW_R"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(ask,digits));

//---
   if(PriceRowRight==1)//High
      ObjectSetString(0,OBJPREFIX+"PRICEROW_R"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(TFHigh,digits));

//---
   if(PriceRowRight==2)//Open
      ObjectSetString(0,OBJPREFIX+"PRICEROW_R"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(TFOpen,digits));

//---
   if(PriceRowRight==3)//Pivot
      ObjectSetString(0,OBJPREFIX+"PRICEROW_R"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(pp,digits));

//--- SetColor
   ObjectSetInteger(0,OBJPREFIX+"PRICEROW_R"+" - "+_Symb,OBJPROP_COLOR,COLOR_FONT);
   ObjectSetInteger(0,OBJPREFIX+"PRICEROW_L"+" - "+_Symb,OBJPROP_COLOR,COLOR_FONT);

//---
   if(PriceRowLeft<=1)
     {
      //---
      if((bid-TFLow)==0)
         ObjectSetInteger(0,OBJPREFIX+"PRICEROW_L"+" - "+_Symb,OBJPROP_COLOR,COLOR_RED);
     }
//---
   if(PriceRowLeft==3)
     {
      //---
      if(avg>pp)
         ObjectSetInteger(0,OBJPREFIX+"PRICEROW_L"+" - "+_Symb,OBJPROP_COLOR,COLOR_BUY);
      //---
      if(avg<pp)
         ObjectSetInteger(0,OBJPREFIX+"PRICEROW_L"+" - "+_Symb,OBJPROP_COLOR,COLOR_SELL);
     }
//---
   if(PriceRowRight<=1)
     {
      //---
      if((ask-TFHigh)==0)
         ObjectSetInteger(0,OBJPREFIX+"PRICEROW_R"+" - "+_Symb,OBJPROP_COLOR,COLOR_GREEN);
     }
//---
   if(PriceRowRight==3)
     {
      //---
      if(avg>pp)
         ObjectSetInteger(0,OBJPREFIX+"PRICEROW_R"+" - "+_Symb,OBJPROP_COLOR,COLOR_BUY);
      //---
      if(avg<pp)
         ObjectSetInteger(0,OBJPREFIX+"PRICEROW_R"+" - "+_Symb,OBJPROP_COLOR,COLOR_SELL);
     }

//--- Spread
   ObjectSetString(0,OBJPREFIX+"SPREAD"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(MarketInfo(_Symb,MODE_SPREAD),0)+"p");

//---
   if(Spread>=100)
      ObjectSetInteger(0,OBJPREFIX+"SPREAD"+" - "+_Symb,OBJPROP_COLOR,clrOrangeRed);
   else
      ObjectSetInteger(0,OBJPREFIX+"SPREAD"+" - "+_Symb,OBJPROP_COLOR,COLOR_FONT);

//--- OpenLots
   ObjectSetString(0,OBJPREFIX+"OPENLOTS"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(OpenLots(_Symb,OP_ALL),2));

//---
   if(OpenLots(_Symb,OP_BUY)>0 && OpenLots(_Symb,OP_SELL)==0)
      ObjectSetInteger(0,OBJPREFIX+"OPENLOTS"+" - "+_Symb,OBJPROP_COLOR,COLOR_BUY);

//---
   if(OpenLots(_Symb,OP_SELL)>0 && OpenLots(_Symb,OP_BUY)==0)
      ObjectSetInteger(0,OBJPREFIX+"OPENLOTS"+" - "+_Symb,OBJPROP_COLOR,COLOR_SELL);

//---
   color COLOR_HEDGE=(SelectedTheme==0)?clrDarkOrange:clrGold;

//---
   if(OpenLots(_Symb,OP_SELL)>0 && OpenLots(_Symb,OP_BUY)>0)
      ObjectSetInteger(0,OBJPREFIX+"OPENLOTS"+" - "+_Symb,OBJPROP_COLOR,COLOR_HEDGE);

//---
   if(OpenLots(_Symb,OP_ALL)==0)
      ObjectSetInteger(0,OBJPREFIX+"OPENLOTS"+" - "+_Symb,OBJPROP_COLOR,COLOR_FONT);

//--- Get Currencies
   double AUD=AUD(),CAD=CAD(),CHF=CHF(),EUR=EUR(),GBP=GBP(),JPY=JPY(),NZD=NZD(),USD=USD();

//---
   double symbol_r=SymbPerc(_Symb);

//--- Percent
   ObjectSetString(0,OBJPREFIX+"RANGE%"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(SymbPerc(_Symb),0)+"%");
   ObjectSetInteger(0,OBJPREFIX+_Symb,OBJPROP_COLOR,COLOR_FONT);
   ObjectSetInteger(0,OBJPREFIX+"RANGE%"+" - "+_Symb,OBJPROP_COLOR,COLOR_FONT);

//---
   if(symbol_r>=BuyLevel)
     {
      //---
      if(
         (StringFind(_Symb,"AUD",0)!=-1 && (AUD>=BuyLevel || AUD<=SellLevel))
         || 
         (StringFind(_Symb,"CAD",0)!=-1 && (CAD>=BuyLevel || CAD<=SellLevel))
         || 
         (StringFind(_Symb,"CHF",0)!=-1 && (CHF>=BuyLevel || CHF<=SellLevel))
         || 
         (StringFind(_Symb,"EUR",0)!=-1 && (EUR>=BuyLevel || EUR<=SellLevel))
         || 
         (StringFind(_Symb,"GBP",0)!=-1 && (GBP>=BuyLevel || GBP<=SellLevel))
         || 
         (StringFind(_Symb,"JPY",0)!=-1 && (JPY>=BuyLevel || JPY<=SellLevel))
         || 
         (StringFind(_Symb,"NZD",0)!=-1 && (NZD>=BuyLevel || NZD<=SellLevel))
         || 
         (StringFind(_Symb,"USD",0)!=-1 && (USD>=BuyLevel || USD<=SellLevel))
         )
         ObjectSetInteger(0,OBJPREFIX+_Symb,OBJPROP_COLOR,COLOR_GREEN);
      //---
      ObjectSetInteger(0,OBJPREFIX+"RANGE%"+" - "+_Symb,OBJPROP_COLOR,COLOR_GREEN);
     }

//---
   if(symbol_r<=SellLevel)
     {
      //---
      if(
         (StringFind(_Symb,"AUD",0)!=-1 && (AUD>=BuyLevel || AUD<=SellLevel))
         || 
         (StringFind(_Symb,"CAD",0)!=-1 && (CAD>=BuyLevel || CAD<=SellLevel))
         || 
         (StringFind(_Symb,"CHF",0)!=-1 && (CHF>=BuyLevel || CHF<=SellLevel))
         || 
         (StringFind(_Symb,"EUR",0)!=-1 && (EUR>=BuyLevel || EUR<=SellLevel))
         || 
         (StringFind(_Symb,"GBP",0)!=-1 && (GBP>=BuyLevel || GBP<=SellLevel))
         || 
         (StringFind(_Symb,"JPY",0)!=-1 && (JPY>=BuyLevel || JPY<=SellLevel))
         || 
         (StringFind(_Symb,"NZD",0)!=-1 && (NZD>=BuyLevel || NZD<=SellLevel))
         || 
         (StringFind(_Symb,"USD",0)!=-1 && (USD>=BuyLevel || USD<=SellLevel))
         )
         ObjectSetInteger(0,OBJPREFIX+_Symb,OBJPROP_COLOR,COLOR_RED);
      //---
      ObjectSetInteger(0,OBJPREFIX+"RANGE%"+" - "+_Symb,OBJPROP_COLOR,COLOR_RED);
     }

//--- AvoidZeroDivide
   double currentclose=iClose(_Symb,CalcTF,0);
   double previousclose=iClose(_Symb,CalcTF,1);

//---
   if(previousclose!=0)
     {
      //---
      //double symbol_p=NormalizeDouble((dayclose-dayopen)/dayclose*100,2); //Old Calculation
      double symbol_p=NormalizeDouble((currentclose-previousclose)/previousclose*100,2);

      //---
      if(symbol_p>0)
        {
         //--- SetObjects
         if(symbol_r>=75)
            ObjectSetString(0,OBJPREFIX+"SYMBOL§"+" - "+_Symb,OBJPROP_TEXT,0,"á");
         if(symbol_r<75)
            ObjectSetString(0,OBJPREFIX+"SYMBOL§"+" - "+_Symb,OBJPROP_TEXT,0,"ä");
         //---
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL%"+" - "+_Symb,OBJPROP_COLOR,±Clr(symbol_p));
         //---
         ObjectSetString(0,OBJPREFIX+"SYMBOL%"+" - "+_Symb,OBJPROP_TEXT,0,±Str(symbol_p,2)+"%");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL§"+" - "+_Symb,OBJPROP_COLOR,±Clr(symbol_p));
         //--- Range P
         if(range>ADR(_Symb))
           {
            //---
            if(symbol_r>=BuyLevel)
               ObjectSetInteger(0,OBJPREFIX+"RANGE₱"+" - "+_Symb,OBJPROP_COLOR,COLOR_GREEN);
           }
        }

      //---
      if(symbol_p<0)
        {
         //---
         if(symbol_r<=25)
            ObjectSetString(0,OBJPREFIX+"SYMBOL§"+" - "+_Symb,OBJPROP_TEXT,0,"â");
         if(symbol_r>25)
            ObjectSetString(0,OBJPREFIX+"SYMBOL§"+" - "+_Symb,OBJPROP_TEXT,0,"æ");
         //---
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL%"+" - "+_Symb,OBJPROP_COLOR,±Clr(symbol_p));
         //---
         ObjectSetString(0,OBJPREFIX+"SYMBOL%"+" - "+_Symb,OBJPROP_TEXT,0,±Str(symbol_p,2)+"%");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL§"+" - "+_Symb,OBJPROP_COLOR,±Clr(symbol_p));
         //--- Range P
         if(range>ADR(_Symb))
           {
            //---
            if(symbol_r<=SellLevel)
               ObjectSetInteger(0,OBJPREFIX+"RANGE₱"+" - "+_Symb,OBJPROP_COLOR,COLOR_RED);
           }
        }

      //---
      if(symbol_p==0)
        {
         //---
         ObjectSetString(0,OBJPREFIX+"SYMBOL§"+" - "+_Symb,OBJPROP_TEXT,0,"à");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL%"+" - "+_Symb,OBJPROP_COLOR,±Clr(symbol_p));
         //---
         ObjectSetString(0,OBJPREFIX+"SYMBOL%"+" - "+_Symb,OBJPROP_TEXT,0,±Str(symbol_p,2)+"%");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL§"+" - "+_Symb,OBJPROP_COLOR,±Clr(symbol_p));
        }
     }

//--- Floating
   ObjectSetString(0,OBJPREFIX+"POINTS"+" - "+_Symb,OBJPROP_TEXT,±Str(FloatingPoints(_Symb),0)+"p");
   ObjectSetInteger(0,OBJPREFIX+"POINTS"+" - "+_Symb,OBJPROP_COLOR,±Clr(FloatingPoints(_Symb)));

//---
   ObjectSetString(0,OBJPREFIX+"PROFITS"+" - "+_Symb,OBJPROP_TEXT,±Str(FloatingProfits(_Symb),2)+_AccountCurrency());
   ObjectSetInteger(0,OBJPREFIX+"PROFITS"+" - "+_Symb,OBJPROP_COLOR,±Clr(FloatingProfits(_Symb)));

//---
   ObjectSetString(0,OBJPREFIX+"RETURN"+" - "+_Symb,OBJPROP_TEXT,±Str(FloatingReturn(_Symb),2)+"%");
   ObjectSetInteger(0,OBJPREFIX+"RETURN"+" - "+_Symb,OBJPROP_COLOR,±Clr(FloatingReturn(_Symb)));

//--- AutoSL&TP&Lots
   StopLossDist=StringToDouble(ObjectGetString(0,OBJPREFIX+"SL<>"+" - "+_Symb,OBJPROP_TEXT,0));
   RiskInp=StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK%<>",OBJPROP_TEXT,0));
   RR=StringToDouble(ObjectGetString(0,OBJPREFIX+"RR<>",OBJPROP_TEXT,0));
   _TP=StopLossDist*RR;

//--- SL
   if(AutoSL)
     {
      //---
      ObjectSetInteger(0,OBJPREFIX+"SL<>"+" - "+_Symb,OBJPROP_READONLY,true);
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"SL<>"+" - "+_Symb,OBJPROP_TEXT,0,DoubleToString(ATR(_Symb,ATRTF,ATRPeriod)*ATRMulti,0));
     }
   else
      ObjectSetInteger(0,OBJPREFIX+"SL<>"+" - "+_Symb,OBJPROP_READONLY,false);

//--- _TP
   if(AutoTP)
     {
      //---
      ObjectSetInteger(0,OBJPREFIX+"_TP<>"+" - "+_Symb,OBJPROP_READONLY,true);
      //---
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"_TP<>"+" - "+_Symb,OBJPROP_TEXT,0,DoubleToString(_TP,0));
     }
   else
      ObjectSetInteger(0,OBJPREFIX+"_TP<>"+" - "+_Symb,OBJPROP_READONLY,false);

//--- Lots
   if(AutoLots)
     {
      //---
      ObjectSetInteger(0,OBJPREFIX+"LOTSIZE<>"+" - "+_Symb,OBJPROP_READONLY,true);
      //---
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+_Symb,OBJPROP_TEXT,0,DoubleToString(_Lots(_Symb,RiskInp,StopLossDist),2));
     }
   else
      ObjectSetInteger(0,OBJPREFIX+"LOTSIZE<>"+" - "+_Symb,OBJPROP_READONLY,false);
//---
  }
//+------------------------------------------------------------------+
//| OverAllInfo                                                      |
//+------------------------------------------------------------------+
void OverAllInfo()
  {
//--- TotalPos
   ObjectSetInteger(0,OBJPREFIX+"SELLPOS«",OBJPROP_COLOR,0,COLOR_FONT);
   ObjectSetInteger(0,OBJPREFIX+"BUYPOS«",OBJPROP_COLOR,0,COLOR_FONT);

//---
   int openpos_sell=0;

//---
   for(int x=0; x<ArraySize(aSymbols); x++)
      openpos_sell+=OpenPos(aSymbols[x],OP_SELL);

//---
   ObjectSetString(0,OBJPREFIX+"SELLPOS«",OBJPROP_TEXT,DoubleToString(openpos_sell,0));

//---
   if(openpos_sell>0)
      ObjectSetInteger(0,OBJPREFIX+"SELLPOS«",OBJPROP_COLOR,0,COLOR_SELL);

//---
   int openpos_buy=0;

//---
   for(int x=0; x<ArraySize(aSymbols); x++)
      openpos_buy+=OpenPos(aSymbols[x],OP_BUY);

//---
   ObjectSetString(0,OBJPREFIX+"BUYPOS«",OBJPROP_TEXT,DoubleToString(openpos_buy,0));

//---
   if(openpos_buy>0)
      ObjectSetInteger(0,OBJPREFIX+"BUYPOS«",OBJPROP_COLOR,0,COLOR_BUY);

//---
   int openpos_all=0;

//---
   for(int x=0; x<ArraySize(aSymbols); x++)
      openpos_all+=OpenPos(aSymbols[x],OP_ALL);

//---
   ObjectSetString(0,OBJPREFIX+"TOTALPOS«",OBJPROP_TEXT,DoubleToString(openpos_all,0));

//---
   if(openpos_buy>0 && openpos_sell==0)
      ObjectSetInteger(0,OBJPREFIX+"TOTALPOS«",OBJPROP_COLOR,COLOR_BUY);

//---
   if(openpos_sell>0 && openpos_buy==0)
      ObjectSetInteger(0,OBJPREFIX+"TOTALPOS«",OBJPROP_COLOR,COLOR_SELL);

//---
   color COLOR_HEDGE=(SelectedTheme==0)?clrDarkOrange:clrGold;

//---
   if(openpos_sell>0 && openpos_buy>0)
      ObjectSetInteger(0,OBJPREFIX+"TOTALPOS«",OBJPROP_COLOR,COLOR_HEDGE);

//---
   if(openpos_all==0)
      ObjectSetInteger(0,OBJPREFIX+"TOTALPOS«",OBJPROP_COLOR,COLOR_FONT);

//--- Total
   ObjectSetString(0,OBJPREFIX+"TOTAL«",OBJPROP_TEXT,±Str(TotalFloatingPoints(),0)+"p");
   ObjectSetInteger(0,OBJPREFIX+"TOTAL«",OBJPROP_COLOR,±Clr(TotalFloatingPoints()));

//---
   ObjectSetString(0,OBJPREFIX+"TOTAL««",OBJPROP_TEXT,±Str(TotalFloatingProfits(),2)+_AccountCurrency());
   ObjectSetInteger(0,OBJPREFIX+"TOTAL««",OBJPROP_COLOR,±Clr(TotalFloatingProfits()));

//---
   ObjectSetString(0,OBJPREFIX+"TOTAL«««",OBJPROP_TEXT,±Str(TotalReturn(),2)+"%");
   ObjectSetInteger(0,OBJPREFIX+"TOTAL«««",OBJPROP_COLOR,±Clr(TotalReturn()));

//--- Balance
   ObjectSetString(0,OBJPREFIX+"BALANCE«",OBJPROP_TEXT,Balance());

//--- Leverage
   ObjectSetString(0,OBJPREFIX+"LEVERAGE",OBJPROP_TEXT,Leverage()>="1"?Leverage():"1");

//--- TotalLots
   ObjectSetString(0,OBJPREFIX+"TOTALLOTS",OBJPROP_TEXT,DoubleToString(OpenLots(IntegerToString(-1),OP_ALL),2));

//---
   if(OpenLots(IntegerToString(-1),OP_BUY)>0 && OpenLots(IntegerToString(-1),OP_SELL)==0)
      ObjectSetInteger(0,OBJPREFIX+"TOTALLOTS",OBJPROP_COLOR,COLOR_BUY);

//---
   if(OpenLots(IntegerToString(-1),OP_SELL)>0 && OpenLots(IntegerToString(-1),OP_BUY)==0)
      ObjectSetInteger(0,OBJPREFIX+"TOTALLOTS",OBJPROP_COLOR,COLOR_SELL);

//---
   if(OpenLots(IntegerToString(-1),OP_SELL)>0 && OpenLots(IntegerToString(-1),OP_BUY)>0)
      ObjectSetInteger(0,OBJPREFIX+"TOTALLOTS",OBJPROP_COLOR,COLOR_HEDGE);

//---
   if(OpenLots(IntegerToString(-1),OP_ALL)==0)
      ObjectSetInteger(0,OBJPREFIX+"TOTALLOTS",OBJPROP_COLOR,COLOR_FONT);

//--- Time
   ObjectSetString(0,OBJPREFIX+"TIME",OBJPROP_TEXT,TimeToString(TimeLocal(),TIME_SECONDS));

//---
   string TimeChar="",TimeStr=TimeToString(TimeLocal(),TIME_MINUTES);

//---
   if((TimeStr>=TimeToString(StrToTime("00:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("01:00"),TIME_MINUTES))
      || 
      (TimeStr>=TimeToString(StrToTime("12:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("13:00"),TIME_MINUTES)))
      TimeChar="Â";
//---
   if((TimeStr>=TimeToString(StrToTime("01:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("02:00"),TIME_MINUTES))
      || 
      (TimeStr>=TimeToString(StrToTime("13:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("14:00"),TIME_MINUTES)))
      TimeChar="·";
//---
   if((TimeStr>=TimeToString(StrToTime("02:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("03:00"),TIME_MINUTES))
      || 
      (TimeStr>=TimeToString(StrToTime("14:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("15:00"),TIME_MINUTES)))
      TimeChar="¸";
//---
   if((TimeStr>=TimeToString(StrToTime("03:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("04:00"),TIME_MINUTES))
      || 
      (TimeStr>=TimeToString(StrToTime("15:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("16:00"),TIME_MINUTES)))
      TimeChar="¹";
//---
   if((TimeStr>=TimeToString(StrToTime("04:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("05:00"),TIME_MINUTES))
      || 
      (TimeStr>=TimeToString(StrToTime("16:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("17:00"),TIME_MINUTES)))
      TimeChar="º";
//---
   if((TimeStr>=TimeToString(StrToTime("05:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("06:00"),TIME_MINUTES))
      || 
      (TimeStr>=TimeToString(StrToTime("17:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("18:00"),TIME_MINUTES)))
      TimeChar="»";
//---
   if((TimeStr>=TimeToString(StrToTime("06:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("07:00"),TIME_MINUTES))
      || 
      (TimeStr>=TimeToString(StrToTime("18:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("19:00"),TIME_MINUTES)))
      TimeChar="¼";
//---
   if((TimeStr>=TimeToString(StrToTime("07:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("08:00"),TIME_MINUTES))
      || 
      (TimeStr>=TimeToString(StrToTime("19:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("20:00"),TIME_MINUTES)))
      TimeChar="½";
//---
   if((TimeStr>=TimeToString(StrToTime("08:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("09:00"),TIME_MINUTES))
      || 
      (TimeStr>=TimeToString(StrToTime("20:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("21:00"),TIME_MINUTES)))
      TimeChar="¾";
//---
   if((TimeStr>=TimeToString(StrToTime("09:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("10:00"),TIME_MINUTES))
      || 
      (TimeStr>=TimeToString(StrToTime("21:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("22:00"),TIME_MINUTES)))
      TimeChar="¿";
//---
   if((TimeStr>=TimeToString(StrToTime("10:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("11:00"),TIME_MINUTES))
      || 
      (TimeStr>=TimeToString(StrToTime("22:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("23:00"),TIME_MINUTES)))
      TimeChar="À";
//---
   if((TimeStr>=TimeToString(StrToTime("11:00"),TIME_MINUTES) && TimeStr<TimeToString(StrToTime("12:00"),TIME_MINUTES))
      || 
      (TimeStr>=TimeToString(StrToTime("23:00"),TIME_MINUTES) && TimeStr<=TimeToString(StrToTime("23:59"),TIME_MINUTES)))
      TimeChar="Á";

//---
   ObjectSetString(0,OBJPREFIX+"TIME§",OBJPROP_TEXT,TimeChar);
//---
  }
//+------------------------------------------------------------------+
//| CStrenghts                                                       |
//+------------------------------------------------------------------+
void CStrenghts()
  {
//--- Get Currencies
   double AUD=AUD(),CAD=CAD(),CHF=CHF(),EUR=EUR(),GBP=GBP(),JPY=JPY(),NZD=NZD(),USD=USD();

//--- AUD
   ObjectSetString(0,OBJPREFIX+"AUD%",OBJPROP_TEXT,DoubleToString(AUD,0)+"%");
   UpdatePercent("AUD",AUD);
   UpdateProBar("AUD",AUD);

//--- CAD
   ObjectSetString(0,OBJPREFIX+"CAD%",OBJPROP_TEXT,DoubleToString(CAD,0)+"%");
   UpdatePercent("CAD",CAD);
   UpdateProBar("CAD",CAD);

//--- CHF
   ObjectSetString(0,OBJPREFIX+"CHF%",OBJPROP_TEXT,DoubleToString(CHF,0)+"%");
   UpdatePercent("CHF",CHF);
   UpdateProBar("CHF",CHF);

//--- EUR
   ObjectSetString(0,OBJPREFIX+"EUR%",OBJPROP_TEXT,DoubleToString(EUR,0)+"%");
   UpdatePercent("EUR",EUR);
   UpdateProBar("EUR",EUR);

//--- GBP
   ObjectSetString(0,OBJPREFIX+"GBP%",OBJPROP_TEXT,DoubleToString(GBP,0)+"%");
   UpdatePercent("GBP",GBP);
   UpdateProBar("GBP",GBP);

//--- JPY
   ObjectSetString(0,OBJPREFIX+"JPY%",OBJPROP_TEXT,DoubleToString(JPY,0)+"%");
   UpdatePercent("JPY",JPY);
   UpdateProBar("JPY",JPY);

//--- NZD
   ObjectSetString(0,OBJPREFIX+"NZD%",OBJPROP_TEXT,DoubleToString(NZD(),0)+"%");
   UpdatePercent("NZD",NZD);
   UpdateProBar("NZD",NZD);
//--- USD
   ObjectSetString(0,OBJPREFIX+"USD%",OBJPROP_TEXT,DoubleToString(USD,0)+"%");
   UpdatePercent("USD",USD);
   UpdateProBar("USD",USD);
//---
  }
//+------------------------------------------------------------------+
//| Alert                                                           |
//+------------------------------------------------------------------+
void Alert()
  {
//--- Get Currencies
   double AUD=AUD(),CAD=CAD(),CHF=CHF(),EUR=EUR(),GBP=GBP(),JPY=JPY(),NZD=NZD(),USD=USD();

//---
   SuggestedPair="";

//---
   double CompareArr[8];

//---
   CompareArr[0]=AUD;
   CompareArr[1]=CAD;
   CompareArr[2]=CHF;
   CompareArr[3]=EUR;
   CompareArr[4]=GBP;
   CompareArr[5]=JPY;
   CompareArr[6]=NZD;
   CompareArr[7]=USD;

//--- GetMax
   double MaxValue=ArrayMaximum(CompareArr);

//---
   string Max="\n";

//---
   if(MaxValue==0)
      Max="AUD";

//---
   if(MaxValue==1)
      Max="CAD";

//---
   if(MaxValue==2)
      Max="CHF";

//---
   if(MaxValue==3)
      Max="EUR";

//---
   if(MaxValue==4)
      Max="GBP";

//---
   if(MaxValue==5)
      Max="JPY";

//---
   if(MaxValue==6)
      Max="NZD";

//---
   if(MaxValue==7)
      Max="USD";

//--- GetMin
   double MinValue=ArrayMinimum(CompareArr);

//---
   string Min="\n";

//---
   if(MinValue==0)
      Min="AUD";

//---
   if(MinValue==1)
      Min="CAD";

//---
   if(MinValue==2)
      Min="CHF";

//---
   if(MinValue==3)
      Min="EUR";

//---
   if(MinValue==4)
      Min="GBP";

//---
   if(MinValue==5)
      Min="JPY";

//---
   if(MinValue==6)
      Min="NZD";

//---
   if(MinValue==7)
      Min="USD";

//---
   if(AlarmIsEnabled)
     {
      //--- AUD
      if(AUD>ResetAlertDwn && AUD<ResetAlertUp)
        {
         //---
         if(!AUDAlarm)
            AUDAlarm=true;
        }
      //---
      if(AUD>=BuyLevel && AUDAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Min=="CAD")
            pair="AUDCAD";
         //---
         if(Min=="CHF")
            pair="AUDCHF";
         //---
         if(Min=="EUR")
            pair="EURAUD";
         //---
         if(Min=="GBP")
            pair="GBPAUD";
         //---
         if(Min=="JPY")
            pair="AUDJPY";
         //---
         if(Min=="NZD")
            pair="AUDNZD";
         //---
         if(Min=="USD")
            pair="AUDUSD";
         //---
         string message="\n";
         //---
         message="AUD reached HIGH";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(AUDTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            AUDAlarm=false;
           }
        }
      if(AUD<=SellLevel && AUDAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Max=="CAD")
            pair="AUDCAD";
         //---
         if(Max=="CHF")
            pair="AUDCHF";
         //---
         if(Max=="EUR")
            pair="EURAUD";
         //---
         if(Max=="GBP")
            pair="GBPAUD";
         //---
         if(Max=="JPY")
            pair="AUDJPY";
         //---
         if(Max=="NZD")
            pair="AUDNZD";
         //---
         if(Max=="USD")
            pair="AUDUSD";
         //---
         string message="\n";
         //---
         message="AUD reached LOW";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(AUDTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            AUDAlarm=false;
           }
        }

      //--- CAD
      if(CAD>ResetAlertDwn && CAD<ResetAlertUp)
        {
         //---
         if(!CADAlarm)
            CADAlarm=true;
        }
      //---
      if(CAD>=BuyLevel && CADAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Min=="AUD")
            pair="AUDCAD";
         //---
         if(Min=="CHF")
            pair="CADCHF";
         //---
         if(Min=="EUR")
            pair="EURCAD";
         //---
         if(Min=="GBP")
            pair="GBPCAD";
         //---
         if(Min=="JPY")
            pair="CADJPY";
         //---
         if(Min=="NZD")
            pair="NZDCAD";
         //---
         if(Min=="USD")
            pair="USDCAD";
         //---
         string message="\n";
         //---
         message="CAD reached HIGH";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(CADTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            CADAlarm=false;
           }
        }
      if(CAD<=SellLevel && CADAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Max=="AUD")
            pair="AUDCAD";
         //---
         if(Max=="CHF")
            pair="CADCHF";
         //---            
         if(Max=="EUR")
            pair="EURCAD";
         //---
         if(Max=="GBP")
            pair="GBPCAD";
         //---
         if(Max=="JPY")
            pair="CADJPY";
         //---
         if(Max=="NZD")
            pair="NZDCAD";
         //---
         if(Max=="USD")
            pair="USDCAD";
         //---
         string message="\n";
         //---
         message="CAD reached LOW";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(CADTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            CADAlarm=false;
           }
        }

      //--- CHF
      if(CHF>ResetAlertDwn && CHF<ResetAlertUp)
        {
         //---
         if(!CHFAlarm)
            CHFAlarm=true;
        }
      //---
      if(CHF>=BuyLevel && CHFAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Min=="AUD")
            pair="AUDCHF";
         //---
         if(Min=="CAD")
            pair="CADCHF";
         //---
         if(Min=="EUR")
            pair="EURCHF";
         //---
         if(Min=="GBP")
            pair="GBPCHF";
         //---
         if(Min=="JPY")
            pair="CHFJPY";
         //---
         if(Min=="NZD")
            pair="NZDCHF";
         //---
         if(Min=="USD")
            pair="USDCHF";
         //---
         string message="\n";
         //---
         message="CHF reached HIGH";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(CHFTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            CHFAlarm=false;
           }
        }
      if(CHF<=SellLevel && CHFAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Max=="AUD")
            pair="AUDCHF";
         //---
         if(Max=="CAD")
            pair="CADCHF";
         //---
         if(Max=="EUR")
            pair="EURCHF";
         //---
         if(Max=="GBP")
            pair="GBPCHF";
         //---
         if(Max=="JPY")
            pair="CHFJPY";
         //---
         if(Max=="NZD")
            pair="NZDCHF";
         //---
         if(Max=="USD")
            pair="USDCHF";
         //---
         string message="\n";
         //---
         message="CHF reached LOW";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(CHFTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            CHFAlarm=false;
           }
        }

      //--- EUR
      if(EUR>ResetAlertDwn && EUR<ResetAlertUp)
        {
         //---
         if(!EURAlarm)
            EURAlarm=true;
        }
      //---
      if(EUR>=BuyLevel && EURAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Min=="AUD")
            pair="EURAUD";
         //---
         if(Min=="CAD")
            pair="EURCAD";
         //---
         if(Min=="CHF")
            pair="EURCHF";
         //---
         if(Min=="GBP")
            pair="EURGBP";
         //---
         if(Min=="JPY")
            pair="EURJPY";
         //---
         if(Min=="NZD")
            pair="EURNZD";
         //---
         if(Min=="USD")
            pair="EURUSD";
         //---
         string message="\n";
         //---
         message="EUR reached HIGH";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(EURTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            EURAlarm=false;
           }
        }
      if(EUR<=SellLevel && EURAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Max=="AUD")
            pair="EURAUD";
         //---
         if(Max=="CAD")
            pair="EURCAD";
         //---
         if(Max=="CHF")
            pair="EURCHF";
         //---
         if(Max=="GBP")
            pair="EURGBP";
         //---
         if(Max=="JPY")
            pair="EURJPY";
         //---
         if(Max=="NZD")
            pair="EURNZD";
         //---
         if(Max=="USD")
            pair="EURUSD";
         //---
         string message="\n";
         //---
         message="EUR reached LOW";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(EURTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            EURAlarm=false;
           }
        }

      //--- GBP
      if(GBP>ResetAlertDwn && GBP<ResetAlertUp)
        {
         //---
         if(!GBPAlarm)
            GBPAlarm=true;
        }
      //---
      if(GBP>=BuyLevel && GBPAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Min=="AUD")
            pair="GBPAUD";
         //---
         if(Min=="CAD")
            pair="GBPCAD";
         //---
         if(Min=="CHF")
            pair="GBPCHF";
         //---
         if(Min=="EUR")
            pair="EURGBP";
         //---
         if(Min=="JPY")
            pair="GBPJPY";
         //---
         if(Min=="NZD")
            pair="GBPNZD";
         //---
         if(Min=="USD")
            pair="GBPUSD";
         //---
         string message="\n";
         //---
         message="GBP reached HIGH";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(GBPTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            GBPAlarm=false;
           }
        }
      if(GBP<=SellLevel && GBPAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Max=="AUD")
            pair="GBPAUD";
         //---
         if(Max=="CAD")
            pair="GBPCAD";
         //---
         if(Max=="CHF")
            pair="GBPCHF";
         //---
         if(Max=="EUR")
            pair="EURGBP";
         //---
         if(Max=="JPY")
            pair="GBPJPY";
         //---
         if(Max=="NZD")
            pair="GBPNZD";
         //---
         if(Max=="USD")
            pair="GBPUSD";
         //---
         string message="\n";
         //---
         message="GBP reached LOW";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(GBPTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            GBPAlarm=false;
           }
        }

      //--- JPY
      if(JPY>ResetAlertDwn && JPY<ResetAlertUp)
        {
         //---
         if(!JPYAlarm)
            JPYAlarm=true;
        }
      //---
      if(JPY>=BuyLevel && JPYAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Min=="AUD")
            pair="AUDJPY";
         //---            
         if(Min=="CAD")
            pair="CADJPY";
         //---
         if(Min=="CHF")
            pair="CHFJPY";
         //---
         if(Min=="EUR")
            pair="EURJPY";
         //---
         if(Min=="GBP")
            pair="GBPJPY";
         //---
         if(Min=="NZD")
            pair="NZDJPY";
         //---
         if(Min=="USD")
            pair="USDJPY";
         //---
         string message="\n";
         //---
         message="JPY reached HIGH";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(JPYTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            JPYAlarm=false;
           }
        }
      if(JPY<=SellLevel && JPYAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Max=="AUD")
            pair="AUDJPY";
         //---
         if(Max=="CAD")
            pair="CADJPY";
         //---
         if(Max=="CHF")
            pair="CHFJPY";
         //---
         if(Max=="EUR")
            pair="EURJPY";
         //---
         if(Max=="GBP")
            pair="GBPJPY";
         //---
         if(Max=="NZD")
            pair="NZDJPY";
         //---
         if(Max=="USD")
            pair="USDJPY";
         //---
         string message="\n";
         //---
         message="JPY reached LOW";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(JPYTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            JPYAlarm=false;
           }
        }

      //--- NZD
      if(NZD>ResetAlertDwn && NZD<ResetAlertUp)
        {
         //---
         if(!NZDAlarm)
            NZDAlarm=true;
        }
      //---
      if(NZD>=BuyLevel && NZDAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Min=="AUD")
            pair="AUDNZD";
         //---
         if(Min=="CAD")
            pair="NZDCAD";
         //---
         if(Min=="CHF")
            pair="NZDCHF";
         //---
         if(Min=="EUR")
            pair="EURNZD";
         //---
         if(Min=="GBP")
            pair="GBPNZD";
         //---
         if(Min=="JPY")
            pair="NZDJPY";
         //---
         if(Min=="USD")
            pair="NZDUSD";
         //---
         string message="\n";
         //---
         message="NZD reached HIGH";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(NZDTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            NZDAlarm=false;
           }
        }
      if(NZD<=SellLevel && NZDAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Max=="AUD")
            pair="AUDNZD";
         //---
         if(Max=="CAD")
            pair="NZDCAD";
         //---
         if(Max=="CHF")
            pair="NZDCHF";
         //---
         if(Max=="EUR")
            pair="EURNZD";
         //---
         if(Max=="GBP")
            pair="GBPNZD";
         //---
         if(Max=="JPY")
            pair="NZDJPY";
         //---
         if(Max=="USD")
            pair="NZDUSD";
         //---
         string message="\n";
         //---
         message="NZD reached LOW";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(NZDTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            NZDAlarm=false;
           }
        }

      //--- USD
      if(USD>ResetAlertDwn && USD<ResetAlertUp)
        {
         //---
         if(!USDAlarm)
            USDAlarm=true;
        }
      //---
      if(USD>=BuyLevel && USDAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Min=="AUD")
            pair="AUDUSD";
         //---
         if(Min=="CAD")
            pair="USDCAD";
         //---
         if(Min=="CHF")
            pair="USDCHF";
         //---
         if(Min=="EUR")
            pair="EURUSD";
         //---
         if(Min=="GBP")
            pair="GBPUSD";
         //---
         if(Min=="JPY")
            pair="USDJPY";
         //---
         if(Min=="NZD")
            pair="NZDUSD";
         //---
         string message="\n";
         //---
         message="USD reached HIGH";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(USDTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            USDAlarm=false;
           }
        }
      if(USD<=SellLevel && USDAlarm)
        {
         //--- GetPair
         string pair="\n";
         //---
         if(Max=="AUD")
            pair="AUDUSD";
         //---
         if(Max=="CAD")
            pair="USDCAD";
         //---
         if(Max=="CHF")
            pair="USDCHF";
         //---
         if(Max=="EUR")
            pair="EURUSD";
         //---
         if(Max=="GBP")
            pair="GBPUSD";
         //---
         if(Max=="JPY")
            pair="USDJPY";
         //---
         if(Max=="NZD")
            pair="NZDUSD";
         //---
         string message="\n";
         //---
         message="USD reached LOW";
         //---
         if(pair!="N/A" && pair!="\n" && PairSuggest)
            StringAdd(message," | Suggested: "+pair);
         //---
         SuggestedPair=pair;
         //---
         if(USDTrigger || !SmartAlert)
           {
            //---
            SendAlerts(message);
            //---
            USDAlarm=false;
           }
        }
     }
//---
  }
//+------------------------------------------------------------------+
//| SendAlerts                                                       |
//+------------------------------------------------------------------+
void SendAlerts(string message)
  {
//---
   if(_Alert)
      Alert(message);
//---
   if(Push)
      SendNotification(message);
//---
   if(Mail)
      SendMail(ExpertName+" [Alert]",StringSubstr(message,StringLen(OBJPREFIX),StringLen(message)));
  }
//+------------------------------------------------------------------+
//| ResetTrigger                                                     |
//+------------------------------------------------------------------+
void ResetTrigger()
  {
//---
   AUDTrigger=false;
   CADTrigger=false;
   CHFTrigger=false;
   EURTrigger=false;
   GBPTrigger=false;
   JPYTrigger=false;
   NZDTrigger=false;
   USDTrigger=false;
//---
  }
//+------------------------------------------------------------------+
//| SpeedOmeter                                                      |
//+------------------------------------------------------------------+
void SpeedOmeter(string _Symb)
  {
//--- CalcSpeed
   double Pts=SymbolInfoDouble(_Symb,SYMBOL_POINT),LastPrice=0,CurrentPrice=0;
   
//---
   if(Pts!=0)
     {
      //---
      LastPrice=GlobalVariableGet(OBJPREFIX+_Symb+" - Price")/Pts;
      //---
      CurrentPrice=((SymbolInfoDouble(_Symb,SYMBOL_ASK)+SymbolInfoDouble(_Symb,SYMBOL_BID))/2)/Pts;
     }
     
//---
   double Speed=NormalizeDouble((CurrentPrice-LastPrice),0);
   
//---
   GlobalVariableSet(OBJPREFIX+_Symb+" - Price",(SymbolInfoDouble(_Symb,SYMBOL_ASK)+SymbolInfoDouble(_Symb,SYMBOL_BID))/2);

//--- SetMaxSpeed
   if(Speed>99)
      Speed=99;

//--- Alarm Trigger
   long Trigger=(iVolume(_Symb,PERIOD_M1,1)/10)/2;

//--- Get Currencies
   double AUD=AUD(),CAD=CAD(),CHF=CHF(),EUR=EUR(),GBP=GBP(),JPY=JPY(),NZD=NZD(),USD=USD();

//---
   if(SuggestedPair!="\n" && Trigger>0)
     {
      //---
      if(AUD<=SellLevel || AUD>=BuyLevel)
         if(StringFind(_Symb,"AUD",0)!=-1)
            if(StringFind(_Symb,SuggestedPair,0)!=-1)
               if(MathAbs(Speed)>=Trigger)
                  AUDTrigger=true;

      //---
      if(CAD<=SellLevel || CAD>=BuyLevel)
         if(StringFind(_Symb,"CAD",0)!=-1)
            if(StringFind(_Symb,SuggestedPair,0)!=-1)
               if(MathAbs(Speed)>=Trigger)
                  CADTrigger=true;

      //---
      if(CHF<=SellLevel || CHF>=BuyLevel)
         if(StringFind(_Symb,"CHF",0)!=-1)
            if(StringFind(_Symb,SuggestedPair,0)!=-1)
               if(MathAbs(Speed)>=Trigger)
                  CHFTrigger=true;

      //---
      if(EUR<=SellLevel || EUR>=BuyLevel)
         if(StringFind(_Symb,"EUR",0)!=-1)
            if(StringFind(_Symb,SuggestedPair,0)!=-1)
               if(MathAbs(Speed)>=7)
                  EURTrigger=true;

      //---
      if(GBP<=SellLevel || GBP>=BuyLevel)
         if(StringFind(_Symb,"GBP",0)!=-1)
            if(StringFind(_Symb,SuggestedPair,0)!=-1)
               if(MathAbs(Speed)>=Trigger)
                  GBPTrigger=true;

      //---
      if(JPY<=SellLevel || JPY>=BuyLevel)
         if(StringFind(_Symb,"JPY",0)!=-1)
            if(StringFind(_Symb,SuggestedPair,0)!=-1)
               if(MathAbs(Speed)>=7)
                  JPYTrigger=true;

      //---
      if(NZD<=SellLevel || NZD>=BuyLevel)
         if(StringFind(_Symb,"NZD",0)!=-1)
            if(StringFind(_Symb,SuggestedPair,0)!=-1)
               if(MathAbs(Speed)>=Trigger)
                  NZDTrigger=true;

      //---
      if(USD<=SellLevel || USD>=BuyLevel)
         if(StringFind(_Symb,"USD",0)!=-1)
            if(StringFind(_Symb,SuggestedPair,0)!=-1)
               if(MathAbs(Speed)>=Trigger)
                  USDTrigger=true;
      //---
     }
     
//--- ResetColors
   if(ShowTradePanel)
     {
      //---
      for(int i=0; i<(10); i++)
        {
         //--- SetObjects
         if(ObjectFind(0,OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i,0,0))==0)
            ObjectSetInteger(0,OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i,0,0),OBJPROP_COLOR,clrNONE);
         //---
         if(ObjectFind(0,OBJPREFIX+"SPEEDª"+" - "+_Symb)==0)
            ObjectSetInteger(0,OBJPREFIX+"SPEEDª"+" - "+_Symb,OBJPROP_COLOR,clrNONE);
        }
      //--- SetColor&Text
      for(int i=0; i<MathAbs(Speed); i++)
        {
         //--- PositiveValue
         if(Speed>0)
           {
            //--- SetObjects
            if(ObjectFind(0,OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i,0,0))==0)
               ObjectSetInteger(0,OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i,0,0),OBJPROP_COLOR,COLOR_BUY);
            //---
            if(ObjectFind(0,OBJPREFIX+"SPEEDª"+" - "+_Symb)==0)
               ObjectSetInteger(0,OBJPREFIX+"SPEEDª"+" - "+_Symb,OBJPROP_COLOR,COLOR_BUY);
           }
         //--- NegativeValue
         if(Speed<0)
           {
            //--- SetObjects
            if(ObjectFind(0,OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i,0,0))==0)
               ObjectSetInteger(0,OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i,0,0),OBJPROP_COLOR,COLOR_SELL);
            //---
            if(ObjectFind(0,OBJPREFIX+"SPEEDª"+" - "+_Symb)==0)
               ObjectSetInteger(0,OBJPREFIX+"SPEEDª"+" - "+_Symb,OBJPROP_COLOR,COLOR_SELL);
           }
         //---
         if(ObjectFind(0,OBJPREFIX+"SPEEDª"+" - "+_Symb)==0)
            ObjectSetString(0,OBJPREFIX+"SPEEDª"+" - "+_Symb,OBJPROP_TEXT,0,±Str(Speed,0));//SetObject
        }
     }
//---
  }
//+------------------------------------------------------------------+
//| UpdatePercent                                                    |
//+------------------------------------------------------------------+
void UpdatePercent(string _Symb,double Percent)
  {
//---
   ObjectSetString(0,OBJPREFIX+_Symb+"%",OBJPROP_TEXT,DoubleToString(Percent,0)+"%");
   
//---
   if(Percent>=BuyLevel)
     {
      ObjectSetInteger(0,OBJPREFIX+_Symb+"%",OBJPROP_COLOR,clrLimeGreen);
      ObjectSetInteger(0,OBJPREFIX+_Symb+"§",OBJPROP_COLOR,clrLimeGreen);
     }
     
//---
   if(Percent<=SellLevel)
     {
      ObjectSetInteger(0,OBJPREFIX+_Symb+"%",OBJPROP_COLOR,clrRed);
      ObjectSetInteger(0,OBJPREFIX+_Symb+"§",OBJPROP_COLOR,clrRed);
     }
     
//---
   if(Percent<BuyLevel && Percent>SellLevel)
     {
      ObjectSetInteger(0,OBJPREFIX+_Symb+"%",OBJPROP_COLOR,COLOR_FONT);
      ObjectSetInteger(0,OBJPREFIX+_Symb+"§",OBJPROP_COLOR,COLOR_FONT);
     }
//---
  }
//+------------------------------------------------------------------+
//| LotStep                                                          |
//+------------------------------------------------------------------+
double LotStep(const string _Symb)
  {
   return(SymbolInfoDouble(_Symb,SYMBOL_VOLUME_STEP));
  }
//+------------------------------------------------------------------+
//| GetSetInputs                                                     |
//+------------------------------------------------------------------+
void GetSetInputs(const string _Symb)
  {
//--- GetMarketInfo
   double LotStep=SymbolInfoDouble(_Symb,SYMBOL_VOLUME_STEP),MinLot=SymbolInfoDouble(_Symb,SYMBOL_VOLUME_MIN),MaxLot=SymbolInfoDouble(_Symb,SYMBOL_VOLUME_MAX);
   long MinStop=SymbolInfoInteger(_Symb,SYMBOL_TRADE_STOPS_LEVEL);

//--- GetLotSizeInput
   double LotSizeInp=StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+_Symb,OBJPROP_TEXT));/*SetObject*/

//--- RoundLotSize
   double LotSize=LotSizeInp;

//--- Avoid ZeroDivide
   if(LotStep!=0)
      LotSize=MathRound(LotSize/LotStep)*LotStep;

//---
   if(!UserIsEditing)
      ObjectSetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+_Symb,OBJPROP_TEXT,0,DoubleToString(LotSize,2));/*SetObject*/

//--- WrongLotSize
   if(LotSize<=MinLot)
     {
      //---
      LotSize=MinLot;
      //---
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+_Symb,OBJPROP_TEXT,0,DoubleToString(LotSize,2));/*SetObject*/
     }

//---
   if(LotSize>=MaxLot)
     {
      //---
      LotSize=MaxLot;
      //---
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+_Symb,OBJPROP_TEXT,0,DoubleToString(LotSize,2));/*SetObject*/
     }

//--- GetSLInput
   double StopLossInp=StringToDouble(ObjectGetString(0,OBJPREFIX+"SL<>"+" - "+_Symb,OBJPROP_TEXT));/*GetObject*/

//--- WrongSL
   if(StopLossInp!=0)
     {
      //---
      if(StopLossInp<=0.99 || StopLossInp<MinStop)
        {
         //---
         if(!UserIsEditing)
            ObjectSetString(0,OBJPREFIX+"SL<>"+" - "+_Symb,OBJPROP_TEXT,0,DoubleToString(MinStop,0));/*SetObject*/
        }
     }

//--- GetTPInput
   double TakeProfitInp=StringToDouble(ObjectGetString(0,OBJPREFIX+"_TP<>"+" - "+_Symb,OBJPROP_TEXT));/*GetObject*/

//--- WrongTP
   if(TakeProfitInp!=0)
     {
      //---
      if(TakeProfitInp<=0.99 || TakeProfitInp<MinStop)
        {
         //---
         if(!UserIsEditing)
            ObjectSetString(0,OBJPREFIX+"_TP<>"+" - "+_Symb,OBJPROP_TEXT,0,DoubleToString(MinStop,0));/*SetObject*/
        }
     }

//--- Save Global Variables
   GlobalVariableSet(OBJPREFIX+_Symb+" - Stoploss",StringToDouble(ObjectGetString(0,OBJPREFIX+"SL<>"+" - "+_Symb,OBJPROP_TEXT)));
   GlobalVariableSet(OBJPREFIX+_Symb+" - Takeprofit",StringToDouble(ObjectGetString(0,OBJPREFIX+"_TP<>"+" - "+_Symb,OBJPROP_TEXT)));
   GlobalVariableSet(OBJPREFIX+_Symb+" - Lotsize",StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+_Symb,OBJPROP_TEXT)));
//---
  }
//+------------------------------------------------------------------+
//| GetParam                                                         |
//+------------------------------------------------------------------+
void GetParam(string p)
  {
//---
   if(p==OBJPREFIX+" ")
     {
      //---
      double pVal=TerminalInfoInteger(TERMINAL_PING_LAST);
      //---
      MessageBox
      (
       //---
       dString("99A6D43B833CB976021189ABAEEACF5D")+AccountInfoString(ACCOUNT_NAME)
       +"\n"+
       dString("47D4F60E4272BE70FB300EB05BD2AEC9")+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))
       +"\n"+
       dString("83744D48C2D63F90DD2F812DBB5CFC0C")+IntegerToString(AccountInfoInteger(ACCOUNT_LEVERAGE))
       +"\n\n"+
       //---
       dString("B001C36F24DDD87AFB300EB05BD2AEC9")+AccountInfoString(ACCOUNT_COMPANY)
       +"\n"+
       dString("808FEF727352434E021189ABAEEACF5D")+AccountInfoString(ACCOUNT_SERVER)
       +"\n"+
       dString("70FA849373E41928")+DoubleToString(pVal/1000,2)+dString("CDB9155CB6080FC4")
       +"\n\n"+
       //---
       dString("47EFF8FADDDA4F05FB300EB05BD2AEC9")+dString("97BA10D5D76C54AE")
       +"\n\n"+
       dString("7823F8858C13A39B7CC5A7EC4F40E381")
       +"\n"+
       dString("3D1E8ABC29DB2E92F1B07FD9CB96A45738FCA32595840B48C24BEEC18191F150087C9AFD999E487F")
       +"\n\n"+
       dString("589AC65F2BB83753")
       +"\n"+
       dString("3D1E8ABC29DB2E92F1B07FD9CB96A45738FCA32595840B4801D4FEEBA49183BD6314E740BF3EB954")
       //---
       ,MB_CAPTION,MB_ICONINFORMATION|MB_OK
       );
     }
//---
  }
//+------------------------------------------------------------------+
//| GetSetInputsA                                                    |
//+------------------------------------------------------------------+
void GetSetInputsA()
  {
//---   
   double balance=AccountInfoDouble(ACCOUNT_BALANCE);
   
//---
   if(StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK%<>",OBJPROP_TEXT))-RiskInpP!=0)
     {
      //---
      RiskC=(balance/100)*StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK%<>",OBJPROP_TEXT));
      //---
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"RISK$<>",OBJPROP_TEXT,0,DoubleToString(RiskC,2));/*SetObject*/
      //---
      RiskInpP=StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK%<>",OBJPROP_TEXT));
     }
     
//---
   if(StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK$<>",OBJPROP_TEXT))-RiskInpC!=0)
     {
      //---
      if(balance!=0)
         RiskP=StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK$<>",OBJPROP_TEXT))*100/balance;
      //---
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"RISK%<>",OBJPROP_TEXT,0,DoubleToString(RiskP,2));/*SetObject*/
      //---
      RiskInpC=StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK$<>",OBJPROP_TEXT));
     }

//---
   if(RiskInpP<0.01)
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"RISK%<>",OBJPROP_TEXT,0,DoubleToString(0.01,2));/*SetObject*/

//---
   if(RiskInpC<=0)
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"RISK$<>",OBJPROP_TEXT,0,DoubleToString(0.01,2));/*SetObject*/
//---
  }
//+------------------------------------------------------------------+
//| SellBasket                                                       |
//+------------------------------------------------------------------+
void SellBasket(string Currency)
  {
//---
   for(int i=0; i<ArraySize(aSymbols); i++)
     {
      //---
      int stringfind=StringFind(Prefix+aSymbols[i]+Suffix,Currency,StringLen(Prefix));
      //---
      if(stringfind!=-1)
        {
         //---
         if(stringfind>0)
            OrderSend(Prefix+aSymbols[i]+Suffix,OP_BUY);
         else
            OrderSend(Prefix+aSymbols[i]+Suffix,OP_SELL);
        }
     }
//---
  }
//+------------------------------------------------------------------+
//| BuyBasket                                                        |
//+------------------------------------------------------------------+
void BuyBasket(string Currency)
  {
//---
   for(int i=0; i<ArraySize(aSymbols); i++)
     {
      //---
      int stringfind=StringFind(Prefix+aSymbols[i]+Suffix,Currency,StringLen(Prefix));
      //---
      if(stringfind!=-1)
        {
         //---
         if(stringfind>0)
            OrderSend(Prefix+aSymbols[i]+Suffix,OP_SELL);
         else
            OrderSend(Prefix+aSymbols[i]+Suffix,OP_BUY);
        }
     }
//---
  }
//+------------------------------------------------------------------+
//| CloseBasket                                                      |
//+------------------------------------------------------------------+
void CloseBasket(string Currency)
  {
//---
   for(int i=0; i<ArraySize(aSymbols); i++)
     {
      //---
      int stringfind=StringFind(Prefix+aSymbols[i]+Suffix,Currency,StringLen(Prefix));
      //---
      if(stringfind!=-1)
        {
         //--- NoOrders
         if(OpenPos(Prefix+aSymbols[i]+Suffix,OP_ALL)==0)
           {
            SetStatus("ý","No open orders...");
            ObjectSetInteger(0,OBJPREFIX+"CLOSE"+" - "+Prefix+aSymbols[i]+Suffix,OBJPROP_STATE,false);//SetObject
           }
         else
            OrderClose(Prefix+aSymbols[i]+Suffix);
        }
     }
//---
  }
//+------------------------------------------------------------------+
//| OrderSend                                                        |
//+------------------------------------------------------------------+
void OrderSend(const string _Symb,const int Type)
  {
//---
   int op_tkt=0;
   uint tick=0,ex_time=0;
//---
   double rq_price=0,slippage=0;
//--- GetMarketInfo
   double LotStep=SymbolInfoDouble(_Symb,SYMBOL_VOLUME_STEP),MinLot=SymbolInfoDouble(_Symb,SYMBOL_VOLUME_MIN),MaxLot=SymbolInfoDouble(_Symb,SYMBOL_VOLUME_MAX);
   double Pts=SymbolInfoDouble(_Symb,SYMBOL_POINT),_Bid=SymbolInfoDouble(_Symb,SYMBOL_BID),_Ask=SymbolInfoDouble(_Symb,SYMBOL_ASK);
   double LotSize=GlobalVariableGet(OBJPREFIX+_Symb+" - Lotsize"),StopLoss=GlobalVariableGet(OBJPREFIX+_Symb+" - Stoploss"),TakeProfit=GlobalVariableGet(OBJPREFIX+_Symb+" - Takeprofit");
   long Spread=SymbolInfoInteger(_Symb,SYMBOL_SPREAD),MinStop=SymbolInfoInteger(_Symb,SYMBOL_TRADE_STOPS_LEVEL),FreezeLevel=SymbolInfoInteger(_Symb,SYMBOL_TRADE_FREEZE_LEVEL);
//--- reset the error value
   ResetLastError();
//--- CheckOrdSendRequirements
   if(MQLInfoInteger(MQL_TRADE_ALLOWED) && !IsTradeContextBusy() && TerminalInfoInteger(TERMINAL_CONNECTED))
     {
      //--- SellOrders
      if(Type==OP_SELL)
        {
         //--- One-Click Trading
         if(!OneClickTrading)
           {
            //---
            if(MessageBox("Do you really want to open a new order?\n\n"+"Symbol: "+_Symb+"\n"+"Ordertype: Sell"+"\n"+"Lotsize: "+DoubleToString(LotSize,2)+"\n\n"+"Stoploss: "+DoubleToString(StopLoss,0)+"\n"+"Takeprofit: "+DoubleToString(TakeProfit,0),"Order Send - "+MB_CAPTION,MB_ICONQUESTION|MB_YESNO)!=IDYES)
               return;
           }
         //--- CheckStops
         if((StopLoss!=0 && (_Bid+StopLoss*Pts)>=(_Ask+FreezeLevel*Pts) && StopLoss>=(MinStop+Spread)) || (StopLoss==0))
           {
            //---
            if((TakeProfit!=0 && (_Bid-TakeProfit*Pts)<=(_Ask-FreezeLevel*Pts) && TakeProfit>=MinStop) || (TakeProfit==0))
              {
               //--- EnoughMargin
               if(AccountFreeMarginCheck(_Symb,OP_SELL,LotSize)>=0)
                 {
                  //--- CorrectLotSize (Rounded by GetSetInputs)
                  if(LotSize>=MinLot && LotSize<=MaxLot)
                    {
                     //---
                     SetStatus(")","Sending Sell Order...");
                     //---
                     tick=GetTickCount();//GetTime
                     rq_price=SymbolInfoDouble(_Symb,SYMBOL_BID);//GetPrice
                     op_tkt=OrderSend(_Symb,OP_SELL,LotSize,rq_price,Slippage,0,0,ExpertName,MagicNumber,0,clrNONE);//SendOrder
                    }
                  else
                    {
                     //--- Error
                     SetStatus("ý","Order send failed...");
                     Print(_Symb+" OrderSend failed with error #131 [Invalid trade volume]");
                     _PlaySound(ErrorSound);
                     //---
                     Sleep(ErrorInterval);
                     ResetStatus();
                     return;
                    }
                  //---
                  if(op_tkt<0)
                    {
                     SetStatus("ý","Order send failed...");
                     Print(_Symb+" OrderSend failed with error #",_LastError);
                     _PlaySound(ErrorSound);
                     //---
                     Sleep(ErrorInterval);
                     ResetStatus();
                     return;
                    }
                  else
                    {
                     //--- Succeeded
                     ex_time=GetTickCount()-tick;//CalcExeTime
                     slippage=(PriceByTkt(OPENPRICE,op_tkt)-rq_price)/Pts;//CalcSlippage
                     Print(_Symb+" OrderSend placed successfully (Open Sell) "+"#"+IntegerToString(op_tkt)+" | Execuction Time: "+IntegerToString(ex_time)+"ms"+" | Slippage: "+DoubleToString(slippage,0)+"p");
                     _PlaySound("sell.wav");
                     //--- SL
                     if(StopLoss>0 && StopLoss>=MinStop)
                       {
                        //---
                        if(OrderSelect(op_tkt,SELECT_BY_TICKET,MODE_TRADES))
                          {
                           //---
                           if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+StopLoss*Pts,OrderTakeProfit(),0,clrNONE))
                             {
                              //--- Error
                              Print(_Symb+" Error in OrderModify. Error code=",_LastError);
                              _PlaySound(ErrorSound);
                             }
                           else
                             {
                              //--- Succeeded
                              //Print("Order modified successfully");
                             }
                          }
                       }
                     //--- _TP
                     if(TakeProfit>0 && TakeProfit>=MinStop)
                       {
                        //---
                        if(OrderSelect(op_tkt,SELECT_BY_TICKET,MODE_TRADES))
                          {
                           //---
                           if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()-TakeProfit*Pts,0,clrNONE))
                             {
                              //--- Error
                              Print(_Symb+" Error in OrderModify. Error code=",_LastError);
                              _PlaySound(ErrorSound);
                             }
                           else
                             {
                              //--- Succeeded
                              //Print("Order modified successfully");*/
                             }
                          }
                       }
                    }
                  //---
                 }
               else
                 {
                  //--- NotEnoughMoney
                  SetStatus("ý","Not enough money...");
                  Print(" '",AccountInfoInteger(ACCOUNT_LOGIN),"' :"," order #0 sell ",DoubleToString(LotSize,2)," ",_Symb," [Not enough money]");
                  _PlaySound(ErrorSound);
                  Sleep(ErrorInterval);
                  ResetStatus();
                  return;
                 }
               //---
              }
            else
              {
               //--- InvalidStop
               SetStatus("ý","Invalid takeprofit...");
               Print(" '",AccountInfoInteger(ACCOUNT_LOGIN),"' :"," order #0 sell ",DoubleToString(LotSize,2)," ",_Symb," failed [Invalid T/P]");
               _PlaySound(ErrorSound);
               Sleep(ErrorInterval);
               ResetStatus();
               return;
              }
           }
         else
           {
            //--- InvalidStop
            SetStatus("ý","Invalid stoploss...");
            Print(" '",AccountInfoInteger(ACCOUNT_LOGIN),"' :"," order #0 sell ",DoubleToString(LotSize,2)," ",_Symb," failed [Invalid S/L]");
            _PlaySound(ErrorSound);
            Sleep(ErrorInterval);
            ResetStatus();
            return;
           }
         //---
         ResetStatus();
         //---
        }
        
      //--- BuyOrders
      if(Type==OP_BUY)
        {
         //--- One-Click Trading
         if(!OneClickTrading)
           {
            //---
            if(MessageBox("Do you really want to open a new order?\n\n"+"Symbol: "+_Symb+"\n"+"Ordertype: Buy"+"\n"+"Lotsize: "+DoubleToString(LotSize,2)+"\n\n"+"Stoploss: "+DoubleToString(StopLoss,0)+"\n"+"Takeprofit: "+DoubleToString(TakeProfit,0),"Order Send - "+MB_CAPTION,MB_ICONQUESTION|MB_YESNO)!=IDYES)
               return;
           }
         //--- CheckStops
         if((StopLoss!=0 && (_Ask-StopLoss*Pts)<=(_Bid-FreezeLevel*Pts) && StopLoss>=(MinStop+Spread)) || (StopLoss==0))
           {
            //---
            if((TakeProfit!=0 && (_Ask+TakeProfit*Pts)>=(_Bid+FreezeLevel*Pts) && TakeProfit>=MinStop) || (TakeProfit==0))
              {
               //--- EnoughMargin
               if(AccountFreeMarginCheck(_Symb,OP_BUY,LotSize)>=0)
                 {
                  //--- CorrectLotSize (Rounded by GetSetInputs)
                  if(LotSize>=MinLot && LotSize<=MaxLot)
                    {
                     //---
                     SetStatus(")","Sending Buy Order...");
                     //---
                     tick=GetTickCount();//GetTime
                     rq_price=SymbolInfoDouble(_Symb,SYMBOL_ASK);//GetPrice
                     op_tkt=OrderSend(_Symb,OP_BUY,LotSize,rq_price,Slippage,0,0,ExpertName,MagicNumber,0,clrNONE);//SendOrder
                    }
                  else
                    {
                     //--- Error
                     SetStatus("ý","Order send failed...");
                     Print(_Symb+" OrderSend failed with error #131 [Invalid trade volume]");
                     _PlaySound(ErrorSound);
                     //---
                     Sleep(ErrorInterval);
                     ResetStatus();
                     return;
                    }
                  //---
                  if(op_tkt<0)
                    {
                     //--- Error
                     SetStatus("ý","Order send failed...");
                     Print(_Symb+" OrderSend failed with error #",_LastError);
                     _PlaySound(ErrorSound);
                     //---
                     Sleep(ErrorInterval);
                     ResetStatus();
                     return;
                    }
                  else
                    {
                     //--- Succeeded
                     ex_time=GetTickCount()-tick;//CalcExeTime
                     slippage=(rq_price-PriceByTkt(OPENPRICE,op_tkt))/Pts;//CalcSlippage
                     Print(_Symb+" OrderSend placed successfully (Open Buy) "+"#"+IntegerToString(op_tkt)+" | Execuction Time: "+IntegerToString(ex_time)+"ms"+" | Slippage: "+DoubleToString(slippage,0)+"p");
                     _PlaySound("buy.wav");
                     //--- SL
                     if(StopLoss>0 && StopLoss>=MinStop)
                       {
                        if(OrderSelect(op_tkt,SELECT_BY_TICKET,MODE_TRADES))
                          {
                           if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-StopLoss*Pts,OrderTakeProfit(),0,clrNONE))
                             {
                              //--- Error
                              Print(_Symb+" Error in OrderModify. Error code=",_LastError);
                              _PlaySound(ErrorSound);
                             }
                           else
                             {
                              //--- Succeeded
                              //Print("Order modified successfully");
                             }
                          }
                       }
                     //--- _TP
                     if(TakeProfit>0 && TakeProfit>=MinStop)
                       {
                        //---
                        if(OrderSelect(op_tkt,SELECT_BY_TICKET,MODE_TRADES))
                          {
                           //---
                           if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()+TakeProfit*Pts,0,clrNONE))
                             {
                              //--- Error
                              Print(_Symb+" Error in OrderModify. Error code=",_LastError);
                              _PlaySound(ErrorSound);
                             }
                           else
                             {
                              //--- Succeeded
                              //Print("Order modified successfully");
                             }
                          }
                       }
                    }
                  //---
                 }
               else
                 {
                  //--- NotEnoughMoney
                  SetStatus("ý","Not enough money...");
                  Print(" '",AccountInfoInteger(ACCOUNT_LOGIN),"' :"," order #0 buy ",DoubleToString(LotSize,2)," ",_Symb," [Not enough money]");
                  _PlaySound(ErrorSound);
                  Sleep(ErrorInterval);
                  ResetStatus();
                  return;
                 }
               //---
              }
            else
              {
               //--- InvalidStop
               SetStatus("ý","Invalid takeprofit...");
               Print(" '",AccountInfoInteger(ACCOUNT_LOGIN),"' :"," order #0 buy ",DoubleToString(LotSize,2)," ",_Symb," failed [Invalid T/P]");
               _PlaySound(ErrorSound);
               Sleep(ErrorInterval);
               ResetStatus();
               return;
              }
           }
         else
           {
            //--- InvalidStop
            SetStatus("ý","Invalid stoploss...");
            Print(" '",AccountInfoInteger(ACCOUNT_LOGIN),"' :"," order #0 buy ",DoubleToString(LotSize,2)," ",_Symb," failed [Invalid S/L]");
            _PlaySound(ErrorSound);
            Sleep(ErrorInterval);
            ResetStatus();
            return;
           }
         //---
         ResetStatus();
         //---
        }
     }
   else
     {
      //--- RequirementsNotFulfilled
      if(!TerminalInfoInteger(TERMINAL_CONNECTED))
        {
         SetStatus("ý","No Internet connection...");
         Print(_Symb+" No Internet connection found! Please check your network connection and try again.");
        }
      //---
      if(IsTradeContextBusy())
        {
         SetStatus("ý","Trade context is busy...");
         Print(_Symb+" Trade context is busy, Please wait...");
        }
      //---
      if(!MQLInfoInteger(MQL_TRADE_ALLOWED))
        {
         SetStatus("ý","AutoTrading is disabled...");
         Print(_Symb+" Check if automated trading is allowed in the terminal / program settings and try again.");
        }
      //---
      _PlaySound(ErrorSound);
      //---
      Sleep(ErrorInterval);
      ResetStatus();
      return;
      //---
     }
//---
  }
//+------------------------------------------------------------------+
//| OrderClose                                                       |
//+------------------------------------------------------------------+
void OrderClose(const string _Symb)
  {
//---
   double ordprofit=0,ordlots=0;
//---
   int c_tkt=0, ordtype=0;
   uint tick=0, ex_time=0;
//---
   double rq_price=0,slippage=0;
//---
   string ordtypestr="\n";

//--- reset the error value
   ResetLastError();
//--- CheckOrdCloseRequirements
   if(MQLInfoInteger(MQL_TRADE_ALLOWED) && !IsTradeContextBusy() && TerminalInfoInteger(TERMINAL_CONNECTED))
     {
      //--- SelectOrder
      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         //---
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            //---
            if((OrderSymbol()==_Symb || _Symb==IntegerToString(-1)) && OrderMagicNumber()==MagicNumber)
              {
               //---
               if(OrderType()<=OP_SELL)//MarketOrdersOnly
                 {
                  //---
                  ordlots=OrderLots();//SetLots
                  if(ordlots>OrderLots())
                     ordlots=OrderLots();
                  //---
                  tick=GetTickCount();
                  rq_price=OrderClosePrice();
                  c_tkt=OrderTicket();
                  ordtype=OrderType();
                  ordtypestr=(OrderType()==OP_SELL)?ordtypestr="Sell":ordtypestr="Buy";
                  //--- One-Click Trading
                  if(!OneClickTrading)
                    {
                     if(MessageBox("Do you really want to close the order below?\n\n"+"Symbol: "+OrderSymbol()+"\n"+"Ordertype: "+ordtypestr+"\n"+"Lotsize: "+DoubleToString(ordlots,2),"Order Close - "+MB_CAPTION,MB_ICONQUESTION|MB_YESNO)!=IDYES)
                        continue;
                    }
                  //---
                  SetStatus(")","Closing "+ordtypestr+" Order...");
                  //---
                  if(!OrderClose(OrderTicket(),ordlots,rq_price,0,COLOR_CLOSE))
                    {
                     //--- Error
                     SetStatus("ý","Order close failed...");
                     Print(_Symb+" OrderClose failed with error #",_LastError);
                     _PlaySound(ErrorSound);
                     Sleep(ErrorInterval);
                     ResetStatus();
                     return;
                    }
                  else
                    {
                     //--- Succeeded
                     ex_time=GetTickCount()-tick;//CalcExeTime
                     slippage=(ordtype==OP_SELL)?(PriceByTkt(CLOSEPRICE,c_tkt)-rq_price)/_Point:(rq_price-PriceByTkt(CLOSEPRICE,c_tkt))/_Point;//CalcSlippage
                     Print(OrderSymbol()+" Order closed successfully"+" (Close "+ordtypestr+") "+"#"+IntegerToString(c_tkt)+" | Execuction Time: "+IntegerToString(ex_time)+"ms"+" | "+"Slippage: "+DoubleToString(slippage,0)+"p");
                     SetStatus("þ","Order successfully closed...");
                     _PlaySound("close.wav");
                    }
                  //---
                  ResetStatus();
                  //---
                 }
              }
           }
        }
      //---
     }
   else
     {
      //--- RequirementsNotFulfilled
      if(!TerminalInfoInteger(TERMINAL_CONNECTED))
        {
         SetStatus("ý","No Internet connection...");
         Print(_Symb+" No Internet connection found! Please check your network connection and try again.");
        }
      //---
      if(IsTradeContextBusy())
        {
         SetStatus("ý","Trade context is busy...");
         Print(_Symb+" Trade context is busy, Please wait...");
        }
      //---
      if(!MQLInfoInteger(MQL_TRADE_ALLOWED))
        {
         SetStatus("ý","AutoTrading is disabled...");
         Print(_Symb+" Check if automated trading is allowed in the terminal / program settings and try again.");
        }
      //---
      _PlaySound(ErrorSound);
      //---
      Sleep(ErrorInterval);
      ResetStatus();
      return;
     }
//---
  }
//+------------------------------------------------------------------+
//| FloatingPoints                                                   |
//+------------------------------------------------------------------+
double FloatingPoints(const string _Symb)
  {
//---
   double sellpts=0,buypts=0,Pts=SymbolInfoDouble(_Symb,SYMBOL_POINT);
//---
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      //---
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         //---
         if(OrderSymbol()==_Symb && OrderMagicNumber()==MagicNumber)
           {
            //---
            if(OrderType()==OP_SELL)
               sellpts+=(OrderOpenPrice()-OrderClosePrice())/Pts;
            //---
            if(OrderType()==OP_BUY)
               buypts+=(OrderClosePrice()-OrderOpenPrice())/Pts;
           }
        }
     }
//---
   return(sellpts+buypts);
  }
//+------------------------------------------------------------------+
//| FloatingProfits                                                  |
//+------------------------------------------------------------------+
double FloatingProfits(const string _Symb)
  {
//---  
   double profit=0;
//---
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      //---
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         //---
         if(OrderSymbol()==_Symb && OrderMagicNumber()==MagicNumber)
           {
            //---
            if(OrderType()<=OP_SELL)//MarketOrdersOnly
               profit+=OrderProfit()+OrderCommission()+OrderSwap();
           }
        }
     }
//---
   return(profit);
  }
//+------------------------------------------------------------------+
//| FloatingReturn                                                   |
//+------------------------------------------------------------------+
double FloatingReturn(const string _Symb)
  {
//---
   double percent=0;
//--- CalcReturn (ROI)
   if(AccountInfoDouble(ACCOUNT_BALANCE)!=0)//AvoidZeroDivide
      percent=FloatingProfits(_Symb)*100/AccountInfoDouble(ACCOUNT_BALANCE);
//---
   return(percent);
  }
//+------------------------------------------------------------------+
//| TotalFloatingPoints                                              |
//+------------------------------------------------------------------+
double TotalFloatingPoints()
  {
//---
   double cnt=0;
//---
   for(int i=0; i<ArraySize(aSymbols); i++)
      cnt+=FloatingPoints(Prefix+aSymbols[i]+Suffix);
//---
   return(cnt);
  }
//+------------------------------------------------------------------+
//| TotalFloatingProfits                                             |
//+------------------------------------------------------------------+
double TotalFloatingProfits()
  {
//---
   double cnt=0;
//---
   for(int i=0; i<ArraySize(aSymbols); i++)
      cnt+=FloatingProfits(Prefix+aSymbols[i]+Suffix);
//---
   return(cnt);
  }
//+------------------------------------------------------------------+
//| TotalReturn                                                      |
//+------------------------------------------------------------------+
double TotalReturn()
  {
//---
   double percent=0;
//--- CalcReturn (ROI)
   if(AccountInfoDouble(ACCOUNT_BALANCE)!=0)//AvoidZeroDivide
      percent=TotalFloatingProfits()*100/AccountInfoDouble(ACCOUNT_BALANCE);
//---
   return(percent);
  }
//+------------------------------------------------------------------+
//| OpenPos                                                          |
//+------------------------------------------------------------------+
int OpenPos(const string _Symb,const int Type)
  {
//---
   int count=0;
//---
   for(int i=0; i<OrdersTotal(); i++)
     {
      //---
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         //---
         if((OrderSymbol()==_Symb || _Symb==IntegerToString(-1)) && OrderMagicNumber()==MagicNumber)
           {
            //---
            if(OrderType()==OP_SELL && Type==OP_SELL)
               count++;
            //---
            if(OrderType()==OP_BUY && Type==OP_BUY)
               count++;
            //---
            if(OrderType()<=OP_SELL && Type==OP_ALL)
               count++;
           }
        }
     }
//---
   return(count);
  }
//+------------------------------------------------------------------+
//| OpenLots                                                         |
//+------------------------------------------------------------------+
double OpenLots(const string _Symb,const int Type)
  {
//---
   double count=0;
//---
   for(int i=0; i<OrdersTotal(); i++)
     {
      //---
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         //---
         if((OrderSymbol()==_Symb || _Symb==IntegerToString(-1)) && OrderMagicNumber()==MagicNumber)
           {
            //---
            if(OrderType()==OP_SELL && Type==OP_SELL)
               count+=OrderLots();
            //---
            if(OrderType()==OP_BUY && Type==OP_BUY)
               count+=OrderLots();
            //---
            if(OrderType()<=OP_SELL && Type==OP_ALL)
               count+=OrderLots();
           }
        }
     }
//---
   return(count);
  }
//+------------------------------------------------------------------+
//| Leverage                                                         |
//+------------------------------------------------------------------+
string Leverage()
  {
//---
   string result="";
//---
   double equity=AccountInfoDouble(ACCOUNT_EQUITY);
   double margin_used=AccountInfoDouble(ACCOUNT_MARGIN);
   int leverage=(int)AccountInfoInteger(ACCOUNT_LEVERAGE);
   double real_leverage=margin_used/equity*leverage;
//---
   if(real_leverage==0)
      result="1:"+IntegerToString(AccountInfoInteger(ACCOUNT_LEVERAGE));
   else
      result="1:"+DoubleToString(real_leverage,0);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| SymbPerc                                                         |
//+------------------------------------------------------------------+
double SymbPerc(string _Symb)
  {
//---
   double percent=0,range=iHigh(_Symb,CalcTF,0)-iLow(_Symb,CalcTF,0);
//---
   if(range!=0)
      percent=100*((iClose(_Symb,CalcTF,0)-iLow(_Symb,CalcTF,0))/range);
//---
   return(percent);
  }
//+------------------------------------------------------------------+
//| ±Str                                                             |
//+------------------------------------------------------------------+
string ±Str(double Inp,int Precision)
  {
//--- PositiveValue
   if(Inp>0)
      return("+"+DoubleToString(Inp,Precision));
//--- NegativeValue
   else
      return(DoubleToString(Inp,Precision));
//---
  }
//+------------------------------------------------------------------+
//| ±Clr                                                             |
//+------------------------------------------------------------------+
color ±Clr(double Inp)
  {
//---
   color clr=clrNONE;
//--- PositiveValue
   if(Inp>0)
      clr=COLOR_GREEN;
//--- NegativeValue
   if(Inp<0)
      clr=COLOR_RED;
//--- NeutralValue
   if(Inp==0)
      clr=COLOR_FONT;
//---
   return(clr);
  }
//+------------------------------------------------------------------+
//| ±ClrBR                                                           |
//+------------------------------------------------------------------+
color ±ClrBR(double Inp)
  {
//---
   color clr=clrNONE;
//--- PositiveValue
   if(Inp>0)
      clr=COLOR_BUY;
//--- NegativeValue
   if(Inp<0)
      clr=COLOR_SELL;
//--- NeutralValue
   if(Inp==0)
      clr=COLOR_FONT;
//---
   return(clr);
  }
//+------------------------------------------------------------------+
//| Deposits                                                         |
//+------------------------------------------------------------------+ 
double Deposits()
  {
//---
   double total=0;
//---
   for(int i=0; i<OrdersHistoryTotal(); i++)
     {
      //---
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         //---
         if(OrderType()>5 && OrderProfit()>0)
            total+=OrderProfit();
        }
     }
//---
   return(total);
  }
//+------------------------------------------------------------------+
//| _AccountCurrency                                                 |
//+------------------------------------------------------------------+
string _AccountCurrency()
  {
//---
   string txt="";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="AUD")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="BGN")
      txt="B";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="CAD")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="CHF")
      txt="F";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="COP")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="CRC")
      txt="₡";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="CUP")
      txt="₱";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="CZK")
      txt="K";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="EUR")
      txt="€";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="GBP")
      txt="£";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="GHS")
      txt="¢";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="HKD")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="JPY")
      txt="¥";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="NGN")
      txt="₦";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="NOK")
      txt="k";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="NZD")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="USD")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="RUB")
      txt="₽";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="SGD")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="ZAR")
      txt="R";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="SEK")
      txt="k";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="VND")
      txt="₫";
//---
   if(txt=="")
      txt="$";
//---
   return(txt);
  }
//+------------------------------------------------------------------+
//| _DayOfWeek                                                       |
//+------------------------------------------------------------------+
string _DayOfWeek()
  {
//---
   string txt="\n";
//---
   if(TimeDayOfWeek(TimeLocal())==0)
      txt="Sunday";
//---
   if(TimeDayOfWeek(TimeLocal())==1)
      txt="Monday";
//---
   if(TimeDayOfWeek(TimeLocal())==2)
      txt="Tuesday";
//---
   if(TimeDayOfWeek(TimeLocal())==3)
      txt="Wednesday";
//---
   if(TimeDayOfWeek(TimeLocal())==4)
      txt="Thursday";
//---
   if(TimeDayOfWeek(TimeLocal())==5)
      txt="Friday";
//---
   if(TimeDayOfWeek(TimeLocal())==6)
      txt="Saturday";
//---
   return(txt);
  }
//+------------------------------------------------------------------+
//| _Month                                                           |
//+------------------------------------------------------------------+
string _Month()
  {
//---
   string txt="\n";
//---
   if(TimeMonth(TimeLocal())==1)
      txt="January";
//---
   if(TimeMonth(TimeLocal())==2)
      txt="February";
//---
   if(TimeMonth(TimeLocal())==3)
      txt="March";
//---
   if(TimeMonth(TimeLocal())==4)
      txt="April";
//---
   if(TimeMonth(TimeLocal())==5)
      txt="May";
//---
   if(TimeMonth(TimeLocal())==6)
      txt="June";
//---
   if(TimeMonth(TimeLocal())==7)
      txt="July";
//---
   if(TimeMonth(TimeLocal())==8)
      txt="August";
//---
   if(TimeMonth(TimeLocal())==9)
      txt="September";
//---
   if(TimeMonth(TimeLocal())==10)
      txt="October";
//---
   if(TimeMonth(TimeLocal())==11)
      txt="November";
//---
   if(TimeMonth(TimeLocal())==12)
      txt="December";
//---
   return(txt);
  }
//+------------------------------------------------------------------+
//| PriceByTkt                                                       |
//+------------------------------------------------------------------+
double PriceByTkt(const int Type,const int Ticket)
  {
//---
   double price=0;
//---
   if(OrderSelect(Ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      //---
      if(Type==OPENPRICE)
         price=OrderOpenPrice();
      //---
      if(Type==CLOSEPRICE)
         price=OrderClosePrice();
     }
//---
   return(price);
  }
//+------------------------------------------------------------------+
//| SymbolFind                                                       |
//+------------------------------------------------------------------+
bool SymbolFind(const string _Symb,int mode)
  {
//---
   bool result=false;
//---
   for(int i=0; i<SymbolsTotal(mode); i++)
     {
      //---
      if(_Symb==SymbolName(i,mode))
        {
         result=true;//SymbolFound
         break;
        }
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| AUD                                                              |
//+------------------------------------------------------------------+
double AUD()
  {
//---
   double dbl=0;
//---
   dbl=(SymbPerc(Prefix+"AUDJPY"+Suffix)+SymbPerc(Prefix+"AUDNZD"+Suffix)+SymbPerc(Prefix+"AUDUSD"+Suffix)+(100-SymbPerc(Prefix+"EURAUD"+Suffix))+(100-SymbPerc(Prefix+"GBPAUD"+Suffix))+SymbPerc(Prefix+"AUDCHF"+Suffix)+SymbPerc(Prefix+"AUDCAD"+Suffix))/7.0;
//---
   return((double)DoubleToString(dbl,0));
  }
//+------------------------------------------------------------------+
//| CAD                                                              |
//+------------------------------------------------------------------+
double CAD()
  {
//---
   double dbl=0;
//---
   dbl=(SymbPerc(Prefix+"CADJPY"+Suffix)+(100-SymbPerc(Prefix+"NZDCAD"+Suffix))+(100-SymbPerc(Prefix+"USDCAD"+Suffix))+(100-SymbPerc(Prefix+"EURCAD"+Suffix))+(100-SymbPerc(Prefix+"GBPCAD"+Suffix))+(100-SymbPerc(Prefix+"AUDCAD"+Suffix))+SymbPerc(Prefix+"CADCHF"+Suffix))/7.0;
//---
   return((double)DoubleToString(dbl,0));
  }
//+------------------------------------------------------------------+
//| CHF                                                              |
//+------------------------------------------------------------------+
double CHF()
  {
//---
   double dbl=0;
//---
   dbl=(SymbPerc(Prefix+"CHFJPY"+Suffix)+(100-SymbPerc(Prefix+"NZDCHF"+Suffix))+(100-SymbPerc(Prefix+"USDCHF"+Suffix))+(100-SymbPerc(Prefix+"EURCHF"+Suffix))+(100-SymbPerc(Prefix+"GBPCHF"+Suffix))+(100-SymbPerc(Prefix+"AUDCHF"+Suffix))+(100-SymbPerc(Prefix+"CADCHF"+Suffix)))/7.0;
//---
   return((double)DoubleToString(dbl,0));
  }
//+------------------------------------------------------------------+
//| EUR                                                              |
//+------------------------------------------------------------------+
double EUR()
  {
//---
   double dbl=0;
//---
   dbl=(SymbPerc(Prefix+"EURJPY"+Suffix)+SymbPerc(Prefix+"EURNZD"+Suffix)+SymbPerc(Prefix+"EURUSD"+Suffix)+SymbPerc(Prefix+"EURCAD"+Suffix)+SymbPerc(Prefix+"EURGBP"+Suffix)+SymbPerc(Prefix+"EURAUD"+Suffix)+SymbPerc(Prefix+"EURCHF"+Suffix))/7.0;
//---
   return((double)DoubleToString(dbl,0));
  }
//+------------------------------------------------------------------+
//| GBP                                                              |
//+------------------------------------------------------------------+
double GBP()
  {
//---
   double dbl=0;
//---
   dbl=(SymbPerc(Prefix+"GBPJPY"+Suffix)+SymbPerc(Prefix+"GBPNZD"+Suffix)+SymbPerc(Prefix+"GBPUSD"+Suffix)+SymbPerc(Prefix+"GBPCAD"+Suffix)+(100-SymbPerc(Prefix+"EURGBP"+Suffix))+SymbPerc(Prefix+"GBPAUD"+Suffix)+SymbPerc(Prefix+"GBPCHF"+Suffix))/7.0;
//---
   return((double)DoubleToString(dbl,0));
  }
//+------------------------------------------------------------------+
//| JPY                                                              |
//+------------------------------------------------------------------+
double JPY()
  {
//---
   double dbl=0;
//---
   dbl=((100-SymbPerc(Prefix+"AUDJPY"+Suffix))+(100-SymbPerc(Prefix+"CHFJPY"+Suffix))+(100-SymbPerc(Prefix+"CADJPY"+Suffix))+(100-SymbPerc(Prefix+"EURJPY"+Suffix))+(100-SymbPerc(Prefix+"GBPJPY"+Suffix))+(100-SymbPerc(Prefix+"NZDJPY"+Suffix))+(100-SymbPerc(Prefix+"USDJPY"+Suffix)))/7.0;
//---
   return((double)DoubleToString(dbl,0));
  }
//+------------------------------------------------------------------+
//| NZD                                                              |
//+------------------------------------------------------------------+
double NZD()
  {
//---
   double dbl=0;
//---
   dbl=(SymbPerc(Prefix+"NZDJPY")+(100-SymbPerc(Prefix+"GBPNZD"+Suffix))+SymbPerc(Prefix+"NZDJPY"+Suffix)+SymbPerc(Prefix+"NZDCAD"+Suffix)+(100-SymbPerc(Prefix+"EURNZD"+Suffix))+(100-SymbPerc(Prefix+"AUDNZD"+Suffix))+SymbPerc(Prefix+"NZDCHF"+Suffix))/7.0;
//---
   return((double)DoubleToString(dbl,0));
  }
//+------------------------------------------------------------------+
//| USD                                                              |
//+------------------------------------------------------------------+
double USD()
  {
//---
   double dbl=0;
//---
   dbl=((100-SymbPerc(Prefix+"AUDUSD"+Suffix))+SymbPerc(Prefix+"USDCHF"+Suffix)+SymbPerc(Prefix+"USDCAD"+Suffix)+(100-SymbPerc(Prefix+"EURUSD"+Suffix))+(100-SymbPerc(Prefix+"GBPUSD"+Suffix))+SymbPerc(Prefix+"USDJPY"+Suffix)+(100-SymbPerc(Prefix+"NZDUSD"+Suffix)))/7.0;
//---
   return((double)DoubleToString(dbl,0));
  }
//+------------------------------------------------------------------+
//| Symbols                                                          |
//+------------------------------------------------------------------+
string Symbols[]=
  {
//---
   "AUDCAD",
   "AUDCHF",
   "AUDJPY",
   "AUDNZD",
   "AUDUSD",
//---
   "CADCHF",
   "CADJPY",
   "CHFJPY",
//---
   "EURAUD",
   "EURCAD",
   "EURCHF",
   "EURGBP",
   "EURJPY",
   "EURNZD",
   "EURUSD",
//---
   "GBPAUD",
   "GBPCAD",
   "GBPCHF",
   "GBPNZD",
   "GBPUSD",
   "GBPJPY",
//---
   "NZDCHF",
   "NZDCAD",
   "NZDJPY",
   "NZDUSD",
//---
   "USDCAD",
   "USDCHF",
   "USDJPY"
  };
//+------------------------------------------------------------------+
string Currenies[]=
  {
   "AUD",
   "CAD",
   "CHF",
   "EUR",
   "GBP",
   "JPY",
   "NZD",
   "USD"
  };
//+------------------------------------------------------------------+
//| SetFull                                                          |
//+------------------------------------------------------------------+
void SetFull()
  {
//---
   ArrayResize(UsedSymbols,28,0);
//---
   UsedSymbols[0]="AUDCAD";
   UsedSymbols[1]="AUDCHF";
   UsedSymbols[2]="AUDJPY";
   UsedSymbols[3]="AUDNZD";
   UsedSymbols[4]="AUDUSD";
//---
   UsedSymbols[5]="CADCHF";
   UsedSymbols[6]="CADJPY";
   UsedSymbols[7]="CHFJPY";
//---
   UsedSymbols[8]="EURAUD";
   UsedSymbols[9]="EURCAD";
   UsedSymbols[10]="EURCHF";
   UsedSymbols[11]="EURGBP";
   UsedSymbols[12]="EURJPY";
   UsedSymbols[13]="EURNZD";
   UsedSymbols[14]="EURUSD";
//---
   UsedSymbols[15]="GBPAUD";
   UsedSymbols[16]="GBPCAD";
   UsedSymbols[17]="GBPCHF";
//---
   UsedSymbols[18]="GBPNZD";
   UsedSymbols[19]="GBPUSD";
   UsedSymbols[20]="GBPJPY";
//---
   UsedSymbols[21]="NZDCHF";
   UsedSymbols[22]="NZDCAD";
   UsedSymbols[23]="NZDJPY";
   UsedSymbols[24]="NZDUSD";
//---
   UsedSymbols[25]="USDCAD";
   UsedSymbols[26]="USDCHF";
   UsedSymbols[27]="USDJPY";
//---
  }
//+------------------------------------------------------------------+
//| SetStatus                                                        |
//+------------------------------------------------------------------+
void SetStatus(string Char,string Text)
  {
//---
   Comment("");
//---
   stauts_time=TimeLocal();
//---
   ObjectSetString(0,OBJPREFIX+"STATUS",OBJPROP_TEXT,Char);
   ObjectSetString(0,OBJPREFIX+"STATUS«",OBJPROP_TEXT,Text);
//---
  }
//+------------------------------------------------------------------+
//| ResetStatus                                                      |
//+------------------------------------------------------------------+
void ResetStatus()
  {
//---
   if(ObjectGetString(0,OBJPREFIX+"STATUS",OBJPROP_TEXT)!="\n" || ObjectGetString(0,OBJPREFIX+"STATUS«",OBJPROP_TEXT)!="\n")
     {
      ObjectSetString(0,OBJPREFIX+"STATUS",OBJPROP_TEXT,"\n");
      ObjectSetString(0,OBJPREFIX+"STATUS«",OBJPROP_TEXT,"\n");
     }
//---
  }
//+------------------------------------------------------------------+
//| Dpi                                                              |
//+------------------------------------------------------------------+
int Dpi(int Size)
  {
//---
   int screen_dpi=TerminalInfoInteger(TERMINAL_SCREEN_DPI);
   int base_width=Size;
   int width=(base_width*screen_dpi)/96;
   int scale_factor=(TerminalInfoInteger(TERMINAL_SCREEN_DPI)*100)/96;
//---
   width=(base_width*scale_factor)/100;
//---
   return(width);
  }
//+------------------------------------------------------------------+
//| dString                                                          |
//+------------------------------------------------------------------+
string dString(string text)
  {
//---
   uchar in[],out[],key[];
//---
   StringToCharArray("H+#eF_He",key);
//---
   StringToCharArray(text,in,0,StringLen(text));
//---
   HexToArray(text,in);
//---
   CryptDecode(CRYPT_DES,in,key,out);
//---
   string result=CharArrayToString(out);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| HexToArray                                                       |
//+------------------------------------------------------------------+
bool HexToArray(string str,uchar &arr[])
  {
//--- By Andrew Sumner & Alain Verleyen
//--- https://www.mql5.com/en/forum/157839/page3
#define HEXCHAR_TO_DECCHAR(h) (h<=57?(h-48):(h-55))
//---
   int strcount = StringLen(str);
   int arrcount = ArraySize(arr);
   if(arrcount < strcount / 2) return false;
//---
   uchar tc[];
   StringToCharArray(str,tc);
//---
   int i=0,j=0;
//---
   for(i=0; i<strcount; i+=2)
     {
      //---
      uchar tmpchr=(HEXCHAR_TO_DECCHAR(tc[i])<<4)+HEXCHAR_TO_DECCHAR(tc[i+1]);
      //---
      arr[j]=tmpchr;
      j++;
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| ArrayToHex                                                       |
//+------------------------------------------------------------------+
//--- By Andrew Sumner & Alain Verleyen
//--- https://www.mql5.com/en/forum/157839/page3
string ArrayToHex(uchar &arr[],int count=-1)
  {
   string res="";
//---
   if(count<0 || count>ArraySize(arr))
      count=ArraySize(arr);
//---
   for(int i=0; i<count; i++)
      res+=StringFormat("%.2X",arr[i]);
//---
   return(res);
  }
//+------------------------------------------------------------------+
//|  ChartSetColor                                                   |
//+------------------------------------------------------------------+ 
void ChartSetColor(const int Type)
  {
//--- Set Light
   if(Type==0)
     {
      ChartSetInteger(0,CHART_COLOR_BACKGROUND,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_FOREGROUND,COLOR_FONT);
      ChartSetInteger(0,CHART_COLOR_GRID,clrNONE);
      ChartSetInteger(0,CHART_COLOR_CHART_UP,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_CHART_DOWN,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_CHART_LINE,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_VOLUME,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_ASK,clrNONE);
      ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,COLOR_CBG_LIGHT);
      //---
      ChartSetInteger(0,CHART_SHOW_OHLC,false);
      ChartSetInteger(0,CHART_SHOW_ASK_LINE,false);
      ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,false);
      ChartSetInteger(0,CHART_SHOW_GRID,false);
      ChartSetInteger(0,CHART_SHOW_VOLUMES,false);
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,false);
      ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,false);
     }
     
//--- Set Dark
   if(Type==1)
     {
      ChartSetInteger(0,CHART_COLOR_BACKGROUND,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_FOREGROUND,COLOR_FONT);
      ChartSetInteger(0,CHART_COLOR_GRID,clrNONE);
      ChartSetInteger(0,CHART_COLOR_CHART_UP,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_CHART_DOWN,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_CHART_LINE,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_VOLUME,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_ASK,clrNONE);
      ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,COLOR_CBG_DARK);
      //---
      ChartSetInteger(0,CHART_SHOW_OHLC,false);
      ChartSetInteger(0,CHART_SHOW_ASK_LINE,false);
      ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,false);
      ChartSetInteger(0,CHART_SHOW_GRID,false);
      ChartSetInteger(0,CHART_SHOW_VOLUMES,false);
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,false);
      ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,false);
     }
     
//--- Set Original
   if(Type==2)
     {
      ChartSetInteger(0,CHART_COLOR_BACKGROUND,ChartColor_BG);
      ChartSetInteger(0,CHART_COLOR_FOREGROUND,ChartColor_FG);
      ChartSetInteger(0,CHART_COLOR_GRID,ChartColor_GD);
      ChartSetInteger(0,CHART_COLOR_CHART_UP,ChartColor_UP);
      ChartSetInteger(0,CHART_COLOR_CHART_DOWN,ChartColor_DWN);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,ChartColor_BULL);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,ChartColor_BEAR);
      ChartSetInteger(0,CHART_COLOR_CHART_LINE,ChartColor_LINE);
      ChartSetInteger(0,CHART_COLOR_VOLUME,ChartColor_VOL);
      ChartSetInteger(0,CHART_COLOR_ASK,ChartColor_ASK);
      ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,ChartColor_LVL);
      //---
      ChartSetInteger(0,CHART_SHOW_OHLC,ChartColor_OHLC);
      ChartSetInteger(0,CHART_SHOW_ASK_LINE,ChartColor_ASKLINE);
      ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,ChartColor_PERIODSEP);
      ChartSetInteger(0,CHART_SHOW_GRID,ChartColor_GRID);
      ChartSetInteger(0,CHART_SHOW_VOLUMES,ChartColor_SHOWVOL);
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,ChartColor_OBJDESCR);
      ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,ChartColor_TRADELVL);
     }
     
     //---
   if(Type==3)
     {
      ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrWhite);
      ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrBlack);
      ChartSetInteger(0,CHART_COLOR_GRID,clrSilver);
      ChartSetInteger(0,CHART_COLOR_CHART_UP,clrBlack);
      ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrBlack);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrWhite);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrBlack);
      ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrBlack);
      ChartSetInteger(0,CHART_COLOR_VOLUME,clrGreen);
      ChartSetInteger(0,CHART_COLOR_ASK,clrOrangeRed);
      ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,clrOrangeRed);
      //---
      ChartSetInteger(0,CHART_SHOW_OHLC,false);
      ChartSetInteger(0,CHART_SHOW_ASK_LINE,false);
      ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,false);
      ChartSetInteger(0,CHART_SHOW_GRID,false);
      ChartSetInteger(0,CHART_SHOW_VOLUMES,false);
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,false);
     }
//---
  }
//+------------------------------------------------------------------+
//| ChartGetColor                                                    |
//+------------------------------------------------------------------+
//---- Original Template
color ChartColor_BG=0,ChartColor_FG=0,ChartColor_GD=0,ChartColor_UP=0,ChartColor_DWN=0,ChartColor_BULL=0,ChartColor_BEAR=0,ChartColor_LINE=0,ChartColor_VOL=0,ChartColor_ASK=0,ChartColor_LVL=0;
//---
bool ChartColor_OHLC=false,ChartColor_ASKLINE=false,ChartColor_PERIODSEP=false,ChartColor_GRID=false,ChartColor_SHOWVOL=false,ChartColor_OBJDESCR=false,ChartColor_TRADELVL=false;
//----
void ChartGetColor()
  {
   ChartColor_BG=(color)ChartGetInteger(0,CHART_COLOR_BACKGROUND,0);
   ChartColor_FG=(color)ChartGetInteger(0,CHART_COLOR_FOREGROUND,0);
   ChartColor_GD=(color)ChartGetInteger(0,CHART_COLOR_GRID,0);
   ChartColor_UP=(color)ChartGetInteger(0,CHART_COLOR_CHART_UP,0);
   ChartColor_DWN=(color)ChartGetInteger(0,CHART_COLOR_CHART_DOWN,0);
   ChartColor_BULL=(color)ChartGetInteger(0,CHART_COLOR_CANDLE_BULL,0);
   ChartColor_BEAR=(color)ChartGetInteger(0,CHART_COLOR_CANDLE_BEAR,0);
   ChartColor_LINE=(color)ChartGetInteger(0,CHART_COLOR_CHART_LINE,0);
   ChartColor_VOL=(color)ChartGetInteger(0,CHART_COLOR_VOLUME,0);
   ChartColor_ASK=(color)ChartGetInteger(0,CHART_COLOR_ASK,0);
   ChartColor_LVL=(color)ChartGetInteger(0,CHART_COLOR_STOP_LEVEL,0);
//---
   ChartColor_OHLC=ChartGetInteger(0,CHART_SHOW_OHLC,0);
   ChartColor_ASKLINE=ChartGetInteger(0,CHART_SHOW_ASK_LINE,0);
   ChartColor_PERIODSEP=ChartGetInteger(0,CHART_SHOW_PERIOD_SEP,0);
   ChartColor_GRID=ChartGetInteger(0,CHART_SHOW_GRID,0);
   ChartColor_SHOWVOL=ChartGetInteger(0,CHART_SHOW_VOLUMES,0);
   ChartColor_OBJDESCR=ChartGetInteger(0,CHART_SHOW_OBJECT_DESCR,0);
   ChartColor_TRADELVL=ChartGetInteger(0,CHART_SHOW_TRADE_LEVELS,0);
//---
  }
//+------------------------------------------------------------------+
//| ChartMiddleX                                                     |
//+------------------------------------------------------------------+
int ChartMiddleX()
  {
   return((int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS)/2);
  }
//+------------------------------------------------------------------+
//| ChartMiddleY                                                     |
//+------------------------------------------------------------------+
int ChartMiddleY()
  {
   return((int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS)/2);
  }
//+------------------------------------------------------------------+
//| Create rectangle label                                           |
//+------------------------------------------------------------------+
//https://docs.mql4.com/constants/objectconstants/enum_object/obj_rectangle_label
bool RectLabelCreate(const long             chart_ID=0,               // chart's ID
                     const string           name="RectLabel",         // label name
                     const int              sub_window=0,             // subwindow index
                     const int              x=0,                      // X coordinate
                     const int              y=0,                      // Y coordinate
                     const int              width=50,                 // width
                     const int              height=18,                // height
                     const color            back_clr=C'236,233,216',  // background color
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // border type
                     const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                     const color            clr=clrRed,               // flat border color (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // flat border style
                     const int              line_width=1,             // flat border width
                     const bool             back=false,               // in the background
                     const bool             selection=false,          // highlight to move
                     const bool             hidden=true,              // hidden in the object list
                     const long             z_order=0,                // priority for mouse click 
                     const string           tooltip="\n")             // tooltip for mouse hover
  {
//---- reset the error value
   ResetLastError();
//---
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create a rectangle label! Error code = ",_LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Create a text label                                              | 
//+------------------------------------------------------------------+ 
//https://docs.mql4.com/constants/objectconstants/enum_object/obj_label
bool LabelCreate(const long              chart_ID=0,               // chart's ID 
                 const string            name="Label",             // label name 
                 const int               sub_window=0,             // subwindow index 
                 const int               x=0,                      // X coordinate 
                 const int               y=0,                      // Y coordinate 
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                 const string            text="Label",             // text 
                 const string            font="Arial",             // font 
                 const int               font_size=10,             // font size 
                 const color             clr=clrRed,               // color 
                 const double            angle=0.0,                // text slope 
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type 
                 const bool              back=false,               // in the background 
                 const bool              selection=false,          // highlight to move 
                 const bool              hidden=true,              // hidden in the object list 
                 const long              z_order=0,                // priority for mouse click 
                 const string            tooltip="\n",             // tooltip for mouse hover
                 const bool              tester=true)              // create object in the strategy tester
  {
//--- reset the error value 
   ResetLastError();
//--- CheckTester
   if(!tester && MQLInfoInteger(MQL_TESTER))
      return(false);
//---
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create text label! Error code = ",_LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create Edit object                                               |
//+------------------------------------------------------------------+
//https://docs.mql4.com/constants/objectconstants/enum_object/obj_edit
bool EditCreate(const long             chart_ID=0,               // chart's ID
                const string           name="Edit",              // object name
                const int              sub_window=0,             // subwindow index
                const int              x=0,                      // X coordinate
                const int              y=0,                      // Y coordinate
                const int              width=50,                 // width
                const int              height=18,                // height
                const string           text="Text",              // text
                const string           font="Arial",             // font
                const int              font_size=10,             // font size
                const ENUM_ALIGN_MODE  align=ALIGN_CENTER,       // alignment type
                const bool             read_only=false,          // ability to edit
                const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                const color            clr=clrBlack,             // text color
                const color            back_clr=clrWhite,        // background color
                const color            border_clr=clrNONE,       // border color
                const bool             back=false,               // in the background
                const bool             selection=false,          // highlight to move
                const bool             hidden=true,              // hidden in the object list
                const long             z_order=0,                // priority for mouse click 
                const string           tooltip="\n")             // tooltip for mouse hover
  {
//--- reset the error value
   ResetLastError();
//---
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create \"Edit\" object! Error code = ",_LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align);
      ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Create the button                                                | 
//+------------------------------------------------------------------+ 
//https://docs.mql4.com/constants/objectconstants/enum_object/obj_button
bool ButtonCreate(const long              chart_ID=0,               // chart's ID 
                  const string            name="Button",            // button name 
                  const int               sub_window=0,             // subwindow index 
                  const int               x=0,                      // X coordinate 
                  const int               y=0,                      // Y coordinate 
                  const int               width=50,                 // button width 
                  const int               height=18,                // button height 
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                  const string            text="Button",            // text 
                  const string            font="Arial",             // font 
                  const int               font_size=10,             // font size 
                  const color             clr=clrBlack,             // text color 
                  const color             back_clr=C'236,233,216',  // background color 
                  const color             border_clr=clrNONE,       // border color 
                  const bool              state=false,              // pressed/released 
                  const bool              back=false,               // in the background 
                  const bool              selection=false,          // highlight to move 
                  const bool              hidden=true,              // hidden in the object list 
                  const long              z_order=0,                // priority for mouse click 
                  const string            tooltip="\n")             // tooltip for mouse hover
  {
//--- reset the error value 
   ResetLastError();
//---
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create the button! Error code = ",_LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//---
   return(true);
  }
//+--------------------------------------------------------------------+ 
//| ChartMouseScrollSet                                                | 
//+--------------------------------------------------------------------+ 
//https://docs.mql4.com/constants/chartconstants/charts_samples
bool ChartMouseScrollSet(const bool value)
  {
//--- reset the error value 
   ResetLastError();
//---
   if(!ChartSetInteger(0,CHART_MOUSE_SCROLL,0,value))
     {
      Print(__FUNCTION__,
            ", Error Code = ",_LastError);
      return(false);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+ 
//| PlaySound                                                        | 
//+------------------------------------------------------------------+ 
void _PlaySound(const string FileName)
  {
//---
   if(SoundIsEnabled)
      PlaySound(FileName);
//---
  }
//+------------------------------------------------------------------+
//| End of the Code                                                  |
//+------------------------------------------------------------------+
