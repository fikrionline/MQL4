//+------------------------------------------------------------------+
//|                                                 FractalLines.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
//---- input parameters
extern int  lines = 5;  //Êîëè÷åñòâî âèäèìûõ ôðàêòàëüíûõ ëèíèé
extern int  MaxFractals = 10000;
extern bool ShowHorisontalLines = true;
extern bool ShowFractalLines = true; 
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//--- my variables
double bufUpPrice[10000];   //ìàññèâ öåí Up ôðàêòàëîâ
double bufUpDate[10000];    //ìàññèâ äàò Up ôðàêòàëîâ
double bufDownPrice[10000]; //ìàññèâ öåí Down ôðàêòàëîâ
double bufDownDate[10000];  //ìàññèâ äàò Down ôðàêòàëîâ
int Up = 0;    //ñ÷åò÷èê Up ôðàêòàëîâ
int Down = 0;  //ñ÷åò÷èê Down ôðàêòàëîâ
//+------------------------------------------------------------------+
//| Ôóíêöèÿ LevelCalculate ñ÷èòàåò çíà÷åíèå öåíû ïðîáèòèÿ ôðàêòàëüíîé|
//| ëèíèè ïî ïðîñòåéøèì óðàâíèíèÿì àíàëèòè÷åñêîé ãåîìåòðèè           |
//+------------------------------------------------------------------+
double LevelCalculate(double Price1, double Time1, double Price2,  
                      double Time2, double NewTime)
  {
   double level;
   if(Time2 != Time1) // Íà âñÿêèé ñëó÷àé, ÷òîáû íå áûëî äåëåíèÿ íà 0.
       level = (NewTime - Time1)*(Price2 - Price1) / (Time2-Time1) + Price1;
   else
       return(Price2);
   return(level);
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 217);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 218);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexEmptyValue(1, 0.0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
//---- ïîñëåäíèé ïîñ÷èòàííûé áàð áóäåò ïåðåñ÷èòàí   
   if(counted_bars > 0) 
       counted_bars--;
   int limit = Bars - counted_bars;
//Ïîæàëóé, ðàññòàâèì ñòðåëêè â ìîìåíò ïðîáèòèÿ ôðàêòàëüíûõ ëèíèé, îöåíèì ýôôåêòèâíîñòü
//Èäåÿ ïîçàèìñòâîâàíà ó Rosha, íàäåþñü, íå îáèäèòñÿ :)    
   string arrowName; // çäåñü áóäóò íàçíà÷àòüñÿ óíèêàëüíîå èìÿ îáúåêòà-ñòðåëêè
//Íîìåð ïðîáèòîãî ôðàêòàëà
//Ïðîáèòèå ôðàêòàëüíîé ëèíèè
   int FractalUp = 0;
   int FractalDown = 0;
//Ïðîñòîå ïðîáèòèå ôðàêòàëà
   int SimpleFractalUp = 0;
   int SimpleFractalDown = 0;
   double BuyFractalLevel = 0;  //óðîâåíü ïðîáèòèÿ ôðàêòàëüíîé ëèíèè Up
   double SellFractalLevel = 0; //óðîâåíü ïðîáèòèÿ ôðàêòàëüíîé ëèíèè Down
   double buf = 0; // áóôåðíîé çíà÷åíèå íàëè÷èå ôðàêòàëà, åñëè 0, òî ôðàêòàëà íåò
//---- îñíîâíîé öèêë       
   for(int i = limit; i>0; i--)
     {   
       //Ðèñóåì ïðîñòûå ôðàêòàëüíûå óðîâíè
       //Îïðåäåëèì òåêóùèå ôðàêòàëüíûå óðîâíè 
       BuyFractalLevel = LevelCalculate(bufUpPrice[Up], bufUpDate[Up], bufUpPrice[Up-1],
                                        bufUpDate[Up-1], Time[i]);
       //Äâèãàåì âòîðóþ êîîðäèíàòó ôðàêòàëüíîé ïðÿìîé Up                              
       ObjectSet("LineUp" + Up, OBJPROP_TIME1, Time[i]);
       ObjectSet("LineUp" + Up, OBJPROP_PRICE1, BuyFractalLevel); 
       SellFractalLevel = LevelCalculate(bufDownPrice[Down], bufDownDate[Down], 
                                         bufDownPrice[Down-1], bufDownDate[Down-1], Time[i]);
       //Äâèãàåì âòîðóþ êîîðäèíàòó ôðàêòàëüíîé ïðÿìîé Down                                
       ObjectSet("LineDown" + Down, OBJPROP_TIME1, Time[i]);
       ObjectSet("LineDown" + Down, OBJPROP_PRICE1, SellFractalLevel);
       //Èùåì ïðîñòîå ïðîáèòèå
       if(Close[i] > ObjectGet("SimpleUp" + Up, OBJPROP_PRICE1) && (Up > SimpleFractalUp))
         {
           arrowName = "SimleUpArrow" + Up;
           ObjectCreate(arrowName, OBJ_ARROW, 0, Time[i-1], Low[i-1] - Point*10);
           ObjectSet(arrowName, OBJPROP_ARROWCODE, 241);
           ObjectSet(arrowName, OBJPROP_COLOR, Brown);
           SimpleFractalUp = Up;             
         }
       if(Close[i] < ObjectGet("SimpleDown" + Down, OBJPROP_PRICE1) && 
          (Down > SimpleFractalDown))
         {
           arrowName = "SimleUpArrow" + Down;
           ObjectCreate(arrowName, OBJ_ARROW, 0, Time[i-1], High[i-1] + Point*10);
           ObjectSet(arrowName, OBJPROP_ARROWCODE, 242);
           ObjectSet(arrowName, OBJPROP_COLOR, Brown);
           SimpleFractalDown = Down;
         }
       //Èùåì ñëîæíîå ïðîáèòèå
       if((Close[i] > BuyFractalLevel) && (Up > FractalUp)) 
         {
           //Ñòàâèì ñòðåëî÷êó ââåðõ
           arrowName = "UpArrow" + Up;
           ObjectCreate(arrowName, OBJ_ARROW, 0, Time[i-1], Low[i-1] - Point*10);
           ObjectSet(arrowName, OBJPROP_ARROWCODE, 241);
           ObjectSet(arrowName, OBJPROP_COLOR, Blue);
           FractalUp = Up;        
         }                                 
       if((Close[i] < SellFractalLevel) && (Down > FractalDown))
         {
           //Ñòàâèì ñòðåëî÷êó ââåðõ
           arrowName = "DownArrow" + Down;
           ObjectCreate(arrowName, OBJ_ARROW, 0, Time[i-1], High[i-1] + Point*10);
           ObjectSet(arrowName, OBJPROP_ARROWCODE, 242);
           ObjectSet(arrowName, OBJPROP_COLOR, Red); 
           FractalDown = Down;       
         }
       //Ðèñóåì ñàì ôðàêòàë  Up
       ExtMapBuffer1[i] = iFractals(NULL, 0, MODE_UPPER, i);
       //Åñëè îí åñòü, òî çàíîñèì åãî â ìàññèâ ôðàêòàëîâ
       buf = iFractals(NULL, 0, MODE_UPPER, i);
       if(buf != 0)
         {
           Up++;
           bufUpPrice[Up] = iFractals(NULL, 0, MODE_UPPER, i);
           bufUpDate[Up] = Time[i];
           //Òåêóùèé óðîâåíü ïðîáèòèÿ ôðàêòàëà - ñàì ôðàêòàë
           BuyFractalLevel = bufUpPrice[Up];
           if(Up > 1)
             {
               //Ïðîñòîé ôðàêòàë
               ObjectCreate("SimpleUp" + Up, OBJ_TREND, 0, bufUpDate[Up], 
                            bufUpPrice[Up], Time[i-1], bufUpPrice[Up]);
               ObjectSet("SimpleUp" + Up, OBJPROP_COLOR, Aqua);
               ObjectSet("SimpleUp" + Up, OBJPROP_RAY, True);   
               //×åðòèì ôðàêòàëüíûå ëèíèè ïî 2 êîîðäèíàòàì
               ObjectCreate("LineUp" + Up, OBJ_TREND, 0, bufUpDate[Up], 
                            bufUpPrice[Up], bufUpDate[Up-1], bufUpPrice[Up-1]); 
               ObjectSet("LineUp" + Up, OBJPROP_COLOR, Blue);
               ObjectSet("LineUp" + Up, OBJPROP_RAY, False);
               //Óäàëÿåì óñòàðåâøèè ëèíèè
               if(Up > lines + 1)
                 {
                   ObjectDelete("LineUp" + (Up - lines));
                   ObjectDelete("SimpleUp" + (Up - lines));                  
                 }
             }     
         }
       //Àíàëîãè÷íûé áëîê, íî íà Down ôðàêòàëû
       ExtMapBuffer2[i] = iFractals(NULL, 0, MODE_LOWER, i);
       buf = iFractals(NULL, 0, MODE_LOWER, i);    
       if(buf != 0)
         {
           Down++;
           bufDownPrice[Down] = iFractals(NULL, 0, MODE_LOWER, i);
           bufDownDate[Down] = Time[i];
           SellFractalLevel = bufDownPrice[Down];                           
           if(Down > 1)
             {
               ObjectCreate("SimpleDown" + Down, OBJ_TREND, 0, bufDownDate[Down], 
                            bufDownPrice[Down], Time[i-1], bufDownPrice[Down]);        
               ObjectSet("SimpleDown" + Down, OBJPROP_COLOR, LightCoral);
               ObjectSet("SimpleDown" + Down, OBJPROP_RAY, True);                
               ObjectCreate("LineDown" + Down, OBJ_TREND, 0, bufDownDate[Down], 
                            bufDownPrice[Down], bufDownDate[Down-1], bufDownPrice[Down-1]);        
               ObjectSet("LineDown" + Down, OBJPROP_COLOR, Red);
               ObjectSet("LineDown" + Down, OBJPROP_RAY, False);
               if(Down > lines + 1)
                 {
                   ObjectDelete("LineDown" + (Down - lines));
                   ObjectDelete("SimpleDown" + (Down - lines));
                 }            
             }   
         }           
       if(!ShowHorisontalLines)
         {   
           ObjectDelete("SimpleDown" + Down);              
           ObjectDelete("SimpleUp" + Up);                
         }
       if(!ShowFractalLines)
         {
           ObjectDelete("LineDown" + Down);        
           ObjectDelete("LineUp" + Up);
         }          
     }   
//----
   return(0);
  }
//+------------------------------------------------------------------+