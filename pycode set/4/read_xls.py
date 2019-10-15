import xlrd

def read(infile,sheetname):
    bk = xlrd.open_workbook(infile)
    # shxrange = range(bk.nsheets)
    try:
        sh = bk.sheet_by_name(sheetname)
    except:
        print ("no sheet in %s named %s" % (infile,sheetname))
    nrows = sh.nrows
    ncols = sh.ncols
    # print ("nrows %d, ncols %d" % (nrows,ncols))

    _1stvalue=sh.col_values(0)
    _2ndvalue=sh.col_values(1)
    # row_value = []
    # row_list=[]
    # for i in range(1,nrows):
    #     row_data = sh.row_values(i)
    #     row_value.append(row_data)
    # for i in range(1):
    #     row_data = sh.row_values(i)
    #     row_list.append(row_data)

    return _1stvalue,_2ndvalue

