package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

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



}
