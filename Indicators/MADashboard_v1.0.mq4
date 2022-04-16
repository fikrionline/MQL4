//+------------------------------------------------------------------+
//|                                                 MA Dashboard.mq4 |
//+------------------------------------------------------------------+

//#property show_inputs
#property indicator_chart_window

//#include <hanover --- function header (np).mqh>

extern string   ParameterFile         = "NONE";
//extern string   Currencies          = "AUD,CAD,CHF,EUR,GBP,JPY,NZD,USD,TRY,SGD,DKK,HKD,NOK,SEK,PLN,HUF,CZK,ZAR";
extern string   Currencies            = "AUD,CAD,CHF,EUR,GBP,JPY,NZD,USD";
extern string   CurrencySuffix        = "";
extern string   TimeFrames            = "MN,W1,D1,H4,H1,M30,M15,M5,M1";
extern string   MAParameters          = "60,0,1,0,0";                  // period, ma_shift, ma_method, applied_price, shift
extern string   FontNameSizeColor     = "Verdana,10,White";
extern int      WingdingsSymbol       = 117;
extern color    BullishColor          = clrGreen;
extern color    BearishColor          = clrRed;
extern string   PositionSettings      = "0,TR,10,70,30,10,20";        // Window, Corner, HorizPos, HorizAdjust, HorizSpacing, VertPos, VertSpacing
extern string   Visibility            = "M1,M5,M15,M30,H1,H4,D1,W1,MN";
extern string   RefreshPeriod         = "+0";
double spr, pnt, tickval, bidp, askp, lswap, sswap;
int dig, tf, ma[5], RefreshEveryXMins, vis, FontSize, Window, Corner, HorizPos, HorizAdjust, HorizSpacing, VertPos, VertSpacing;
string IndiName, ccy, sym, C[40], TFs[9], arr[10], FontName;
datetime prev_time;
color FontColor;

//+------------------------------------------------------------------+
int init() {
   //+------------------------------------------------------------------+

   ccy = Symbol();
   sym = Symbol();
   tf = Period();
   bidp = MarketInfo(ccy, MODE_BID);
   askp = MarketInfo(ccy, MODE_ASK);
   pnt = MarketInfo(ccy, MODE_POINT);
   dig = MarketInfo(ccy, MODE_DIGITS);
   spr = MarketInfo(ccy, MODE_SPREAD);
   tickval = MarketInfo(ccy, MODE_TICKVALUE);
   if (dig == 3 || dig == 5) {
      pnt *= 10;
      spr /= 10;
      tickval *= 10;
   }

   del_obj();
   plot_obj();
   prev_time = -9999;
   return (0);
}
//+------------------------------------------------------------------+
int deinit() {
   //+------------------------------------------------------------------+
   del_obj();
   return (0);
}
//+------------------------------------------------------------------+
int start() {
   //+------------------------------------------------------------------+
   if (RefreshEveryXMins < 0)
      return (0);
   if (RefreshEveryXMins == 0) {
      del_obj();
      plot_obj();
   } else {
      if (prev_time != iTime(sym, RefreshEveryXMins, 0)) {
         del_obj();
         plot_obj();
         prev_time = iTime(sym, RefreshEveryXMins, 0);
      }
   }
   return (0);
}

//+------------------------------------------------------------------+
void del_obj() {
   //+------------------------------------------------------------------+
   int k = 0;
   while (k < ObjectsTotal()) {
      string objname = ObjectName(k);
      if (StringSubstr(objname, 0, StringLen(IndiName)) == IndiName)
         ObjectDelete(objname);
      else
         k++;
   }
   return;
}

//+------------------------------------------------------------------+
void plot_obj() {
   //+------------------------------------------------------------------+
   CheckPresets();
   color colr = FontColor; // default color supplied by user
   int c = 0;
   int xp = HorizPos; // horizontal position for text label
   int yp = VertPos + c * VertSpacing; // vertical position for text label
   for (int t = 0; t < 9; t++) { // this loop prints the timeframe headings
      if (TFs[t] > "") { // ignore any gaps in the user-supplied list of Timeframes
         string tstr1 = StrToStr(TFs[t], "R4"); // build and print the label
         string objname = IndiName + "-hdg" + NumberToStr(-t - 1, "T-6");
         PlotLabel(objname, false, Window, Corner, xp + HorizAdjust + t * HorizSpacing, yp, tstr1, FontColor, FontSize, FontName, 0, false, vis); // Plot text label
      }
   }
   for (int i = 0; i < 40; i++) { // for each currency in the Currencies setting.......
      if (StringLen(C[i]) < 1) continue; // ignore any gaps in the list
      for (int j = 0; j < 40; j++) { // measured against each other currency........
         if (i == j) continue; // don't measure a currency against itself
         if (StringLen(C[j]) < 1) continue; // ignore any gaps in the list
         ccy = C[i] + C[j] + CurrencySuffix; // build the symbol ID for the pair, and append any suffix 
         if (iClose(ccy, 1440, 0) == 0) continue; // ignore any pair not being offered by the broker
         c++;
         yp = VertPos + c * VertSpacing; // yp = vertical position
         objname = IndiName + NumberToStr(-i - 1, "T-6") + NumberToStr(-j - 1, "T-6"); // print the symbol id
         PlotLabel(objname, false, Window, Corner, xp, yp, ccy, FontColor, FontSize, FontName, 0, false, vis); // Plot text label
         for (t = 0; t < 9; t++) { // for each timeframe.......
            if (TFs[t] > "") { // ignore any gaps in the user-supplied list of Timeframes
               double bid = iClose(ccy, StrToTF(TFs[t]), 0); // get the bid price for the pair
               double mval = iMA(ccy, StrToTF(TFs[t]), ma[0], ma[1], ma[2], ma[3], ma[4]); // get the MA of the bid price, using the user-supplied settings 
               if (bid > mval) // select the color for bullish or bearish Wingdings symbol
                  colr = BullishColor;
               else
                  colr = BearishColor;
               objname = IndiName + NumberToStr(-i - 1, "T-6") + NumberToStr(-j - 1, "T-6") + NumberToStr(-t - 1, "T-6"); // plot the symbol as a text label
               PlotLabel(objname, false, Window, Corner, xp + HorizAdjust + t * HorizSpacing, yp, CharToStr(WingdingsSymbol), colr, FontSize, "Wingdings", 0, false, vis); // Plot text label
            }
         }
      }
   }

   yp += 2 * VertSpacing;

   return;
}

//+------------------------------------------------------------------+
int CheckPresets() {
   //+------------------------------------------------------------------+
   //---------------------------------------------------------------------------------------------------------------
   //    Enter the file name in here
   //---------------------------------------------------------------------------------------------------------------
   ParameterFile = StringUpper(ParameterFile);
   string FileName = "Presets---MADash.TXT";
   if (ParameterFile > "") FileName = "Presets---MADash." + ParameterFile;
   //---------------------------------------------------------------------------------------------------------------
   int handle = FileOpen(FileName, FILE_CSV | FILE_READ, ';');
   if (handle > 0) {
      while (!FileIsEnding(handle)) {
         string text = FileReadString(handle);
         int t0 = StringFind(text, "//", 0);
         if (t0 == 0) text = "";
         else if (t0 > 0) text = StringSubstr(text, 0, t0);
         string temp = "";
         int quote = 0;
         for (int i = 0; i < StringLen(text); i++) {
            string schar = StringSubstr(text, i, 1);
            if (schar == "\x22") quote = 1 - quote;
            else if (quote == 1) temp = temp + schar;
            else if (schar != " " && schar != "_") temp = temp + StringLower(schar);
         }
         if (StringLen(temp) > 0) {
            int equal = StringFind(temp, "=", 0);
            int semic = StringFind(temp, ";", 0);
            string pname = "";
            pname = StringSubstr(temp, 0, equal);
            string pvalue = StringSubstr(temp, equal + 1, semic - equal + 1);
            if (pvalue != "*") {
               //---------------------------------------------------------------------------------------------------------------
               //    Parameter assignment statements go in here
               //---------------------------------------------------------------------------------------------------------------
               if (pname == "currencies") Currencies = pvalue;
               else
               if (pname == "currencysuffix") CurrencySuffix = pvalue;
               else
               if (pname == "timeframes") TimeFrames = pvalue;
               else
               if (pname == "maparameters") MAParameters = pvalue;
               else
               if (pname == "fontnamesizecolor") FontNameSizeColor = pvalue;
               else
               if (pname == "wingdingssymbol") WingdingsSymbol = StrToInteger(pvalue);
               else
               if (pname == "bullishcolor") BullishColor = StrToColor(pvalue);
               else
               if (pname == "bearishcolor") BearishColor = StrToColor(pvalue);
               else
               if (pname == "positionsettings") PositionSettings = pvalue;
               else
               if (pname == "refreshperiod") RefreshPeriod = pvalue;
               //          Debug("pname  = " + pname);
               //          Debug("pvalue = " + pvalue);
               //---------------------------------------------------------------------------------------------------------------
            }
         }
         temp = FileReadString(handle);
      }
      FileClose(handle);
   }

   RefreshEveryXMins = StrToTF(RefreshPeriod);
   vis = GetVisibility(Visibility);

   Currencies = StringUpper(Currencies);
   if (Currencies == "") Currencies = StringSubstr(Symbol(), 0, 3) + "," + StringSubstr(Symbol(), 3, 3);
   StrToStringArray(Currencies, C, ",");

   TimeFrames = StringUpper(TimeFrames);
   if (TimeFrames == "") TimeFrames = TFToStr(Period());
   StrToStringArray(TimeFrames, TFs, ",");

   StrToIntegerArray(MAParameters, ma, ",");

   StrToStringArray(FontNameSizeColor, arr);
   FontName = arr[0];
   FontSize = StrToInteger(arr[1]);
   FontColor = StrToColor(arr[2]);

   StrToStringArray(PositionSettings, arr);
   Window = StrToInteger(arr[0]);
   Corner = 2 * (StringFind(StringUpper(arr[1]), "B") >= 0) + (StringFind(StringUpper(arr[1]), "R") >= 0);
   HorizPos = StrToInteger(arr[2]);
   HorizAdjust = StrToInteger(arr[3]);
   HorizSpacing = StrToInteger(arr[4]);
   VertPos = StrToInteger(arr[5]);
   VertSpacing = StrToInteger(arr[6]);

   IndiName = NumberToStr(GetUniqueInt(), "'MADash-'Z6");
   IndicatorShortName(IndiName);

   return (0);
}

//+------------------------------------------------------------------+
//#include <hanover --- extensible functions (np).mqh>
/*
  NOTE:
  
  Below are the code libraries that I wrote in 2012, and have been generously
  updated by pips4life to make them compatible for build 600+.
  
  I've copied them from the mqh file to make it easier for non-coders to compile.
  This code should now compile without errors, using any version of MetaEditor.
  
  I've retained all of the functions for possible future use. However, please
  feel welcome to delete any unused ones if efficiency is important to you.

//===========================================================================
//                   FUNCTIONS LIBRARY - Alphabetical list 
//===========================================================================

/*
AppendIfMissing()             appends a character to a string if it's not already the rightmost character
AppendIfNotNull()             appends a character to a string if the string is not null
ArrayInitializeString()       initializes every element in a string array rto a certain value (default = null)
BarConvert()                  converts a bar# (candle#) to the equivalent bar# on another timeframe
BaseToNumber()                performs multibase arithmetic: converts a non-base 10 number (string) to a base 10 integer
BoolToStr()                   converts a boolean value to "true" or "false"
ColorToStr()                  converts a MT4 color value to its equivalent string token (e.g. "AliceBlue", "BurlyWood", "Red", "b101g96r44" etc) 
ConvertCcy()                  converts an amount from one currency to another 
DateToStr()                   formats a MT4 date/time value to a string, using a very sophisticated format mask
DatesToStr()                  performs multiple DateToStr() operations in a single function
DayNumber()                   given a MT4 datetime, returns number of days since 1 Jan 1970
DaysBetween()                 returns number of days between two dates (dates in YYYYMMDD format)
DebugDoubleArray()            unloads a set of values from a double array, prefixed by the element number, to a single string
DebugIntegerArray()           unloads a set of values from an int array, prefixed by the element number, to a single string
DebugStringArray()            unloads a set of values from a string array, prefixed by the element number, to a single string
DivZero()                     returns 0 instead of 'divide by zero' error, if denominator evaluates to 0
DoubleArrayToStr()            unloads a set of values from a double array to a single string, inserting a specified delimiter between the values
EasterDay()                   returns the MT4time value of Easter Sunday for the given year
EmbedString()                 embeds characters from a mask into a string, creating a new string
ExpandCcy()                   expands a curency symbol name, e.g. "EJ" to "EURJPY"
ExtractAlpha()                returns alphabetic (or other) characters in a string
ExtractUnique()               returns 1 occurrence only of each char in a string; result may be optionally sorted asc/desc
FileSort()                    shell sorts an ASCII text file, rewriting the file with its records in alphanumeric order
GetHash()                     calculate and return checksum of a string
GetPipValue()                 reads file "PipValues.TXT" to return the pip value (e.g. 0.0001 for non-JPY pairs, 0.01 for JPY pairs) for the passed symbol
GetUniqueInt()                returns a unique integer 1,2,3,4 ...... from Global Variable "##UniqueInt"
GetVisibility()               returns suitable OBJPROP_TIMEFRAMES value from a timeframes string (e.g. "M1,M5,M15")
ifint()                       returns different integer values, depending on condition
ifnum()                       returns different numeric (double) values, depending on condition
ifstr()                       returns different string values, depending on condition
IntegerArrayToStr()           unloads a set of values from an int array to a single string, inserting a specified delimiter between the values
IsAlpha()                     returns true if a string contains only certain types of characters, otherwise returns false
iRegr()                       returns &pips, &slope, &stdev of regr curve defined by pair, tf, poly degree, #points, st devs, hist shift
ListGlobals()                 lists all GlobalVariables and their values, to a string
ListObjects()                 lists all objects
ListOrders()                  lists all orders of your chosen stati (open/pending/closed/deleted) to a string
LookupDoubleArray()           looks up a numeric value in a double array, returning the element number (if found)
LookupIntegerArray()          looks up a numeric value in an int array, returning the element number (if found)
LookupStringArray()           looks up a string value in a string array, returning the element number (if found)
MathFactorial()               calculates a factorial n(n-1)(n-2)...1 using a recursive technique
MathFix()                     returns the value of N, rounded to D decimal places (fixes precision bug in MQL4 MathRound) 
MathInt()                     returns the value of N, rounded DOWN to D decimal places (fixes precision bug in MQL4 MathFloor)
MathSign()                    returns the sign (-1,0,+1) of a number
MonthNumber()                 given a MT4 datetime, returns number of months since 1 Jan 1970
NumberToBase()                performs multibase arithmetic: converts a base 10 integer to a non-base 10 number (string)
NumberToStr()                 formats a numeric (int/double) value to a string, using a very sophisticated format mask
NumbersToStr()                performs multiple NumberToStr() operations in a single function
OrderStatus()                 given a ticket number, returns the order status (O=open, P=pending, C=closed, D=deleted, U=unknown)
ReadWebPage()                 reads a page from a specified URL into a string
ReduceCcy()                   reduces a currency symbol name, e.g. "EURJPY" to "EJ"
ReturnDay()                   returns the MT4time value of the (e.g.) 3rd Sunday after 14 Feb 2011
ShellsortDoubleArray()        shell sorts an array of double values into ascending or descending sequence
ShellsortIntegerArray()       shell sorts an array of int values into ascending or descending sequence
ShellsortString()             shell sorts the characters in a string into ascending or descending ASCII sequence
ShellsortStringArray()        shell sorts an array of string values into ascending or descending ASCII sequence
StrToBool()                   converts a suitable string (T(rue)/t(rue)/F(alse)/f(alse)/1) to a boolean value
StrToChar()                   returns the decimal ASCII value of a 1 byte string (inverse of MQL4's CharToStr())
StrToColor()                  converts a string (color name, RGB values, etc) to a MQL4 color
StrToColorArray()             loads a color array from a delimiter-separated set of string values (e.g. "Blue,Green,Red"); returns the number of array elements loaded
StrToDate()                   converts a number of different string patterns to a MT4 date/time value
StrToDoubleArray()            loads a double array from a delimiter-separated set of string values (e.g. "1,2,3"); returns the number of array elements loaded
StrToIntegerArray()           loads an int array from a delimiter-separated set of string values (e.g. "1,2,3"); returns the number of array elements loaded
StrToNumber()                 strips all non-numeric characters from a string, returning a numeric (int/double) value
StrToStr()                    left/right/center aligns, or truncates, a string, using a very sophisticated format mask
StrToStringArray()            loads a string array from a delimiter-separated set of string values (e.g. "1,2,3"); returns the number of array elements loaded
StrToTF()                     converts a timeframe string to a number (e.g. "M15" to 15)
StringArrayToStr()            unloads a set of values from an string array to a single string, inserting a specified delimiter between the values
StringDecrypt()               unencrypts a string that was previously encrypted using StringEncrypt()
StringEncrypt()               encrypts a string
StringExtract()               extracts the content of string between 2 specified delimiters
StringFindCount()             returns the number of occurrences of a certain substring in a string
StringInsert()                inserts characters into a given position in a string
StringLeft()                  returns the leftmost characters, or all but the N rightmost characters, of a string
StringLeftExtract()           extracts N characters from a string, counting from the left
StringLeftPad()               inserts specified padding characters at the beginning of a string
StringLeftTrim()              removes all leading spaces from a string
StringLower()                 converts all alphabetic characters in a string to lowercase
StringOverwrite()             overwrites characters in a given position of a string
StringRepeat()                returns a given string, repeated N times
StringReplace()               replaces substring in a string with another substring
StringReverse()               reverses a string, e.g. "ABCDE" becomes "EDCBA"
StringRight()                 returns the rightmost characters, or all but the N leftmost characters, of a string
StringRightExtract()          extracts N characters from a string, counting from the right
StringRightPad()              appends specified padding characters to the end of a string
StringRightTrim()             removes all trailing spaces from a string
StringTranslate()             translates characters in a string, given a full translation table
StringTrim()                  removes all (leading, trailing and embedded) spaces from a string
StringUpper()                 converts all alphabetic characters in a string to uppercase
StrsToStr()                   performs multiple StrToStr() operations in a single function
TFToStr()                     converts a number to a timeframe string (e.g.  1440 to "D1")
WeekNumber()                  given a MT4 datetime, returns the week number since 1 Jan 1970, week is assumed to start on Sunday
YMDtoDate()                   converts 3 integers (year, month and day) to a MT4 date/time value

Debugging Functions:

d()                           outputs up to 8 values to the file /EXPERTS/FILES/DEBUG.TXT, appending data to the end of the file
dd()                          outputs up to 8 values to the file /EXPERTS/FILES/DEBUG.TXT, creating a new file
err_msg()                     returns a full description of an error, given its error code number
log()                         outputs up to 8 values for viewing using Microsoft's DebugView facility

Object Plotting Functions:

  PlotTL    (objname, delete, window#, time1,  price1, time2, price2, color, width, style, ray,   backg, vis, objtxt);      // Plot trendline
  PlotBox   (objname, delete, window#, time1,  price1, time2, price2, color, width, style,        backg, vis, objtxt);      // Plot rectangle
  PlotArrow (objname, delete, window#, time1,  price1,                color, size,  code,         backg, vis        );      // Plot arrow
  PlotVL    (objname, delete, window#, time1,                         color, width, style,        backg, vis, objtxt);      // Plot vertical line
  PlotHL    (objname, delete, window#,         price1,                color, width, style,        backg, vis, objtxt);      // Plot horizontal line
  PlotText  (objname, delete, window#, time1,  price1,        text,   color, size,  font,  angle, backg, vis)        ;      // Plot text
  PlotLabel (objname, delete, window#, corner, hpos,   vpos,  text,   color, size,  font,  angle, backg, vis)        ;      // Plot text label


*/
//#include <hanover --- extensible functions b600 (np).mqh>
//+-----------------------------------------------------------------------+
//|  Updated for b600:     hanover --- extensible functions b600 (np).mqh |
//|  Similar for b509:     hanover --- extensible functions b509 (np).mqh |
//|  Orig based on b509:   hanover --- extensible functions (np).mqh      |
//|                                                                       |
//|  Copyright 2017 by pips4life, original by hanover                     |
//+-----------------------------------------------------------------------+
// (np) = non-proprietary

//USE ONLY AT YOUR OWN RISK!!!  The user assumes all liability for everything. 
//The author(s) & contributor(s) have ZERO liability!! NO EXCEPTIONS!

