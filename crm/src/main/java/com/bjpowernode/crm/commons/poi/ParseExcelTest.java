package com.bjpowernode.crm.commons.poi;

import com.bjpowernode.crm.commons.utils.HSSFUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.logging.Level;

/**
 * 使用apache-poi解析excel文件
 */
public class ParseExcelTest {
    public static void main(String[] args) throws Exception {
        //根据excel文件生成HSSFWorkbook对象，封装了excel文件的所有信息
        FileInputStream is = new FileInputStream("C:\\WJ\\A-JAVA\\CRM\\excel\\studentExcel.xls");
        HSSFWorkbook wb = new HSSFWorkbook(is);
        //根据wb获取HSSFSheet对象，封装了一页的所有信息
        HSSFSheet sheet = wb.getSheetAt(0);//页的下标，下标从0开始，依次增加

        //根据sheet获取HSSFRow对象，封装了一行的所有信息
        HSSFRow row = null;
        HSSFCell cell = null;
        for (int i = 0; i <= sheet.getLastRowNum(); i++) {//sheet.getLastRowNum,最后一行的下标
            row = sheet.getRow(i);//行的下标，下标从0开始，一次增加

            for (int j = 0; j < row.getLastCellNum(); j++) {//row.getLastCellNum():最后一列的下标 + 1
                //根据row获取HSSFCell对象，封装了一列的所有信息
                cell = row.getCell(j);//列的下标，下标从0开始

                //获取列中的数据,获取要根据数据的类型来调用相应的方法，类型不匹配会报错
                System.out.print(HSSFUtils.getCellValueForStr(cell) + " ");
//                System.out.println(getCellValueForStr(cell));
//                if (cell.getCellType()==HSSFCell.CELL_TYPE_STRING) {
//                    System.out.print(cell.getStringCellValue() + " ");
//                } else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
//                    System.out.print(cell.getNumericCellValue() + " ");
//                } else if (cell.getCellType() == HSSFCell.CELL_TYPE_BOOLEAN) {
//                    System.out.print(cell.getBooleanCellValue() + " ");
//                } else if (cell.getCellType() == HSSFCell.CELL_TYPE_FORMULA) {
//                    System.out.print(cell.getCellFormula() + " ");
//                } else {
//                    System.out.print("" + " ");
//                }
            }

            //每一行中所有列都打完，下一行换行
            System.out.println("");
        }
    }

    /**
     * 从指定的HSSFCell对象中获取列的值
     * @param cell
     * @return
     */
     public static String getCellValueForStr(HSSFCell cell){
        String ret = "";
         //获取列中的数据,获取要根据数据的类型来调用相应的方法，类型不匹配会报错
         if (cell.getCellType()==HSSFCell.CELL_TYPE_STRING) {
             ret = cell.getStringCellValue();
         } else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
             ret = String.valueOf(cell.getNumericCellValue());
         } else if (cell.getCellType() == HSSFCell.CELL_TYPE_BOOLEAN) {
             ret = String.valueOf(cell.getBooleanCellValue());
         } else if (cell.getCellType() == HSSFCell.CELL_TYPE_FORMULA) {
             ret = cell.getCellFormula();
         } else {
             ret = "";
         }
         return ret;
     }
}
