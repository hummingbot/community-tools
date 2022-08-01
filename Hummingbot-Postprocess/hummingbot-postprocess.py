from datetime import datetime, timedelta
from os import error
import ccxt
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from prettytable import PrettyTable


# Enter/modify the following: 
exchange = 'ascendex'
market = 'CNTR/USDT'
start_time = datetime(2022, 2, 9, 22, 00, 00) #Year, Month, Day, Hour, Minute, Second
trades_path = '/Users/xxx/CNTR_bot/hummingbot_data/trades.csv'
fees_percent = 0.2

# Automatic calcualtion of candlestick interval
def calc_candlestick_interval(start_time, max_limit=500):
    duration = datetime.now() - start_time
    seconds = duration.total_seconds()
    minutes = int(seconds // 60)
    if minutes < max_limit:
        interval = '1m'
        lim = minutes
    elif max_limit <= minutes <= 5*max_limit:
        interval = '5m'
        lim = minutes // 5
    elif 5*max_limit <= minutes <= 15*max_limit:
        interval = '15m'
        lim = minutes // 15
    elif 15*max_limit <= minutes <= 30*max_limit:
        interval = '30m'
        lim = minutes // 30
    elif 30*max_limit <= minutes <= 60*max_limit:
        interval = '1h'
        lim = minutes // 60
    else:
        print("Start time is too long back. Please select a closer time")
        exit()

    return lim, interval

# Fetching data from exchange
lim, candlestick_interval = calc_candlestick_interval(start_time) 
exchange = eval("ccxt." + exchange +"()")
bars = exchange.fetch_ohlcv(market, timeframe=candlestick_interval, limit=lim)
df_bars = pd.DataFrame(bars[:-1], columns=['timestamp', 'open', 'high', 'low', 'close', 'volume'])
df_bars['timestamp'] = pd.to_datetime(df_bars['timestamp'], unit='ms')
df_bars = df_bars[df_bars['timestamp'] > start_time]

# Fetching local hummingbot trade data
df_trades = pd.read_csv(trades_path, usecols=['amount','price','timestamp','trade_fee','trade_type'])
df_trades['timestamp'] = pd.to_datetime(df_trades['timestamp'], unit='ms')
df_trades = df_trades[df_trades['timestamp'] > start_time]

# Postprocessing
buy_trades = df_trades[df_trades['trade_type']=="BUY"]
sell_trades = df_trades[df_trades['trade_type']=="SELL"]
market_change = (df_bars['close'].iloc[-1] - df_bars['close'].iloc[0])/df_bars['close'].iloc[-1]*100 
avg_buy = sum(buy_trades['amount']*buy_trades['price'])/sum(buy_trades['amount'])
avg_sell = sum(sell_trades['amount']*sell_trades['price'])/sum(sell_trades['amount'])
avg_spread = avg_sell - avg_buy
n_buys = len(buy_trades.index)
total_buy_amount = sum(buy_trades['amount'])
total_sell_amount = sum(sell_trades['amount'])
n_sells = len(sell_trades.index)
trade_volume = sum(sell_trades['amount']*sell_trades['price']) + sum(buy_trades['amount']*buy_trades['price'])
fees = fees_percent/100*trade_volume
trade_pnl = avg_spread*trade_volume/(2*df_bars['close'].iloc[-1]) - fees

#Plot buys and sells with price history 
fig1 = px.line(df_bars, x="timestamp", y="high")
fig2 = px.line(df_bars, x="timestamp", y="low")
fig3 = px.scatter(df_trades, x="timestamp", y="price", color="trade_type")
fig3.update_traces(marker=dict(size=12, line=dict(width=2, color='DarkSlateGrey')))
fig5 = go.Figure(data=fig1.data + fig2.data + fig3.data) 
fig5.show()

#Print statistics 
print('\n\n' + "***********RUN STATISTICS*******************" + '\n')

t = PrettyTable(['Description', 'Value'])
t.add_row(['Market', market])
t.add_row(['Start date&time', start_time])
t.add_row(['Market change percentage', "{:.2f}".format(market_change)])
t.add_row(['Number of buy trades', n_buys])
t.add_row(['Number of sell trades', n_sells])
t.add_row(['Average buy price', "{:.6f}".format(avg_buy)])
t.add_row(['Average sell price', "{:.6f}".format(avg_sell)])
t.add_row(['Average spread', "{:.6f}".format(avg_spread)])
t.add_row(['Fees (in quote)', "{:.2f}".format(fees)])
t.add_row(['Trade pnl after fees (in quote)', "{:.2f}".format(trade_pnl)])
t.add_row(['Trade volume (in quote)', "{:.2f}".format(trade_volume)])
t.add_row(['Change in base asset', "{:.2f}".format(total_buy_amount-total_sell_amount)])
t.add_row(['Pnl percentage of trade volume', "{:.2f}".format(trade_pnl/trade_volume*100)])

print(t)