// Official location:  
// Modified, useful MQ4 utilities, indicators, and related tips (by pips4life)
// https://www.forexfactory.com/showthread.php?p=9837951
// 
// Based on the original Thread: "Handy MQL4 utility functions"
// https://www.forexfactory.com/showthread.php?t=165557
//
// INSTRUCTIONS for use:
// These are INCLUDE files!  They belong in the "\Include" folder:
//    In MT4, File->Open Data Folder => MQL4\Include\  (put them here)
//
// In YOUR main code (usually in MQL4\Indicators\ or MQL4\Scripts\ ) , typically near the top:
//#include <hanover --- function header b600 (np).mqh>
// And usually near the bottom:
//#include <hanover --- extensible functions b600 (np).mqh>
// (See below for more extensive information, including "USAGE:" below!)
//
// If using the b509 version, replace "b600" above with "b509" in both names.
// (Search around to find a b509 compiler if you don't have one).

/* Version History


NO SUPPORT SHOULD BE EXPECTED.  If you find errors and report them, perhaps
they will be addressed, maybe not.  If you can fix them, please share the fixed version.
If you found an old pattern or technique which may occur elsewhere, decribe in "Usage:" below.
Document similar to here:

(Most recent history first):

v3 Updated on 2017-May-06 by pips4life (Kent), still for > b600 support. (b1065 as of now)  DEV
   Renamed.  Added " b600" to both this file and the function headers file.
   Fixed important v2 bug in NumberToStr function.  
      In 509: outstr = n; // n is a double. Ex: If n=3.5 => outstr="3.50000000"  (8 bits, padded zeros)
      In 600: Above results in   outstr="3.5" (no zeros!) Changed to: outstr=DoubleToStr(n,8);
   Added new functions:
      ConvertCcy()
      GetPipValue()
   Added new arg (objtext) to: PlotTL, PlotBox, PlotVL, PlotHL
   Other small changes to be consistent with hanover's most recent posted versions. (2016-04-29)
   NEW: Search for b600_b509" (or just "b600" and "b509") to find the very few sections which are exclusive
     and cannot be used in the opposite version.  These files should be compatible with EITHER
     version, after making very small changes as noted.  The vast majority of edits to make 
     these compatible with b600 are backwards compatible to b509 also.
     TIP: Areas to edit have:  // Search tag for nearby edits: "b600_b509"
     IMPORTANT: I could not use b600 to "Save As" the b509 file and open it with 509!!  Instead, I
     had to cut-and-paste the text into the file while using the 509 MetaEditor!  Same text, but it works.
     (Must be some unicode character or something else; I've not idea why, since it is "text").
   Described a useful technique: How to debug code compiled with b509 that will output lines of code,
     that one puts into a simple b600 script, that then compares the output values of b600 vs. b509.
     Search below for "DEBUG b600_Code"
   Updated "USAGE:" instructions below.
   
v2 Updated on 2014-Aug-04 by pips4life (Kent) for >600 support. HOWEVER,
   do NOT contact me for further support, nor hanover(David), who has made it
   abundantly clear he is done with MT4 programming!  My changes are
   provided as-is.  If you make updates, post them to (my new thread now, or) David's thread:
      Handy MQL4 utility functions
      http://www.forexfactory.com/showthread.php?t=165557


*** IMPORTANT! ***  USAGE: If you combine this file with another of David's .mt4 source
  files, then ABSOLUTELY make the following changes using "Replace", while *enabling* options "whole word" and "match case" :
   
   1. Change the "#include <hanover --- ...(np).mqh" calls.  Add the " b600" to match these replacement file names.
        Or... rename these files by removing " b600" (one space included).   (Similar instructions if " b509" version).
   2. Change his use of "StringReplace" to "stringReplaceOld". (lower-case leading "s").  You will likely NOT get any
        compiler error or warning, but the new MT4 function does NOT behave the same as Davids' does!!
   3. (POSSIBLY OPTIONAL: ) Change "StringSubstr" to "stringSubstrOld", because new MT4 expects 
        different 3rd argument value (-1 instead of 0); and it WILL corrupt strings if the 2nd argument
        is unexpectedly <0.  Again, you won't see any compiler error or warning, but make the change!
   4. Change his use of variable name "char" to be "s_char" instead.  The compiler will give errors until fixed.
   5. Change his use of variable name "sort" to be "s_sort" instead.  (Do the same for any use of other reserved keywords).
        Fyi: It is my suggestion to use prefixes of "s_" (string) "i_"(integer), "d_"(double), etc. Or "l_"(local var). Any change will suffice.
   6. Fix all other compiler errors and eliminate warnings if possible, doing whatever needs to be done, then upload your changes to
       the main thread above.  (...and elsewhere if you so choose).
   7. If problems occur (which they may, because not every function has been tested!), search for "DEBUG b600_Code" in this file.

   8. The local-variable names in the code below are sometimes the same as global-variable 
        names used.  In general, one can usually ignore warnings that say:
        declaration of 'varname' hides global declaration at line XX,  in File AAA, Line YY, Column ZZ
        Or, update the names per the suggestion in step #5 above.  The warnings should resolve.

Original v1:  2014-and-earlier:  Hanover of ForexFactory.com  ALL COPYRIGHTS RESERVED!
Updates to original:  2017-04-29-and-earlier:  Hanover of ForexFactory.com  ALL COPYRIGHTS RESERVED!

*/

// DEV :   COMMENT THE "#include..." LINE OUT WHEN RELEASED
// If uncommented, one can compile and then debug just this file for the errors & warnings. 
// However, more may occur when called by an "#include" statement from another program.
//#include <hanover --- function header b600 (np).mqh>   

//+------------------------------------------------------------------+
//|                        hanover --- extensible functions (np).mqh |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
double GetPipValue(string inst) {
   //+------------------------------------------------------------------+
   string piparr[2];
   double result = 0.0001;
   if (Digits < 4) // JPY pair
      result = 0.01;

   int h_inp = FileOpen("PipValues.TXT", FILE_CSV | FILE_READ, '~'); // obtain override from file
   if (h_inp >= 0) {
      while (!FileIsEnding(h_inp)) {
         string s_inp = StringTrim(FileReadString(h_inp));
         if (FileIsEnding(h_inp)) break;
         StrToStringArray(s_inp, piparr, "=");
         if (inst == stringSubstrOld(piparr[0], 0, StringLen(inst))) {
            result = StrToNumber(piparr[1]);
            break;
         }
      }
      FileClose(h_inp);
   }
   return (result);
}

//+------------------------------------------------------------------+
int ifint(bool cond, int iftrue, int iffalse) {
   //+------------------------------------------------------------------+
   if (cond) return (iftrue);
   return (iffalse);
}

//+------------------------------------------------------------------+
double ifnum(bool cond, double iftrue, double iffalse) {
   //+------------------------------------------------------------------+
   if (cond) return (iftrue);
   return (iffalse);
}

//+------------------------------------------------------------------+
string ifstr(bool cond, string iftrue, string iffalse) {
   //+------------------------------------------------------------------+
   if (cond) return (iftrue);
   return (iffalse);
}

//+------------------------------------------------------------------+
string EmbedString(string str, string mask, string embedchar = "#", bool complete = false) {
   //+------------------------------------------------------------------+
   // Example:   string s1 = "abcdefghi";   string s2 = "## ##12 ##-";
   // EmbedString(s1,s2)          returns "ab cd12 ef-"
   // EmbedString(s1,s2,"#",true) returns "ab cd12 ef-ghi"

   string res = "";
   int p1 = 0;
   for (int p2 = 0; p2 < StringLen(mask); p2++) {
      string s = stringSubstrOld(mask, p2, 1);
      if (s == embedchar) {
         res = res + stringSubstrOld(str, p1, 1);
         p1++;
      } else {
         res = res + s;
      }
   }
   if (complete && p1 < StringLen(str))
      res = res + stringSubstrOld(str, p1);
   return (res);
}

//+------------------------------------------------------------------+
int DaysBetween(string d1, string d2, string msk = "YYYYMMDD") {
   //+------------------------------------------------------------------+
   // Calculates number of days between two dates in the format YYYYMMDD
   // If either date field is blank, it is assumed to be today (MT4 time)  
   if (StringLen(ExtractAlpha(d1, "1")) < 1) d1 = DateToStr(TimeCurrent(), "YMD");
   if (StringLen(ExtractAlpha(d2, "1")) < 1) d2 = DateToStr(TimeCurrent(), "YMD");
   int res = StrToDate(d2, msk) - StrToDate(d1, msk);
   res = MathInt(res / 86400);
   return (res);
}

//+------------------------------------------------------------------+
int GetUniqueInt() {
   //+------------------------------------------------------------------+
   string gvar = "##UniqueInt";
   if (!GlobalVariableCheck(gvar))
      GlobalVariableSet(gvar, 0);
   int val = GlobalVariableGet(gvar) + 1;
   GlobalVariableSet(gvar, val);
   return (val);
}

//+------------------------------------------------------------------+
int DayNumber(datetime d) {
   //+------------------------------------------------------------------+
   // Returns julian day number since Jan 1, 1970
   return (MathInt(d / 86400));
}

//+------------------------------------------------------------------+
int WeekNumber(datetime d, bool monday = false) {
   //+------------------------------------------------------------------+
   // Returns julian week number since Jan 1, 1970
   // If monday=true, weeks start on Mondays; otherwise Sundays
   if (monday)
      return (MathInt((d + 3 * 86400) / 7 / 86400));
   else
      return (MathInt((d + 4 * 86400) / 7 / 86400));
}

//+------------------------------------------------------------------+
int MonthNumber(datetime d) {
   //+------------------------------------------------------------------+
   // Returns julian month number since Jan 1, 1970
   return (MathInt((TimeYear(d) - 1970) * 12 + TimeMonth(d)));
}

//+------------------------------------------------------------------+
int MathFactorial(int n) {
   //+------------------------------------------------------------------+
   // Returns n! using a recursive technique
   /*
     if (n==0)
       return(1);
     else
       return(n*MathFactorial(n-1));  
   */
   // Non-recursive algo.....
   int retval = 1;
   for (int i = 1; i <= n; i++)
      retval = retval * i;
   return (retval);
}

//+------------------------------------------------------------------+
bool IsAlpha(string str, string test = "Aa ") {
   //+------------------------------------------------------------------+
   // Returns true if str contains only the characters listed in test. In test:
   // --- the metacharacter 'A' refers to all uppercase alphabetic characters, i.e. 'A' thru 'Z'
   // --- the metacharacter 'a' refers to all lowercase alphabetic characters, i.e. 'a' thru 'z'
   // --- the metacharacter '1' refers to all numeric digits, i.e. '0' thru '9'
   // Example: IsAlpha("Hello, world") returns FALSE, because the comma is not included in
   //   the default test string of upper/lowercase characters and spaces
   bool val = true;
   for (int i = 0; i < StringLen(str); i++) {
      string s = stringSubstrOld(str, i, 1);
      bool ok = false;
      if ((s >= "A" && s <= "Z" && StringFind(test, "A") >= 0) ||
         (s >= "a" && s <= "z" && StringFind(test, "a") >= 0) ||
         (s >= "0" && s <= "9" && StringFind(test, "1") >= 0) ||
         StringFind(test, s) >= 0)
         ok = true;
      if (!ok) {
         val = false;
         break;
      }
   }
   return (val);
}

//+------------------------------------------------------------------+
string ExtractAlpha(string istr, string other = "Aa") {
   //+------------------------------------------------------------------+
   // Returns alphabetic (or other) characters in a string, strips out everything else
   // parameter 'other' defaults to 'Aa' which will return all uppercase & lowercase alpha chars
   // appending '1' to 'other' will return digits 0-9 also
   // appending any other chars to 'other' will cause those chars to be returned also
   // Example: ExtractAlpha("-34.5°C","1-.") will return "-34.5" 
   // Note: to strip a numeric value from a string, see StrToNumber() function
   string ostr = "";
   for (int i = 0; i < StringLen(istr); i++) {
      string s = stringSubstrOld(istr, i, 1);
      if ((s >= "A" && s <= "Z" && StringFind(other, "A") >= 0) ||
         (s >= "a" && s <= "z" && StringFind(other, "a") >= 0) ||
         (s >= "0" && s <= "9" && StringFind(other, "1") >= 0) ||
         StringFind(other, s) >= 0)
         ostr = ostr + s;
   }
   return (ostr);
}

//+------------------------------------------------------------------+
string ExtractUnique(string istr, string s_sort = "") {
   //+------------------------------------------------------------------+
   // Returns a string (ostr) where there is only one occurrence of each character
   // in the input string (istr)
   // Example: ExtractUnqiue("aaabb") returns "ab"
   // s_sort parameter may be null (no sort), "a" (sort ascending), "d" (sort descending)
   // if "a" or "d", sorts chars in resulting string into ASCII order
   // Example: ExtractUnique("the quick brown fox jumps over the lazy dog","a")
   //    returns " abcdefghijklmnopqrstuvwxyz"
   string ostr = "";
   for (int i = 0; i < StringLen(istr); i++) {
      string s = stringSubstrOld(istr, i, 1);
      if (StringFind(ostr, s) < 0)
         ostr = ostr + s;
   }
   if (StringUpper(s_sort) == "A" || StringUpper(s_sort) == "D")
      ostr = ShellsortString(ostr, (StringUpper(s_sort) == "D"));
   return (ostr);
}

//+------------------------------------------------------------------+
datetime ReturnDay(int count, string dow, datetime start) {
   //+------------------------------------------------------------------+
   // Example: ReturnDay(3,"Sat",StrToTime("2011.02.14"))
   //   returns the MT4time value of the 3rd Saturday after 14 Feb 2011
   int c = 0;
   datetime dt = start - 86400;
   while (c < count) {
      dt += 86400;
      if (StringUpper(DateToStr(dt, "w")) == StringUpper(dow)) c++;
   }
   return (dt);
}

//+------------------------------------------------------------------+
datetime EasterDay(int year) {
   //+------------------------------------------------------------------+
   //   returns the MT4time value of Easter Sunday for the given (4 digit) year
   //   e.g. DateToStr(EasterDay(2011),"M/D/Y") returns "04/24/2011"
   int result = MathMod(225 - 11 * MathMod(year, 19) - 21, 30) + 21;
   if (result > 48) result--;
   result = result + 7 - MathMod(year + MathInt(year / 4) + result + 1, 7);
   result = YMDtoDate(year, 3, 1) + (result - 1) * 86400;
   return (result);
}

//+------------------------------------------------------------------+
int GetHash(string str) {
   //+------------------------------------------------------------------+
   // returns a hash (checksum) value for a given string
   int sum = 0;
   for (int i = 0; i < StringLen(str); i++)
      sum = sum + (i + 1) * StringGetChar(str, i);
   return (sum);
}

//+------------------------------------------------------------------+
int GetVisibility(string timeframes) {
   //+------------------------------------------------------------------+
   // Given a string of timeframes (e.g. "M1,M5,M15"), it returns visibility value,
   //   suitable for use in ObjectSet(object_name,OBJPROP_TIMEFRAMES,visibility) 
   //
   // Example: ObjectSet("my object",OBJPROP_TIMEFRAMES,GetVisibility("M1,M5,M15"));
   //   means that "my object" will be plotted only on M1, M5 and M15 charts
   //
   if (timeframes == "") return (0);
   timeframes = StringUpper(timeframes) + ",";
   int i_vis = 0;
   if (StringFind(timeframes, "M1,") >= 0) i_vis += OBJ_PERIOD_M1;
   if (StringFind(timeframes, "M5,") >= 0) i_vis += OBJ_PERIOD_M5;
   if (StringFind(timeframes, "M15,") >= 0) i_vis += OBJ_PERIOD_M15;
   if (StringFind(timeframes, "M30,") >= 0) i_vis += OBJ_PERIOD_M30;
   if (StringFind(timeframes, "H1,") >= 0) i_vis += OBJ_PERIOD_H1;
   if (StringFind(timeframes, "H4,") >= 0) i_vis += OBJ_PERIOD_H4;
   if (StringFind(timeframes, "D1,") >= 0) i_vis += OBJ_PERIOD_D1;
   if (StringFind(timeframes, "W1,") >= 0) i_vis += OBJ_PERIOD_W1;
   if (StringFind(timeframes, "MN,") >= 0) i_vis += OBJ_PERIOD_MN1;
   return (i_vis);
}

//+------------------------------------------------------------------+
string ListGlobals(string mask = "-,12.6", string cr = "") {
   //+------------------------------------------------------------------+
   // Returns a string that contains a list of all Global Variables
   //  Numbers are formatted according to 'mask' (see NumberToStr() function)
   //  (Note: press F3 in MT4 to give list of Globals also)
   //
   // e.g. to output all globals to the file GLOBALS.TXT:
   //    int h = FileOpen("Globals.TXT",FILE_BIN|FILE_WRITE);
   //    string s = ListGlobals();
   //    FileWriteString(h,s,StringLen(s));
   //    FileClose(h);
   // 
   string str = "Global Variable ID                                                                        Value" + cr + "\n";
   str = str + "------------------------------------------------------------------------   --------------------" + cr + "\n";
   for (int i = 0; i < GlobalVariablesTotal(); i++) {
      string GVname = GlobalVariableName(i);
      double GVvalue = GlobalVariableGet(GVname);
      //if (StringLen(str) > 0)    str = str + "\n";
      str = str + StrToStr(GVname, "L72") + NumberToStr(GVvalue, mask);
      if (GVvalue > TimeCurrent() - 10 * 365 * 86400 && GVvalue <= TimeCurrent())
         str = str + DateToStr(GVvalue, "'    'w D n Y  H:I:S");
      str = str + cr + "\n";
   }
   return (str);
}

//+------------------------------------------------------------------+
string ListObjects(string cr = "") {
   //+------------------------------------------------------------------+
   string ObjType[24] = {
      "VLine",
      "HLine",
      "TLine",
      "TBAngle",
      "LRChan",
      "Chan",
      "SDChan",
      "GLine",
      "GFan",
      "GGrid",
      "Fib",
      "FibTime",
      "FibFan",
      "FibArc",
      "FibExp",
      "FibChan",
      "Rectangle",
      "Triangle",
      "Ellipse",
      "Pfork",
      "Cycles",
      "Text",
      "Arrow",
      "Label"
   };
   string str = "    #  Name                            Type       Description                                                   Time-1               Price-1  " +
      "Time-2               Price-2  Color             Style Size Backg  Ray        Arrow    Xpos    Ypos" + cr + "\n";
   str = str + "-----  ------------------------------  ---------  ------------------------------------------------------------  ----------------   ---------  " +
      "----------------   ---------  ----------------  ----- ---- -----  -----      -----    ----    ----" + cr + "\n";
   for (int i = 0; i < ObjectsTotal(); i++) {
      string name = ObjectName(i);
      int type = ObjectType(name);
      str = str + NumberToStr(i, "5'  '") +
         StrToStr(name, "L30'  '") +
         StrToStr(ObjType[type], "L11") +
         StrToStr(ObjectDescription(name), "L60'  '") +
         DateToStr(ObjectGet(name, OBJPROP_TIME1), "BY.M.D H:I'  '") +
         NumberToStr(ObjectGet(name, OBJPROP_PRICE1), "BR-3.5'  '") +
         DateToStr(ObjectGet(name, OBJPROP_TIME2), "BY.M.D H:I'  '") +
         NumberToStr(ObjectGet(name, OBJPROP_PRICE2), "BR-3.5'  '") +
         StrToStr(ColorToStr(ObjectGet(name, OBJPROP_COLOR)), "L20' '") +
         NumberToStr(ObjectGet(name, OBJPROP_STYLE), "2'  '") +
         NumberToStr(ObjectGet(name, OBJPROP_WIDTH), "2'  '") +
         StrToStr(BoolToStr(ObjectGet(name, OBJPROP_BACK)), "L5'  '") +
         StrToStr(BoolToStr(ObjectGet(name, OBJPROP_RAY)), "L5'  '") +
         NumberToStr(ObjectGet(name, OBJPROP_ARROWCODE), "B6'  '") +
         NumberToStr(ObjectGet(name, OBJPROP_CORNER), "1'  '") +
         NumberToStr(ObjectGet(name, OBJPROP_XDISTANCE), "B6'  '") +
         NumberToStr(ObjectGet(name, OBJPROP_YDISTANCE), "B6") +
         cr + "\n";
   }
   return (str);
}

