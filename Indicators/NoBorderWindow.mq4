//----------------------------------------------------------------------------------------------------------------------------
#property copyright "unknown"
#property link "mladenfx@gmail.com"
#property description "made as indicator by mladen"
//----------------------------------------------------------------------------------------------------------------------------
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots 0
//----------------------------------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------------------------------
//
//
//
//
//

#define _name "_toggleButton"
int OnInit() {
   if (ObjectFind(0, _name) < 0)
      ObjectCreate(0, _name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, _name, OBJPROP_XDISTANCE, 50);
   ObjectSetInteger(0, _name, OBJPROP_YDISTANCE, 30);
   ObjectSetInteger(0, _name, OBJPROP_XSIZE, 45);
   ObjectSetInteger(0, _name, OBJPROP_YSIZE, 25);
   ObjectSetInteger(0, _name, OBJPROP_CORNER, CORNER_RIGHT_LOWER);
   ObjectSetInteger(0, _name, OBJPROP_ANCHOR, ANCHOR_RIGHT_LOWER);
   ObjectSetInteger(0, _name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, _name, OBJPROP_BGCOLOR, clrGainsboro);
   ObjectSetInteger(0, _name, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetString(0, _name, OBJPROP_TEXT, ObjectGetInteger(0, _name, OBJPROP_STATE) ? "ON" : "OFF");
   manageWindows(ObjectGetInteger(0, _name, OBJPROP_STATE));

   return (INIT_SUCCEEDED);
}
void OnDeinit(const int reason) {
   if (reason == REASON_REMOVE) ObjectDelete(0, _name);
   return;
}
int OnCalculate(const int rates_total,
   const int prev_calculated,
      const datetime & time[],
         const double & open[],
            const double & high[],
               const double & low[],
                  const double & close[],
                     const long & tick_volume[],
                        const long & volume[],
                           const int & spread[]) {
   return (rates_total);
}

//
//
//
//
//

void OnChartEvent(const int id,
   const long & lparam,
      const double & dparam,
         const string & sparam) {
   if (id == CHARTEVENT_OBJECT_CLICK && sparam == _name) {
      ObjectSetString(0, _name, OBJPROP_TEXT, ObjectGetInteger(0, _name, OBJPROP_STATE) ? "ON" : "OFF");
      manageWindows(ObjectGetInteger(0, _name, OBJPROP_STATE));
   }
   return;
}

//----------------------------------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------------------------------
//
//
//
//
//
//

#import "user32.dll"
int SetWindowLongA(int hWnd, int nIndex, int dwNewLong);
int GetWindowLongA(int hWnd, int nIndex);
int SetWindowPos(int hWnd, int hWndInsertAfter, int X, int Y, int cx, int cy, int uFlags);
int GetParent(int hWnd);
int GetTopWindow(int hWnd);
int GetWindow(int hWnd, int wCmd);
#import

#define GWL_STYLE - 16
#define WS_CAPTION 0x00C00000
#define WS_BORDER 0x00800000
#define WS_SIZEBOX 0x00040000
#define WS_DLGFRAME 0x00400000
#define SWP_NOSIZE 0x0001
#define SWP_NOMOVE 0x0002
#define SWP_NOZORDER 0x0004
#define SWP_NOACTIVATE 0x0010
#define SWP_FRAMECHANGED 0x0020
#define GW_CHILD 0x0005
#define GW_HWNDNEXT 0x0002

void manageWindows(bool state) {
   int hChartParent = GetParent((int) ChartGetInteger(ChartID(), CHART_WINDOW_HANDLE));
   int hMDIClient = GetParent(hChartParent);
   int hChildWindow = GetTopWindow(hMDIClient);

   //
   //
   //
   //
   //

   while (hChildWindow > 0) {
      ManageBorderByWindowHandle(hChildWindow, state);
      hChildWindow = GetWindow(hChildWindow, GW_HWNDNEXT);
   }
}
void ManageBorderByWindowHandle(int hWindow, bool state) {
   int iNewStyle;
   if (state)
      iNewStyle = GetWindowLongA(hWindow, GWL_STYLE) & (~(WS_BORDER | WS_DLGFRAME | WS_SIZEBOX));
   else iNewStyle = GetWindowLongA(hWindow, GWL_STYLE) | ((WS_BORDER | WS_DLGFRAME | WS_SIZEBOX));

   if (hWindow > 0 && iNewStyle > 0) {
      SetWindowLongA(hWindow, GWL_STYLE, iNewStyle);
      SetWindowPos(hWindow, 0, 0, 0, 0, 0, SWP_NOZORDER | SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE | SWP_FRAMECHANGED);
   }
}
