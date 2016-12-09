__author__ = 'ADMIN'

import matplotlib.pyplot as plt
import numpy as np
import time
import math

data = []
with open('test.txt') as input_file:
    for line in input_file:
        data.append(line.rstrip('\n'))

t = (np.array([float(i) for i in data[0::6]]) - float(data[0]))/1000
T1 = np.array([float(i) for i in data[1::6]])
T2 = np.array([float(i) for i in data[2::6]])
T3 = np.array([float(i) for i in data[3::6]])
Tref = np.array([float(i) for i in data[4::6]])
Power = np.array([float(i) for i in data[5::6]])
counter = 0

def init_plot():
    plt.ion()       # Enable interactive mode

    f, axarr = plt.subplots(2,2)
    l1, = axarr[0,0].plot([], [], 'r-x', label='Water temperature', linewidth=2.0)
    l2, = axarr[0,0].plot([], [], 'k-', label='Reference temperature',linewidth=2.0)
    l3, = axarr[1,0].plot([], [], 'b-x', label='Input power',linewidth=2.0)

    lp, = axarr[1,0].plot([], [], 'k-', label='Input power average',linewidth=1.0)
    lt, = axarr[0,0].plot([], [], 'k-', label='Temperature average',linewidth=1.0)
    lm, = axarr[0,0].plot([], [], 'k--', label='_nolegend_',linewidth=1.0)
    ll, = axarr[0,0].plot([], [], 'k--', label='_nolegend_',linewidth=1.0)

    l4, = axarr[0,1].plot([], [], 'r-x', label='Water temperature',linewidth=2.0)
    l5, = axarr[0,1].plot([], [], 'k-', label='Reference temperature',linewidth=2.0)
    l6, = axarr[1,1].plot([], [], 'b-x', label='Input power',linewidth=2.0)

    axarr[0,0].legend(loc="upper left",shadow=True, fancybox=True)
    axarr[1,0].legend(loc="upper left",shadow=True, fancybox=True)
    axarr[0,1].legend(loc="upper left",shadow=True, fancybox=True)
    axarr[1,1].legend(loc="upper left",shadow=True, fancybox=True)

    axarr[0,0].set_axis_bgcolor((0.95, 0.95, 0.95))
    axarr[1,0].set_axis_bgcolor((0.95, 0.95, 0.95))
    axarr[0,1].set_axis_bgcolor((0.95, 0.95, 0.95))
    axarr[1,1].set_axis_bgcolor((0.95, 0.95, 0.95))
    f.patch.set_facecolor('#FFFFFF')

    axarr[0,0].set_autoscale_on(True) # enable autoscale
    axarr[0,0].autoscale_view(True,True,True)
    axarr[1,0].set_autoscale_on(True) # enable autoscale
    axarr[1,0].autoscale_view(True,True,True)
    axarr[0,1].set_autoscale_on(True) # enable autoscale
    axarr[0,1].autoscale_view(True,True,True)
    axarr[1,1].set_autoscale_on(True) # enable autoscale
    axarr[1,1].autoscale_view(True,True,True)

    axarr[1,0].set_xlabel('Time [s]')
    axarr[0,0].set_ylabel('Temp [C]')
    axarr[1,0].set_ylabel('Power [W]')
    axarr[1,1].set_xlabel('Time [s]')
    axarr[0,1].set_ylabel('Temp [C]')
    axarr[1,1].set_ylabel('Power [W]')

    axarr[0,0].set_title('Real time process data (last 60 seconds)')
    axarr[0,1].set_title('Real time process data (last 1200 seconds) ')

    axarr[0,0].grid(which='both')
    axarr[1,0].grid(which='both')
    axarr[0,0].grid(which='minor', alpha=0.2)
    axarr[0,0].grid(which='major', alpha=0.5)
    axarr[1,0].grid(which='minor', alpha=0.2)
    axarr[1,0].grid(which='major', alpha=0.5)

    axarr[0,1].grid(which='both')
    axarr[1,1].grid(which='both')
    axarr[0,1].grid(which='minor', alpha=0.2)
    axarr[0,1].grid(which='major', alpha=0.5)
    axarr[1,1].grid(which='minor', alpha=0.2)
    axarr[1,1].grid(which='major', alpha=0.5)

    return f, axarr, l1, l2, l3, l4, l5, l6, lm, ll, lp, lt