//+------------------------------------------------------------------+
string ListOrders(string types = "POCDNU", string cr = "") {
   //+------------------------------------------------------------------+
   // Returns a string that contains a lists of all orders of given type(s):
   //  P=pending, O=open, C=closed, D=deleted, N=non-existent ticket, U=unknown
   //
   // e.g. to output all pending and open orders to the file ORDERS.TXT:
   //    int h = FileOpen("ORDERS.TXT",FILE_BIN|FILE_WRITE);
   //    string s = ListOrders("PO");
   //    FileWriteString(h,s,StringLen(s));
   //    FileClose(h);
   // 
   /*   Output format         From  Thru  Length  MQL4 from
        -------------         ----  ----  ------  ---------
        Pool (T/H)               1     1     1        0
        Order#                   3    12    10        2
        Status                  15    15     1       14
        Type                    18    27    10       17
        Pair symbol             32    41    10       31
        Volume (lot size)       42    49     8       41
        Open Time               53    73    21       52
        Open Price              75    84    10       74
        SL                      87    96    10       86
        TP                      98   107    10       97
        Close/expiry Time      111   131    21      110
        Close Price            133   142    10      132
        Commission             147   157    11      146
        Swap                   160   170    11      159
        Profit/Loss            172   186    15      171
        Comment                188   219    32      187
        Magic Number           222   233    12      221
   */
   types = StringUpper(types);
   string type[6] = {
      "buy",
      "sell",
      "buy limit",
      "sell limit",
      "buy stop",
      "sell stop"
   };
   string str = "Pool  Order#  St Type          Symbol        Size  [Open Time                  Price]        S/L        T/P  [Close/Expire Time          Price]" +
      "   Commission         Swap          Profit  Comment                                 Magic#" + cr + "\n";
   str = str + "----  ------  -- ----------    ------      ------  ----------------------    --------    -------    -------  ----------------------    --------" +
      "   ----------   ----------    ------------  --------------------------------  ------------" + cr + "\n";
   int total = OrdersTotal();
   for (int i = total - 1; i >= 0; i--) {
      bool b_os = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (StringFind(types, OrderStatus(OrderTicket())) < 0) continue;
      string info = "T " + StrToStr(NumberToStr(OrderTicket(), "10'  '") + OrderStatus(OrderTicket()) + "  " + StrToStr(type[OrderType()], "L14") + OrderSymbol(), "L36") +
         NumberToStr(OrderLots(), ",6.2") + DateToStr(OrderOpenTime(), "  [w D n Y H:I") + NumberToStr(OrderOpenPrice(), "5.5']'") +
         NumberToStr(OrderStopLoss(), "5.5") + NumberToStr(OrderTakeProfit(), "5.5") +
         DateToStr(OrderExpiration(), "'  ['Bw D n Y H:I") + NumberToStr(OrderClosePrice(), "5.5']'") + NumberToStr(OrderCommission(), ",-7.2") +
         NumberToStr(OrderSwap(), ",-7.2") + NumberToStr(OrderProfit(), ",-9.2'  '") + StrToStr(OrderComment(), "L32") + NumberToStr(OrderMagicNumber(), ",11");
      str = str + info + cr + "\n";
   }

   total = OrdersHistoryTotal();
   for (i = total - 1; i >= 0; i--) {
      b_os = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
      if (StringFind(types, OrderStatus(OrderTicket())) < 0) continue;
      info = "H " + StrToStr(NumberToStr(OrderTicket(), "10'  '") + OrderStatus(OrderTicket()) + "  " + StrToStr(type[OrderType()], "L14") + OrderSymbol(), "L36") +
         NumberToStr(OrderLots(), ",6.2") + DateToStr(OrderOpenTime(), "  [w D n Y H:I") + NumberToStr(OrderOpenPrice(), "5.5']'") +
         NumberToStr(OrderStopLoss(), "5.5") + NumberToStr(OrderTakeProfit(), "5.5") +
         DateToStr(OrderCloseTime(), "'  ['Bw D n Y H:I") + NumberToStr(OrderClosePrice(), "5.5']'") + NumberToStr(OrderCommission(), ",-7.2") +
         NumberToStr(OrderSwap(), ",-7.2") + NumberToStr(OrderProfit(), ",-9.2'  '") + StrToStr(OrderComment(), "L32") + NumberToStr(OrderMagicNumber(), ",11");
      str = str + info + cr + "\n";
   }
   return (str);
}

//+------------------------------------------------------------------+
string OrderStatus(int tkt) {
   //+------------------------------------------------------------------+
   // Given a ticket number, returns the status of an order:
   //  P=pending, O=open, C=closed, D=deleted, N=non-existent ticket, U=unknown
   bool exist = OrderSelect(tkt, SELECT_BY_TICKET);
   if (!exist)
      return ("N"); // ticket not found
   if (OrderCloseTime() == 0) {
      if (OrderType() == OP_BUY || OrderType() == OP_SELL)
         return ("O"); // open
      else
         return ("P"); // pending
   } else {
      if (OrderType() == OP_BUY || OrderType() == OP_SELL)
         return ("C"); // closed (for profit or loss)
      else
         return ("D"); // cancelled (deleted)
   }
   return ("U"); // unknown
}

//+------------------------------------------------------------------+
void log(string s1, string s2 = "", string s3 = "", string s4 = "", string s5 = "", string s6 = "", string s7 = "", string s8 = "",
   string s9 = "", string s10 = "", string s11 = "", string s12 = "", string s13 = "", string s14 = "", string s15 = "") {
   //+------------------------------------------------------------------+
   // Outputs up to 15 values to Microsoft DebugView app (debugging alternative for MQL4)
   // see http://www.forexfactory.com/showthread.php?t=245303 thread for more info
   string out = StringTrimRight(StringConcatenate(WindowExpertName(), ".mq4 ", Symbol(), " ", s1, " ", s2, " ", s3, " ", s4, " ", s5,
      " ", s6, " ", s7, " ", s8, " ", s9, " ", s10, " ", s11, " ", s12, " ", s13, " ", s14, " ", s15));
   //   OutputDebugStringA(out);
}

//+------------------------------------------------------------------+
int BarConvert(int bar, string FromTF, string ToTF, string s_ccy = "") {
   //+------------------------------------------------------------------+
   // Usage: returns bar# on ToTF that matches same time of bar# on FromTF
   // e.g. bar = BarConvert(40,"M15","H4",Symbol());
   //   will find the bar# on H4 chart whose time matches bar# 40 on M15 chart
   s_ccy = ExpandCcy(s_ccy);
   return (iBarShift(s_ccy, StrToTF(ToTF), iTime(s_ccy, StrToTF(FromTF), bar)));
}

//+------------------------------------------------------------------+
int StrToColor(string str)
//+------------------------------------------------------------------+
// Returns the numeric value for an MQL4 color descriptor string
// Usage:   int x = StrToColor("Aqua")      returns x = 16776960
//
// or:      int x = StrToColor("0,255,255") returns x = 16776960
// i.e.             StrToColor("<red>,<green>,<blue>")
//
// or:      int x = StrToColor("0xFFFF00")  returns x = 16776960
// i.e.             StrToColor("0xbbggrr")
//
// or:      int x = StrToColor("r0g255b255")  returns x = 16776960
// i.e.             StrToColor("r<nnn>g<nnn>b<nnn>")
//
// or:      int x = StrToColor("16776960")    returns x = 16776960
// i.e.             StrToColor("numbervalue")
{
   str = StringLower(stringReplaceOld(str, " ", ""));
   if (str == "") return (CLR_NONE);
   if (str == "aliceblue") return (0xFFF8F0);
   if (str == "antiquewhite") return (0xD7EBFA);
   if (str == "aqua") return (0xFFFF00);
   if (str == "aquamarine") return (0xD4FF7F);
   if (str == "beige") return (0xDCF5F5);
   if (str == "bisque") return (0xC4E4FF);
   if (str == "black") return (0x000000);
   if (str == "blanchedalmond") return (0xCDEBFF);
   if (str == "blue") return (0xFF0000);
   if (str == "blueviolet") return (0xE22B8A);
   if (str == "brown") return (0x2A2AA5);
   if (str == "burlywood") return (0x87B8DE);
   if (str == "cadetblue") return (0xA09E5F);
   if (str == "chartreuse") return (0x00FF7F);
   if (str == "chocolate") return (0x1E69D2);
   if (str == "coral") return (0x507FFF);
   if (str == "cornflowerblue") return (0xED9564);
   if (str == "cornsilk") return (0xDCF8FF);
   if (str == "crimson") return (0x3C14DC);
   if (str == "darkblue") return (0x8B0000);
   if (str == "darkgoldenrod") return (0x0B86B8);
   if (str == "darkgray") return (0xA9A9A9);
   if (str == "darkgreen") return (0x006400);
   if (str == "darkkhaki") return (0x6BB7BD);
   if (str == "darkolivegreen") return (0x2F6B55);
   if (str == "darkorange") return (0x008CFF);
   if (str == "darkorchid") return (0xCC3299);
   if (str == "darksalmon") return (0x7A96E9);
   if (str == "darkseagreen") return (0x8BBC8F);
   if (str == "darkslateblue") return (0x8B3D48);
   if (str == "darkslategray") return (0x4F4F2F);
   if (str == "darkturquoise") return (0xD1CE00);
   if (str == "darkviolet") return (0xD30094);
   if (str == "deeppink") return (0x9314FF);
   if (str == "deepskyblue") return (0xFFBF00);
   if (str == "dimgray") return (0x696969);
   if (str == "dodgerblue") return (0xFF901E);
   if (str == "firebrick") return (0x2222B2);
   if (str == "forestgreen") return (0x228B22);
   if (str == "gainsboro") return (0xDCDCDC);
   if (str == "gold") return (0x00D7FF);
   if (str == "goldenrod") return (0x20A5DA);
   if (str == "gray") return (0x808080);
   if (str == "green") return (0x008000);
   if (str == "greenyellow") return (0x2FFFAD);
   if (str == "honeydew") return (0xF0FFF0);
   if (str == "hotpink") return (0xB469FF);
   if (str == "indianred") return (0x5C5CCD);
   if (str == "indigo") return (0x82004B);
   if (str == "ivory") return (0xF0FFFF);
   if (str == "khaki") return (0x8CE6F0);
   if (str == "lavender") return (0xFAE6E6);
   if (str == "lavenderblush") return (0xF5F0FF);
   if (str == "lawngreen") return (0x00FC7C);
   if (str == "lemonchiffon") return (0xCDFAFF);
   if (str == "lightblue") return (0xE6D8AD);
   if (str == "lightcoral") return (0x8080F0);
   if (str == "lightcyan") return (0xFFFFE0);
   if (str == "lightgoldenrod") return (0xD2FAFA);
   if (str == "lightgray") return (0xD3D3D3);
   if (str == "lightgreen") return (0x90EE90);
   if (str == "lightpink") return (0xC1B6FF);
   if (str == "lightsalmon") return (0x7AA0FF);
   if (str == "lightseagreen") return (0xAAB220);
   if (str == "lightskyblue") return (0xFACE87);
   if (str == "lightslategray") return (0x998877);
   if (str == "lightsteelblue") return (0xDEC4B0);
   if (str == "lightyellow") return (0xE0FFFF);
   if (str == "lime") return (0x00FF00);
   if (str == "limegreen") return (0x32CD32);
   if (str == "linen") return (0xE6F0FA);
   if (str == "magenta") return (0xFF00FF);
   if (str == "maroon") return (0x000080);
   if (str == "mediumaquamarine") return (0xAACD66);
   if (str == "mediumblue") return (0xCD0000);
   if (str == "mediumorchid") return (0xD355BA);
   if (str == "mediumpurple") return (0xDB7093);
   if (str == "mediumseagreen") return (0x71B33C);
   if (str == "mediumslateblue") return (0xEE687B);
   if (str == "mediumspringgreen") return (0x9AFA00);
   if (str == "mediumturquoise") return (0xCCD148);
   if (str == "mediumvioletred") return (0x8515C7);
   if (str == "midnightblue") return (0x701919);
   if (str == "mintcream") return (0xFAFFF5);
   if (str == "mistyrose") return (0xE1E4FF);
   if (str == "moccasin") return (0xB5E4FF);
   if (str == "navajowhite") return (0xADDEFF);
   if (str == "navy") return (0x800000);
   if (str == "none") return (CLR_NONE);
   if (str == "oldlace") return (0xE6F5FD);
   if (str == "olive") return (0x008080);
   if (str == "olivedrab") return (0x238E6B);
   if (str == "orange") return (0x00A5FF);
   if (str == "orangered") return (0x0045FF);
   if (str == "orchid") return (0xD670DA);
   if (str == "palegoldenrod") return (0xAAE8EE);
   if (str == "palegreen") return (0x98FB98);
   if (str == "paleturquoise") return (0xEEEEAF);
   if (str == "palevioletred") return (0x9370DB);
   if (str == "papayawhip") return (0xD5EFFF);
   if (str == "peachpuff") return (0xB9DAFF);
   if (str == "peru") return (0x3F85CD);
   if (str == "pink") return (0xCBC0FF);
   if (str == "plum") return (0xDDA0DD);
   if (str == "powderblue") return (0xE6E0B0);
   if (str == "purple") return (0x800080);
   if (str == "red") return (0x0000FF);
   if (str == "rosybrown") return (0x8F8FBC);
   if (str == "royalblue") return (0xE16941);
   if (str == "saddlebrown") return (0x13458B);
   if (str == "salmon") return (0x7280FA);
   if (str == "sandybrown") return (0x60A4F4);
   if (str == "seagreen") return (0x578B2E);
   if (str == "seashell") return (0xEEF5FF);
   if (str == "sienna") return (0x2D52A0);
   if (str == "silver") return (0xC0C0C0);
   if (str == "skyblue") return (0xEBCE87);
   if (str == "slateblue") return (0xCD5A6A);
   if (str == "slategray") return (0x908070);
   if (str == "snow") return (0xFAFAFF);
   if (str == "springgreen") return (0x7FFF00);
   if (str == "steelblue") return (0xB48246);
   if (str == "tan") return (0x8CB4D2);
   if (str == "teal") return (0x808000);
   if (str == "thistle") return (0xD8BFD8);
   if (str == "tomato") return (0x4763FF);
   if (str == "turquoise") return (0xD0E040);
   if (str == "violet") return (0xEE82EE);
   if (str == "wheat") return (0xB3DEF5);
   if (str == "white") return (0xFFFFFF);
   if (str == "whitesmoke") return (0xF5F5F5);
   if (str == "yellow") return (0x00FFFF);
   if (str == "yellowgreen") return (0x32CD9A);

   int t1 = StringFind(str, ",", 0);
   int t2 = StringFind(str, ",", t1 + 1);
   if (t1 > 0 && t2 > 0) {
      int red = StrToInteger(stringSubstrOld(str, 0, t1));
      int green = StrToInteger(stringSubstrOld(str, t1 + 1, t2 - 1));
      int blue = StrToInteger(stringSubstrOld(str, t2 + 1, StringLen(str)));
      return (blue * 256 * 256 + green * 256 + red);
   }

   if (stringSubstrOld(str, 0, 2) == "0x") {
      string cnvstr = "0123456789abcdef";
      string seq = "234567";
      int retval = 0;
      for (int i = 0; i < 6; i++) {
         int pos = StrToInteger(stringSubstrOld(seq, i, 1));
         int val = StringFind(cnvstr, stringSubstrOld(str, pos, 1), 0);
         if (val < 0) return (val);
         retval = retval * 16 + val;
      }
      return (retval);
   }

   string cclr = "", tmp = "";
   red = 0;
   blue = 0;
   green = 0;
   if (StringFind("rgb", stringSubstrOld(str, 0, 1)) >= 0) {
      for (i = 0; i < StringLen(str); i++) {
         tmp = stringSubstrOld(str, i, 1);
         if (StringFind("rgb", tmp, 0) >= 0)
            cclr = tmp;
         else {
            if (cclr == "b") blue = blue * 10 + StrToInteger(tmp);
            if (cclr == "g") green = green * 10 + StrToInteger(tmp);
            if (cclr == "r") red = red * 10 + StrToInteger(tmp);
         }
      }
      return (blue * 256 * 256 + green * 256 + red);
   }

   return (StrToNumber(str));
}

//+------------------------------------------------------------------+
string ColorToStr(color colr) {
   //+------------------------------------------------------------------+
   // converts a MT4 color value to its string token, e.g. "DimGray","Red","Lime" or "b60g0r100"
   if (colr == 0xFFF8F0) return ("AliceBlue");
   if (colr == 0xD7EBFA) return ("AntiqueWhite");
   if (colr == 0xFFFF00) return ("Aqua");
   if (colr == 0xD4FF7F) return ("Aquamarine");
   if (colr == 0xDCF5F5) return ("Beige");
   if (colr == 0xC4E4FF) return ("Bisque");
   if (colr == 0x000000) return ("Black");
   if (colr == 0xCDEBFF) return ("BlanchedAlmond");
   if (colr == 0xFF0000) return ("Blue");
   if (colr == 0xE22B8A) return ("BlueViolet");
   if (colr == 0x2A2AA5) return ("Brown");
   if (colr == 0x87B8DE) return ("BurlyWood");
   if (colr == 0xA09E5F) return ("CadetBlue");
   if (colr == 0x00FF7F) return ("Chartreuse");
   if (colr == 0x1E69D2) return ("Chocolate");
   if (colr == 0x507FFF) return ("Coral");
   if (colr == 0xED9564) return ("CornflowerBlue");
   if (colr == 0xDCF8FF) return ("Cornsilk");
   if (colr == 0x3C14DC) return ("Crimson");
   if (colr == 0x8B0000) return ("DarkBlue");
   if (colr == 0x0B86B8) return ("DarkGoldenrod");
   if (colr == 0xA9A9A9) return ("DarkGray");
   if (colr == 0x006400) return ("DarkGreen");
   if (colr == 0x6BB7BD) return ("DarkKhaki");
   if (colr == 0x2F6B55) return ("DarkOliveGreen");
   if (colr == 0x008CFF) return ("DarkOrange");
   if (colr == 0xCC3299) return ("DarkOrchid");
   if (colr == 0x7A96E9) return ("DarkSalmon");
   if (colr == 0x8BBC8F) return ("DarkSeaGreen");
   if (colr == 0x8B3D48) return ("DarkSlateBlue");
   if (colr == 0x4F4F2F) return ("DarkSlateGray");
   if (colr == 0xD1CE00) return ("DarkTurquoise");
   if (colr == 0xD30094) return ("DarkViolet");
   if (colr == 0x9314FF) return ("DeepPink");
   if (colr == 0xFFBF00) return ("DeepSkyBlue");
   if (colr == 0x696969) return ("DimGray");
   if (colr == 0xFF901E) return ("DodgerBlue");
   if (colr == 0x2222B2) return ("FireBrick");
   if (colr == 0x228B22) return ("ForestGreen");
   if (colr == 0xDCDCDC) return ("Gainsboro");
   if (colr == 0x00D7FF) return ("Gold");
   if (colr == 0x20A5DA) return ("Goldenrod");
   if (colr == 0x808080) return ("Gray");
   if (colr == 0x008000) return ("Green");
   if (colr == 0x2FFFAD) return ("GreenYellow");
   if (colr == 0xF0FFF0) return ("Honeydew");
   if (colr == 0xB469FF) return ("HotPink");
   if (colr == 0x5C5CCD) return ("IndianRed");
   if (colr == 0x82004B) return ("Indigo");
   if (colr == 0xF0FFFF) return ("Ivory");
   if (colr == 0x8CE6F0) return ("Khaki");
   if (colr == 0xFAE6E6) return ("Lavender");
   if (colr == 0xF5F0FF) return ("LavenderBlush");
   if (colr == 0x00FC7C) return ("LawnGreen");
   if (colr == 0xCDFAFF) return ("LemonChiffon");
   if (colr == 0xE6D8AD) return ("LightBlue");
   if (colr == 0x8080F0) return ("LightCoral");
   if (colr == 0xFFFFE0) return ("LightCyan");
   if (colr == 0xD2FAFA) return ("LightGoldenrod");
   if (colr == 0xD3D3D3) return ("LightGray");
   if (colr == 0x90EE90) return ("LightGreen");
   if (colr == 0xC1B6FF) return ("LightPink");
   if (colr == 0x7AA0FF) return ("LightSalmon");
   if (colr == 0xAAB220) return ("LightSeaGreen");
   if (colr == 0xFACE87) return ("LightSkyBlue");
   if (colr == 0x998877) return ("LightSlateGray");
   if (colr == 0xDEC4B0) return ("LightSteelBlue");
   if (colr == 0xE0FFFF) return ("LightYellow");
   if (colr == 0x00FF00) return ("Lime");
   if (colr == 0x32CD32) return ("LimeGreen");
   if (colr == 0xE6F0FA) return ("Linen");
   if (colr == 0xFF00FF) return ("Magenta");
   if (colr == 0x000080) return ("Maroon");
   if (colr == 0xAACD66) return ("MediumAquamarine");
   if (colr == 0xCD0000) return ("MediumBlue");
   if (colr == 0xD355BA) return ("MediumOrchid");
   if (colr == 0xDB7093) return ("MediumPurple");
   if (colr == 0x71B33C) return ("MediumSeaGreen");
   if (colr == 0xEE687B) return ("MediumSlateBlue");
   if (colr == 0x9AFA00) return ("MediumSpringGreen");
   if (colr == 0xCCD148) return ("MediumTurquoise");
   if (colr == 0x8515C7) return ("MediumVioletRed");
   if (colr == 0x701919) return ("MidnightBlue");
   if (colr == 0xFAFFF5) return ("MintCream");
   if (colr == 0xE1E4FF) return ("MistyRose");
   if (colr == 0xB5E4FF) return ("Moccasin");
   if (colr == 0xADDEFF) return ("NavajoWhite");
   if (colr == 0x800000) return ("Navy");
   if (colr == 0xE6F5FD) return ("OldLace");
   if (colr == 0x008080) return ("Olive");
   if (colr == 0x238E6B) return ("OliveDrab");
   if (colr == 0x00A5FF) return ("Orange");
   if (colr == 0x0045FF) return ("OrangeRed");
   if (colr == 0xD670DA) return ("Orchid");
   if (colr == 0xAAE8EE) return ("PaleGoldenrod");
   if (colr == 0x98FB98) return ("PaleGreen");
   if (colr == 0xEEEEAF) return ("PaleTurquoise");
   if (colr == 0x9370DB) return ("PaleVioletRed");
   if (colr == 0xD5EFFF) return ("PapayaWhip");
   if (colr == 0xB9DAFF) return ("PeachPuff");
   if (colr == 0x3F85CD) return ("Peru");
   if (colr == 0xCBC0FF) return ("Pink");
   if (colr == 0xDDA0DD) return ("Plum");
   if (colr == 0xE6E0B0) return ("PowderBlue");
   if (colr == 0x800080) return ("Purple");
   if (colr == 0x0000FF) return ("Red");
   if (colr == 0x8F8FBC) return ("RosyBrown");
   if (colr == 0xE16941) return ("RoyalBlue");
   if (colr == 0x13458B) return ("SaddleBrown");
   if (colr == 0x7280FA) return ("Salmon");
   if (colr == 0x60A4F4) return ("SandyBrown");
   if (colr == 0x578B2E) return ("SeaGreen");
   if (colr == 0xEEF5FF) return ("Seashell");
   if (colr == 0x2D52A0) return ("Sienna");
   if (colr == 0xC0C0C0) return ("Silver");
   if (colr == 0xEBCE87) return ("SkyBlue");
   if (colr == 0xCD5A6A) return ("SlateBlue");
   if (colr == 0x908070) return ("SlateGray");
   if (colr == 0xFAFAFF) return ("Snow");
   if (colr == 0x7FFF00) return ("SpringGreen");
   if (colr == 0xB48246) return ("SteelBlue");
   if (colr == 0x8CB4D2) return ("Tan");
   if (colr == 0x808000) return ("Teal");
   if (colr == 0xD8BFD8) return ("Thistle");
   if (colr == 0x4763FF) return ("Tomato");
   if (colr == 0xD0E040) return ("Turquoise");
   if (colr == 0xEE82EE) return ("Violet");
   if (colr == 0xB3DEF5) return ("Wheat");
   if (colr == 0xFFFFFF) return ("White");
   if (colr == 0xF5F5F5) return ("WhiteSmoke");
   if (colr == 0x00FFFF) return ("Yellow");
   if (colr == 0x32CD9A) return ("YellowGreen");
   if (colr == CLR_NONE) return ("None");
   int blue = MathInt(colr / 65536);
   int green = MathInt((colr - blue * 65536) / 256);
   int red = MathMod(colr, 256);
   return ("b" + NumberToStr(blue, "T3") + "g" + NumberToStr(green, "T3") + "r" + NumberToStr(red, "T3"));
}

