# 读ck吞吐量1.25w/s
import os

# from clickhouse_driver import Client
# def createCSVTemplate(dataDir):
#     clickhouse_user = 'default'
#     clickhouse_pwd = ''
#     clickhouse_host_sq = '10.20.8.124'
#     clickhouse_port = '8000'
#     clickhouse_database = 'tyid'
#     client = Client(host=clickhouse_host_sq, port=clickhouse_port, user=clickhouse_user,
#                     database=clickhouse_database, password=clickhouse_pwd)
#     # api_interface_sql = "select * from T_TYID_DATA_INFO where entity_one_type='ty001' and entity_two_type='ty004' limit 10000000"
#     api_interface_sql = "select * from T_TYID_DATA_INFO_TEST where entity_one_type='ty001' and entity_two_type='ty003' limit 10000"
#     try:
#         with open(os.path.join(dataDir, "template.csv"), mode="w+") as mTemplates:
#             for data in client.execute(api_interface_sql):
#                 mTemplates.write(str(data) + "\n")
#         # print(a)
#     except Exception as e:
#         print(e)
import math


def readDataFromCSV(dataDir):
    with open(os.path.join(dataDir, "template.csv"), mode="r", encoding="gbk") as sampleDatas:
        return sampleDatas.readlines()


def writeCk2CsvAll(dataDir, datas):
    sample = "('1215187878912167983', '610722200106090603', 'ty001', '13205440559', 'ty003', '采集数据', '0', 99, 75, datetime.datetime(2020, 1, 8, 15, 20, 10), datetime.datetime(2020, 1, 8, 15, 20, 10), datetime.datetime(2020, 1, 8, 15, 20, 10), datetime.datetime(2020, 1, 8, 15, 20, 10))"
    batchSize = math.ceil(datas / 10000000)
    for batch in range(batchSize):
        with open(os.path.join(dataDir, "allCkTestDatas" + str(batch) + ".csv"), mode="w+") as testDatas:
            for data in range(batch*10000000, (batch+1)*10000000):
                testDatas.write(
                    sample.replace("610722200106090603", str(100000000000000000 + data)).replace("13205440559", str(
                        13666277742 + data)) + "\n")


def creatDatas(limit):
    # dataDir = "/home/tyiddatas/juuoku"
    dataDir = "C:/Users/nkln/Desktop/tyid3/ck2hugegraph"
    # datas = readDataFromCSV(dataDir)
    writeCk2CsvAll(dataDir, limit)


if __name__ == '__main__':
    # 10亿
    # creatDatas(10*10000*10000)
    # 1亿
    # creatDatas(1000)
    # createCSVTemplate("C:/Users/nkln/Desktop/tyid3/ck2hugegraph")
    # 10w测试
    creatDatas(20 * 10000)
