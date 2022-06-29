package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        //请求转发到登录页面
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        //调用service层进行查询
        User user = userService.queryUserByLoginActAndPwd(map);
        //根据查询结果生成响应信息
        ReturnObject retDataObject = new ReturnObject();
        if (user == null) {//判空
            //登录失败，用户名或密码错误
            retDataObject.setCode("0");
            retDataObject.setMessage("用户名或密码错误");
        }else{//进一步判断是否合法
            //根据需求，需要判断 账号是否过期，是否被锁定，是否ip受限
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String nowStr = sdf.format(new Date());

            if (nowStr.compareTo(user.getExpireTime()) > 0) {
                //登录失败，账号已过期
                retDataObject.setCode("0");
                retDataObject.setMessage("账号已过期");
            } else if ("0".equals(user.getLockState())) {
                //登录失败，账号被锁定
                retDataObject.setCode("0");
                retDataObject.setMessage("账号被锁定");
            } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {
                //登录失败，ip受限
                retDataObject.setCode("0");
                retDataObject.setMessage("ip受限");
            } else {
                //登录成功
                retDataObject.setCode("1");
            }
        }
        return retDataObject;
    }
}
