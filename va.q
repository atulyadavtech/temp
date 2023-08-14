##############################################################################
# Purpose: To disable the scheduler if node hours were reached or after contract end
##############################################################################

#'''
#create hook disablequeues
#set hook disablequeues event = 'periodic'
#set hook disablequeues fail_action = none
#set hook disablequeues alarm = 60
#set hook disablequeues freq = 43200
#import hook disablequeues application/x-python default disablequeue.py
#
#'''

##############################################################################
#
#
# Import the needed modules for the program

import pbs
import sys
import os
import re
import subprocess
import datetime




# Debug Flag
DEBUG = True
# DEBUG = False


# Variables to Change:
USGHRSCMD='/usr/local/bin/usagehrs'
RemainingHoursThreshHold = '0'

# Identify the QMGR Command
pbs_conf = pbs.pbs_conf
pbs_bin = pbs_conf['PBS_EXEC'] + os.sep + 'bin'
QMGRCMD = pbs_bin + os.sep + 'qmgr'

# Get All Queues
QueueCMD=QMGRCMD + " -c 'print queue @default'"
Queues=subprocess.check_output([QueueCMD],shell=True, bufsize=1, universal_newlines=True)

# Current Date
enddate_format = "%b %d %Y"
CurrentDate = datetime.datetime.now()

if os.path.exists(USGHRSCMD):
        RemainingHours='0'
        EndDate=''
        HumanEndDate=''

        # Python 2
        output = subprocess.check_output([USGHRSCMD],shell=True, bufsize=1, universal_newlines=True)
        # Python3
        #output = subprocess.run([USGHRSCMD], stdout=subprocess.PIPE).stdout.decode('utf-8')
        for line in output.splitlines():
                if re.match("remaining nodehours =", line):
                        pbs.logmsg(pbs.LOG_DEBUG, line)
                        RemainingHours = re.split(r'=', line)[1].rstrip().lstrip()
                        pbs.logmsg(pbs.LOG_DEBUG, RemainingHours)
                        pbs.logmsg(pbs.LOG_DEBUG, RemainingHoursThreshHold)

                if re.match("remaining gpuhours =", line):
                        pbs.logmsg(pbs.LOG_DEBUG, line)
                        RemainingHours = re.split(r'=', line)[1].rstrip().lstrip()
                        pbs.logmsg(pbs.LOG_DEBUG, RemainingHours)
                        pbs.logmsg(pbs.LOG_DEBUG, RemainingHoursThreshHold)

                if re.match("End date =", line):
                        End_Date=re.split(r'=', line)[1].rstrip().lstrip()
                        EndDate = datetime.datetime.strptime(End_Date,enddate_format)


        if (int(RemainingHours) > int(RemainingHoursThreshHold)) and (EndDate > CurrentDate):
                pbs.logmsg(pbs.LOG_DEBUG, RemainingHours)
                pbs.logmsg(pbs.LOG_DEBUG, RemainingHoursThreshHold)
                pbs.logmsg(pbs.EVENT_DEBUG3, ("disablequeuesDBG1"))
                pbs.logmsg(pbs.EVENT_DEBUG3, ("disablequeuesDBG2"))
                for line in Queues.splitlines():
                        if re.search("create queue ",  line):
                                QueueToUpdate=re.split(r' ', line)[2].rstrip().lstrip()
                                UpdateQueueCommand=QMGRCMD + ' -c "set queue ' + QueueToUpdate + ' enabled=True"'
                                pbs.logmsg(pbs.EVENT_DEBUG3, ("disablequeuesDBG3: " + UpdateQueueCommand))
                                os.system(UpdateQueueCommand)
        else:
                for line in Queues.splitlines():
                        if re.search("create queue ",  line):
                                QueueToUpdate=re.split(r' ', line)[2].rstrip().lstrip()
                                UpdateQueueCommand=QMGRCMD + ' -c "set queue ' + QueueToUpdate + ' enabled=False"'
                                pbs.logmsg(pbs.EVENT_DEBUG3, ("disablequeuesDBG3: " + UpdateQueueCommand))
                                os.system(UpdateQueueCommand)
