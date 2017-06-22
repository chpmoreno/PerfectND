print 'Importing modules...'
from sense_hat import SenseHat
from datetime import datetime
from azure.storage.blob import BlockBlobService
from threading import Thread
import csv
import json
import sys
import time
import smtplib
import string


print 'Connecting to Azure...'
# Azure 
name='perfectndsa'
key = '41eoKtqzIXvovIzQhWYi5ZK+JY7PU1/6Tp5fHpnFm9v37z1OPRTCWaJ1hhhQh6rqeF+u3BKXjaUAJ8SgXnhzWQ=='
block_blob = BlockBlobService(account_name=name, account_key=key)
block_blob.create_container('example')

print 'Initializing sensor...'
# Sensor
hat = SenseHat()

# Send data to azure method
def send_data(data):
    json_data = json.dumps(data)
    block_blob.create_blob_from_text("example", 'data.json', json_data)

# Prepare output csv
with open('data.csv', 'w') as data_file:
    writer = csv.writer(data_file, delimiter=',')
    writer.writerow(["Timestamp", "Temperature_hum (Cº)", "Temperature_press (Cº)", "Humidity (%rH)", "Pressure (mBars)"])

print 'Load Done!\n'
acc_dryness = 0
acc_stinkness = 0
t = 0
i = 1
O = (0, 0, 0)
pixels = [O]*64
dry = False
stink = False
# Main Loop
while True:
    try:
        t = t+1
        threshold_dry = 120*37/30
        threshold_stinky = 180*1020/1000
        temp = hat.get_temperature()
        hum = hat.get_humidity()
        temp_p = hat.get_temperature_from_pressure()
        pressure = hat.get_pressure()
        timestamp = datetime.now()        
        
        temp_mean = (temp+temp_p)/2
        acc_dryness = acc_dryness + temp_mean/hum
        acc_stinkness = acc_stinkness + pressure/1000
        
        
        if (acc_dryness >= threshold_dry) & (dry==False):
            color = (0, 255, 0)
            dry = True
            SUBJECT = "Perfect ND Status (BGSE IoT prototype)"
            TO = "gaston.besanson@accenture.com"
            FROM = "perfectnd@outlook.com"
            text = "Dear client,\n \n Announcement: Your clothes are already dry, ready for you to pick up and nicely fold them. You have "+str(round(threshold_stinky-acc_stinkness))+"min to take them before they become too stinky to be worn. \n\n Please pick up them as soon as possible.\n\n Yours sincerely,\n PerfectND Communication Managers: Jose and Roger\n\n This message was created automatically from Raspberry Pi, thank you for trusting our company."
            BODY = string.join((
                    "From: %s" % FROM,
                    "To: %s" % TO,
                    "Subject: %s" % SUBJECT ,
                    "",
                    text
                    ), "\r\n")
            server = smtplib.SMTP('smtp-mail.outlook.com',587)
            server.ehlo()
            server.starttls()
            server.ehlo()
            server.login('perfectnd@outlook.com', 'l0sPEPES')
            server.sendmail(FROM, [TO], BODY)
            server.quit()
            
            new_thread = Thread(target=send_data, args=(timestamp, temp))
            new_thread.start()
        else:
            color = (0, 0, 255)
        
        if (acc_stinkness >= threshold_stinky) & (stink == False):
            stink = True            
            color = (255, 0, 0)
            SUBJECT = "Perfect ND Status (BGSE IoT prototype)"
            TO = "gaston.besanson@accenture.com"
            FROM = "perfectnd@outlook.com"
            text = "Dear client,\n \n Announcement: You took too long to pick them up.... Now the clothes are so stinky that nobody in the world would want to get closer than 10 meters from you. You will live in isolation until you wash the clothes again. Please be more careful next time.\n\n Yours sincerely,\n PerfectND Communication Managers: Jose and Roger\n\n This message was created automatically from Raspberry Pi, thank you for trusting our company."
            BODY = string.join((
                    "From: %s" % FROM,
                    "To: %s" % TO,
                    "Subject: %s" % SUBJECT ,
                    "",
                    text
                    ), "\r\n")
            server = smtplib.SMTP('smtp-mail.outlook.com',587)
            server.ehlo()
            server.starttls()
            server.ehlo()
            server.login('perfectnd@outlook.com', 'l0sPEPES')
            server.sendmail(FROM, [TO], BODY)
            server.quit()
            
        
        print('Temperature: %s C' % temp)
        print('Temperature from pressure sensor: %s C' % temp_p)
        print('Humidity: %s %%rH' % hum)
        print('Pressure: %s Milibars' % pressure)
        print('Time: %s' % datetime.now())
        
        hat.clear()
        X = color
        
        if acc_stinkness >= i*threshold_stinky/8:
            X1 = (255, 255, 255)            
            pixels[0:i*8] = [X1]*min(i,8)*8
            i = i+1
        
        if (dry == True) & (stink == False):
            X = (8,117,30)
            indx = [2,3,4,10,13,18,21,26,27,28,34,42,50,58]
            for j in indx:
                pixels[j] = X
            #pixels = [
                      #O,O,X,X,X,O,O,O,
                      #O,O,X,O,0,X,O,O,
                      #O,O,X,O,O,0,X,O,
                      #O,O,X,0,0,0,X,O,
                      #O,O,X,O,O,0,X,O,
                      #O,O,X,O,O,0,X,O,
                      #O,O,X,O,0,X,O,O,
                      #O,O,X,X,X,O,O,O]
        if stink == True:
            X = (255,0,0)
            indx = [2,3,4,10,13,18,22,26,30,34,38,42,46,50,53,58,59,60]
            for j in indx:
                pixels[j] = X
            
        hat.set_pixels(pixels)
                  
        with open('data.csv', 'a') as data_file:
            csv_file = csv.writer(data_file, delimiter=',')
            csv_file.writerow([timestamp, temp, temp_p, hum, pressure])
        
        
        time.sleep(60)
    except KeyboardInterrupt:
        break

# Clear sensor and quit
hat.clear()
block_blob.create_blob_from_path('example', 'final_output.csv', 'data.csv')
print '\rSensor Cleared'
sys.exit()
