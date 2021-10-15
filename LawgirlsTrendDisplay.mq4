//+------------------------------------------------------------------+
//|                                Lawgirl's Trend Display v1.02.mq4 |
//|                                           Copyright © 2010, gspe |
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

#property copyright "Copyright © 2010, gspe"
#property link      ""

#property indicator_chart_window

extern bool		ShowCurrentPairOnly  = false; //	Dispaly only chart Pair
extern string	PairsToTrade = "AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,CADCHF,CADJPY,CHFJPY,EURAUD,EURCAD,EURCHF,EURGBP,EURJPY,EURNZD,EURUSD,GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,GBPUSD,NZDCAD,NZDCHF,NZDJPY,NZDUSD,USDCAD,USDCHF,USDJPY";
extern string	PeriodsToTrade = "H1,H4,D1,W1,MN"; // Time Frames to display are user defined
//extern string  lb="----Look back inputs----";
//extern double  MinimumValueChange=1;
//extern bool    TrendRequiresAllThree=true;
//extern bool    TrendRequiresOnlyHtf=false;
//extern bool    AlertByEmail=false;
extern string	pdi="----Pair display inputs----";
extern int		FontSize=10;
extern color	FontColour=Yellow;
extern string	Font_Font = "Lucida Sans Unicode";
extern double	DisplayStarts_X=5;	//we positioning the object from the top right corner of window
extern double	DisplayStarts_Y=5;
extern bool		IndicatorInRSIWindow  = false;	// Dispaly the indicator in the RSI Window
extern string	RSI_WindowName = "RSI(3)";			// RSI Window ShortName

double	ValueChange_1=2.5,
		ValueChange_2=4.75;

int	symbolCodeSUP=233,
		symbolCodeSDN=234,
		symbolCodeWUP=236,
		symbolCodeWDN=238,
		symbolCodeNoSignal=232;
color	colorCodeSUP=Blue,
		colorCodeSDN=Red,
		colorCodeWUP=DeepSkyBlue,
		colorCodeWDN=Magenta,
		colorCodeNoSignal=Gold;

//Pair extraction
int		NoOfPairs;				// Holds the number of pairs passed by the user via the inputs screen
int		NoOfPeriods;			// Holds the number of periods passed by the user via the inputs screen
string	TradePair[];			//Array to hold the pairs traded by the user
string	TradePeriod[];			//Array to hold the periods traded by the user
int		TradePeriodTF[];		//Array to hold the periods traded by the user
int		TradeTrendSymbol[][5];	//Array to hold the pairs trend symbol
color 	TradeTrendColor[][5];	//Array to hold the pairs trend color
bool  	AlertSent[];

string	trend;
int		OldBars;
int WindowNo = 0;
//+------------------------------------------------------------------+
string objPrefix ;	// all objects drawn by this indicator will be prefixed with this
string buff_str ;	// all objects drawn by this indicator will be prefixed with this
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
{
//+------------------------------------------------------------------+ 
//----
	int i, j;
	objPrefix = WindowExpertName();
	
	if(IndicatorInRSIWindow)
	{
		WindowNo = WindowFind(RSI_WindowName);
		if(WindowNo < 0)
		{
			Alert("RSI_WindowName is Wrong");
			return(0);
		}
		DisplayStarts_X = 5;
		DisplayStarts_Y = 5;
	}

	if(!ShowCurrentPairOnly)
	{
		//Extract the pairs traded by the user
		NoOfPairs = StringFindCount(PairsToTrade,",")+1;
		ArrayResize(TradePair, NoOfPairs);
		string AddChar = StringSubstr(Symbol(),6,4);
		StrPairToStringArray(PairsToTrade, TradePair, AddChar);
	}
	else
	{
		//Fill the array with only chart pair
		NoOfPairs = 1;
		ArrayResize(TradePair, NoOfPairs);
		TradePair[0] = Symbol();
	}
	
	NoOfPeriods = StringFindCount(PeriodsToTrade, ",")+1;
	ArrayResize(TradePeriod, NoOfPeriods);
	ArrayResize(TradePeriodTF, NoOfPeriods);
	StrToStringArray(PeriodsToTrade, TradePeriod);
	
	for(j=0; j<NoOfPeriods; j++)
	{
		TradePeriodTF[j] = StrToTF(TradePeriod[j]);	//this is for display Periods from topleft corner
		//TradePeriodTF[NoOfPeriods-j] = StrToTF(TradePeriod[j]);	//this is for display Periods from topright corner
	}
//----	
	ArrayResize(TradeTrendSymbol, NoOfPairs);
	ArrayInitialize(TradeTrendSymbol, symbolCodeNoSignal);		// Inizialize the array with symbolCodeNoSignal
	ArrayResize(TradeTrendColor, NoOfPairs);
	ArrayInitialize(TradeTrendColor, colorCodeNoSignal);		// Inizialize the array with colorCodeNoSignal
//----
	return(0);
}// End init()

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
{
//----
	Comment("");   
//+------------------------------------------------------------------+ 
	RemoveObjects(objPrefix);
//----
	return(0);
}// End deinit()

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
   GetPairTrends(TradeTrendSymbol, TradeTrendColor);
   PrintPairTrends();

}//End start()
//+------------------------------------------------------------------+

