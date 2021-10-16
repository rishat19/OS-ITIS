#!/usr/bin/python3

# Ганиев Ришат, 11-902

import os
import sys
import random
import time

arg = sys.argv[1]
pid = os.getpid()
print(f"Запущена программа Child в процессе с PID {pid} с аргументом {arg}.")
time.sleep(int(arg))
print(f"Завершился процесс с PID {pid}.")
exit_status = random.randint(0, 1)
os._exit(exit_status)