def set_limit_left(T_arr, T1_arr, Tref_arr, Power_arr):
    xmin = math.floor(min(T_arr))
    xmax = math.ceil(max(T_arr))
    y0min = math.floor(min(min(T1_arr), min(Tref_arr)))
    y0max = max(max(T1_arr), max(Tref_arr))
    y0max = math.ceil(y0max + (y0max - y0min + 1)*0.1)
    y1min = math.floor(min(Power_arr))
    if y1min > 1200:
        y1min = 1200
    y1max = max(Power_arr)
    y1max = math.ceil(y1max + (y1max - y1min + 1)*0.1)
    if y1max < 1:
        y1max = 5
    axarr[0,0].set_xlim([xmin,xmax])
    axarr[0,0].set_ylim([y0min,y0max])
    axarr[1,0].set_xlim([xmin,xmax])
    axarr[1,0].set_ylim([y1min,y1max])

    major_ticks = np.linspace(xmin, xmax, 11)
    minor_ticks = np.linspace(xmin, xmax, 20)
    major_ticksy = np.linspace(y0min, y0max, 6)
    minor_ticksy = np.linspace(y0min, y0max, 18)
    major_ticksy1 = np.linspace(y1min, y1max, 6)
    minor_ticksy1 = np.linspace(y1min, y1max, 18)
    axarr[0,0].set_xticks(major_ticks)
    axarr[0,0].set_xticks(minor_ticks, minor=True)
    axarr[0,0].set_yticks(major_ticksy)
    axarr[0,0].set_yticks(minor_ticksy, minor=True)
    axarr[1,0].set_xticks(major_ticks)
    axarr[1,0].set_xticks(minor_ticks, minor=True)
    axarr[1,0].set_yticks(major_ticksy1)
    axarr[1,0].set_yticks(minor_ticksy1, minor=True)

def set_limit_right(T_arr2, T1_arr2, Tref_arr2, Power_arr2):
    xmin2 = math.floor(min(T_arr2))
    xmax2 = math.ceil(max(T_arr2))
    y0min2 = math.floor(min(min(T1_arr2), min(Tref_arr2)))
    y0max2 = max(max(T1_arr2), max(Tref_arr2))
    y0max2 = math.ceil(y0max2 + (y0max2 - y0min2 + 1)*0.1)
    y1min2 = math.floor(min(Power_arr2))
    if y1min2 > 1200:
        y1min2 = 1200
    y1max2 = max(Power_arr2)
    y1max2 = math.ceil(y1max2 + (y1max2 - y1min2 + 1)*0.1)
    if y1max2 < 1:
        y1max2 = 5
    axarr[0,1].set_xlim([xmin2,xmax2])
    axarr[0,1].set_ylim([y0min2,y0max2])
    axarr[1,1].set_xlim([xmin2,xmax2])
    axarr[1,1].set_ylim([y1min2,y1max2])

    major_ticks2 = np.linspace(xmin2, xmax2, 11)
    minor_ticks2 = np.linspace(xmin2, xmax2, 20)
    major_ticksy2 = np.linspace(y0min2, y0max2, 6)
    minor_ticksy2 = np.linspace(y0min2, y0max2, 18)
    major_ticksy12 = np.linspace(y1min2, y1max2, 6)
    minor_ticksy12 = np.linspace(y1min2, y1max2, 18)
    axarr[0,1].set_xticks(major_ticks2)
    axarr[0,1].set_xticks(minor_ticks2, minor=True)
    axarr[0,1].set_yticks(major_ticksy2)
    axarr[0,1].set_yticks(minor_ticksy2, minor=True)
    axarr[1,1].set_xticks(major_ticks2)
    axarr[1,1].set_xticks(minor_ticks2, minor=True)
    axarr[1,1].set_yticks(major_ticksy12)
    axarr[1,1].set_yticks(minor_ticksy12, minor=True)

def movingaverage(interval, window_size):
    window= np.ones(int(window_size))/float(window_size)
    return np.convolve(interval, window, 'same')

