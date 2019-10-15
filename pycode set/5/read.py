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

    cell_value = sh.cell_value(0,0)
    # print (cell_value)

    row_value = []
    row_list=[]
    for i in range(1,nrows):
        row_data = sh.row_values(i)
        row_value.append(row_data)
    for i in range(1):
        row_data = sh.row_values(i)
        row_list.append(row_data)

    return row_list,row_value

