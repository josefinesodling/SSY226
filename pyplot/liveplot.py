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

plt.ion()       # Enable interactive mode

f, axarr = plt.subplots(2,2)
l1, = axarr[0,0].plot([], [], 'r-', label='Water temperature')
l2, = axarr[0,0].plot([], [], 'b-', label='Reference temperature')
l3, = axarr[1,0].plot([], [], 'b-', label='Input power')

l4, = axarr[0,1].plot([], [], 'r-', label='Water temperature')
l5, = axarr[0,1].plot([], [], 'b-', label='Reference temperature')
l6, = axarr[1,1].plot([], [], 'b-', label='Input power')

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

axarr[0,0].set_title('Real Time Process Data (Last 60 Seconds)')
axarr[0,1].set_title('Real Time Process Data (Last 1400 Seconds)')

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

a = 1.675091827e-3
b = 1.857536553e-4
c = 5.373169834e-7

t_arr = []
T1_arr = []
Tref_arr = []
Power_arr = []

t_arr2 = []
T1_arr2 = []
Tref_arr2 = []
Power_arr2 = []

samples = 60
samples2 = 1400
q = 0
q2 = 0
TIME = np.linspace(-samples, 0, samples)
TIME2 = np.linspace(-samples2, 0, samples2)
T_arr = []
T_arr2 = []

while 1:
    # Read data
    read_time = t[counter]
    read_T1 = T1[counter]
    read_Tref = Tref[counter]
    read_Power = Power[counter]

    # Calculate data
    R1 = (2250600/read_T1 - 2200)
    Tw = float(math.log(R1))
    T_water = (1 /(a + (b + (c * Tw * Tw ))* Tw )) - 273.15
    Power_real = (read_Power /100)*1218

    # Add data to arrays
    t_arr.append(read_time)
    T1_arr.append(T_water)
    Tref_arr.append(read_Tref)
    Power_arr.append(Power_real)

    T1_arr2.append(T_water)
    Tref_arr2.append(read_Tref)
    Power_arr2.append(Power_real)

    if len(T1_arr) > samples:
        T_arr = TIME
        t_arr.pop(0)
        T1_arr.pop(0)
        Tref_arr.pop(0)
        Power_arr.pop(0)
    else:
        T_arr.append(TIME[q])
        q += 1

    if len(T1_arr2) > samples2:
        T_arr2 = TIME2
        T1_arr2.pop(0)
        Tref_arr2.pop(0)
        Power_arr2.pop(0)
    else:
        T_arr2.append(TIME2[q2])
        q2 += 1


    # Plot data
    l1.set_data(T_arr,T1_arr)
    l2.set_data(T_arr,Tref_arr)
    l3.set_data(T_arr,Power_arr)

    l4.set_data(T_arr2,T1_arr2)
    l5.set_data(T_arr2,Tref_arr2)
    l6.set_data(T_arr2,Power_arr2)

    f.canvas.draw()

    if len(T_arr) > 3:
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

    if len(T_arr2) > 3:
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

    #axarr[0,0].relim()
    #axarr[0,0].autoscale_view(True,True,True) #Autoscale
    #axarr[1,0].relim()
    #axarr[1,0].autoscale_view(True,True,True) #Autoscale
    #axes.relim()        # Recalculate limits
    #axes.autoscale_view(True,True,True) #Autoscale
    plt.draw()      # Redraw
    plt.pause(0.0001)


    #Sleep
    #time.sleep(1)
    counter += 1