f, axarr, l1, l2, l3, l4, l5, l6, lm, ll, lp, lt = init_plot()

a = 1.675091827e-3
b = 1.857536553e-4
c = 5.373169834e-7

t_arr, T1_arr, Tref_arr, Power_arr = [],[],[],[]
t_arr2, T1_arr2, Tref_arr2, Power_arr2 = [],[],[],[]
mov_T1, mov_Pow, window = [],[],10

samples = 60
samples2 = 1200
q, q2 = 0,0
TIME = np.linspace(-samples, 0, samples+1)
TIME2 = np.linspace(-samples2, 0, samples2/10 +1)
T_arr, T_arr2 = [],[]

mean_counter, mean_T1, mean_Tref, mean_Power = 0,0,0,0

while 1:
    start_time = time.time()

    # Read data from Arduino -------------
    read_T1 = T1[counter]
    read_Tref = Tref[counter]
    read_Power = Power[counter]
    # ------------------------------------

    # Calculate data
    R1 = (2250600/read_T1 - 2200)
    Tw = float(math.log(R1))
    T_water = (1 /(a + (b + (c * Tw * Tw ))* Tw )) - 273.15
    Power_real = (read_Power /100)*1218

    # Add data to arrays
    T1_arr.append(T_water)
    Tref_arr.append(read_Tref)
    Power_arr.append(Power_real)
    mov_T1.append(T_water)
    mov_Pow.append(Power_real)

    if mean_counter == 10:
        mean_counter = 0
        T1_arr2.append(mean_T1)
        Tref_arr2.append(mean_Tref)
        Power_arr2.append(mean_Power)
        mean_T1 = 0
        mean_Tref = 0
        mean_Power = 0
    else:
        mean_T1 += T_water/10
        mean_Tref += read_Tref/10
        mean_Power += Power_real/10
        mean_counter += 1

    if len(T1_arr) > samples + 1:
        T_arr = TIME
        T1_arr.pop(0)
        Tref_arr.pop(0)
        Power_arr.pop(0)
    else:
        T_arr.append(TIME[q])
        q += 1

    if len(T1_arr2) > samples2/10 + 1:
        T_arr2 = TIME2
        T1_arr2.pop(0)
        Tref_arr2.pop(0)
        Power_arr2.pop(0)
    else:
        if mean_counter == 0:
            T_arr2.append(TIME2[q2])
            q2 += 1

    if len(mov_Pow) > samples + 1 + window:
        mov_Pow.pop(0)
        mov_T1.pop(0)

    # Plot data
    l1.set_data(T_arr,T1_arr)
    l2.set_data(T_arr,Tref_arr)
    l3.set_data(T_arr,Power_arr)
    lm.set_data([min(T_arr),max(T_arr)],[max(T1_arr),max(T1_arr)])
    ll.set_data([min(T_arr),max(T_arr)],[min(T1_arr),min(T1_arr)])

    if len(mov_Pow) > 25:
        P = movingaverage(mov_Pow, window)
        P = [i for i in P ]
        T = movingaverage(mov_T1, window)
        T = [i for i in T]

        for i in range(int(window/2)):
            P.pop()
            P.pop(0)
            T.pop()
            T.pop(0)

        if len(P) == len(T_arr):
            lp.set_data(T_arr,P)
            lt.set_data(T_arr,T)

    if 'span' in locals():
        span.remove()
    span = axarr[0,0].axhspan(min(T1_arr), max(T1_arr), color='y', alpha=0.1, lw=0)


    if mean_counter == 0:
        l4.set_data(T_arr2,T1_arr2)
        l5.set_data(T_arr2,Tref_arr2)
        l6.set_data(T_arr2,Power_arr2)

    f.canvas.draw()

    if len(T_arr) > 1:
        set_limit_left(T_arr, T1_arr, Tref_arr, Power_arr)

    if (len(T_arr2) > 1) & (mean_counter == 0):
        set_limit_right(T_arr2, T1_arr2, Tref_arr2, Power_arr2)

    plt.draw()
    plt.pause(0.0001)
    sleeptime = 1 - (time.time() - start_time)
    if sleeptime >= 0:
        time.sleep(sleeptime)
    counter += 1




