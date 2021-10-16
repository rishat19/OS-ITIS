#!/usr/bin/python3

# Ганиев Ришат, 11-902

import os
import random
import sys

arguments = sys.argv
if len(arguments) > 1:
    number_of_child_processes = int(arguments[1])
    list_of_pids = []
    for i in range(number_of_child_processes):
        pid = os.fork()
        if pid > 0:
            list_of_pids.append(pid)
        else:
            os.execl("./Child.py", "Child.py", str(random.randint(5, 10)))
    while len(list_of_pids) > 0:
        pid, exit_status = os.wait()
        if pid > 0:
            print(f"Дочерний процесс с PID {pid} завершился. Статус завершения {exit_status}.")
            list_of_pids.remove(pid)
else:
    print("Ошибка: не указано количество дочерних процессов.")