//+------------------------------------------------------------------+
int StrToChar(string str) {
   //+------------------------------------------------------------------+
   // Returns the (decimal) ASCII value from a 1 byte string
   // Example: StrToChar("A") returns 65
   for (int i = 0; i < 256; i++)
      if (CharToStr(i) == stringSubstrOld(str, 0, 1)) return (i);
   return (0);
}

//+------------------------------------------------------------------+
bool StrToBool(string str) {
   //+------------------------------------------------------------------+
   // Returns boolean value from a string:
   // If the string starts with t, T, y, Y or 1, true is returned
   // Otherwise (assuming the string starts with f, F, n, N or 0, false is returned
   str = StringLower(stringSubstrOld(str, 0, 1));
   if (str == "t" || str == "y" || str == "1") return (true);
   return (false);
}

//+------------------------------------------------------------------+
string BoolToStr(bool bval) {
   //+------------------------------------------------------------------+
   // Converts the boolean value true or false to the string "true" or "false" 
   if (bval) return ("true");
   return ("false");
}

//+------------------------------------------------------------------+
int StrToTF(string str = "") {
   //+------------------------------------------------------------------+
   // Converts a timeframe string to its MT4-numeric value
   // Usage:   int x=StrToTF("M15")   returns x=15
   //   or:  +1,+2,+3, etc return next higher TFs; 
   //        -1,-2,-3, etc return next lower TFs;
   //        +0            returns current TF (i.e. Period())
   // Note:    
   //  StrToTF(NULL)  StrToTF(0)    StrToTF("0")  StrToTF("T")                 ---  all return 0
   //  StrToTF("")    StrToTF(" ")  StrToTF()     StrToTF(0.0)  StrToTF("+0")  ---  all return Period()

   str = StringUpper(StringTrim(str));
   int num = StrToNumber(str);
   string tfarr[9] = {
      "M1",
      "M5",
      "M15",
      "M30",
      "H1",
      "H4",
      "D1",
      "W1",
      "MN"
   };
   if (stringSubstrOld(str, 0, 1) == "+" || stringSubstrOld(str, 0, 1) == "-") {
      int per = LookupStringArray(TFToStr(Period()), tfarr);
      if (per < 0) return (-1);
      if (per + num < 0 || per + num > 8) return (-1);
      str = tfarr[per + num];
   }
   if (str == "MN" || str == "MN1" || num >= 43200) return (43200);
   if (str == "W1" || num >= 10080) return (10080);
   if (str == "D1" || num >= 1440) return (1440);
   if (str == "H4" || num >= 240) return (240);
   if (str == "H1" || num >= 60) return (60);
   if (str == "M30" || num >= 30) return (30);
   if (str == "M15" || num >= 15) return (15);
   if (str == "M5" || num >= 5) return (5);
   if (str == "M1" || num >= 1) return (1);
   if (str == "I" || num < 0) return (-1);
   if (str == "T" || str == "0") return (0);
   if (str == "" || num == 0) return (Period());
   return (-1);
}

//+------------------------------------------------------------------+
string TFToStr(int i_tf = 0) {
   //+------------------------------------------------------------------+
   // Converts a MT4-numeric timeframe to its descriptor string
   // Usage:   string s=TFToStr(15) returns s="M15"

   if (i_tf == 0) i_tf = Period();
   if (i_tf >= 43200) return ("MN");
   if (i_tf >= 10080) return ("W1");
   if (i_tf >= 1440) return ("D1");
   if (i_tf >= 240) return ("H4");
   if (i_tf >= 60) return ("H1");
   if (i_tf >= 30) return ("M30");
   if (i_tf >= 15) return ("M15");
   if (i_tf >= 5) return ("M5");
   if (i_tf >= 1) return ("M1");
   return ("");
}

//+------------------------------------------------------------------+
string err_msg(int e)
//+------------------------------------------------------------------+
// Returns error message text for a given MQL4 error number
// Usage:   string s=err_msg(146) returns s="Error 0146:  Trade context is busy."
{
   switch (e) {
   case 0:
      return ("Error 0000:  No error returned.");
   case 1:
      return ("Error 0001:  No error returned, but the result is unknown.");
   case 2:
      return ("Error 0002:  Common error.");
   case 3:
      return ("Error 0003:  Invalid trade parameters.");
   case 4:
      return ("Error 0004:  Trade server is busy.");
   case 5:
      return ("Error 0005:  Old version of the client terminal.");
   case 6:
      return ("Error 0006:  No connection with trade server.");
   case 7:
      return ("Error 0007:  Not enough rights.");
   case 8:
      return ("Error 0008:  Too frequent requests.");
   case 9:
      return ("Error 0009:  Malfunctional trade operation.");
   case 64:
      return ("Error 0064:  Account disabled.");
   case 65:
      return ("Error 0065:  Invalid account.");
   case 128:
      return ("Error 0128:  Trade timeout.");
   case 129:
      return ("Error 0129:  Invalid price.");
   case 130:
      return ("Error 0130:  Invalid stops.");
   case 131:
      return ("Error 0131:  Invalid trade volume.");
   case 132:
      return ("Error 0132:  Market is closed.");
   case 133:
      return ("Error 0133:  Trade is disabled.");
   case 134:
      return ("Error 0134:  Not enough money.");
   case 135:
      return ("Error 0135:  Price changed.");
   case 136:
      return ("Error 0136:  Off quotes.");
   case 137:
      return ("Error 0137:  Broker is busy.");
   case 138:
      return ("Error 0138:  Requote.");
   case 139:
      return ("Error 0139:  Order is locked.");
   case 140:
      return ("Error 0140:  Long positions only allowed.");
   case 141:
      return ("Error 0141:  Too many requests.");
   case 145:
      return ("Error 0145:  Modification denied because order too close to market.");
   case 146:
      return ("Error 0146:  Trade context is busy.");
   case 147:
      return ("Error 0147:  Expirations are denied by broker.");
   case 148:
      return ("Error 0148:  The amount of open and pending orders has reached the limit set by the broker.");
   case 149:
      return ("Error 0149:  An attempt to open a position opposite to the existing one when hedging is disabled.");
   case 150:
      return ("Error 0150:  An attempt to close a position contravening the FIFO rule.");
   case 4000:
      return ("Error 4000:  No error.");
   case 4001:
      return ("Error 4001:  Wrong function pointer.");
   case 4002:
      return ("Error 4002:  Array index is out of range.");
   case 4003:
      return ("Error 4003:  No memory for function call stack.");
   case 4004:
      return ("Error 4004:  Recursive stack overflow.");
   case 4005:
      return ("Error 4005:  Not enough stack for parameter.");
   case 4006:
      return ("Error 4006:  No memory for parameter string.");
   case 4007:
      return ("Error 4007:  No memory for temp string.");
   case 4008:
      return ("Error 4008:  Not initialized string.");
   case 4009:
      return ("Error 4009:  Not initialized string in array.");
   case 4010:
      return ("Error 4010:  No memory for array string.");
   case 4011:
      return ("Error 4011:  Too long string.");
   case 4012:
      return ("Error 4012:  Remainder from zero divide.");
   case 4013:
      return ("Error 4013:  Zero divide.");
   case 4014:
      return ("Error 4014:  Unknown command.");
   case 4015:
      return ("Error 4015:  Wrong jump (never generated error).");
   case 4016:
      return ("Error 4016:  Not initialized array.");
   case 4017:
      return ("Error 4017:  DLL calls are not allowed.");
   case 4018:
      return ("Error 4018:  Cannot load library.");
   case 4019:
      return ("Error 4019:  Cannot call function.");
   case 4020:
      return ("Error 4020:  Expert function calls are not allowed.");
   case 4021:
      return ("Error 4021:  Not enough memory for temp string returned from function.");
   case 4022:
      return ("Error 4022:  System is busy (never generated error).");
   case 4050:
      return ("Error 4050:  Invalid function parameters count.");
   case 4051:
      return ("Error 4051:  Invalid function parameter value.");
   case 4052:
      return ("Error 4052:  String function internal error.");
   case 4053:
      return ("Error 4053:  Some array error.");
   case 4054:
      return ("Error 4054:  Incorrect series array using.");
   case 4055:
      return ("Error 4055:  Custom indicator error.");
   case 4056:
      return ("Error 4056:  Arrays are incompatible.");
   case 4057:
      return ("Error 4057:  Global variables processing error.");
   case 4058:
      return ("Error 4058:  Global variable not found.");
   case 4059:
      return ("Error 4059:  Function is not allowed in testing mode.");
   case 4060:
      return ("Error 4060:  Function is not confirmed.");
   case 4061:
      return ("Error 4061:  Send mail error.");
   case 4062:
      return ("Error 4062:  String parameter expected.");
   case 4063:
      return ("Error 4063:  Integer parameter expected.");
   case 4064:
      return ("Error 4064:  Double parameter expected.");
   case 4065:
      return ("Error 4065:  Array as parameter expected.");
   case 4066:
      return ("Error 4066:  Requested history data in updating state.");
   case 4067:
      return ("Error 4067:  Some error in trading function.");
   case 4099:
      return ("Error 4099:  End of file.");
   case 4100:
      return ("Error 4100:  Some file error.");
   case 4101:
      return ("Error 4101:  Wrong file name.");
   case 4102:
      return ("Error 4102:  Too many opened files.");
   case 4103:
      return ("Error 4103:  Cannot open file.");
   case 4104:
      return ("Error 4104:  Incompatible access to a file.");
   case 4105:
      return ("Error 4105:  No order selected.");
   case 4106:
      return ("Error 4106:  Unknown symbol.");
   case 4107:
      return ("Error 4107:  Invalid price.");
   case 4108:
      return ("Error 4108:  Invalid ticket.");
   case 4109:
      return ("Error 4109:  Trade is not allowed. Enable checkbox 'Allow live trading' in the expert properties.");
   case 4110:
      return ("Error 4110:  Longs are not allowed. Check the expert properties.");
   case 4111:
      return ("Error 4111:  Shorts are not allowed. Check the expert properties.");
   case 4200:
      return ("Error 4200:  Object exists already.");
   case 4201:
      return ("Error 4201:  Unknown object property.");
   case 4202:
      return ("Error 4202:  Object does not exist.");
   case 4203:
      return ("Error 4203:  Unknown object type.");
   case 4204:
      return ("Error 4204:  No object name.");
   case 4205:
      return ("Error 4205:  Object coordinates error.");
   case 4206:
      return ("Error 4206:  No specified subwindow.");
   case 4207:
      return ("Error 4207:  Some error in object function.");
   case 4250:
      return ("Error 4250:  Error setting notification into the queue for sending.");
   case 4251:
      return ("Error 4251:  Invalid parameter - empty string passed into the SendNotification() function.");
   case 4252:
      return ("Error 4252:  Invalid settings for sending notifications (the ID is not specified or notifications are not enabled).");
   case 4253:
      return ("Error 4253:  Too frequent notification sending.");
      //    case 9001:  return("Error 9001:  Cannot close entire order - insufficient volume previously open.");
      //    case 9002:  return("Error 9002:  Incorrect net position.");
      //    case 9003:  return("Error 9003:  Orders not completed correctly - details in log file.");
   default:
      return ("Error " + e + ": ??? Unknown error.");
   }
   return ("0");
}

//+------------------------------------------------------------------+
string StringTranslate(string str, string str1, string str2, string delim = ",") {
   //+------------------------------------------------------------------+
   // str is the string to be translated
   // str1 is a list of strings (dictionary) that will be replaced by 
   // the corresponding string in str2
   // delim is the delimiter between strings in the str1 and str2 lists

   // Example: StringTranslate("0123456789", "12;4;89", "X;YZ;000", ";")
   // will result in "0X3YZ567000", i.e. 
   //   every occurrence of "12" is replaced with "X"
   //   every occurrence of "4"  is replaced with "YZ"
   //   every occurrence of "89" is replaced with "000"

   string outstr = "";
   string arr1[], arr2[];
   int i = 1 + StringFindCount(str1, delim);
   ArrayResize(arr1, i);
   ArrayResize(arr2, i);
   for (i = 0; i < ArraySize(arr1); i++) {
      arr1[i] = "";
      arr2[i] = "";
   }
   StrToStringArray(str1, arr1, delim);
   StrToStringArray(str2, arr2, delim);
   i = 0;
   while (i < StringLen(str)) {
      bool f = false;
      for (int j = 0; j < ArraySize(arr1); j++) {
         if (arr1[j] == "") break;
         if (stringSubstrOld(str, i, StringLen(arr1[j])) == arr1[j]) {
            f = true;
            outstr = outstr + arr2[j];
            i += StringLen(arr1[j]);
            break;
         }
      }
      if (!f) {
         outstr = outstr + stringSubstrOld(str, i, 1);
         i++;
      }
   }
   return (outstr);
}

//+------------------------------------------------------------------+
string StringOverwrite(string str1, int pos, string str2) {
   //+------------------------------------------------------------------+
   // Returns a result where characters in str1, starting at pos, are replaced 
   // by those in str2; the number of chars replaced = the length of str2, e.g.
   // StringOverwrite("0123456789",5,"XY") returns "01234XY789"
   // In other words, "XY" is 'poked' into character positions 5-6 of "0123456789"
   string outstr = "";
   for (int i = 0; i < StringLen(str1); i++) {
      if (i < pos) outstr = outstr + stringSubstrOld(str1, i, 1);
      else
      if (i < pos + StringLen(str2)) outstr = outstr + stringSubstrOld(str2, i - pos, 1);
      else
         outstr = outstr + stringSubstrOld(str1, i, 1);
   }
   return (outstr);
}

//+------------------------------------------------------------------+
string StringInsert(string str1, int pos, string str2) {
   //+------------------------------------------------------------------+
   // Creates a result where str2 is inserted into str1, at pos in str1, e.g.
   // StringInsert("0123456789",5,"XY") returns "01234XY56789"

   string outstr = stringSubstrOld(str1, 0, pos) + str2 + stringSubstrOld(str1, pos);
   return (outstr);
}

//+------------------------------------------------------------------+
string StringLeft(string str, int n = 1)
//+------------------------------------------------------------------+
// Returns the leftmost N characters of STR, if N is positive
// Usage:    string x=StringLeft("ABCDEFG",2)  returns x = "AB"
//
// Returns all but the rightmost N characters of STR, if N is negative
// Usage:    string x=StringLeft("ABCDEFG",-2)  returns x = "ABCDE"
{
   if (n > 0) return (stringSubstrOld(str, 0, n));
   if (n < 0) return (stringSubstrOld(str, 0, StringLen(str) + n));
   return ("");
}

//+------------------------------------------------------------------+
string StringRight(string str, int n = 1)
//+------------------------------------------------------------------+
// Returns the rightmost N characters of STR, if N is positive
// Usage:    string x=StringRight("ABCDEFG",2)  returns x = "FG"
//
// Returns all but the leftmost N characters of STR, if N is negative
// Usage:    string x=StringRight("ABCDEFG",-2)  returns x = "CDEFG"
{
   if (n > 0) return (stringSubstrOld(str, StringLen(str) - n, n));
   if (n < 0) return (stringSubstrOld(str, -n, StringLen(str) - n));
   return ("");
}

//+------------------------------------------------------------------+
string StringLeftPad(string str, int n = 1, string str2 = " ")
//+------------------------------------------------------------------+
// Prepends occurrences of the string STR2 to the string STR to make a string N characters long
// Usage:    string x=StringLeftPad("ABCDEFG",9," ")  returns x = "  ABCDEFG"
{
   return (StringRepeat(str2, n - StringLen(str)) + str);
}

//+------------------------------------------------------------------+
string StringRightPad(string str, int n = 1, string str2 = " ")
//+------------------------------------------------------------------+
// Appends occurrences of the string STR2 to the string STR to make a string N characters long
// Usage:    string x=StringRightPad("ABCDEFG",9," ")  returns x = "ABCDEFG  "
{
   return (str + StringRepeat(str2, n - StringLen(str)));
}

//+------------------------------------------------------------------+
string StringReverse(string str)
//+------------------------------------------------------------------+
// Reverses the content of a string, e.g. "ABCDE" becomes "EDCBA"
{
   string outstr = "";
   for (int i = StringLen(str) - 1; i >= 0; i--)
      outstr = outstr + stringSubstrOld(str, i, 1);
   return (outstr);
}

//+------------------------------------------------------------------+
string StringExtract(string str, string str1, string str2) {
   //+------------------------------------------------------------------+
   // Extract all characters from str berween the first occurrence of str1,
   // and the first occurrence of str2 that occurs after str1
   int f1 = StringFind(str, str1);
   if (f1 < 0) return ("");
   int f2 = StringFind(str, str2, f1 + 1);
   if (f2 < 0) f2 = StringLen(str) + 1;
   if (f2 == f1 + 1) return ("");
   return (stringSubstrOld(str, f1 + 1, f2 - f1 - 1));
}

//+------------------------------------------------------------------+
string StringLeftExtract(string str, string str2, int n = 1, int m = 0) {
   //+------------------------------------------------------------------+
   //  extracts all chars to left of the nth occurrence of string str2
   //    in string str, plus the next m characters
   //  If n > 0, occurrences are counted forward from the left in str
   //  If n < 0, occurrences are counted backward from the right in str2
   //  If omitted, n defaults to 1
   //  If omitted, m defaults to 0
   // Example: StringLeftExtract("C:\Program Files\MT4\experts","\\",1) returns "C:"
   // Example: StringLeftExtract("C:\Program Files\MT4\experts","\\",-1) returns "C:\Program Files\MT4"
   if (n > 0) {
      int j = -1;
      for (int i = 1; i <= n; i++) j = StringFind(str, str2, j + 1);
      if (j > 0) return (StringLeft(str, j + m));
   }
   if (n < 0) {
      int c = 0;
      j = 0;
      for (i = StringLen(str) - 1; i >= 0; i--) {
         if (stringSubstrOld(str, i, StringLen(str2)) == str2) {
            c++;
            if (c == -n) {
               j = i;
               break;
            }
         }
      }
      if (j > 0) return (StringLeft(str, j + m));
   }
   return ("");
}

