package com.bjpowernode.crm.commons.poi;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;

import javax.swing.*;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * 使用apache-poi生成excel文件
 */
public class CreateExcelTest {

    public static void main(String[] args) throws IOException {
        //创建HSSFWorkbook对象，对应一个excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        //使用wb创建HSSFSheet对象，对应wb文件中的一页
        HSSFSheet sheet = wb.createSheet("页名");
        //使用sheet创建HSSFRow对象，对应sheet页中的一行
        HSSFRow row = sheet.createRow(0);//参数：行号，从0开始，依次增加
        //使用row对象创建HSSFCell对象，对应row中的列
        HSSFCell cell = row.createCell(0);//参数：列号，从0开始，依次递增
        //往单元格中写内容
        cell.setCellValue("学号");//这是一个重载的方法，可以写不同类型的数据
        //再写一列
        cell = row.createCell(1);//这里仍然是用变量cell，但是依然是由row对象创建的，上一个cell不会被垃圾回首器回收，不会空指针
        cell.setCellValue("姓名");
        cell = row.createCell(2);//这里仍然是用变量cell，但是依然是由row对象创建的，上一个cell不会被垃圾回首器回收，不会空指针
        cell.setCellValue("年龄");

        //生成HSSFCellStyle对象，用来设置格式
        HSSFCellStyle cellStyle = wb.createCellStyle();
        cellStyle.setAlignment(HorizontalAlignment.CENTER);//居中

        //使用sheet创建20个HSSFRow对象
        for (int i = 1; i < 20; i++) {
            row = sheet.createRow(i);

            cell = row.createCell(0);
            cell.setCellValue(100+i);
            cell = row.createCell(1);
            cell.setCellValue("name" + i);
            cell = row.createCell(2);
            cell.setCellValue(10+i);
            cell.setCellStyle(cellStyle);
        }

        //调用工具函数生成excel文件
        FileOutputStream out = new FileOutputStream("C:\\WJ\\A-JAVA\\CRM\\excel\\studentExcel.xls");//这里的目录必须是要事先存在的，不然会报io异常，文件名不存在的话会自动生成
        wb.write(out);

        //关闭资源,自己new的要手动关，不关占用资源，不是自己new的不用管，谁提供谁管
        out.close();
        wb.close();
    }
}
