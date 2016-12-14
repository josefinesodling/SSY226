import serial
s = serial.Serial(port='/dev/cu.usbmodem14111', baudrate=9600)

#s.read()

while 1:
    #q = s.readline().splitlines()
    q = s.readline()
    #q = float(q[0])
    p = s.readline().splitlines()
    p = int(p[0])
    r = s.readline().splitlines()
    r = int(r[0])
    print(q,p,r)