//+------------------------------------------------------------------+
string StringRightExtract(string str, string str2, int n = 1, int m = 0) {
   //+------------------------------------------------------------------+
   //   extracts all chars to right of the nth occurrence of string str2
   //     in string str, plus a further m characters
   //  If n > 0, occurrences are counted forward from the left in str
   //  If n < 0, occurrences are counted backward from the right in str
   //  If omitted, n defaults to 1
   //  If omitted, m defaults to 0
   // Example: StringRightExtract("C:\Program Files\MT4\experts","\\",1) returns "Program Files\MT4\experts"
   // Example: StringRightExtract("C:\Program Files\MT4\experts","\\",-1) returns "experts"
   if (n > 0) {
      int j = -1;
      for (int i = 1; i <= n; i++) j = StringFind(str, str2, j + 1);
      if (j > 0) return (StringRight(str, StringLen(str) - j - 1 + m));
   }
   if (n < 0) {
      int c = 0;
      j = 0;
      for (i = StringLen(str) - 1; i >= 0; i--) {
         if (stringSubstrOld(str, i, StringLen(str2)) == str2) {
            c++;
            if (c == -n) {
               j = i;
               break;
            }
         }
      }
      if (j > 0) return (StringRight(str, StringLen(str) - j - 1 + m));
   }
   return ("");
}

//+------------------------------------------------------------------+
int StringFindCount(string str, string str2)
//+------------------------------------------------------------------+
// Returns the number of occurrences of STR2 in STR
// Usage:   int x = StringFindCount("ABCDEFGHIJKABACABB","AB")   returns x = 3
{
   int c = 0;
   for (int i = 0; i < StringLen(str); i++)
      if (stringSubstrOld(str, i, StringLen(str2)) == str2) c++;
   return (c);
}

/*
//+------------------------------------------------------------------+
string stringReplaceOld(string str, int n, string str2, string str3)
//+------------------------------------------------------------------+
// Replaces the Nth occurrence of STR2 in STR with STR3, working from left to right, if N is positive
// Usage:   string s = stringReplaceOld("ABCDEFGHIJKABACABB",2,"AB","XYZ")   returns s = "ABCDEFGHIJKXYZACABB"
//
// Replaces the Nth occurrence of STR2 in STR with STR3, working from right to left, if N is negative
// Usage:   string s = stringReplaceOld("ABCDEFGHIJKABACABB",-1,"AB","XYZ")   returns s = "ABCDEFGHIJKABACXYZB"
//
// Replaces all occurrence of STR2 in STR with STR3, if N is 0
// Usage:   string s = stringReplaceOld("ABCDEFGHIJKABACABB",0,"AB","XYZ")   returns s = "XYZCDEFGHIJKXYZACXYZB"
{

  return("");
}
*/

//+------------------------------------------------------------------+
string StringTrim(string str, string s_char = " ")
//+------------------------------------------------------------------+
// Removes all spaces (leading, traing embedded) from a string
// Usage:    string x=StringTrim("The Quick Brown Fox")  returns x = "TheQuickBrownFox"
// s_char defaults to space(s), but may contain a list of characters to be stripped
{
   string outstr = "";
   for (int i = 0; i < StringLen(str); i++) {
      if (StringFind(s_char, stringSubstrOld(str, i, 1)) < 0)
         outstr = outstr + stringSubstrOld(str, i, 1);
   }
   return (outstr);
}

//+------------------------------------------------------------------+
string StringLeftTrim(string str, string s_char = " ")
//+------------------------------------------------------------------+
// Removes all leading spaces from a string
// Usage:    string x=StringLeftTrim("  XX YY  ")  returns x = "XX  YY  "
// s_char defaults to space(s), but may contain a list of characters to be stripped
{
   bool left = true;
   string outstr = "";
   for (int i = 0; i < StringLen(str); i++) {
      if (StringFind(s_char, stringSubstrOld(str, i, 1)) < 0 || !left) {
         outstr = outstr + stringSubstrOld(str, i, 1);
         left = false;
      }
   }
   return (outstr);
}

//+------------------------------------------------------------------+
string StringRightTrim(string str, string s_char = " ")
//+------------------------------------------------------------------+
// Removes all trailing spaces from a string
// Usage:    string x=StringRightTrim("  XX YY  ")  returns x = "  XX  YY"
// s_char defaults to space(s), but may contain a list of characters to be stripped
{
   int pos = 0;
   for (int i = StringLen(str) - 1; i >= 0; i--) {
      if (StringFind(s_char, stringSubstrOld(str, i, 1)) < 0) {
         pos = i;
         break;
      }
   }
   string outstr = stringSubstrOld(str, 0, pos + 1);
   return (outstr);
}

