package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.sun.deploy.net.cookie.CookieUnavailableException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import sun.awt.windows.WLightweightFramePeer;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpSession session, HttpServletResponse response){
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
//            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//            String nowStr = sdf.format(new Date());
            //以上两行代码用来进行日期格式化，这种代码在别的地方可能也会用到，为了得到代码的复用，可以封装起来，写个工具类

            String nowStr = DateUtils.formatDateTime(new Date());
            if (nowStr.compareTo(user.getExpireTime()) > 0) {
                //登录失败，账号已过期
//                retDataObject.setCode("0"); 这种代码中的0、1等数据可能会随着业务的拓展发生改动，所以不应该写死，可以设置一个常量类，以后改常量类就行了
                retDataObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                retDataObject.setMessage("账号已过期");
            } else if ("0".equals(user.getLockState())) {
                //登录失败，账号被锁定
//                retDataObject.setCode("0");
                retDataObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                retDataObject.setMessage("账号被锁定");
            } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {
                //登录失败，ip受限
//                retDataObject.setCode("0");
                retDataObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                retDataObject.setMessage("ip受限");
            } else {
                //登录成功
//                retDataObject.setCode("1");
                retDataObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                //用户登录成功后，在浏览器上打开不同的窗口都是一个会话，所以可以用session域保存用户的登录信息
//                session.setAttribute("sessionUser",user); 这种方式同样是写死了，同样的可以写到常量类中，调用即可
                session.setAttribute(Contants.SESSION_USER,user);

                //到这表示用户登录成功，如果用户还选择了 十天内免登录 功能，那么则需要向浏览器写cookie以记录会话状态
                if ("true".equals(isRemPwd)) {//用户选择了十天内免登录
                    //需要记住密码，往外写cookie
                    Cookie c1 = new Cookie("loginAct", user.getLoginAct());
                    c1.setMaxAge(60*60*24*10);//保存10天
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd", user.getLoginPwd());
                    c2.setMaxAge(60*60*24*10);
                    response.addCookie(c2);
                } else {//用户未选择十天内免登录
                    //需要清除cookie,方式为 再写个同名cookie进行覆盖，但是生命周期为0
                    Cookie c1 = new Cookie("loginAct", "1");
                    c1.setMaxAge(0);
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd", "1");
                    c1.setMaxAge(0);
                    response.addCookie(c2);
                }
            }
        }
        return retDataObject;

    }
}
