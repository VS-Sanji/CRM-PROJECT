package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.sun.corba.se.impl.oa.toa.TOA;
import com.sun.deploy.net.HttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.*;

@Controller
public class ActivityController {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList",userList);
        return "workbench/activity/index";
    }

    //保存创建的市场活动
    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public Object saveCreateActivity(HttpSession session, Activity activity){

        User user = (User) session.getAttribute(Contants.SESSION_USER);

        //查询语句中需要9个参数，而前台发送过来的只有6个，所以还需要手动补充参数，封装到实体类对象中
        //id用UUID来实现
        activity.setId(UUIDUtils.getUUID());
        //date
        activity.setCreateTime(DateUtils.formatDateTime(new Date()));
        //编辑的用户
        activity.setCreateBy(user.getId());

        //增删改都涉及对数据库的写操作，所以当出现异常时需要知道异常情况，所以try...catch
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service
            int i = activityService.saveCreateActivity(activity);
            //根据service调用结果进行判断，生成响应信息
            if (i > 0) {
                //保存成功
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                //保存失败
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请求稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
        }

        //返回响应信息
        return returnObject;
    }

    //根据条件分页查询市场活动
    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    @ResponseBody
    public Object queryActivityByConditionForPage(String name, String owner, String startDate, String endDate,
                                                  int pageNo, int pageSize){
        //封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginNo",(pageNo - 1)*pageSize);
        map.put("pageSize",pageSize);

        //调用service查询数据库
        List<Activity> retList = activityService.queryActivityByConditionForPage(map);
        int totalCount = activityService.queryCountOfActivityByCondition(map);

        //封装查询结果
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("retList",retList);
        retMap.put("totalCount", totalCount);

        //返回结果
        return retMap;
    }

    //根据id们删除市场活动
    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] id){
        System.out.println(id[0]);
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service层删除市场活动
            int ret = activityService.deleteActivityByIds(id);
            if (ret > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    //根据id查询市场活动
    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id){
        //调用service
        Activity activity = activityService.queryActivityById(id);
        //返回查询结果
        return activity;
    }

    //保存修改的市场活动
    @RequestMapping("/workbench/activity/saveEditActivity.do")
    @ResponseBody
    public Object saveEditActivity(Activity activity, HttpSession session){
        //封装参数，根据sql语句需求进行封装
        //获取修改时间，修改人
        User user =(User) session.getAttribute(Contants.SESSION_USER);
        String dateTime = DateUtils.formatDateTime(new Date());
        activity.setEditBy(user.getId());
        activity.setEditTime(dateTime);

        ReturnObject returnObject = new ReturnObject();
        //调用service
        try {
            int i = activityService.saveEditActivity(activity);

            if (i == 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
                return returnObject;
            }else if (i == 1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                return returnObject;
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
            return returnObject;
        }
        return returnObject;
    }

    //演示文件下载
    @RequestMapping("/workbench/activity/fileDownload.do")
    public void fileDownload(HttpServletResponse response) throws IOException {
        //1.设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //2.获取输出流
        OutputStream os = response.getOutputStream();

        //浏览器接收到响应信息后，默认情况下，直接在显示窗口中打开响应信息；即使打不开，也会调用应用程序打开；只有实在打不开，才会激活文件下载
        //可以设置响应头信息，使浏览器接收到响应信息之后，直接激活文件下载窗口，即使能打开也不打开
        response.addHeader("Content-Disposition","attachment;filename=student.xls");

        //读取excel文件(InputStream),读到内存中，再通过OutputStream往外输出
        FileInputStream fileInputStream = new FileInputStream("C:\\Dev\\crm\\crm-ziliao\\excel\\studentExcel.xls");
        byte[] buff = new byte[256];
        int len = 0;
        while ((len = fileInputStream.read(buff)) != -1){
            os.write(buff,0,len);
        }

        //3.关闭资源
        //os.close(); 这是用response获取的流，由tomcat管理，不用我们自己手动关闭
        fileInputStream.close();
        os.flush();//输出流冲刷
    }

}
