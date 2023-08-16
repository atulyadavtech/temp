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

pbs.logmsg(pbs.LOG_DEBUG,"disablequeues hook starting")

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
                pbs.logmsg(pbs.LOG_DEBUG, line)
                if re.match("remaining nodehours =", line):
                        pbs.logmsg(pbs.LOG_DEBUG, "CPU Node Hours Case")
                        pbs.logmsg(pbs.LOG_DEBUG, line)

                        RemainingHours = re.split(r'=', line)[1].rstrip().lstrip()
                        pbs.logmsg(pbs.LOG_DEBUG, "Node Hours Validation")
                        pbs.logmsg(pbs.LOG_DEBUG, RemainingHours)
                        pbs.logmsg(pbs.LOG_DEBUG, RemainingHoursThreshHold)

                if re.match("remaining gpuhours =", line):
                        pbs.logmsg(pbs.LOG_DEBUG, "GPU Node Hours Case")
                        pbs.logmsg(pbs.LOG_DEBUG, line)
                        RemainingHours = re.split(r'=', line)[1].rstrip().lstrip()
                        pbs.logmsg(pbs.LOG_DEBUG, "GPU Hours Validation")
                        pbs.logmsg(pbs.LOG_DEBUG, RemainingHoursThreshHold)

                if re.match("End date =", line):
                        pbs.logmsg(pbs.LOG_DEBUG, "End date Case")
                        pbs.logmsg(pbs.LOG_DEBUG,line)
                        End_Date=re.split(r'=', line)[1].rstrip().lstrip()
                        EndDate = datetime.datetime.strptime(End_Date,enddate_format)
                        pbs.logmsg(pbs.LOG_DEBUG, "Date Validation")
                        pbs.logmsg(pbs.LOG_DEBUG, str(CurrentDate))
                        pbs.logmsg(pbs.LOG_DEBUG, str(EndDate))

        if (float(RemainingHours) > float(RemainingHoursThreshHold)) and (EndDate > CurrentDate):
                pbs.logmsg(pbs.LOG_DEBUG,"final")
                pbs.logmsg(pbs.LOG_DEBUG, RemainingHours)
                pbs.logmsg(pbs.LOG_DEBUG, str(EndDate))
                for line in Queues.splitlines():
                        if re.search("create queue ",  line):
                                pbs.logmsg(pbs.LOG_DEBUG,"Enabling all the Queue")
                                QueueToUpdate=re.split(r' ', line)[2].rstrip().lstrip()
                                UpdateQueueCommand=QMGRCMD + ' -c "set queue ' + QueueToUpdate + ' enabled=True"'
                                pbs.logmsg(pbs.EVENT_DEBUG3, ("disablequeuesDBG3: " + UpdateQueueCommand))
                                os.system(UpdateQueueCommand)
        else:
                for line in Queues.splitlines():
                        if re.search("create queue ",  line):
                                pbs.logmsg(pbs.LOG_DEBUG,"Disabling all the Queue")
                                QueueToUpdate=re.split(r' ', line)[2].rstrip().lstrip()
                                UpdateQueueCommand=QMGRCMD + ' -c "set queue ' + QueueToUpdate + ' enabled=False"'
                                pbs.logmsg(pbs.EVENT_DEBUG3, ("disablequeuesDBG3: " + UpdateQueueCommand))
                                os.system(UpdateQueueCommand)
