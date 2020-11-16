import os
import random
import time


def changedate():
    path = r"D:\workspace\envai_platform\device\src\main\java\com\skycomm\zhdy"
    for file_path in os.listdir(path):
        file_path = os.path.join(path, file_path)
        print(os.stat(file_path))
        os.utime(file_path, (time.mktime(time.strptime(
            "2019-05-" + str(random.randint(21, 30)) + " " + str(random.randint(9, 18)) + ":" + str(
                random.randint(0, 59)) + ":" + str(random.randint(0, 59)) + "", "%Y-%m-%d %H:%M:%S")), time.mktime(
            time.strptime("2019-05-" + str(random.randint(21, 30)) + " " + str(random.randint(9, 18)) + ":" + str(
                random.randint(0, 59)) + ":" + str(random.randint(0, 59)) + "", "%Y-%m-%d %H:%M:%S"))))
        print(os.stat(file_path))


# 1556590369.0
# 1557882088.0
# 1558416487.0
def changedate2(path):
    for file_path in os.listdir(path):
        file_path = os.path.join(path, file_path)
        if os.path.isfile(file_path):
            print(os.stat(file_path))
            os.utime(file_path, (1558416487, 1558416487))
            print(os.stat(file_path))
        else:
            if os.path.isdir(file_path):
                os.utime(file_path, (1558416487, 1558416487))
                changedate2(file_path)

def changedata3():
    path = r"C:\mywork\envai_platform\inside-device\src\main\java\com\skycomm"
    for file_path in os.listdir(path):
        file_path = os.path.join(path, file_path)
        print(os.stat(file_path))
        os.utime(file_path, (1558416487, 1558416487))
        print(os.stat(file_path))


list = []

if __name__ == '__main__':
    # changedate()
    # print(time.mktime(time.strptime("2019-04-30 10:12:49", "%Y-%m-%d %H:%M:%S")))
    # print(time.mktime(time.strptime("2019-05-15 9:01:28", "%Y-%m-%d %H:%M:%S")))
    # print(time.mktime(time.strptime("2019-05-21 13:28:07", "%Y-%m-%d %H:%M:%S")))
    # path = r"C:\mywork"
    # changedate2(path)
    changedata3()