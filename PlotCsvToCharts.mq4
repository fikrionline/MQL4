//+------------------------------------------------------------------+
//|                                        PlotCsvOnChartsScript.mq4 |
//|                                                      nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "nicholishen"
#property link "https://www.forexfactory.com/nicholishen"
#property version "1.00"
#property strict
#property script_show_inputs#include <ChartObjects\ChartObjectsArrows.mqh>

#include <ChartObjects\ChartObjectsLines.mqh>

#include <Arrays\ArrayObj.mqh>

#include <Files\File.mqh>

#include <stdlib.mqh>

/*
TODO: 
 
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PlotTrade: public CObject {
   protected: CChartObjectArrow m_in;
   CChartObjectArrow m_out;
   CChartObjectTrend m_line;
   static ulong s_count;
   string m_tooltip;
   public: PlotTrade() {}
   virtual bool create(long chart_id, string symbol,
      int order_type, double size,
      datetime time_open, double price_open,
      datetime time_close, double price_close,
      double profit) {
      string name = "__plot_" + string(++s_count) + "_";
      int digits = (int) SymbolInfoInteger(symbol, SYMBOL_DIGITS);
      m_tooltip = StringFormat("%s %.2f\n%s\n%s\n%s\n%s\nProfit: %s",
         order_type == OP_BUY ? "BUY" : "SELL", size,
         TimeToString(time_open), DoubleToString(price_open, digits),
         TimeToString(time_close), DoubleToString(price_close, digits),
         DoubleToString(profit, 2)
      );
      color line_col = order_type == OP_BUY ? clrDodgerBlue : clrRed;
      if (!m_in.Create(chart_id, name + "in", 0, time_open, price_open, 1) ||
         !m_out.Create(chart_id, name + "out", 0, time_close, price_close, 3) ||
         !m_line.Create(chart_id, name + "line", 0,
            time_open, price_open,
            time_close, price_close
         ) ||
         !m_line.RayRight(false) ||
         !m_in.Color(line_col) ||
         !m_line.Color(line_col) ||
         !m_line.Style(STYLE_DOT) ||
         !m_in.Tooltip(m_tooltip) ||
         !m_out.Tooltip(m_tooltip) ||
         !m_line.Tooltip(m_tooltip)
      )
         return false;
      return true;
   }
   virtual string tooltip() const {
      return m_tooltip;
   }
   virtual bool tooltip(const string tip) {
      m_tooltip = tip;
      return (
         m_in.Tooltip(tip) &&
         m_out.Tooltip(tip) &&
         m_line.Tooltip(tip)
      );
   }
   virtual int Compare(const CObject * node,
      const int mode = 0) const override {
      const PlotTrade * other = node;
      if (this.m_in.Time(0) > other.m_in.Time(0)) return 1;
      if (this.m_in.Time(0) < other.m_in.Time(0)) return -1;
      return 0;
   }

};
ulong PlotTrade::s_count = 0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class PlotTradeSignalRow: public PlotTrade {
   protected: long m_chart_id;
   string m_symbol;
   ENUM_TIMEFRAMES m_timeframe;
   int m_offset;
   string m_header[];
   string m_data[];
   public: PlotTradeSignalRow(string header, ENUM_TIMEFRAMES timeframe, int offset) {
      StringSplit(header, ';', m_header);
      m_timeframe = timeframe;
      m_offset = offset * 60 * 60;
   }
   virtual bool create(string row) {
      if (StringSplit(row, ';', m_data) < 1)
         return false;
      m_symbol = _get("symbol");
      if (!chart_map(m_symbol, m_chart_id, m_timeframe))
         return false;
      int digits = (int) SymbolInfoInteger(m_symbol, SYMBOL_DIGITS);
      string order = _get("type");
      if (!(order == "Buy" || order == "Sell"))
         return false;
      int order_type = order == "Buy" ? OP_BUY : OP_SELL;
      double size = double(_get("volume"));
      datetime time_open = StringToTime(_get("time"));
      time_open += m_offset;
      double price_open = double(_get("price"));
      datetime time_close = StringToTime(_get("time", 2));
      time_close += m_offset;
      double price_close = double(_get("price", 2));
      double profit = double(_get("profit"));
      string comment = _get("comment");
      if (price_close <= 0.0 || price_open <= 0.0 || time_open == 0 || time_close == 0)
         return false;
      bool parent_create = PlotTrade::create(
         m_chart_id, m_symbol, order_type, size,
         time_open, price_open, time_close, price_close, profit
      );
      if (!parent_create)
         return false;
      this.tooltip(m_symbol + " " + this.tooltip());
      m_in.Detach();
      m_out.Detach();
      m_line.Detach();
      return true;
   }
   protected: string _get(string title, int count = 1) {
      int cnt = 0;
      int index = -1;
      int total = ArraySize(m_header);
      for (int i = 0; i < total; i++) {
         if (StringCompare(m_header[i], title, false) == 0) {
            if (++cnt == count) {
               index = i;
               break;
            }
         }
      }
      return index >= 0 && index < total ? m_data[index] : NULL;
   }
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ChartAndSymbol: public CObject {
   public: ChartAndSymbol(string sym): symbol(sym),
   chart_id(-1) {}
   string symbol;
   long chart_id;
   virtual int Compare(const CObject * node,
      const int mode = 0) const override {
      const ChartAndSymbol * other = node;
      if (StringFind(this.symbol, other.symbol) >= 0 ||
         StringFind(other.symbol, this.symbol) >= 0
      )
         return 0;
      return StringCompare(this.symbol, other.symbol, false);
   }
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool chart_map(string & symbol, long & chart_id, ENUM_TIMEFRAMES timeframe) {
   static CArrayObj list;
   list.Sort();
   ChartAndSymbol * s = new ChartAndSymbol(symbol);
   int index = list.Search(s);
   if (index >= 0) {
      delete s;
      s = list.At(index);
      chart_id = s.chart_id;
      return true;
   }
   int i;
   string symbol_name = NULL;
   for (i = SymbolsTotal(false) - 1; i >= 0; --i) {
      symbol_name = SymbolName(i, false);
      if (StringFind(symbol_name, symbol) >= 0)
         break;
   }
   if (i < 0) {
      delete s;
      return false;
   }
   long id = ChartOpen(symbol_name, timeframe);
   if (id < 0) {
      delete s;
      return false;
   }
   ChartSetInteger(id, CHART_AUTOSCROLL, false);
   s.symbol = symbol_name;
   symbol = symbol_name;
   s.chart_id = id;
   chart_id = id;
   list.Add(s);
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class FileCsv: public CFile {
   public: bool OpenRead(const string file_name) {
      return (CFile::Open(file_name, FILE_READ | FILE_CSV) != INVALID_HANDLE);
   }
   string read_row() {
      return FileReadString(this.Handle());
   }
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input string inp_folder_name = "SignalPlotter"; //CSV Folder Name
input string inp_file_name = "history.csv"; //CSV File Name
input ENUM_TIMEFRAMES inp_timeframe = PERIOD_M5; //Charts timeframe
input int inp_hour_offset = 0; //Hour offset 

void OnStart() {
   FileCsv file;
   CArrayObj list;
   if (!file.OpenRead(inp_folder_name + "//" + inp_file_name)) {
      Alert("FileOpenError: ", ErrorDescription(_LastError));
      return;
   }
   string header = file.read_row();
   while (!file.IsEnding()) {
      PlotTradeSignalRow * row = new PlotTradeSignalRow(
         header, inp_timeframe, inp_hour_offset
      );
      list.Add(row);
      if (!row.create(file.read_row()))
         Print("Row not plotted");
   }
}