//+------------------------------------------------------------------+
string StringRepeat(string str, int n = 1)
//+------------------------------------------------------------------+
// Repeats the string STR N times
// Usage:    string x=StringRepeat("-",10)  returns x = "----------"
{
   string outstr = "";
   for (int i = 0; i < n; i++) {
      outstr = outstr + str;
   }
   return (outstr);
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
   for (int i = 0; i < StringLen(str); i++) {
      int t1 = StringFind(lower, stringSubstrOld(str, i, 1), 0);
      if (t1 >= 0)
         outstr = outstr + stringSubstrOld(upper, t1, 1);
      else
         outstr = outstr + stringSubstrOld(str, i, 1);
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
   for (int i = 0; i < StringLen(str); i++) {
      int t1 = StringFind(upper, stringSubstrOld(str, i, 1), 0);
      if (t1 >= 0)
         outstr = outstr + stringSubstrOld(lower, t1, 1);
      else
         outstr = outstr + stringSubstrOld(str, i, 1);
   }
   return (outstr);
}

//+------------------------------------------------------------------+
string StringEncrypt(string str) {
   //+------------------------------------------------------------------+
   //  Return encrypted string 
   string outstr = "";
   for (int i = StringLen(str) - 1; i >= 0; i--) {
      int x = StringGetChar(str, i);
      outstr = outstr + CharToStr(255 - x);
   }
   return (outstr);
}

//+------------------------------------------------------------------+
string StringDecrypt(string str) {
   //+------------------------------------------------------------------+
   //  Return decrypted string (inverse function of String Encrypt)
   string outstr = "";
   for (int i = StringLen(str) - 1; i >= 0; i--) {
      int x = StringGetChar(str, i);
      outstr = outstr + CharToStr(255 - x);
   }
   return (outstr);
}

//+------------------------------------------------------------------+
string stringReplaceOld(string str, string str1, string str2) {
   //+------------------------------------------------------------------+
   // Usage: replaces every occurrence of str1 with str2 in str
   // e.g. stringReplaceOld("ABCDE","CD","X") returns "ABXE"
   string outstr = "";
   for (int i = 0; i < StringLen(str); i++) {
      if (stringSubstrOld(str, i, StringLen(str1)) == str1) {
         outstr = outstr + str2;
         i += StringLen(str1) - 1;
      } else
         outstr = outstr + stringSubstrOld(str, i, 1);
   }
   return (outstr);
}

//+------------------------------------------------------------------+
string AppendIfMissing(string str, string str1 = ",") {
   //+------------------------------------------------------------------+
   // If the last character in str isn't str1, then str1 is appended to str
   // e.g. AppendIfMissing("C:\MT4\experts","\") returns "C:\MT4\experts\"
   if (stringSubstrOld(str, StringLen(str) - 1, 1) != str1)
      return (str + str1);
   return (str);
}

//+------------------------------------------------------------------+
string AppendIfNotNull(string str, string str1 = ",") {
   //+------------------------------------------------------------------+
   // Appends str1 to str, if str is not null
   // e.g. suppose: a[0]="a"   a[1]="b"   a[2]="c"   a[3]="d"
   //  string s=""; for (int i=0; i<4; i++)   s=AppendIfNotNull(s,",")+a[i];
   //  returns "a,b,c,d"
   if (StringLen(str) > 0)
      return (str + str1);
   return (str);
}

//+------------------------------------------------------------------+
string ExpandCcy(string str) {
   //+------------------------------------------------------------------+
   // Expands a currency (e.g. G to GBP) or a currency pair (e.g. EU to EURUSD)
   //  as shown in the code
   if (StringLen(str) <= 0) return (Symbol());
   string suff = "";
   if (StringLen(str) > 6) {
      suff = stringSubstrOld(str, 6);
      str = stringSubstrOld(str, 0, 6);
   }
   str = StringTrim(StringUpper(str));
   string str2 = str;
   if (StringLen(str) >= 1 && StringLen(str) <= 2) {
      str2 = "";
      for (int i = 0; i < StringLen(str); i++) {
         string s_char = stringSubstrOld(str, i, 1);
         if (s_char == "A") str2 = str2 + "AUD";
         else
         if (s_char == "C") str2 = str2 + "CAD";
         else
         if (s_char == "E") str2 = str2 + "EUR";
         else
         if (s_char == "F") str2 = str2 + "CHF";
         else
         if (s_char == "G") str2 = str2 + "GBP";
         else
         if (s_char == "J") str2 = str2 + "JPY";
         else
         if (s_char == "N") str2 = str2 + "NZD";
         else
         if (s_char == "U") str2 = str2 + "USD";
         else
         if (s_char == "H") str2 = str2 + "HKD";
         else
         if (s_char == "S") str2 = str2 + "SGD";
         else
         if (s_char == "Z") str2 = str2 + "ZAR";
      }
   }
   return (StringTrim(str2 + suff));
}

//+------------------------------------------------------------------+
string ReduceCcy(string str) {
   //+------------------------------------------------------------------+
   // Abbreviates a single currency (e.g. GBP to G) or a currency pair (e.g. EURUSD to EU)
   //  as shown in the code. Inverse of ExpandCcy() function
   str = StringTrim(StringUpper(str));
   if (StringLen(str) != 3 && StringLen(str) < 6) return ("");
   string s = "";
   for (int i = 0; i < StringLen(str); i += 3) {
      string s_char = stringSubstrOld(str, i, 3);
      if (s_char == "AUD") s = s + "A";
      else
      if (s_char == "CAD") s = s + "C";
      else
      if (s_char == "EUR") s = s + "E";
      else
      if (s_char == "CHF") s = s + "F";
      else
      if (s_char == "GBP") s = s + "G";
      else
      if (s_char == "JPY") s = s + "J";
      else
      if (s_char == "NZD") s = s + "N";
      else
      if (s_char == "USD") s = s + "U";
      else
      if (s_char == "HKD") s = s + "H";
      else
      if (s_char == "SGD") s = s + "S";
      else
      if (s_char == "ZAR") s = s + "Z";
   }
   return (s);
}

//+------------------------------------------------------------------+
double ConvertCcy(double amt, string ccy1, string ccy2, string suff = "") {
   //+------------------------------------------------------------------+
   double rate = MarketInfo(ExpandCcy(ccy1) + ExpandCcy(ccy2) + suff, MODE_BID);
   if (rate <= 0)
      rate = DivZero(1, MarketInfo(ExpandCcy(ccy2) + ExpandCcy(ccy1) + suff, MODE_BID));
   if (rate <= 0)
      rate = -1;
   return (rate * amt);
}

//+------------------------------------------------------------------+
double MathInt(double n, int d = 0) {
   //+------------------------------------------------------------------+
   // Corrects a rounding/accuracy bug in MQL4's MathFloor function
   //   (use MathInt(n) instead of MathFloor(n)
   // Rounds n DOWN to d decimal places, e.g.
   // MathInt(2.57,1) returns 2.5
   // MathInt(2.99)   returns 2
   return (MathFloor(n * MathPow(10, d) + 0.000000000001) / MathPow(10, d));
}

//+------------------------------------------------------------------+
double MathFix(double n, int d = 0) {
   //+------------------------------------------------------------------+
   // Corrects a rounding/accuracy bug in MQL4's MathRound() function
   //   (use MathFix(n) instead of MathRound(n)
   // Rounds n to d decimal places, e.g.
   // MathFix(2.54,1) returns 2.5
   // MathFix(2.57,1) returns 2.6
   // MathFix(2.99)   returns 3
   return (MathRound(n * MathPow(10, d) + 0.000000000001 * MathSign(n)) / MathPow(10, d));
}

//+------------------------------------------------------------------+
double DivZero(double n, double d) {
   //+------------------------------------------------------------------+
   // Divides N by D, and returns 0 if the denominator (D) = 0
   // Usage:   double x = DivZero(y,z)  sets x = y/z
   // Use DivZero(y,z) instead of y/z to eliminate division by zero errors
   if (d == 0) return (0);
   else return (1.0 * n / d);
}

//+------------------------------------------------------------------+
int MathSign(double n) {
   //+------------------------------------------------------------------+
   // Returns the sign of a number (i.e. -1, 0, +1)
   // Usage:   int x=MathSign(-25)   returns x=-1
   if (n > 0) return (1);
   else if (n < 0) return (-1);
   else return (0);
}

//+------------------------------------------------------------------+
datetime StrToDate(string str, string mask, string delim = "") {
   //+------------------------------------------------------------------+
   /*
     Converts a string to a MQL4 datetime value; mask is used to determine the positions
     where the components (year, month, day, hour, minute, second) are within the string.

     If delim="", then the position within the mask gives a component's ABSOLUTE position 
     in the string (delimiter characters in the mask are optional):
     str =   "23/06/2000 18:05:00"
     mask =  "DD MM YYYY HH:II:SS"

     Otherwise delim may contain any number of delimiting characters, e.g. delim = " /:"
     means that a space, slash or colon may be used to separate variable-width components:
     str =   "23/6/00 18:05:0"
     mask =  "DD/MM/YYYY HH:II:SS"

     Special tokens in the mask:
     DD   = Day as a 1 or 2 digit value
     MM   = Month as a 1 or 2 digit value
     MMM  = Month as a 3 character ID, e.g. Jan, AUG
     YY   = 2 digit year value (if > 50, assumed to be 19xx; otherwise, assumed to be 20xx)
     YYYY = Y2K compliant 4 digit year value
     HH   = Hours as a 1 or 2 digit value
     II   = Minutes as a 1 or 2 digit value
     SS   = Seconds as a 1 or 2 digit value
     AM or A.M. = Hours will be converted to military format
     PM or P.M. = Hours will be converted to military format 
   */
   mask = StringUpper(mask);
   str = StringUpper(str);
   if (delim > "") {
      string tmp = "";
      for (int i = 0; i < StringLen(mask); i++) {
         bool f = false;
         for (int j = 0; j < StringLen(delim); j++) {
            if (stringSubstrOld(mask, i, 1) == stringSubstrOld(delim, j, 1)) {
               int k = 5 + 5 * MathFloor(StringLen(tmp) / 5);
               tmp = StringRightPad(tmp, k);
               f = true;
               break;
            }
         }
         if (!f) tmp = tmp + stringSubstrOld(mask, i, 1);
      }
      mask = tmp;
      tmp = "";
      for (i = 0; i < StringLen(str); i++) {
         f = false;
         for (j = 0; j < StringLen(delim); j++) {
            if (stringSubstrOld(str, i, 1) == stringSubstrOld(delim, j, 1)) {
               k = 5 + 5 * MathFloor(StringLen(tmp) / 5);
               tmp = StringRightPad(tmp, k);
               f = true;
               break;
            }
         }
         if (!f) tmp = tmp + stringSubstrOld(str, i, 1);
      }
      str = tmp;
   }
   datetime mt4date = 0;
   int x = 0, dd = 0, mm = 0, yy = 0, hh = 0, ii = 0, ss = 0;
   x = StringFind(mask, "HH");
   if (x >= 0) hh = StrToNumber(stringSubstrOld(str, x, 2));
   x = StringFind(mask, "II");
   if (x >= 0) ii = StrToNumber(stringSubstrOld(str, x, 2));
   x = StringFind(mask, "SS");
   if (x >= 0) ss = StrToNumber(stringSubstrOld(str, x, 2));
   x = StringFind(mask, "DD");
   if (x >= 0) dd = StrToNumber(stringSubstrOld(str, x, 2));
   x = StringFind(mask, "MM");
   if (x >= 0) mm = StrToNumber(stringSubstrOld(str, x, 2));
   x = StringFind(mask, "YYYY");
   if (x >= 0) {
      yy = StrToNumber(stringSubstrOld(str, x, 4));
   } else {
      x = StringFind(mask, "YY");
      if (x >= 0)
         yy = StrToNumber(stringSubstrOld(str, x, 2));
   }
   if (yy < 100) {
      if (yy > 50) yy += 1900;
      else yy += 2000;
   }
   x = StringFind(mask, "MMM");
   if (x >= 0 && mm == 0) {
      x = StringFind(" JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC", " " + stringSubstrOld(str, x, 3));
      if (x >= 0) mm = (x + 4) / 4;
   }
   x = StringFind(str, "PM");
   if (x >= 0 && hh >= 1 && hh <= 11) hh += 12;
   x = StringFind(str, "P.M.");
   if (x >= 0 && hh >= 1 && hh <= 11) hh += 12;
   x = StringFind(str, "AM");
   if (x >= 0 && hh == 12) hh = 0;
   x = StringFind(str, "A.M.");
   if (x >= 0 && hh == 12) hh = 0;
   mt4date = StrToTime(NumberToStr(yy, "4'.'") + NumberToStr(mm, "Z2'.'") + NumberToStr(dd, "Z2' '") + NumberToStr(hh, "Z2':'") + NumberToStr(ii, "Z2':'") + NumberToStr(ss, "Z2"));
   return (mt4date);
}

//+------------------------------------------------------------------+
string DateToStr(datetime mt4date, string mask = "") {
   //+------------------------------------------------------------------+
   // Special characters in mask are replaced as follows:
   //   Y = 4 digit year
   //   y = 2 digit year
   //   M = 2 digit month
   //   m = 1-2 digit Month
   //   N = full month name, e.g. November
   //   n = 3 char month name, e.g. Nov
   //   D = 2 digit day of Month, e.g. 01, 31
   //   d = 1-2 digit day of Month, e.g. 1, 31
   //   T or t = append 'th' to day of month, e.g. 14th, 23rd, etc
   //   W = full weekday name, e.g. Tuesday
   //   w = 3 char weekday name, e.g. Tue
   //   H = 2 digit hour (defaults to 24-hour time unless 'a' or 'A' included)
   //   h = 1-2 digit hour (defaults to 24-hour time unless 'a' or 'A' included)
   //   a = convert to 12-hour time and append lowercase am/pm
   //   A = convert to 12-hour time and append uppercase AM/PM
   //   I or i = minutes in the hour
   //   S or s = seconds in the minute
   //   
   //   All other characters in the mask are output 'as is'
   //   You can output reserved characters 'as is', by preceding them with an exclamation point
   //    e.g. DateToStr(StrToTime("2010.07.30"),"(!D=DT N)") results in output: (D=30th July)
   //   
   // You can also embed any text inside single quotes at the far left, or far right, of the mask:
   //    e.g. DateToStr(StrToTime("2010.07.30"),"'xxx'w D n Y'yyy'") results in output: xxxFri 30 Jul 2010yyy

   string ltext = "", rtext = "";
   if (stringSubstrOld(mask, 0, 1) == "'") {
      for (int k1 = 1; k1 < StringLen(mask); k1++) {
         if (stringSubstrOld(mask, k1, 1) == "'") break;
         ltext = ltext + stringSubstrOld(mask, k1, 1);
      }
      mask = stringSubstrOld(mask, k1 + 1);
   }
   if (stringSubstrOld(mask, StringLen(mask) - 1, 1) == "'") {
      for (int k2 = StringLen(mask) - 2; k2 >= 0; k2--) {
         if (stringSubstrOld(mask, k2, 1) == "'") break;
         rtext = stringSubstrOld(mask, k2, 1) + rtext;
      }
      mask = stringSubstrOld(mask, 0, k2);
   }

   if (mask == "") mask = "Y.M.D H:I:S";

   bool blank = false;
   if (stringSubstrOld(StringUpper(mask), 0, 1) == "B") {
      blank = true;
      mask = StringRight(mask, -1);
   }

   string mth[12] = {
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
   };
   string dow[7] = {
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
   };

   int dd = TimeDay(mt4date);
   int mm = TimeMonth(mt4date);
   int yy = TimeYear(mt4date);
   int dw = TimeDayOfWeek(mt4date);
   int hr = TimeHour(mt4date);
   int min = TimeMinute(mt4date);
   int sec = TimeSeconds(mt4date);

   bool h12f = false;
   if (StringFind(StringUpper(mask), "A", 0) >= 0) h12f = true;
   int h12 = 12;
   if (hr > 12) h12 = hr - 12;
   else
   if (hr > 0) h12 = hr;
   string ampm = "am";
   if (hr >= 12)
      ampm = "pm";

   //switch (MathMod(dd,10))   {
   int dd_mod10 = MathMod(dd, 10);
   switch (dd_mod10) {
   case 1:
      string d10 = "st";
      break;
   case 2:
      d10 = "nd";
      break;
   case 3:
      d10 = "rd";
      break;
   default:
      d10 = "th";
      break;
   }
   if (dd > 10 && dd < 14) d10 = "th";

   int days = MathInt(mt4date / 86400);
   int hrs = MathInt(mt4date / 3600);
   int mins = MathInt(mt4date / 60);

   string outdate = "";
   for (int i = 0; i < StringLen(mask); i++) {
      string s_char = stringSubstrOld(mask, i, 1);
      if (s_char == "!") {
         outdate = outdate + stringSubstrOld(mask, i + 1, 1);
         i++;
         continue;
      }
      if (s_char == "@") {
         string char1 = stringSubstrOld(mask, i + 1, 1);
         string char2 = stringSubstrOld(mask, i + 2, 1);
         if (StringUpper(char1) == "D") outdate = outdate + NumberToStr(days, char2);
         if (StringUpper(char1) == "H") outdate = outdate + NumberToStr(hrs, char2);
         if (StringUpper(char1) == "I") outdate = outdate + NumberToStr(mins, char2);
         i += 2;
         continue;
      }
      if (s_char == "d") outdate = outdate + StringTrim(NumberToStr(dd, "2"));
      else
      if (s_char == "D") outdate = outdate + StringTrim(NumberToStr(dd, "Z2"));
      else
      if (s_char == "m") outdate = outdate + StringTrim(NumberToStr(mm, "2"));
      else
      if (s_char == "M") outdate = outdate + StringTrim(NumberToStr(mm, "Z2"));
      else
      if (s_char == "y") outdate = outdate + StringTrim(NumberToStr(yy, "2"));
      else
      if (s_char == "Y") outdate = outdate + StringTrim(NumberToStr(yy, "4"));
      else
      if (s_char == "n") outdate = outdate + stringSubstrOld(mth[mm - 1], 0, 3);
      else
      if (s_char == "N") outdate = outdate + mth[mm - 1];
      else
      if (s_char == "w") outdate = outdate + stringSubstrOld(dow[dw], 0, 3);
      else
      if (s_char == "W") outdate = outdate + dow[dw];
      else
      if (s_char == "h" && h12f) outdate = outdate + StringTrim(NumberToStr(h12, "2"));
      else
      if (s_char == "H" && h12f) outdate = outdate + StringTrim(NumberToStr(h12, "Z2"));
      else
      if (s_char == "h" && !h12f) outdate = outdate + StringTrim(NumberToStr(hr, "2"));
      else
      if (s_char == "H" && !h12f) outdate = outdate + StringTrim(NumberToStr(hr, "Z2"));
      else
      if (s_char == "i") outdate = outdate + StringTrim(NumberToStr(min, "2"));
      else
      if (s_char == "I") outdate = outdate + StringTrim(NumberToStr(min, "Z2"));
      else
      if (s_char == "s") outdate = outdate + StringTrim(NumberToStr(sec, "2"));
      else
      if (s_char == "S") outdate = outdate + StringTrim(NumberToStr(sec, "Z2"));
      else
      if (s_char == "a") outdate = outdate + ampm;
      else
      if (s_char == "A") outdate = outdate + StringUpper(ampm);
      else
      if (StringUpper(s_char) == "T") outdate = outdate + d10;
      else
         outdate = outdate + s_char;
   }
   if (blank && mt4date == 0)
      outdate = StringRepeat(" ", StringLen(outdate));
   return (ltext + outdate + rtext);
}

//+------------------------------------------------------------------+
double StrToNumber(string str) {
   //+------------------------------------------------------------------+
   // Usage: strips all non-numeric characters out of a string, to return a numeric (double) value
   //  valid numeric characters are digits 0,1,2,3,4,5,6,7,8,9, decimal point (.) and minus sign (-)
   // Example: StrToNumber("the balance is $-34,567.98") returns the numeric value -34567.98
   int dp = -1;
   int sgn = 1;
   double num = 0.0;
   for (int i = 0; i < StringLen(str); i++) {
      string s = stringSubstrOld(str, i, 1);
      if (s == "-") sgn = -sgn;
      else
      if (s == ".") dp = 0;
      else
      if (s >= "0" && s <= "9") {
         if (dp >= 0) dp++;
         if (dp > 0)
            num = num + StrToInteger(s) / MathPow(10, dp);
         else
            num = num * 10 + StrToInteger(s);
      }
   }
   return (num * sgn);
}

//+------------------------------------------------------------------+
string NumberToStr(double n, string mask = "")
//+------------------------------------------------------------------+
// Formats a number using a mask, and returns the resulting string
// Usage:    string result = NumberToStr(number,mask)
// 
// Mask parameters:
// n = number of digits to output, to the left of the decimal point
// n.d = output n digits to left of decimal point; d digits to the right
// -n.d = floating minus sign at left of output
// n.d- = minus sign at right of output
// +n.d = floating plus/minus sign at left of output
//
// These characters may appear anywhere in the string:
//   ( or ) = enclose negative number in parentheses
//   $ or £ or ¥ or € = include floating currency symbol at left of output
//   % = include trailing % sign
//   , = use commas to separate thousands, millions, etc
//   Z or z = left fill with zeros instead of spaces
//   * = left fill with asterisks instead of spaces
//   R or r = round result in rightmost displayed digit
//   B or b = blank entire field if number is 0
//   ~ = show tilde in leftmost position if overflow occurs
//   ; = switch use of comma and period (European format)
//   L or l = left align final string 
//   T ot t = trim (remove all spaces from) end result

{

   if (MathAbs(n) == 2147483647)
      n = 0;

   string ltext = "", rtext = "";
   if (stringSubstrOld(mask, 0, 1) == "'") {
      for (int k1 = 1; k1 < StringLen(mask); k1++) {
         if (stringSubstrOld(mask, k1, 1) == "'") break;
         ltext = ltext + stringSubstrOld(mask, k1, 1);
      }
      mask = stringSubstrOld(mask, k1 + 1);
   }
   if (stringSubstrOld(mask, StringLen(mask) - 1, 1) == "'") {
      for (int k2 = StringLen(mask) - 2; k2 >= 0; k2--) {
         if (stringSubstrOld(mask, k2, 1) == "'") break;
         rtext = stringSubstrOld(mask, k2, 1) + rtext;
      }
      mask = stringSubstrOld(mask, 0, k2);
   }

   if (mask == "") mask = "TR-9.2";

   mask = StringUpper(mask);
   if (mask == "B") return (ltext + rtext);

   int dotadj = 0;
   int dot = StringFind(mask, ".", 0);
   if (dot < 0) {
      dot = StringLen(mask);
      dotadj = 1;
   }

   int nleft = 0;
   int nright = 0;
   for (int i = 0; i < dot; i++) {
      string s_char = stringSubstrOld(mask, i, 1);
      if (s_char >= "0" && s_char <= "9") nleft = 10 * nleft + StrToInteger(s_char);
   }
   if (dotadj == 0) {
      for (i = dot + 1; i <= StringLen(mask); i++) {
         s_char = stringSubstrOld(mask, i, 1);
         if (s_char >= "0" && s_char <= "9") nright = 10 * nright + StrToInteger(s_char);
      }
   }
   nright = MathMin(nright, 7);

   if (dotadj == 1) {
      for (i = 0; i < StringLen(mask); i++) {
         s_char = stringSubstrOld(mask, i, 1);
         if (s_char >= "0" && s_char <= "9") {
            dot = i;
            break;
         }
      }
   }

   string csym = "";
   if (StringFind(mask, "$", 0) >= 0) csym = "$";
   if (StringFind(mask, "£", 0) >= 0) csym = "£";
   if (StringFind(mask, "€", 0) >= 0) csym = "€";
   if (StringFind(mask, "¥", 0) >= 0) csym = "¥";

   string leadsign = "";
   string trailsign = "";
   if (StringFind(mask, "+", 0) >= 0 && StringFind(mask, "+", 0) < dot) {
      leadsign = " ";
      if (n > 0) leadsign = "+";
      if (n < 0) leadsign = "-";
   }
   if (StringFind(mask, "-", 0) >= 0 && StringFind(mask, "-", 0) < dot)
      if (n < 0) leadsign = "-";
      else leadsign = " ";
   if (StringFind(mask, "-", 0) >= 0 && StringFind(mask, "-", 0) > dot)
      if (n < 0) trailsign = "-";
      else trailsign = " ";
   if (StringFind(mask, "(", 0) >= 0 || StringFind(mask, ")", 0) >= 0) {
      leadsign = " ";
      trailsign = " ";
      if (n < 0) {
         leadsign = "(";
         trailsign = ")";
      }
   }

   if (StringFind(mask, "%", 0) >= 0) trailsign = "%" + trailsign;

   if (StringFind(mask, ",", 0) >= 0) bool comma = true;
   else comma = false;
   if (StringFind(mask, "Z", 0) >= 0) bool zeros = true;
   else zeros = false;
   if (StringFind(mask, "*", 0) >= 0) bool aster = true;
   else aster = false;
   if (StringFind(mask, "B", 0) >= 0) bool blank = true;
   else blank = false;
   if (StringFind(mask, "R", 0) >= 0) bool round = true;
   else round = false;
   if (StringFind(mask, "~", 0) >= 0) bool overf = true;
   else overf = false;
   if (StringFind(mask, "L", 0) >= 0) bool lftsh = true;
   else lftsh = false;
   if (StringFind(mask, ";", 0) >= 0) bool swtch = true;
   else swtch = false;
   if (StringFind(mask, "T", 0) >= 0) bool trimf = true;
   else trimf = false;

   if (round) n = MathFix(n, nright);
   //string outstr = n; // CHANGE!  In 600+, this does not assume 8 digits, and does not pad with any trailing zeros.
   string outstr = DoubleToStr(n, 8); // This seems to work like 509. (Or, DoubleToString ?? Is there any difference?)

   int dleft = 0;
   for (i = 0; i < StringLen(outstr); i++) {
      s_char = stringSubstrOld(outstr, i, 1);
      if (s_char >= "0" && s_char <= "9") dleft++;
      if (s_char == ".") break;
   }

   // Insert fill characters.......
   string fill = " ";
   if (zeros) fill = "0";
   if (aster) fill = "*";
   if (n < 0)
      outstr = "-" + StringRepeat(fill, nleft - dleft) + stringSubstrOld(outstr, 1, StringLen(outstr) - 1);
   else
      outstr = StringRepeat(fill, nleft - dleft) + stringSubstrOld(outstr, 0, StringLen(outstr));

   outstr = stringSubstrOld(outstr, StringLen(outstr) - 9 - nleft, nleft + 1 + nright - dotadj);

   // Insert the commas.......  
   if (comma) {
      bool digflg = false;
      bool stpflg = false;
      string out1 = "";
      string out2 = "";
      for (i = 0; i < StringLen(outstr); i++) {
         s_char = stringSubstrOld(outstr, i, 1);
         if (s_char == ".") stpflg = true;
         if (!stpflg && (nleft - i == 3 || nleft - i == 6 || nleft - i == 9))
            if (digflg) out1 = out1 + ",";
            else out1 = out1 + " ";
         out1 = out1 + s_char;
         if (s_char >= "0" && s_char <= "9") digflg = true;
      }
      outstr = out1;
   }
   // Add currency symbol and signs........  
   outstr = csym + leadsign + outstr + trailsign;

   // 'Float' the currency symbol/sign.......
   out1 = "";
   out2 = "";
   bool fltflg = true;
   for (i = 0; i < StringLen(outstr); i++) {
      s_char = stringSubstrOld(outstr, i, 1);
      if (s_char >= "0" && s_char <= "9") fltflg = false;
      if ((s_char == " " && fltflg) || (blank && n == 0)) out1 = out1 + " ";
      else out2 = out2 + s_char;
   }
   outstr = out1 + out2;

   // Overflow........  
   if (overf && dleft > nleft) outstr = "~" + stringSubstrOld(outstr, 1, StringLen(outstr) - 1);

   // Left shift.......
   if (lftsh) {
      int len = StringLen(outstr);
      outstr = StringLeftTrim(outstr);
      outstr = outstr + StringRepeat(" ", len - StringLen(outstr));
   }

   // Switch period and comma.......
   if (swtch) {
      out1 = "";
      for (i = 0; i < StringLen(outstr); i++) {
         s_char = stringSubstrOld(outstr, i, 1);
         if (s_char == ".") out1 = out1 + ",";
         else
         if (s_char == ",") out1 = out1 + ".";
         else
            out1 = out1 + s_char;
      }
      outstr = out1;
   }

   // Trim output....
   if (trimf) outstr = StringTrim(outstr);

   return (ltext + outstr + rtext);
}

//+------------------------------------------------------------------+
string StrToStr(string str, string mask, string pad = " ") {
   //+------------------------------------------------------------------+
   // Formats a string according to the mask. Mask may be one of:
   //  "Ln" : left  align the string, and pad/truncate the result field to n characters
   //  "Rn" : right align the string, and pad/truncate the result field to n characters
   //  "Cn" : center the string, and pad/truncate the result field to n characters
   //  "Tn" : truncate the string to n characters; no padding if string is too short

   string ltext = "", rtext = "";
   if (stringSubstrOld(mask, 0, 1) == "'") {
      for (int k1 = 1; k1 < StringLen(mask); k1++) {
         if (stringSubstrOld(mask, k1, 1) == "'") break;
         ltext = ltext + stringSubstrOld(mask, k1, 1);
      }
      mask = stringSubstrOld(mask, k1 + 1);
   }
   if (stringSubstrOld(mask, StringLen(mask) - 1, 1) == "'") {
      for (int k2 = StringLen(mask) - 2; k2 >= 0; k2--) {
         if (stringSubstrOld(mask, k2, 1) == "'") break;
         rtext = stringSubstrOld(mask, k2, 1) + rtext;
      }
      mask = stringSubstrOld(mask, 0, k2);
   }

   if (mask == "") mask = "L20";

   string outstr = "";
   int n = 0;
   for (int i = 0; i < StringLen(mask); i++) {
      string s = stringSubstrOld(mask, i, 1);
      if (s == "!") {
         outstr = outstr + stringSubstrOld(mask, i + 1, 1);
         i++;
         continue;
      }
      if (s == "L" || s == "C" || s == "R" || s == "T") {
         string func = s;
         i++;
         while (i < StringLen(mask)) {
            s = stringSubstrOld(mask, i, 1);
            if (s >= "0" && s <= "9") {
               n = n * 10 + StrToInteger(s);
               i++;
               continue;
            } else
               break;
         }
         i--;
         if (n < StringLen(str)) str = stringSubstrOld(str, 0, n);
         int lpad = 0, rpad = 0;
         if (func == "L") rpad = MathMax(0, n - StringLen(str));
         if (func == "R") lpad = MathMax(0, n - StringLen(str));
         if (func == "C") {
            lpad = MathMax(0, n - StringLen(str)) / 2;
            rpad = MathMax(0, n - StringLen(str)) - lpad;
         }
         outstr = outstr + StringRepeat(pad, lpad) + str + StringRepeat(pad, rpad);
      } else
         outstr = outstr + s;
   }
   return (ltext + outstr + rtext);
}

//+------------------------------------------------------------------+
string NumbersToStr(string mask, double n1 = 0, double n2 = 0, double n3 = 0, double n4 = 0, double n5 = 0, double n6 = 0, double n7 = 0, double n8 = 0, double n9 = 0) {
   //+------------------------------------------------------------------+
   // Concatenates up to 9 numeric (integer or double) values (n1,n2,n3,...) into a single output string
   //  Mask 'mask' is used to format each component number before it is concatenated (see NumberToStr() function)
   if (stringSubstrOld(mask, StringLen(mask) - 1, 1) != "_") mask = mask + "_";
   string outstr = "";
   string maska[9] = {
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>"
   };
   int z = 0;
   for (int x = 0; x < StringLen(mask); x++) {
      if (maska[z] == "<NULL>") maska[z] = "";
      string s = stringSubstrOld(mask, x, 1);
      if (s == "_") {
         if (StringLower(stringSubstrOld(maska[z], 1, 1)) == "@") {
            int yy = StrToNumber(stringSubstrOld(maska[z], 0, 1));
            maska[z] = stringSubstrOld(maska[z], 2);
            for (int y = 1; y < yy; y++) {
               maska[z + 1] = maska[z];
               z++;
            }
         }
         z++;
      } else
         maska[z] = maska[z] + s;
   }
   if (maska[0] != "<NULL>") outstr = outstr + NumberToStr(n1, maska[0]);
   if (maska[1] != "<NULL>") outstr = outstr + NumberToStr(n2, maska[1]);
   if (maska[2] != "<NULL>") outstr = outstr + NumberToStr(n3, maska[2]);
   if (maska[3] != "<NULL>") outstr = outstr + NumberToStr(n4, maska[3]);
   if (maska[4] != "<NULL>") outstr = outstr + NumberToStr(n5, maska[4]);
   if (maska[5] != "<NULL>") outstr = outstr + NumberToStr(n6, maska[5]);
   if (maska[6] != "<NULL>") outstr = outstr + NumberToStr(n7, maska[6]);
   if (maska[7] != "<NULL>") outstr = outstr + NumberToStr(n8, maska[7]);
   if (maska[8] != "<NULL>") outstr = outstr + NumberToStr(n9, maska[8]);
   return (outstr);
}

//+------------------------------------------------------------------+
string DatesToStr(string mask, datetime d1 = 0, datetime d2 = 0, datetime d3 = 0, datetime d4 = 0, datetime d5 = 0, datetime d6 = 0, datetime d7 = 0, datetime d8 = 0, datetime d9 = 0) {
   //+------------------------------------------------------------------+
   // Concatenates up to 9 datetime values (d1,d2,d3,...) into a single output string
   //  Mask 'mask' is used to format each component datetime before it is concatenated (see DateToStr() function)
   if (stringSubstrOld(mask, StringLen(mask) - 1, 1) != "_") mask = mask + "_";
   string outstr = "";
   string maska[9] = {
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>"
   };
   int z = 0;
   for (int x = 0; x < StringLen(mask); x++) {
      if (maska[z] == "<NULL>") maska[z] = "";
      string s = stringSubstrOld(mask, x, 1);
      if (s == "_") {
         if (StringLower(stringSubstrOld(maska[z], 1, 1)) == "@") {
            int yy = StrToNumber(stringSubstrOld(maska[z], 0, 1));
            maska[z] = stringSubstrOld(maska[z], 2);
            for (int y = 1; y < yy; y++) {
               maska[z + 1] = maska[z];
               z++;
            }
         }
         z++;
      } else
         maska[z] = maska[z] + s;
   }
   if (maska[0] != "<NULL>") outstr = outstr + DateToStr(d1, maska[0]);
   if (maska[1] != "<NULL>") outstr = outstr + DateToStr(d2, maska[1]);
   if (maska[2] != "<NULL>") outstr = outstr + DateToStr(d3, maska[2]);
   if (maska[3] != "<NULL>") outstr = outstr + DateToStr(d4, maska[3]);
   if (maska[4] != "<NULL>") outstr = outstr + DateToStr(d5, maska[4]);
   if (maska[5] != "<NULL>") outstr = outstr + DateToStr(d6, maska[5]);
   if (maska[6] != "<NULL>") outstr = outstr + DateToStr(d7, maska[6]);
   if (maska[7] != "<NULL>") outstr = outstr + DateToStr(d8, maska[7]);
   if (maska[8] != "<NULL>") outstr = outstr + DateToStr(d9, maska[8]);
   return (outstr);
}

//+------------------------------------------------------------------+
string StrsToStr(string mask, string s1 = "", string s2 = "", string s3 = "", string s4 = "", string s5 = "", string s6 = "", string s7 = "", string s8 = "", string s9 = "") {
   //+------------------------------------------------------------------+
   // Concatenates up to 9 strings (s1,s2,s3,...) into a single output string
   //  Mask 'mask' is used to format each component string before it is concatenated  (see StrToStr() function)
   if (stringSubstrOld(mask, StringLen(mask) - 1, 1) != "_") mask = mask + "_";
   string outstr = "";
   string maska[9] = {
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>",
      "<NULL>"
   };
   int z = 0;
   for (int x = 0; x < StringLen(mask); x++) {
      if (maska[z] == "<NULL>") maska[z] = "";
      string s = stringSubstrOld(mask, x, 1);
      if (s == "_") {
         if (StringLower(stringSubstrOld(maska[z], 1, 1)) == "@") {
            int yy = StrToNumber(stringSubstrOld(maska[z], 0, 1));
            maska[z] = stringSubstrOld(maska[z], 2);
            for (int y = 1; y < yy; y++) {
               maska[z + 1] = maska[z];
               z++;
            }
         }
         z++;
      } else
         maska[z] = maska[z] + s;
   }
   if (maska[0] != "<NULL>") outstr = outstr + StrToStr(s1, maska[0]);
   if (maska[1] != "<NULL>") outstr = outstr + StrToStr(s2, maska[1]);
   if (maska[2] != "<NULL>") outstr = outstr + StrToStr(s3, maska[2]);
   if (maska[3] != "<NULL>") outstr = outstr + StrToStr(s4, maska[3]);
   if (maska[4] != "<NULL>") outstr = outstr + StrToStr(s5, maska[4]);
   if (maska[5] != "<NULL>") outstr = outstr + StrToStr(s6, maska[5]);
   if (maska[6] != "<NULL>") outstr = outstr + StrToStr(s7, maska[6]);
   if (maska[7] != "<NULL>") outstr = outstr + StrToStr(s8, maska[7]);
   if (maska[8] != "<NULL>") outstr = outstr + StrToStr(s9, maska[8]);
   return (outstr);
}

//+------------------------------------------------------------------+
int BaseToNumber(string str, int base = 16)
//+------------------------------------------------------------------+
// Returns the base 10 version of a number in another base
// Usage:   int x=BaseToNumber("DC",16)   returns x=220
{
   str = StringUpper(str);
   string cnvstr = "0123456789ABCDEF";
   int retval = 0;
   for (int i = 0; i < StringLen(str); i++) {
      int val = StringFind(cnvstr, stringSubstrOld(str, i, 1), 0);
      if (val < 0) return (val);
      retval = retval * base + val;
   }
   return (retval);
}

//+------------------------------------------------------------------+
string NumberToBase(int n, int base = 16, int pad = 4)
//+------------------------------------------------------------------+
// Converts a base 10 number to another base, left-padded with zeros
// Usage:   int x=BaseToNumber(220,16,4)   returns x="00DC"
{
   string cnvstr = "0123456789ABCDEF";
   string outstr = "";
   while (n > 0) {
      int x = MathMod(n, base);
      outstr = stringSubstrOld(cnvstr, x, 1) + outstr;
      n /= base;
   }
   x = StringLen(outstr);
   if (x < pad)
      outstr = StringRepeat("0", pad - x) + outstr;
   return (outstr);
}

//+------------------------------------------------------------------+
int YMDtoDate(int yy, int mm, int dd) {
   //+------------------------------------------------------------------+
   // Converts a year, month and day value to a valid MT4 datetime value
   string dt = NumberToStr(yy, "4") + "." + NumberToStr(mm, "2") + "." + NumberToStr(dd, "2") + " 00:00:00";
   return (StrToTime(dt));
}

//=======================================================================================
//=======================================================================================
// Search tag for nearby edits: "b600_b509"

// /* // Comment out from here DOWN for b509.   Uncomment and use below for >= b600.
//+------------------------------------------------------------------+
string stringSubstrOld(string x, int a, int b = -1) // THIS VERSION IS FOR >= B600
{
   bool debugSubstr = TRUE; // Change to true to investigate whether this replacement function is ever truly needed, or if it makes no difference.
   if (debugSubstr) {
      int aa = a, bb = b;
      if (a < 0) aa = 0;
      if (b <= 0) bb = -1;
      if (StringSubstr(x, a, b) != StringSubstr(x, aa, bb)) {
         // The 2nd arg change still makes a difference, as of build 670.
         if (a < 0) Print("2nd arg to StringSubstr WOULD have been <0 (", a, ") which might corrupt strings in build>600. Changing to 0. Orig_args=(\"", x, "\",", a, ",", b, ")");
         if (b == 0 || b <= -2) Print("3rd arg to StringSubstr WOULD have been =", b, ". Changing to -1 (=EOL). Orig_args=(\"", x, "\",", a, ",", b, ")");
         Print("WARNING: Use of stringSubstrOld(\"", x, "\",", a, ",", b, ")=", StringSubstr(x, aa, bb), " does not match b600 StringSubstr=", StringSubstr(x, a, b), " proving that Old behaves different. Consider fixing code to prevent adjustments to argument(s)");
      }
   }
   if (a < 0) a = 0; // Stop odd behaviour.  If a<0, it might corrupt strings!!
   if (b <= 0) b = -1; // new MQL4 EOL flag.   Formerly, a "0" was EOL. Is officially now -1.
   return (StringSubstr(x, a, b));
}

/*
//+------------------------------------------------------------------+
// Use following with version >= b600.  Use the other "ReadWebPage" with version b509
// ALSO, use the correct corresponding line in the "hanover -- funtion header b600 (np).mqh" file.
string ReadWebPage(string url)   { // THIS VERSION IS FOR >= B600
//+------------------------------------------------------------------+
// Returns the HTML from the designated URL as one long string
  if (!IsDllsAllowed())        { Alert("'Allow DLL imports' on the 'Common' tab must be checked ON");              return("");  }

  int rv = InternetAttemptConnect(0);
  if (rv != 0)                 { Alert("Unknown error attempting to connect to Internet");                         return("");  }

  //int hInternetSession = InternetOpenA("Microsoft Internet Explorer", 0, "", "", 0);
  int hInternetSession = InternetOpenW("Microsoft Internet Explorer", 0, "", "", 0);
  if(hInternetSession <= 0)    { Alert("Unknown error while attempting to acquire internet session");              return("");  }
   
  // Note: The FOLLOWING dwFlags var is *required* so "long" can be used (or uint) instead of int!  As int, or without 
  // having used variable dwFlags, MQL warns: "truncation of constant value"
  long dwFlags = INTERNET_FLAG_NO_CACHE_WRITE | INTERNET_FLAG_PRAGMA_NOCACHE | INTERNET_FLAG_RELOAD; // These have #define valules in the header file.
  int hURL = InternetOpenUrlW(hInternetSession, url, "", 0, dwFlags, 0);
  //int hURL = InternetOpenUrlA(hInternetSession, url, "", 0, INTERNET_FLAG_NO_CACHE_WRITE | INTERNET_FLAG_PRAGMA_NOCACHE | INTERNET_FLAG_RELOAD, 0);
  if(hURL <= 0)                { Alert("hURL=",hURL,": Unable to find requested URL=",url);   InternetCloseHandle(hInternetSession);   return("");  }      
  //if(hURL <= 0)                { Alert("hURL,": Unable to find requested URL");   InternetCloseHandle(hInternetSession);   return("");  }      

  //int cBuffer[256], dwBytesRead[1]; 
  uchar cBuffer[1024];
  int dwBytesRead[1]; 
  string TXT = "";
  int bufferLen = 80; // 1024 ?
  while (!IsStopped())   {
    for (int i = 0; i<1024; i++)    cBuffer[i] = 0;
    bool bResult = InternetReadFile(hURL, cBuffer, bufferLen, dwBytesRead); // Requires the b600 compatible function in the function header file.
    
    if (dwBytesRead[0] == 0)    break;
    string text = "";   
    text = CharArrayToString(cBuffer, 0, dwBytesRead[0]);
    //for (i = 0; i < 1024; i++)   {
    //  text = text + CharToStr(cBuffer[i] & 0x000000FF);             if (StringLen(text) == dwBytesRead[0])    break;
    //  text = text + CharToStr( (cBuffer[i] >> 8) & 0x000000FF);        if (StringLen(text) == dwBytesRead[0])    break;
    //  text = text + CharToStr( (cBuffer[i] >> 16) & 0x000000FF);       if (StringLen(text) == dwBytesRead[0])    break;
    //  text = text + CharToStr( (cBuffer[i] >> 24) & 0x000000FF);
    //}
    TXT = TXT + text;
    Sleep(1);
  }
  if (TXT == "")    Alert("No news events meet your selected criteria.  Or, ReadWebPage failed.");
  InternetCloseHandle(hInternetSession);
  return(TXT);
}

// */ // Comment out from here UP for b509.   Uncomment for >= b600.

// Search tag for nearby edits: "b600_b509"  ==========================================================

/* // Comment out from here DOWN for >= B600.   Uncomment and use below for b509.

//+------------------------------------------------------------------+
// Use following with version b509.  Use the other "ReadWebPage" with version >= b600
// ALSO, use the correct corresponding line in the "hanover -- funtion header b600 (np).mqh" file.
string ReadWebPage(string url)   { // THIS VERSION IS FOR B509
//+------------------------------------------------------------------+
// Returns the HTML from the designated URL as one long string
  if (!IsDllsAllowed())        { Alert("'Allow DLL imports' on the 'Common' tab must be checked ON");              return("");  }

  int rv = InternetAttemptConnect(0);
  if (rv != 0)                 { Alert("Unknown error attempting to connect to Internet");                         return("");  }

  int hInternetSession = InternetOpenA("Microsoft Internet Explorer", 0, "", "", 0);
  if(hInternetSession <= 0)    { Alert("Unknown error while attempting to acquire internet session");              return("");  }

  int hURL = InternetOpenUrlA(hInternetSession, url, "", 0, INTERNET_FLAG_NO_CACHE_WRITE | INTERNET_FLAG_PRAGMA_NOCACHE | INTERNET_FLAG_RELOAD, 0);
  if(hURL <= 0)                { Alert("Unable to find requested URL");   InternetCloseHandle(hInternetSession);   return("");  }      

  int cBuffer[256], dwBytesRead[1]; 
  string TXT = "";
  while (!IsStopped())   {
    for (int i = 0; i<256; i++)    cBuffer[i] = 0;
    bool bResult = InternetReadFile(hURL, cBuffer, 1024, dwBytesRead);
    if (dwBytesRead[0] == 0)    break;
    string text = "";   
    for (i = 0; i < 256; i++)   {
      text = text + CharToStr(cBuffer[i] & 0x000000FF);             if (StringLen(text) == dwBytesRead[0])    break;
      text = text + CharToStr(cBuffer[i] >> 8 & 0x000000FF);        if (StringLen(text) == dwBytesRead[0])    break;
      text = text + CharToStr(cBuffer[i] >> 16 & 0x000000FF);       if (StringLen(text) == dwBytesRead[0])    break;
      text = text + CharToStr(cBuffer[i] >> 24 & 0x000000FF);
    }
    TXT = TXT + text;
    Sleep(1);
  }
  if (TXT == "")    Alert("No news events meet your selected criteria");
  InternetCloseHandle(hInternetSession);
  return(TXT);
}
*/
/*
//+------------------------------------------------------------------+
// Uncomment and use this "StringReplace" ONLY with b509.   In b600, 
// there is an official function by the same name that acts differently.
// In b600, use "stringReplaceOld", which is the same function as below.
string StringReplace(string str, string str1, string str2)  { // THIS VERSION IS FOR B509
//+------------------------------------------------------------------+
// Usage: replaces every occurrence of str1 with str2 in str
// e.g. StringReplace("ABCDE","CD","X") returns "ABXE"
  string outstr = "";
  for (int i=0; i<StringLen(str); i++)   {
    if (StringSubstr(str,i,StringLen(str1)) == str1)  {
      outstr = outstr + str2;
      i += StringLen(str1) - 1;
    }
    else
      outstr = outstr + StringSubstr(str,i,1);
  }
  return(outstr);
}

//+------------------------------------------------------------------+
// NOTE:
// Also FYI, in b600, "stringSubstrOld" replaces use of "StringSubstr"
// because of different treatment of arguments (esp. if arg2 <0). In b509,
// BOTH the official "StringSubstr" and the "stringSubstrOld" can be used 
// in the code simultaneously.  (They do the same thing).
// In b600, in hanover's code that calls these functions, you might get
// away with using the official "StringSubstr", but it is safer to change
// all references to use the (b600 version) replacement,"stringSubstrOld".
//+------------------------------------------------------------------+
string stringSubstrOld(string x,int a,int b=-1) // THIS VERSION IS FOR B509
{
    bool debugSubstr = TRUE; // Change to true to investigate whether 509 code needs repair before using with >600.
    if (debugSubstr && b < 0) Print("WARNING: 2nd arg to StringSubstr is <0 (",a,") which WILL corrupt strings in build>600. Fix code before migrating. Orig_args=(\"",x,"\",",a,",",b,")  Result=\"",StringSubstr(x,a,b),"\"");
    return(StringSubstr(x,a,b));
}

//+------------------------------------------------------------------+


*/ // Comment out from here UP for >= B600.   Uncomment for b509.

// Search tag for nearby edits: "b600_b509"
//=======================================================================================
//=======================================================================================

//+------------------------------------------------------------------+
void ArrayInitializeString(string & a[], string value = "") {
   //+------------------------------------------------------------------+
   for (int i = 0; i < ArraySize(a); i++)
      a[i] = value;
   return;
}

//+------------------------------------------------------------------+
void ShellsortDoubleArray(double & a[], int size = 0, bool desc = false) {
   //+------------------------------------------------------------------+
   // Performs a shell sort (rapid resorting) of double array 'a'
   //  default is ascending order, unless 'desc' is set to true
   int n = ArraySize(a);
   if (size > 0) n = size;
   int j, i, m;
   double mid;
   for (m = n / 2; m > 0; m /= 2) {
      for (j = m; j < n; j++) {
         for (i = j - m; i >= 0; i -= m) {
            if (desc) {
               if (a[i + m] <= a[i])
                  break;
               else {
                  mid = a[i];
                  a[i] = a[i + m];
                  a[i + m] = mid;
               }
            } else {
               if (a[i + m] >= a[i])
                  break;
               else {
                  mid = a[i];
                  a[i] = a[i + m];
                  a[i + m] = mid;
               }
            }
         }
      }
   }
   return;
}

//+------------------------------------------------------------------+
void ShellsortIntegerArray(int & a[], int size = 0, bool desc = false) {
   //+------------------------------------------------------------------+
   // Performs a shell sort (rapid resorting) of integer array 'a'
   //  default is ascending order, unless 'desc' is set to true
   int n = ArraySize(a);
   if (size > 0) n = size;
   int j, i, m, mid;
   for (m = n / 2; m > 0; m /= 2) {
      for (j = m; j < n; j++) {
         for (i = j - m; i >= 0; i -= m) {
            if (desc) {
               if (a[i + m] <= a[i])
                  break;
               else {
                  mid = a[i];
                  a[i] = a[i + m];
                  a[i + m] = mid;
               }
            } else {
               if (a[i + m] >= a[i])
                  break;
               else {
                  mid = a[i];
                  a[i] = a[i + m];
                  a[i + m] = mid;
               }
            }
         }
      }
   }
   return;
}

//+------------------------------------------------------------------+
void ShellsortStringArray(string & a[], int size = 0, bool desc = false) {
   //+------------------------------------------------------------------+
   // Performs a shell sort (rapid resorting) of string array 'a'
   //  default is ascending order, unless 'desc' is set to true
   int n = ArraySize(a);
   if (size > 0) n = size;
   int j, i, m;
   string mid;
   for (m = n / 2; m > 0; m /= 2) {
      for (j = m; j < n; j++) {
         for (i = j - m; i >= 0; i -= m) {
            if (desc) {
               if (a[i + m] <= a[i])
                  break;
               else {
                  mid = a[i];
                  a[i] = a[i + m];
                  a[i + m] = mid;
               }
            } else {
               if (a[i + m] >= a[i])
                  break;
               else {
                  mid = a[i];
                  a[i] = a[i + m];
                  a[i + m] = mid;
               }
            }
         }
      }
   }
   return;
}

//+------------------------------------------------------------------+
string ShellsortString(string a, bool desc = false) {
   //+------------------------------------------------------------------+
   // Performs a shell sort (rapid resorting) of string 'a'
   //  default is ascending order, unless 'desc' is set to true
   // e.g. ShellsortString("cedab") returns "abcde"
   // e.g. ShellsortString("cedab",true) returns "edcba"
   int n = StringLen(a);
   int j, i, m;
   string mid;
   for (m = n / 2; m > 0; m /= 2) {
      for (j = m; j < n; j++) {
         for (i = j - m; i >= 0; i -= m) {
            if (desc) {
               if (stringSubstrOld(a, i + m, 1) <= stringSubstrOld(a, i, 1))
                  break;
               else {
                  mid = stringSubstrOld(a, i, 1);
                  a = StringOverwrite(a, i, stringSubstrOld(a, i + m, 1));
                  a = StringOverwrite(a, i + m, mid);
               }
            } else {
               if (stringSubstrOld(a, i + m, 1) >= stringSubstrOld(a, i, 1))
                  break;
               else {
                  mid = stringSubstrOld(a, i, 1);
                  a = StringOverwrite(a, i, stringSubstrOld(a, i + m, 1));
                  a = StringOverwrite(a, i + m, mid);
               }
            }
         }
      }
   }
   return (a);
}

//+------------------------------------------------------------------+
int StrToDoubleArray(string str, double & a[], string delim = ",", int init = 0) {
   //+------------------------------------------------------------------+
   // Breaks down a single string into double array 'a' (elements delimited by 'delim')
   //  e.g. string is "1,2,3,4,5";  if delim is "," then the result will be
   //  a[0]=1.0   a[1]=2.0   a[2]=3.0   a[3]=4.0   a[4]=5.0
   //  Unused array elements are initialized by value in 'init' (default is 0)
   for (int i = 0; i < ArraySize(a); i++)
      a[i] = init;
   if (str == "") return (0);
   int z1 = -1, z2 = 0;
   if (StringRight(str, 1) != delim) str = str + delim;
   for (i = 0; i < ArraySize(a); i++) {
      z2 = StringFind(str, delim, z1 + 1);
      if (z2 > z1 + 1) a[i] = StrToNumber(stringSubstrOld(str, z1 + 1, z2 - z1 - 1));
      if (z2 >= StringLen(str) - 1) break;
      z1 = z2;
   }
   return (StringFindCount(str, delim));
}

//+------------------------------------------------------------------+
int StrToIntegerArray(string str, int & a[], string delim = ",", int init = 0) {
   //+------------------------------------------------------------------+
   // Breaks down a single string into integer array 'a' (elements delimited by 'delim')
   //  e.g. string is "1,2,3,4,5";  if delim is "," then the result will be
   //  a[0]=1   a[1]=2   a[2]=3   a[3]=4   a[4]=5
   //  Unused array elements are initialized by value in 'init' (default is 0)
   for (int i = 0; i < ArraySize(a); i++)
      a[i] = init;
   if (str == "") return (0);
   int z1 = -1, z2 = 0;
   if (StringRight(str, 1) != delim) str = str + delim;
   for (i = 0; i < ArraySize(a); i++) {
      z2 = StringFind(str, delim, z1 + 1);
      if (z2 > z1 + 1) a[i] = StrToNumber(stringSubstrOld(str, z1 + 1, z2 - z1 - 1));
      if (z2 >= StringLen(str) - 1) break;
      z1 = z2;
   }
   return (StringFindCount(str, delim));
}

//+------------------------------------------------------------------+
int StrToStringArray(string str, string & a[], string delim = ",", string init = "") {
   //+------------------------------------------------------------------+
   // Breaks down a single string into string array 'a' (elements delimited by 'delim')
   for (int i = 0; i < ArraySize(a); i++)
      a[i] = init;
   if (str == "") return (0);
   int z1 = -1, z2 = 0;
   if (StringRight(str, 1) != delim) str = str + delim;
   for (i = 0; i < ArraySize(a); i++) {
      z2 = StringFind(str, delim, z1 + 1);
      if (z2 > z1 + 1) a[i] = stringSubstrOld(str, z1 + 1, z2 - z1 - 1);
      if (z2 >= StringLen(str) - 1) break;
      z1 = z2;
   }
   return (StringFindCount(str, delim));
}

//+------------------------------------------------------------------+
int StrToColorArray(string str, int & a[], string delim = ",", color init = CLR_NONE) {
   //+------------------------------------------------------------------+
   // Breaks down a single string into color array 'a' (elements delimited by 'delim')
   //  e.g. string is "Blue,Green,Red,Yellow,White";  if delim is "," then the result will be
   //  a[0]=16711680   a[1]=32768   a[2]=255   a[3]=65535   a[4]=16777215
   //  Unused array elements are initialized by value in 'init' (default is 0)
   for (int i = 0; i < ArraySize(a); i++)
      a[i] = init;
   if (str == "") return (0);
   int z1 = -1, z2 = 0;
   if (StringRight(str, 1) != delim) str = str + delim;
   for (i = 0; i < ArraySize(a); i++) {
      z2 = StringFind(str, delim, z1 + 1);
      if (z2 > z1 + 1) a[i] = StrToColor(stringSubstrOld(str, z1 + 1, z2 - z1 - 1));
      if (z2 >= StringLen(str) - 1) break;
      z1 = z2;
   }
   return (StringFindCount(str, delim));
}

//+------------------------------------------------------------------+
string DoubleArrayToStr(double & a[], string mask = "", string delim = ",", int fromidx = 0, int thruidx = 0) {
   //+------------------------------------------------------------------+
   // Concatenates the elements of an double array into a single string, after using 'mask' to format each element
   if (thruidx == 0) thruidx = ArraySize(a);
   string str = "";
   for (int i = MathMax(0, fromidx); i < MathMin(ArraySize(a), thruidx); i++)
      if (str == "")
         str = NumberToStr(a[i], mask);
      else
         str = str + delim + NumberToStr(a[i], mask);
   return (str);
}

//+------------------------------------------------------------------+
string IntegerArrayToStr(int & a[], string mask = "", string delim = ",", int fromidx = 0, int thruidx = 0) {
   //+------------------------------------------------------------------+
   // Concatenates the elements of an inetger array into a single string, after using 'mask' to format each element
   if (thruidx == 0) thruidx = ArraySize(a);
   string str = "";
   for (int i = MathMax(0, fromidx); i < MathMin(ArraySize(a), thruidx); i++)
      if (str == "")
         str = NumberToStr(a[i], mask);
      else
         str = str + delim + NumberToStr(a[i], mask);
   return (str);
}

//+------------------------------------------------------------------+
string StringArrayToStr(string & a[], string mask = "", string delim = ",", int fromidx = 0, int thruidx = 0) {
   //+------------------------------------------------------------------+
   // Concatenates the elements of a string array into a single string
   if (thruidx == 0) thruidx = ArraySize(a);
   string str = "";
   for (int i = MathMax(0, fromidx); i < MathMin(ArraySize(a), thruidx); i++)
      if (str == "")
         str = StrToStr(a[i], mask);
      else
         str = str + delim + StrToStr(a[i], mask);
   return (str);
}

//+------------------------------------------------------------------+
string DebugDoubleArray(double & a[], string mask = "", string delim = ",", int fromidx = 0, int thruidx = 0) {
   //+------------------------------------------------------------------+
   // Outputs the contents of double array 'a', to a string, with each element prefixed by its index#
   if (thruidx == 0) thruidx = ArraySize(a);
   string str = "";
   for (int i = MathMax(0, fromidx); i < MathMin(ArraySize(a), thruidx); i++)
      if (str == "")
         str = NumberToStr(i, "'['T4']='") + NumberToStr(a[i], mask);
      else
         str = str + delim + NumberToStr(i, "'['T4']='") + NumberToStr(a[i], mask);
   return (str);
}

//+------------------------------------------------------------------+
string DebugIntegerArray(int & a[], string mask = "", string delim = ",", int fromidx = 0, int thruidx = 0) {
   //+------------------------------------------------------------------+
   // Outputs the contents of integer array 'a', to a string, with each element prefixed by its index#
   if (thruidx == 0) thruidx = ArraySize(a);
   string str = "";
   for (int i = MathMax(0, fromidx); i < MathMin(ArraySize(a), thruidx); i++)
      if (str == "")
         str = NumberToStr(i, "'['T4']='") + NumberToStr(a[i], mask);
      else
         str = str + delim + NumberToStr(i, "'['T4']='") + NumberToStr(a[i], mask);
   return (str);
}

//+------------------------------------------------------------------+
string DebugStringArray(string & a[], string mask = "", string delim = ",", int fromidx = 0, int thruidx = 0) {
   //+------------------------------------------------------------------+
   // Outputs the contents of string array 'a', to a string, with each element prefixed by its index#
   if (thruidx == 0) thruidx = ArraySize(a);
   string str = "";
   for (int i = MathMax(0, fromidx); i < MathMin(ArraySize(a), thruidx); i++)
      if (str == "")
         str = NumberToStr(i, "'['T4']='") + StrToStr(a[i], mask);
      else
         str = str + delim + NumberToStr(i, "'['T4']='") + StrToStr(a[i], mask);
   return (str);
}

//+------------------------------------------------------------------+
int LookupIntegerArray(int num, int & a[]) {
   //+------------------------------------------------------------------+
   for (int i = 0; i < ArraySize(a); i++) {
      if (num == a[i]) return (i);
   }
   return (-1);
}

//+------------------------------------------------------------------+
int LookupDoubleArray(double num, double & a[]) {
   //+------------------------------------------------------------------+
   for (int i = 0; i < ArraySize(a); i++) {
      if (num == a[i]) return (i);
   }
   return (-1);
}

//+------------------------------------------------------------------+
int LookupStringArray(string str, string & a[]) {
   //+------------------------------------------------------------------+
   for (int i = 0; i < ArraySize(a); i++) {
      if (str == a[i]) return (i);
   }
   return (-1);
}

//+------------------------------------------------------------------+
string FileSort(string fname, bool desc = false) {
   //+------------------------------------------------------------------+
   // Sorts the text file named fname, on a line by line basis
   //  (default is ascending sequence, unless desc=true)
   string a[9999];
   int h = FileOpen(fname, FILE_CSV | FILE_READ, '~');
   int i = -1;
   while (!FileIsEnding(h) && i < 9999) {
      i++;
      a[i] = FileReadString(h);
   }
   FileClose(h);
   ArrayResize(a, i);
   ShellsortStringArray(a, desc);
   h = FileOpen(fname, FILE_CSV | FILE_WRITE, '~');
   for (i = 0; i < ArraySize(a); i++) {
      FileWrite(h, a[i]);
   }
   FileClose(h);
   return (0);
}

//+------------------------------------------------------------------+
bool PlotTL(string name, bool del = false, int win = 0, datetime dt1 = 0, double prc1 = 0, datetime dt2 = 0, double prc2 = 0, int clr = 0, int width = 1, int style = 0, bool ray = false, bool bg = false, int i_vis = 0, string objtxt = "") {
   //+------------------------------------------------------------------+
   //  if (StringLen(name)<1 || dt1<=0 || prc1<=0)   return(false);
   if (del) ObjectDelete(name);
   win = MathMax(win, 0);
   if (dt2 <= 0) dt2 = dt1;
   if (prc2 <= 0) prc2 = prc1;
   if (clr < 0) clr = White;
   width = MathMax(width, 1);
   if (ObjectFind(name) < 0)
      ObjectCreate(name, OBJ_TREND, win, dt1, prc1, dt2, prc2);
   ObjectSet(name, OBJPROP_COLOR, clr);
   ObjectSet(name, OBJPROP_WIDTH, width);
   ObjectSet(name, OBJPROP_STYLE, style);
   ObjectSet(name, OBJPROP_RAY, ray);
   ObjectSet(name, OBJPROP_BACK, bg);
   ObjectSet(name, OBJPROP_TIMEFRAMES, i_vis);
   if (StringLen(objtxt) > 0)
      ObjectSetText(name, objtxt, 10, "Arial", White);
   return (true);
}

//+------------------------------------------------------------------+
bool PlotBox(string name, bool del = false, int win = 0, datetime dt1 = 0, double prc1 = 0, datetime dt2 = 0, double prc2 = 0, int clr = 0, int width = 0, int style = 0, bool bg = false, int i_vis = 0, string objtxt = "") {
   //+------------------------------------------------------------------+
   //  if (StringLen(name)<1 || dt1<=0 || prc1<=0 || dt2<=0 || prc2<=0)   return(false);
   if (del) ObjectDelete(name);
   win = MathMax(win, 0);
   if (clr < 0) clr = White;
   width = MathMax(width, 1);
   if (ObjectFind(name) < 0)
      ObjectCreate(name, OBJ_RECTANGLE, win, dt1, prc1, dt2, prc2);
   ObjectSet(name, OBJPROP_COLOR, clr);
   ObjectSet(name, OBJPROP_WIDTH, width);
   ObjectSet(name, OBJPROP_STYLE, style);
   ObjectSet(name, OBJPROP_BACK, bg);
   ObjectSet(name, OBJPROP_TIMEFRAMES, i_vis);
   if (StringLen(objtxt) > 0)
      ObjectSetText(name, objtxt, 10, "Arial", White);
   return (true);
}

//+------------------------------------------------------------------+
bool PlotArrow(string name, bool del = false, int win = 0, datetime dt1 = 0, double prc1 = 0, int clr = 0, int size = 1, int code = 159, bool bg = false, int i_vis = 0) {
   //+------------------------------------------------------------------+
   //  if (StringLen(name)<1 || dt1<=0 || prc1<=0)   return(false);
   if (del) ObjectDelete(name);
   win = MathMax(win, 0);
   if (clr < 0) clr = White;
   size = MathMax(size, 1);
   if (ObjectFind(name) < 0)
      ObjectCreate(name, OBJ_ARROW, win, dt1, prc1, 0, 0);
   ObjectSet(name, OBJPROP_ARROWCODE, code);
   ObjectSet(name, OBJPROP_COLOR, clr);
   ObjectSet(name, OBJPROP_WIDTH, size);
   ObjectSet(name, OBJPROP_BACK, bg);
   ObjectSet(name, OBJPROP_TIMEFRAMES, i_vis);
   return (true);
}

//+------------------------------------------------------------------+
bool PlotVL(string name, bool del = false, int win = 0, datetime dt1 = 0, int clr = 0, int width = 1, int style = 0, bool bg = false, int i_vis = 0, string objtxt = "") {
   //+------------------------------------------------------------------+
   //  if (StringLen(name)<1 || dt1<=0)   return(false);
   if (del) ObjectDelete(name);
   win = MathMax(win, 0);
   if (clr < 0) clr = White;
   width = MathMax(width, 1);
   if (ObjectFind(name) < 0)
      ObjectCreate(name, OBJ_VLINE, win, dt1, 0, 0, 0);
   ObjectSet(name, OBJPROP_COLOR, clr);
   ObjectSet(name, OBJPROP_WIDTH, width);
   ObjectSet(name, OBJPROP_STYLE, style);
   ObjectSet(name, OBJPROP_BACK, bg);
   ObjectSet(name, OBJPROP_TIMEFRAMES, i_vis);
   if (StringLen(objtxt) > 0)
      ObjectSetText(name, objtxt, 10, "Arial", White);
   return (true);
}

//+------------------------------------------------------------------+
bool PlotHL(string name, bool del = false, int win = 0, double prc1 = 0, int clr = 0, int width = 1, int style = 0, bool bg = false, int i_vis = 0, string objtxt = "") {
   //+------------------------------------------------------------------+
   //  if (StringLen(name)<1 || prc1<=0)   return(false);
   if (del) ObjectDelete(name);
   win = MathMax(win, 0);
   if (clr < 0) clr = White;
   width = MathMax(width, 1);
   if (ObjectFind(name) < 0)
      ObjectCreate(name, OBJ_HLINE, win, 0, prc1, 0, 0);
   ObjectSet(name, OBJPROP_COLOR, clr);
   ObjectSet(name, OBJPROP_WIDTH, width);
   ObjectSet(name, OBJPROP_STYLE, style);
   ObjectSet(name, OBJPROP_BACK, bg);
   ObjectSet(name, OBJPROP_TIMEFRAMES, i_vis);
   if (StringLen(objtxt) > 0)
      ObjectSetText(name, objtxt, 10, "Arial", White);
   return (true);
}

//+------------------------------------------------------------------+
bool PlotText(string name, bool del = false, int win = 0, datetime dt1 = 0, double prc1 = 0, string text = " ", int clr = 0, int size = 12, string font = "Arial", double angle = 0, bool bg = false, int i_vis = 0) {
   //+------------------------------------------------------------------+
   //  if (StringLen(name)<1 || dt1<=0 || prc1<=0)   return(false);
   if (del) ObjectDelete(name);
   win = MathMax(win, 0);
   if (clr < 0) clr = White;
   size = MathMax(size, 8);
   if (ObjectFind(name) < 0)
      ObjectCreate(name, OBJ_TEXT, win, dt1, prc1);
   ObjectSetText(name, text, size, font, clr);
   ObjectSet(name, OBJPROP_BACK, bg);
   ObjectSet(name, OBJPROP_TIMEFRAMES, i_vis);
   ObjectSet(name, OBJPROP_ANGLE, angle);
   return (true);
}

//+------------------------------------------------------------------+
bool PlotLabel(string name, bool del = false, int win = 0, int cnr = 0, int hpos = 0, int vpos = 0, string text = " ", int clr = 0, int size = 12, string font = "Arial", double angle = 0, bool bg = false, int i_vis = 0) {
   //+------------------------------------------------------------------+
   //  if (StringLen(name)<1 || hpos<0 || vpos<=0)   return(false);
   if (del) ObjectDelete(name);
   win = MathMax(win, 0);
   cnr = MathMax(cnr, 0);
   if (clr < 0) clr = White;
   size = MathMax(size, 8);
   if (ObjectFind(name) < 0)
      ObjectCreate(name, OBJ_LABEL, win, 0, 0, 0, 0);
   ObjectSet(name, OBJPROP_CORNER, cnr);
   ObjectSet(name, OBJPROP_XDISTANCE, hpos);
   ObjectSet(name, OBJPROP_YDISTANCE, vpos);
   ObjectSetText(name, text, size, font, clr);
   ObjectSet(name, OBJPROP_BACK, bg);
   ObjectSet(name, OBJPROP_TIMEFRAMES, i_vis);
   ObjectSet(name, OBJPROP_ANGLE, angle);
   return (true);
}

//+------------------------------------------------------------------+
int iRegr(double & pips, double & slope, double & stdev, double & prc0, double & prc1, int polynomial_degree = 1, int bars_in_window = 30, int historical_shift = 0, double std_deviations = 1, string symbol = "", string per = "") {
   //+------------------------------------------------------------------+
   // Original i-Regr: https://www.mql5.com/en/code/8417
   // Updated to b600: https://www.mql5.com/en/code/11749

   if (StringLen(StringTrim(symbol)) < 1) symbol = Symbol();
   double d_pnt = MarketInfo(symbol, MODE_POINT);
   int i_dig = MarketInfo(symbol, MODE_DIGITS);
   if (d_pnt <= 0 || i_dig <= 0) return (-1);
   if (i_dig == 3 || i_dig == 5) d_pnt *= 10;
   int period = StrToTF(per);
   if (period < 0) return (-1);
   //  log(symbol, period, polynomial_degree, std_deviations, bars_in_window, historical_shift);

   double fx[1], sqh[1], sql[1];
   double ai[10, 10], b[10], x[10], sx[20];
   double sum;
   int ip, p, n;
   double qq, mm, tt;
   int ii, jj, kk, ll, nn;
   double sq;
   int i0 = 0;
   i0 = historical_shift;
   if (iBars(symbol, period) < bars_in_window) return (-1);
   int mi;
   ip = bars_in_window;
   p = ip;
   sx[1] = p + 1;
   nn = polynomial_degree + 1;
   ArrayResize(fx, i0 + p + 1);
   ArrayResize(sqh, i0 + p + 1);
   ArrayResize(sql, i0 + p + 1);
   //----------------------sx-------------------------------------------------------------------
   for (mi = 1; mi <= nn * 2 - 2; mi++) {
      sum = 0;
      for (n = i0; n <= i0 + p; n++) {
         sum += MathPow(n, mi);
      }
      sx[mi + 1] = sum;
   }
   //----------------------syx-----------
   for (mi = 1; mi <= nn; mi++) {
      sum = 0.00000;
      for (n = i0; n <= i0 + p; n++) {
         if (mi == 1)
            sum += iClose(symbol, period, n);
         else
            sum += iClose(symbol, period, n) * MathPow(n, mi - 1);
      }
      b[mi] = sum;
   }
   //===============Matrix=======================================================================================================
   for (jj = 1; jj <= nn; jj++) {
      for (ii = 1; ii <= nn; ii++) {
         kk = ii + jj - 1;
         ai[ii, jj] = sx[kk];
      }
   }
   //===============Gauss========================================================================================================
   for (kk = 1; kk <= nn - 1; kk++) {
      ll = 0;
      mm = 0;
      for (ii = kk; ii <= nn; ii++) {
         if (MathAbs(ai[ii, kk]) > mm) {
            mm = MathAbs(ai[ii, kk]);
            ll = ii;
         }
      }
      if (ll == 0) return (0);
      if (ll != kk) {
         for (jj = 1; jj <= nn; jj++) {
            tt = ai[kk, jj];
            ai[kk, jj] = ai[ll, jj];
            ai[ll, jj] = tt;
         }
         tt = b[kk];
         b[kk] = b[ll];
         b[ll] = tt;
      }
      for (ii = kk + 1; ii <= nn; ii++) {
         qq = ai[ii, kk] / ai[kk, kk];
         for (jj = 1; jj <= nn; jj++) {
            if (jj == kk)
               ai[ii, jj] = 0;
            else
               ai[ii, jj] = ai[ii, jj] - qq * ai[kk, jj];
         }
         b[ii] = b[ii] - qq * b[kk];
      }
   }
   x[nn] = b[nn] / ai[nn, nn];
   for (ii = nn - 1; ii >= 1; ii--) {
      tt = 0;
      for (jj = 1; jj <= nn - ii; jj++) {
         tt = tt + ai[ii, ii + jj] * x[ii + jj];
         x[ii] = (1 / ai[ii, ii]) * (b[ii] - tt);
      }
   }
   //===========================================================================================================================
   for (n = i0; n <= i0 + p; n++) {
      sum = 0;
      for (kk = 1; kk <= polynomial_degree; kk++) {
         sum += x[kk + 1] * MathPow(n, kk);
      }
      fx[n] = x[1] + sum;
   }
   //-----------------------------------Std-----------------------------------------------------------------------------------
   sq = 0.0;
   for (n = i0; n <= i0 + p; n++) {
      sq += MathPow(iClose(symbol, period, n) - fx[n], 2);
   }
   sq = MathSqrt(sq / (p + 1));
   for (n = i0; n <= i0 + p; n++) {
      sqh[n] = fx[n] + sq * std_deviations;
      sql[n] = fx[n] - sq * std_deviations;
   }
   prc0 = fx[i0];
   prc1 = fx[i0 + p];
   pips = (fx[i0] - fx[i0 + p]) / d_pnt;
   slope = pips / p;
   stdev = sq / d_pnt;
   return (0);
}

// ===========================================  DEBUGGING ===========================================

//+------------------------------------------------------------------+
string d(string s1 = "", string s2 = "", string s3 = "", string s4 = "", string s5 = "", string s6 = "", string s7 = "", string s8 = "",
   string s9 = "", string s10 = "", string s11 = "", string s12 = "", string s13 = "", string s14 = "", string s15 = "") {
   //+------------------------------------------------------------------+
   // Outputs up to 15 values to the DEBUG.TXT file (after creating the file, if it doesn't already exist)
   string out = StringTrimRight(StringConcatenate(s1, " ", s2, " ", s3, " ", s4, " ", s5, " ", s6, " ", s7, " ", s8, " ",
      s9, " ", s10, " ", s11, " ", s12, " ", s13, " ", s14, " ", s15));
   int h = FileOpen("debug.txt", FILE_CSV | FILE_READ | FILE_WRITE, '~');
   FileSeek(h, 0, SEEK_END);
   FileWrite(h, out);
   FileClose(h);
   //return(0);
   return (out);
}

//+------------------------------------------------------------------+
string dd(string s1 = "", string s2 = "", string s3 = "", string s4 = "", string s5 = "", string s6 = "", string s7 = "", string s8 = "",
   string s9 = "", string s10 = "", string s11 = "", string s12 = "", string s13 = "", string s14 = "", string s15 = "") {
   //+------------------------------------------------------------------+
   // Deletes and re-creates the DEBUG.TXT file, and adds up to 15 values to it
   string out = StringTrimRight(StringConcatenate(s1, " ", s2, " ", s3, " ", s4, " ", s5, " ", s6, " ", s7, " ", s8, " ",
      s9, " ", s10, " ", s11, " ", s12, " ", s13, " ", s14, " ", s15));
   int h = FileOpen("debug.txt", FILE_CSV | FILE_WRITE, '~');
   FileWrite(h, out);
   FileClose(h);
   //return(0);
   return (out);
}

/*
// Search tags: "DEBUG b600_Code" "b600_b509"  NO EDITS NECESSARY, but this is useful migration information:
//
// EXAMPLE for how to DEBUG b509 code to capture calls and returns which you
// can grab from the Experts log file, edit, and then put into a simple b600 *script*, 
// that tests whether the b600 output is the same output as was obtained by b509 code.
// The Experts Log file is at:  MT4 menu: File->Open Data Folder => MQL4\Logs\20170506.log  (example name)
//+------------------------------------------------------------------+
// Optional to use the original name and code, or make a copy of the function. 
// (Fyi, a copy is useful for further b600 debugging once you find differences)
string NumberToStr2(double n, string mask="") 
{
   // If the program modifies arguments, capture the original values at the top:
   double orig_n=n;
   string orig_mask=mask;
   //
   string ltext,outstr,rtext;
   //... (the code body here)
   //
   // Examine the final "return" below to see what you will output with print statements:
   Print("DEBUG b600_Code: str = NumberToStr2(",orig_n,", \"",orig_mask,"\");","  // returns=\"",ltext+outstr+rtext,"\"");
   Print("DEBUG b600_Code: if(str != \"",ltext+outstr+rtext,"\") Print(\"NumberToStr2 DIFFERS. str=\",str,\"  Expecting=\\\"",ltext+outstr+rtext,"\");");
   //
   // NOTE! If you have other "return" statements, copy the Print lines and put them just 
   // before *each* return. Edit as needed, to capture the true return value. 
   //
   return(ltext+outstr+rtext);
}

//+------------------------------------------------------------------+
// MQL4\Scripts\test_function.mq4  // NOTE: THIS IS A *SCRIPT*, not an indicator
#include <hanover --- function header b600 (np).mqh>
#include <hanover --- extensible functions b600 (np).mqh>
void OnStart()
{
   //---
   string str; 
   str = NumberToStr2(13.2649, "' ='R~1.1%");  // returns=" =~.3%"
   if(str != " =~.3%") Print("NumberToStr2 DIFFERS. str=",str,"  Expecting=\" =~.3%");
   return;
}
//+------------------------------------------------------------------+
*/