//-------------------------------------------------------------------+
// RemoveObjects                                                     |
//-------------------------------------------------------------------+
void RemoveObjects(string Pref)
{   
	int i;
	string objname = "";

	for (i = ObjectsTotal(); i >= 0; i--)
	{
		objname = ObjectName(i);
		if (StringFind(objname, Pref, 0) > -1) ObjectDelete(objname);
	}
	return(0);
} // End void RemoveObjects(string Pref)

//+------------------------------------------------------------------+
// StringFindCount                                                   |
//+------------------------------------------------------------------+
int StringFindCount(string str, string str2)
// Returns the number of occurrences of STR2 in STR
// Usage:   int x = StringFindCount("ABCDEFGHIJKABACABB","AB")   returns x = 3
{
  int c = 0;
  for (int i=0; i<StringLen(str); i++)
    if (StringSubstr(str,i,StringLen(str2)) == str2)  c++;
  return(c);
} // End int StringFindCount(string str, string str2)

//+------------------------------------------------------------------+
// StrPairToStringArray                                                  |
//+------------------------------------------------------------------+
void StrPairToStringArray(string str, string &a[], string p_suffix, string delim=",")
{
	int z1=-1, z2=0;
	for (int i=0; i<ArraySize(a); i++)
	{
		z2 = StringFind(str,delim,z1+1);
		a[i] = StringSubstr(str,z1+1,z2-z1-1) + p_suffix;
		if (z2 >= StringLen(str)-1)   break;
		z1 = z2;
	}
	return(0);
} // End void StrPairToStringArray(string str, string &a[], string p_suffix, string delim=",") 

//+------------------------------------------------------------------+
// StrToStringArray                                                  |
//+------------------------------------------------------------------+
void StrToStringArray(string str, string &a[], string delim=",")
{
	int z1=-1, z2=0;
	for (int i=0; i<ArraySize(a); i++)
	{
		z2 = StringFind(str,delim,z1+1);
		a[i] = StringSubstr(str,z1+1,z2-z1-1);
		if (z2 >= StringLen(str)-1)   break;
		z1 = z2;
	}
	return(0);
} // End void StrToStringArray(string str, string &a[], string delim=",") 

//+------------------------------------------------------------------+
// StrToTF(string str)                                               |
//+------------------------------------------------------------------+
// Converts a timeframe string to its MT4-numeric value
// Usage:   int x=StrToTF("M15")   returns x=15
int StrToTF(string str)
{
  str = StringUpper(str);
  str = StringTrimLeft(str);
  str = StringTrimRight(str);
  
  if (str == "M1")   return(1);
  if (str == "M5")   return(5);
  if (str == "M15")  return(15);
  if (str == "M30")  return(30);
  if (str == "H1")   return(60);
  if (str == "H4")   return(240);
  if (str == "D1")   return(1440);
  if (str == "W1")   return(10080);
  if (str == "MN")   return(43200);
  return(0);
}  

//+------------------------------------------------------------------+
// StringUpper(string str)                                           |
//+------------------------------------------------------------------+
// Converts any lowercase characters in a string to uppercase
// Usage:    string x=StringUpper("The Quick Brown Fox")  returns x = "THE QUICK BROWN FOX"
string StringUpper(string str)
{
  string outstr = "";
  string lower  = "abcdefghijklmnopqrstuvwxyz";
  string upper  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  for(int i=0; i<StringLen(str); i++)  {
    int t1 = StringFind(lower,StringSubstr(str,i,1),0);
    if (t1 >=0)  
      outstr = outstr + StringSubstr(upper,t1,1);
    else
      outstr = outstr + StringSubstr(str,i,1);
  }
  return(outstr);
}  
//+------------------------------------------------------------------+
//| GetPairTrends                                                    |
//+------------------------------------------------------------------+
void GetPairTrends(int &trend_symbol[][], color &trend_color[][])
{
	int i, j;
	double c_val, p_val, delta_val;
	
	for(i=0; i<NoOfPairs; i++)
	{
		for(j=0; j<NoOfPeriods; j++)
		{
			trend_symbol[i][j] = symbolCodeNoSignal;
			trend_color[i][j] = colorCodeNoSignal;
			
			c_val = iRSI(TradePair[i], TradePeriodTF[j], 3, PRICE_CLOSE, 0);
			p_val = iRSI(TradePair[i], TradePeriodTF[j], 3, PRICE_CLOSE, 1);
			delta_val = MathAbs(c_val - p_val);
			
			if(c_val - p_val > 0)
			{
				if(delta_val > ValueChange_2)
				{
					trend_symbol[i][j] = symbolCodeSUP;
					trend_color[i][j] = colorCodeSUP;
				} // End if(delta_val > ValueChange_2)
				if(delta_val > ValueChange_1 && delta_val < ValueChange_2)
				{
					trend_symbol[i][j] = symbolCodeWUP;
					trend_color[i][j] = colorCodeWUP;
				} // End if(delta_val > ValueChange_1 && delta_val < ValueChange_2)
			} // End if(c_val - p_val > 0)
			if(c_val - p_val < 0)
			{
				if(delta_val > ValueChange_2)
				{
					trend_symbol[i][j] = symbolCodeSDN;
					trend_color[i][j] = colorCodeSDN;
				} // End if(delta_val > ValueChange_2)
				if(delta_val > ValueChange_1 && delta_val < ValueChange_2)
				{
					trend_symbol[i][j] = symbolCodeWDN;
					trend_color[i][j] = colorCodeWDN;
				} // End if(delta_val > ValueChange_1 && delta_val < ValueChange_2)
			} // End if(c_val - p_val > 0)
		} //End for(j=0; j<NoOfPeriods; j++)
	} //End for(i=0; i<NoOfPairs; i++)
	return(0);

}//End GetPairTrends(int &trend_symbol[][], color &trend_color[][])

//+------------------------------------------------------------------+
//| PrintPairTrends                                                    |
//+------------------------------------------------------------------+
void PrintPairTrends()
{
	RemoveObjects(objPrefix);
	
	int i, j;
	
	//Set Trade Pair
	for(i=0; i<NoOfPairs; i++)
	{
		buff_str = StringConcatenate(objPrefix, TradePair[i]);
		ObjectDelete(buff_str);
		ObjectCreate(buff_str,OBJ_LABEL,WindowNo,0,0,0,0);
		ObjectSet(buff_str,OBJPROP_CORNER,1);
		ObjectSet(buff_str,OBJPROP_XDISTANCE,DisplayStarts_X + FontSize*(NoOfPeriods*2));
		ObjectSet(buff_str,OBJPROP_YDISTANCE,DisplayStarts_Y + (i+1)*(FontSize+FontSize/2));
		ObjectSetText(buff_str,TradePair[i],FontSize-2,Font_Font,FontColour);
	}
	//Set Trade Period
	for(j=0; j<NoOfPeriods; j++)
	{
		buff_str = StringConcatenate(objPrefix, TradePeriod[j]);
		ObjectDelete(buff_str);
		ObjectCreate(buff_str,OBJ_LABEL,WindowNo,0,0,0,0);
		ObjectSet(buff_str,OBJPROP_CORNER,1);
		ObjectSet(buff_str,OBJPROP_XDISTANCE,DisplayStarts_X + (NoOfPeriods-1-j)*(FontSize*2));
		ObjectSet(buff_str,OBJPROP_YDISTANCE,DisplayStarts_Y);
		ObjectSetText(buff_str,TradePeriod[j],FontSize-2,Font_Font,FontColour);      
	}
	//Set Trade Trend
	for(i=0; i<NoOfPairs; i++)
	{
		for(j=0; j<NoOfPeriods; j++)
		{
			buff_str = StringConcatenate(objPrefix, TradePair[i], TradePeriod[j]);
			ObjectDelete(buff_str);
			ObjectCreate(buff_str,OBJ_LABEL,WindowNo,0,0,0,0);
 			ObjectSet(buff_str,OBJPROP_CORNER,1);
			ObjectSet(buff_str,OBJPROP_XDISTANCE,DisplayStarts_X + (NoOfPeriods-1-j)*(FontSize*2));
			ObjectSet(buff_str,OBJPROP_YDISTANCE,DisplayStarts_Y + (i+1)*(FontSize+FontSize/2));
			ObjectSetText(buff_str,CharToStr(TradeTrendSymbol[i][j]),FontSize,"Wingdings",TradeTrendColor[i][j]);
		}
	}
//----
	return(0);

}//End PrintPairTrends()




